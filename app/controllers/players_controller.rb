class PlayersController < ApplicationController
  before_action :set_player, only: %i[edit update destroy]

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    @player.name = @player.name.strip.titleize
    @player.games_won = 0
    @player.games_lost = 0
    @player.sets_won = 0

    # if @player.save!
    #   redirect_to @player, notice: 'Jogador criado com sucesso. 🟢'
    # else
    #   render :new, notice: 'Jogador não foi criado com sucesso. 🔴'
    # end

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
      redirect_to @player, notice: 'Jogador atualizado com sucesso. 🟢'
    else
      render :edit, notice: 'Jogador não foi atualizado com sucesso. 🔴'
    end
  end

  def destroy
    @player.destroy

    redirect_to root_path
  end

  private

  def player_params
    params.require(:player).permit(:name, :gender, :games_won, :games_lost, :sets_won)
  end

  def set_player
    @player = Player.find(params[:id])
  end
end
