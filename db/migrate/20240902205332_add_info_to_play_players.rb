class AddInfoToPlayPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :play_players, :games_lost, :integer
  end
end
