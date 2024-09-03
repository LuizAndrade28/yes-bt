class PagesController < ApplicationController
  def home
    # Inicializando variáveis de jogadores e Ordenando os jogadores
    @players = Player.all.order(name: :asc)
    @female_players = Player.where(gender: 'Feminino').order(games_won: :desc)
    @players_ranking = Player.all.order(games_won: :desc)

    # Outras variáveis
    @matches = Match.all

    # respond_to do |format|
    #   format.html
    #   format.turbo_stream
    # end
  end
end
