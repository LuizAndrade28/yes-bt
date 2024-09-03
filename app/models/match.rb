class Match < ApplicationRecord
  has_many :plays, dependent: :destroy

  def day
    I18n.l match_date, format: :day
  end
end
