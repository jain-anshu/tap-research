# frozen_string_literal: true

# == Schema Information
#
# Table name: campaigns
#
#  id                   :integer          not null, primary key
#  original_campaign_id :integer          not null
#  name                 :string           not null
#  length_of_interview  :float            not null
#  cpi                  :float            not null
#
class Campaign < ApplicationRecord
  validates :original_campaign_id, presence: true
  validates :name, presence: true
  validates :cpi, presence: true
  validates :length_of_interview, presence: true
  has_many :quota
end
