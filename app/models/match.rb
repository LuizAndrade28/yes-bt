class Match < ApplicationRecord
  has_many :plays, dependent: :destroy
  # limit the number of plays to 3
  validates :plays, length: { maximum: 3 }
  validates :match_date, presence: true

  def day
    I18n.l match_date, format: :day
  end

  def match_date_br
    I18n.l match_date, format: :default
  end

  def plays_count
    "#{plays.count} / 3 plays"
  end
end
