class Play < ApplicationRecord
  belongs_to :match
  has_many :play_players, dependent: :destroy
  has_many :players, through: :play_players

  accepts_nested_attributes_for :play_players, allow_destroy: true
  
  attr_accessor :games_won_dupla1, :games_won_dupla2

  def dupla1
    play_players.first(2)
  end

  def dupla2
    play_players.last(2)
  end
end
