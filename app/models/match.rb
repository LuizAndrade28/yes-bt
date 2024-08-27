class Match < ApplicationRecord
  has_many :plays, dependent: :destroy
end
