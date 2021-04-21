# frozen_string_literal: true

FactoryBot.define do
  factory :quotum do
    original_quotum_id { 515 }
    name { 'Graduates' }
    num_respondents { 59 }
    campaign
  end
end
