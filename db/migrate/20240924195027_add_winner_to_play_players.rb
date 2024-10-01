class AddWinnerToPlayPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :play_players, :winner, :boolean
  end
end
