class PlayPlayer < ApplicationRecord
  belongs_to :player
  belongs_to :play

  validates :games_won, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
