class CreatePlays < ActiveRecord::Migration[7.1]
  def change
    create_table :plays do |t|
      t.integer :play_number
      t.references :match, null: false, foreign_key: true

      t.timestamps
    end
  end
end
