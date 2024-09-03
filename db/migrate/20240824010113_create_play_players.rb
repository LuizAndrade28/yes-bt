class CreatePlayPlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :play_players do |t|
      t.references :player, null: false, foreign_key: true
      t.references :play, null: false, foreign_key: true
      t.integer :games_won

      t.timestamps
    end
  end
end
