class PlayersController < ApplicationController
  before_action :set_player, only: %i[edit update]

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    @player.name = @player.name.strip.titleize
    @player.games_won = 0
    @player.games_lost = 0
    @player.sets_won = 0

    respond_to do |format|
      if params[:confirm].present? && @player.save!
        format.html { redirect_to root_path, notice: 'Jogador criado com sucesso. 🟢' }
      elsif params[:confirm_and_create].present? && @player.save!
        format.html { redirect_to new_player_path, notice: 'Jogador criado com sucesso. 🟢' }
      else
        format.html { render :new, notice: 'Jogador não foi criado com sucesso. 🔴' }
      end
    end
  end

  def edit
  end

  def update
    if @player.update!(player_params)
      redirect_to root_path, notice: 'Jogador atualizado com sucesso. 🟢'
    else
      render :edit, notice: 'Jogador não foi atualizado com sucesso. 🔴'
    end
  end

  def destroy
    @player = Player.find(params[:id])

    ActiveRecord::Base.transaction do
      @player.matches.each do |match|
        match.plays.each_with_index do |play, i|

          playid = play.id
          playplayers = PlayPlayer.where(play_id: playid).where.not(player_id: @player.id)
          match_plays_count = Match.find(play.match_id).plays.count

          playplayers.each do |playplayer|
            player_to_uptade = Player.find(playplayer.player_id)
            play_games_won = playplayer.games_won
            play_games_lost = playplayer.games_lost

            player_to_uptade.games_won -= play_games_won
            if player_to_uptade.games_lost < 0
              player_to_uptade.games_lost += play_games_lost
            else
              player_to_uptade.games_lost -= play_games_lost
            end
            player_to_uptade.sets_won -= 1 if play_games_won == 6

              if player_to_uptade.save!
                playplayer.destroy!
              else
                raise ActiveRecord::Rollback
              end
          end

          if i + 1 == match_plays_count
            Match.find(play.match_id).destroy!
          end
        end
      end

      if @player.destroy!
        redirect_to root_path, notice: 'Jogador deletado com sucesso. 🟢'
      else
        redirect_to root_path, notice: 'Jogador não foi deletado com sucesso. 🔴'
      end
    end
  rescue => e
    Rails.logger.error "Erro ao deletar o player: #{e.message}"
    redirect_to root_path, notice: "Erro ao deletar o player: #{e.message}"
  end

  private

  def player_params
    params.require(:player).permit(:name, :gender, :games_won, :games_lost, :sets_won)
  end

  def set_player
    @player = Player.find(params[:id])
  end
end
