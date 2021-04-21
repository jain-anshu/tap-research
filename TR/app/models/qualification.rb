# frozen_string_literal: true

# == Schema Information
#
# Table name: qualifications
#
#  id          :integer          not null, primary key
#  question_id :integer          not null
#  pre_codes   :text
#  quotum_id   :integer          not null
#
class Qualification < ApplicationRecord
  validates :question_id, presence: true
  belongs_to :quotum
end
