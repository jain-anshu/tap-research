class Qualification < ApplicationRecord
  validates :question_id, presence: true
  validates :quotum_id, presence: true
  belongs_to(:quotum, {
    primary_key: :original_quotum_id,
    foreign_key: :quotum_id,
    class_name: :Quotum
  })
end
