# frozen_string_literal: true

FactoryBot.define do
  factory :qualification do
    question_id { 49 }
    pre_codes { %w[21 23 24] }
    quotum
  end
end
