# frozen_string_literal: true

# == Schema Information
#
# Table name: quota
#
#  id                 :integer          not null, primary key
#  original_quotum_id :integer          not null
#  name               :string
#  num_respondents    :integer          not null
#  campaign_id        :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Quotum < ApplicationRecord
  validates :original_quotum_id, presence: true
  validates :num_respondents, presence: true
  belongs_to :campaign

  has_many :qualifications
end
