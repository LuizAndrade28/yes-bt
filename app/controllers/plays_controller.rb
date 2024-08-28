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
      @play.match_id = @match.id

      if params[:play][:games_won_dupla1].present? && params[:play][:games_won_dupla2].present?
        games_won_dupla1 = params[:play][:games_won_dupla1].to_i
        games_won_dupla2 = params[:play][:games_won_dupla2].to_i

        @play.dupla1.each do |pp|
          pp.games_won = games_won_dupla1
          pp.player.games_won += games_won_dupla1
          pp.player.games_lost += games_won_dupla2
          pp.player.sets_won += 1 if games_won_dupla1 >= 6
          pp.player.save!
        end

        @play.dupla2.each do |pp|
          pp.games_won = games_won_dupla2
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
      render :new, notice: "Erro ao criar o play: #{e.message}"
  end

  def edit
  end

  def update
    ActiveRecord::Base.transaction do
      if params[:play][:games_won_dupla1].present? && params[:play][:games_won_dupla2].present?
        games_won_dupla1 = params[:play][:games_won_dupla1].to_i
        games_won_dupla2 = params[:play][:games_won_dupla2].to_i

        @play.dupla1.each do |pp|
          old_games_won = pp.games_won || 0
          pp.games_won = games_won_dupla1
          update_player_stats(pp, games_won_dupla1, games_won_dupla2, old_games_won)
          pp.player.save!
          pp.save!
        end

        @play.dupla2.each do |pp|
          old_games_won = pp.games_won || 0
          pp.games_won = games_won_dupla2
          update_player_stats(pp, games_won_dupla2, games_won_dupla1, old_games_won)
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
    if @play.destroy
      redirect_to match_path(@match), notice: 'Play deletado com sucesso. 🟢'
    else
      redirect_to match_path(@match), alert: 'Erro ao deletar o play. 🔴'
    end
  end

  private

  def play_params
    params.require(:play).permit(
                                :games_won_dupla1,
                                :games_won_dupla2,
                                play_players_attributes: [:player_id, :id, :_destroy, :games_won]
                              )
  end

  def set_play
    @play = @match.plays.find(params[:id])
  end

  def set_match
    @match = Match.find(params[:match_id])
  end

  def update_player_stats(play_player, games_won, games_lost, old_games_won = 0)
    player = play_player.player

    # Atualiza as estatísticas do jogador com base nos games ganhos e perdidos
    player.games_won += (games_won - old_games_won)
    player.games_lost += (games_lost - (6 - old_games_won))

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
