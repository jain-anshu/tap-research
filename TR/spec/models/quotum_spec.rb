require 'rails_helper'

RSpec.describe Quotum, type: :model do
  let(:subject) {build(:quotum)}

  it {is_expected.to be_valid}
  it {is_expected.to validate_presence_of(:original_quotum_id)}
  it {is_expected.to validate_presence_of(:num_respondents)}
  it {is_expected.to belong_to(:campaign)}
  it {is_expected.to have_many(:qualifications)}
end
