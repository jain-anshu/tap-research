# frozen_string_literal: true

FactoryBot.define do
  factory :campaign do
    original_campaign_id { 302 }
    name { 'Cookie' }
    length_of_interview { 11.2 }
    cpi { 2.22 }
  end
end
