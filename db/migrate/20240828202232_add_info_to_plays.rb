class AddInfoToPlays < ActiveRecord::Migration[7.1]
  def change
    add_column :plays, :date_play, :date
    add_column :plays, :dupla1, :integer, array: true, default: []
    add_column :plays, :dupla2, :integer, array: true, default: []
    add_column :plays, :dupla1_games, :integer
    add_column :plays, :dupla2_games, :integer
  end
end
