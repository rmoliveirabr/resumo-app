class Post < ApplicationRecord
  after_initialize :set_defaults

  belongs_to :user

  belongs_to :year
  belongs_to :subject
  belongs_to :topic

  has_and_belongs_to_many :tags

  has_many_attached :files

  def blank_stars
   5 - rating.to_i
  end

  def set_defaults
    if !self.rating.present?
      self.rating = "0"
    end
  end
end
