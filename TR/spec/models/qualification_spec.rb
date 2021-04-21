# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Qualification, type: :model do
  let(:subject) { build(:qualification) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:question_id) }
  it { is_expected.to belong_to(:quotum) }
end
