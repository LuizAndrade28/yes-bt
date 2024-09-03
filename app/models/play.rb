class Play < ApplicationRecord
  belongs_to :match
  has_many :play_players, dependent: :destroy
  has_many :players, through: :play_players

  validates :games_won_dupla1, presence: true
  validates :games_won_dupla2, presence: true
  validates :games_won_dupla1, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 6 }
  validates :games_won_dupla2, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 6 }
   validates :play_players, presence: true

  accepts_nested_attributes_for :play_players, allow_destroy: true

  attr_accessor :games_won_dupla1, :games_won_dupla2

  def dupla1
    play_players.first(2)
  end

  def dupla2
    play_players.last(2)
  end
end
