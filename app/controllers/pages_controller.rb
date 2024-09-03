class PagesController < ApplicationController
  def home
    # Inicializando variáveis de jogadores
    @players = Player.all
    @female_players = Player.where(gender: 'Feminino')

    # Ordenando os jogadores
    @players = @players.order(games_won: :desc)
    @female_players = @female_players.order(games_won: :desc)

    # Outras variáveis e lógica de classificação
    @matches = Match.all
    @plays = Play.all
    @play_players = PlayPlayer.all
    @play = Play.new

    # respond_to do |format|
    #   format.html
    #   format.turbo_stream
    # end
  end
end
