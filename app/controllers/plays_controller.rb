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

   if params[:play][:games_won_dupla1].present? && params[:play][:games_won_dupla2].present?
      games_won_dupla1 = params[:play][:games_won_dupla1].to_i
      games_won_dupla2 = params[:play][:games_won_dupla2].to_i

      # Atribuir games_won para os jogadores da dupla 1 e atualizar jogos e sets
      @play.dupla1.each do |pp|
        pp.games_won = games_won_dupla1
        pp.player.games_won += games_won_dupla1 # Incrementar jogos ganhos
        pp.player.games_lost += games_won_dupla2 # Incrementar jogos perdidos
        pp.player.sets_won += 1 if games_won_dupla1 >= 6 # Incrementar sets ganhos
        pp.player.save
      end

      # Atribuir games_won para os jogadores da dupla 2 e atualizar jogos e sets
      @play.dupla2.each do |pp|
        pp.games_won = games_won_dupla2
        pp.player.games_won += games_won_dupla2 # Incrementar jogos ganhos
        pp.player.games_lost += games_won_dupla1 # Incrementar jogos perdidos
        pp.player.sets_won += 1 if games_won_dupla2 >= 6 # Incrementar sets ganhos
        pp.player.save
      end
    end

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
    params.require(:play).permit(:play_number,
                                :games_won_dupla1,
                                :games_won_dupla2,
                                play_players_attributes: [:player_id, :id, :_destroy])
  end

  def set_play
    @play = Play.find(params[:id])
  end

  def set_match
    @match = Match.find(params[:match_id])
  end
end
