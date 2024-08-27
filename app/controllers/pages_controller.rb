class PagesController < ApplicationController
  def home
    @players = Player.all
    @matches = Match.all
    @plays = Play.all
    @play_players = PlayPlayer.all
    @play = Play.new
  end
end
