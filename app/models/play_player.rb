class PlayPlayer < ApplicationRecord
  belongs_to :player
  belongs_to :play

  validates :games_won, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 6, message: 'não pode ser maior que 6' }, if: -> { games_won.present? }
end
