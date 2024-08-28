class PagesController < ApplicationController
  def home
    @players = Player.all.order(:games_won).reverse
    @female_players = Player.where(:gender => 'Feminino').order(:games_won).reverse
    @matches = Match.all
    @plays = Play.all
    @play_players = PlayPlayer.all
    @play = Play.new
  end
end
