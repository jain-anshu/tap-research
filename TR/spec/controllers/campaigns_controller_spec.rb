# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  let(:subject) { get('ordered_campaigns') }
  let!(:qualification) { create(:qualification) }
  let!(:campaign) { create(:campaign, name: 'no_qualification') }
  before do
    campaign
    qualification
    subject
  end
  let(:parsed_response) { JSON.parse(response.body) }
  describe 'GET /campaigns/ordered_campaigns' do
    it 'is getting status OK' do
      expect(response.status).to eq(200)
    end
    it 'is getting correct number of campaigns' do
      expect(parsed_response.count).to eq(2)
    end
    it 'has quota' do
      expect(parsed_response[0].keys).to include('quota')
    end
    it 'has qualification inside quota' do
      expect(parsed_response[0]['quota'][0]).to include('qualifications')
    end
    it 'results get sorted in the descending order of total number of qualifications' do
      expect(parsed_response.first['name']).to eq('Cookie')
    end
  end
end
