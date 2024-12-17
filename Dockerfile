# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.3.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libjemalloc2 libvips postgresql-client nodejs yarn && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set development environment
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3


FROM base AS build

# Install gems needed for development
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential git libpq-dev pkg-config vim && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy Gemfile and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code (note: volume will override this during runtime)
COPY . .

RUN bundle exec bootsnap precompile app/ lib/

RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Create required directories
RUN mkdir -p tmp/pids tmp/cache tmp/sockets log && \
    chmod -R 777 tmp log

# Start server via Thruster by default, this can be overwritten at runtime
# Expose the port Heroku requires
EXPOSE 3000

# Combine both entrypoints
ENTRYPOINT ["/rails/bin/docker-entrypoint", "sh", "-c"]

# Use CMD to start the Rails server with thrust
CMD ["./bin/thrust ./bin/rails server -b 0.0.0.0 -p ${PORT}"]
