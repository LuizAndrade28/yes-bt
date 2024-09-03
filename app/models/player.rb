class Player < ApplicationRecord
  has_many :play_players, dependent: :destroy
  has_many :plays, through: :play_players

  validates :name, presence: true, uniqueness: { message: 'já está cadastrado' }
  validates :gender, presence: true
  # validates :games_won, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def games_balance
    games_won - games_lost
  end

  def matches_count
    plays.select(:match_id).distinct.count
  end
end
