class PagesController < ApplicationController
  def home
    # Inicializando variáveis de jogadores e Ordenando os jogadores
    @players = Player.all.order(name: :asc)
    @female_players = Player.where(gender: 'Feminino').order(games_won: :desc)
    @players_ranking = @players.order(games_won: :desc)

    # Outras variáveis
    @matches = Match.all

    # @female_players = @female_players.order(games_won: :desc)
    # @plays = Play.all
    # @play_players = PlayPlayer.all
    # @play = Play.new

    # respond_to do |format|
    #   format.html
    #   format.turbo_stream
    # end
  end
end
