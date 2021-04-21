# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Campaign, type: :model do
  let(:subject) { build(:campaign) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:original_campaign_id) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:cpi) }
  it { is_expected.to validate_presence_of(:length_of_interview) }
  it { is_expected.to have_many(:quota) }
end
