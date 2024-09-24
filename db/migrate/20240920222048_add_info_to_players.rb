class AddInfoToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :matches_count, :integer
    add_column :players, :games_balance, :integer
  end
end
