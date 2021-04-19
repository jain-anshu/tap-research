class Quotum < ApplicationRecord
  validates :original_quotum_id, presence: true
  validates :num_respondents, presence: true
  validates :campaign_id, presence: true
  belongs_to :campaign, 
    primary_key: :original_campaign_id,
    foreign_key: :campaign_id,
    class_name: :Campaign

  has_many :qualifications
end
