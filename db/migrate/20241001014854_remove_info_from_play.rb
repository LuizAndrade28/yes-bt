class RemoveInfoFromPlay < ActiveRecord::Migration[7.1]
  def change
    remove_column :plays, :play_number, :integer
  end
end
