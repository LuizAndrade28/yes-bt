class MatchesController < ApplicationController
  before_action :set_match, only: %i[edit update destroy]

  def index
    @matches = Match.all
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
    @match.destroy
  end

  private

  def match_params
    params.require(:match).permit(:match_date)
  end

  def set_match
    @match = Match.find(params[:id])
  end
end
