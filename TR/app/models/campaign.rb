class Campaign < ApplicationRecord
  validates :original_campaign_id, presence: true
  validates :name, presence: true
  validates :cpi, presence: true
  validates :length_of_interview, presence: true
  has_many :quota
end
