class Match < ApplicationRecord
  has_many :plays, dependent: :destroy

  def day
    match_date.strftime("%A")
  end
end
