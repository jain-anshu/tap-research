# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'

class FetchCampaignsJob < ApplicationJob
  queue_as :default

  def perform
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
      c.original_campaign_id = rec['id']
      cid = rec['id']
      c.save
      id = c.id
      # Get all quotas for this campaign
      campaign_url = URI("https://staging.tapresearch.com/api/v1/campaigns/#{cid}")
      http = Net::HTTP.new(campaign_url.host, campaign_url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(campaign_url)
      request['Authorization'] = 'Basic  Y29kZXRlc3RAdGFwLmNvbToxYzdkZDZmZDJhOTRiMmU2NDMxYjM2NzE4OWFlYWQwMQ=='

      response = http.request(request)
      campaigns_with_quotas = JSON.parse(response.read_body)
      quotas = campaigns_with_quotas['campaign_quotas']
      quotas.each do |quotum|
        q = Quotum.new
        q.original_quotum_id = quotum['id']
        q.name = quotum['name']
        q.num_respondents = quotum['num_respondents']
        q.campaign_id = id
        q.save
        qid = q.id
        qualifications = quotum['campaign_qualifications']
        qualifications.each do |qu|
          qual = Qualification.new
          qual.question_id = qu['question_id']
          qual.pre_codes = qu['pre_codes'].join(',')
          qual.quotum_id = qid

          qual.save
        end
      end
    end
  end
end
