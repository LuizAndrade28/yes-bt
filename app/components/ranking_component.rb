# frozen_string_literal: true

class RankingComponent < ViewComponent::Base
  def initialize(players:)
    @players = players
  end
end
