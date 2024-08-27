class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :gender
      t.string :name
      t.integer :games_won
      t.integer :games_lost
      t.integer :sets_won

      t.timestamps
    end
  end
end
