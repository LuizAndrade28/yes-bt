class PlaysController < ApplicationController
  before_action :set_play, only: %i[edit update destroy]
  before_action :set_match, only: %i[new create update]

  def new
    @play = @match.plays.new
    4.times { @play.play_players.build }
  end

  def create
    @play = @match.plays.new(play_params)
    @play.match_id = @match.id


    if @play.save!
      redirect_to match_path(@match), notice: 'Play criado com sucesso. 🟢'
    else
      render :new, notice: 'Play não foi criado com sucesso. 🔴'
    end
  end

  def edit
  end

  def update
    if @play.update!(play_params)
      redirect_to request.referer || match_path(@match), notice: 'Play atualizado com sucesso. 🟢'
    else
      render :edit, notice: 'Play não foi atualizado com sucesso. 🔴'
    end
  end

  def destroy
    if @play.destroy!
      redirect_to root_path, notice: 'Play deletado com sucesso. 🟢'
    end
  end

  private

  def play_params
    params.require(:play).permit(:play_number, play_players_attributes: [:player_id, :games_won, :id, :_destroy])
  end

  def set_play
    @play = Play.find(params[:id])
  end

  def set_match
    @match = Match.find(params[:match_id])
  end
end
