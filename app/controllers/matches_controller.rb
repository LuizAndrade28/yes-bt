class MatchesController < ApplicationController
  before_action :set_match, only: %i[edit update destroy]

  def index
    @matches = Match.page(params[:page]).per(8).order(match_date: :desc)
  end

  def show
    @match = Match.find(params[:id])
    @plays = Play.where(match_id: @match.id)
  end
  def new
    @match = Match.new
  end

  def create
    @match = Match.new(match_params)

    if @match.save!
      redirect_to @match, notice: 'Partida criada com sucesso. 🟢'
    else
      render :new, notice: 'Partida não foi criada com sucesso. 🔴'
    end
  end

  def edit
  end

  def update
    if @match.update!(match_params)
      redirect_to @match, notice: 'Partida atualizada com sucesso. 🟢'
    else
      render :edit, notice: 'Partida não foi atualizada com sucesso. 🔴'
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      @match.plays.each do |play|
        play.play_players.each do |play_player|
          player = play_player.player

          player.games_won -= play_player.games_won
          if player.games_lost < 0
            player.games_lost += play_player.games_lost
          else
            player.games_lost -= play_player.games_lost
          end
          player.sets_won -= 1 if play_player.winner == true

          player.games_balance = (player.games_won - player.games_lost)

          if Play.where(match_id: play_player.play.match_id).count == 1
            player.matches_count -= 1
          end

          if player.save!
            play_player.destroy!
          else
            raise ActiveRecord::Rollback, 'Erro ao deletar o play jogador.'
          end
        end

        play.destroy!
      end

      if @match.destroy!
        redirect_to matches_path, notice: "Partida excluída com sucesso. 🟢"
      else
        redirect_to matches_path, notice: "Partida não foi deletada com sucesso. 🔴"
      end
    end
  rescue => e
    Rails.logger.error "Erro ao deletar a partida: #{e.message}"
    redirect_to match_path(@match), notice: "Erro ao deletar a partida: #{e.message}"
  end

  private

  def match_params
    params.require(:match).permit(:match_date)
  end

  def set_match
    @match = Match.find(params[:id])
  end
end
