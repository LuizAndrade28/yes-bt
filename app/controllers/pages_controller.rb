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

  def delete_all_data
    # Deletando todos os jogadores
    Player.delete_all

    # Deletando todos os jogos
    Match.delete_all

    # Deletando todos os jogos
    Play.delete_all

    # Deletando todos os jogos
    PlayPlayer.delete_all

    # Redirecionando para a página inicial
    redirect_to root_path
  end

  def export_data
  end
end
