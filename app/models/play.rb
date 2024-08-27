class Play < ApplicationRecord
  belongs_to :match
  has_many :play_players, dependent: :destroy
  has_many :players, through: :play_players

  accepts_nested_attributes_for :play_players, allow_destroy: true
end
