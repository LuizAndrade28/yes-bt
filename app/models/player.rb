class Player < ApplicationRecord
  has_many :play_players, dependent: :destroy
  has_many :plays, through: :play_players, dependent: :destroy
  has_many :matches, through: :plays, dependent: :destroy

  validates :name, presence: true, uniqueness: { message: 'já está cadastrado' }
  validates :gender, presence: true
  validates :games_won, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sets_won, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # def games_balance
  #   games_won - games_lost
  # end

  # def matches_count
  #   plays.select(:match_id).distinct.count
  # end
end
