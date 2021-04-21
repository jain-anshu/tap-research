# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'

namespace :batch do
  desc 'Fetch all the campaigns and store in db'
  task fetch_campaigns: :environment do
    url = URI('https://staging.tapresearch.com/api/v1/campaigns')

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request['Authorization'] = 'Basic  Y29kZXRlc3RAdGFwLmNvbToxYzdkZDZmZDJhOTRiMmU2NDMxYjM2NzE4OWFlYWQwMQ=='

    response = http.request(request)
    campaigns = JSON.parse(response.read_body)
    campaigns.each do |rec|
      c = Campaign.new
      c.name = rec['name']
      c.length_of_interview = rec['length_of_interview']
      c.cpi = rec['cpi']

      c.save
    end
  end
end
