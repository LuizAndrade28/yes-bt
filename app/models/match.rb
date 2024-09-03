class Match < ApplicationRecord
  has_many :plays, dependent: :destroy
  # limit the number of plays to 3
  validates :plays, length: { maximum: 3 }

  def day
    I18n.l match_date, format: :day
  end

  def plays_count
    "#{plays.count} / 3 plays"
  end
end
