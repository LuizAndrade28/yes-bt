class PlaysController < ApplicationController
  before_action :set_match, only: %i[new edit create update destroy]
  before_action :set_play, only: %i[edit update]

  def new
    @play = @match.plays.new
    4.times { @play.play_players.build }
  end

  def create
    ActiveRecord::Base.transaction do
      @play = @match.plays.new(play_params)
      @play.date_play = @match.match_date
      @play.match_id = @match.id

      if params[:play][:games_won_dupla1].present? && params[:play][:games_won_dupla2].present?
        jogador1 = params[:play][:play_players_attributes]["0"][:player_id].to_i
        jogador2 = params[:play][:play_players_attributes]["1"][:player_id].to_i
        jogador3 = params[:play][:play_players_attributes]["2"][:player_id].to_i
        jogador4 = params[:play][:play_players_attributes]["3"][:player_id].to_i

        @play.dupla1 = [jogador1, jogador2]
        @play.dupla2 = [jogador3, jogador4]
        @play.dupla1_games = params[:play][:games_won_dupla1].to_i
        @play.dupla2_games = params[:play][:games_won_dupla2].to_i

        games_won_dupla1 = params[:play][:games_won_dupla1].to_i
        games_won_dupla2 = params[:play][:games_won_dupla2].to_i

        @play.dupla1.each do |pp|
          pp.games_won = games_won_dupla1
          pp.games_lost = games_won_dupla2
          pp.player.games_won += games_won_dupla1
          pp.player.games_lost += games_won_dupla2
          pp.player.sets_won += 1 if games_won_dupla1 >= 6
          pp.player.save!
        end

        @play.dupla2.each do |pp|
          pp.games_won = games_won_dupla2
          pp.games_lost = games_won_dupla1
          pp.player.games_won += games_won_dupla2
          pp.player.games_lost += games_won_dupla1
          pp.player.sets_won += 1 if games_won_dupla2 >= 6
          pp.player.save!
        end
      end

      if @play.save!
        redirect_to match_path(@match), notice: 'Play criado com sucesso. 🟢'
      else
        raise ActiveRecord::Rollback, 'Play não foi criado com sucesso.'
      end
    end
  rescue => e
      Rails.logger.error "Erro ao criar o play: #{e.message}"
      render :new, notice: "Erro ao criar o play: #{e.message}"
  end

  def edit
  end

  def update
    ActiveRecord::Base.transaction do
      if params[:play][:games_won_dupla1].present? && params[:play][:games_won_dupla2].present?
        games_won_dupla1 = params[:play][:games_won_dupla1].to_i
        games_won_dupla2 = params[:play][:games_won_dupla2].to_i
        @play.dupla1_games = games_won_dupla1
        @play.dupla2_games = games_won_dupla2

        @play.dupla1.each do |pp|
          old_games_won = pp.games_won || 0
          old_games_lost = pp.games_lost || 0
          pp.games_won = games_won_dupla1
          pp.games_lost = games_won_dupla2
          update_player_stats(pp, games_won_dupla1, games_won_dupla2, old_games_won, old_games_lost)
          pp.player.save!
          pp.save!
        end

        @play.dupla2.each do |pp|
          old_games_won = pp.games_won || 0
          old_games_lost = pp.games_lost || 0
          pp.games_won = games_won_dupla2
          pp.games_lost = games_won_dupla1
          update_player_stats(pp, games_won_dupla2, games_won_dupla1, old_games_won, old_games_lost)
          pp.player.save!
          pp.save!
        end
      end

      if @play.update!(play_params)
        @play.play_players.each do |play_player|
          Rails.logger.info "Salvando PlayPlayer #{play_player.id} - Games Won: #{play_player.games_won}"
          play_player.save!
        end
        redirect_to match_path(@match), notice: 'Play atualizado com sucesso. 🟢'
      else
        raise ActiveRecord::Rollback, 'Play não foi atualizado com sucesso.'
      end
    end
  rescue => e
      render :edit, status: :unprocessable_entity, notice: "Erro ao atualizar o play: #{e.message}"
  end

  def destroy
    @play = Play.find(params[:id])

    ActiveRecord::Base.transaction do
      @play.play_players.each do |play_player|
        player = play_player.player

        player.games_won -= play_player.games_won
        if player.games_lost < 0
          player.games_lost += play_player.games_lost
        else
          player.games_lost -= play_player.games_lost
        end
        player.sets_won -= 1 if play_player.games_won >= 6

        if player.save!
          play_player.destroy!
        else
          raise ActiveRecord::Rollback, 'Erro ao deletar o play jogador.'
        end
      end

      if @play.destroy
        redirect_to match_path(@match), notice: 'Play deletado com sucesso. 🟢'
      else
        redirect_to match_path(@match), alert: 'Erro ao deletar o play. 🔴'
      end
    end
  rescue => e
    Rails.logger.error "Erro ao deletar o play: #{e.message}"
    redirect_to match_path(@match), notice: "Erro ao deletar o play: #{e.message}"
  end

  private

  def play_params
    params.require(:play).permit(
                                :games_won_dupla1,
                                :games_won_dupla2,
                                :date_play,
                                :dupla1_games,
                                :dupla2_games,
                                play_players_attributes: [:player_id, :id, :_destroy, :games_won, :games_lost]
                              )
  end

  def set_play
    @play = @match.plays.find(params[:id])
  end

  def set_match
    @match = Match.find(params[:match_id])
  end

  def update_player_stats(play_player, games_won, games_lost, old_games_won = 0, old_games_lost = 0)
    player = play_player.player

    # Atualiza as estatísticas do jogador com base nos games ganhos e perdidos
    player.games_won += (games_won - old_games_won)
    player.games_lost += (games_lost - old_games_lost)

    # Atualiza sets ganhos ou perdidos
    if games_won >= 6 && old_games_won < 6
      player.sets_won += 1
    elsif games_won < 6 && old_games_won >= 6
      player.sets_won -= 1
    end

    # Salva o estado atualizado do jogador
    Rails.logger.info "Atualizando Player #{player.id} - Games Won: #{player.games_won}, Games Lost: #{player.games_lost}, Sets Won: #{player.sets_won}"
  end
end
