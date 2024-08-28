class Player < ApplicationRecord
  has_many :play_players, dependent: :destroy
  has_many :plays, through: :play_players

  validates :name, presence: true
  validates :games_won, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, uniqueness: { message: 'já está cadastrado' }

  # def games_won
  #   play_players.sum(:games_won)
  # end
  def games_balance
    games_won - games_lost
  end

  def matches
    plays.select(:match_id).distinct.count
  end

end
