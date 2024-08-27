class PlayPlayer < ApplicationRecord
  belongs_to :player
  belongs_to :play

  validates :games_won, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :games_won, numericality: { less_than_or_equal_to: 6, message: 'não pode ser maior que 6' }, if: -> { games_won.present? }
  validates :player_id, uniqueness: { scope: :play_id, message: 'já está participando desta partida' }
  validates :play_id, uniqueness: { scope: :player_id, message: 'já está participando desta partida' }

end
