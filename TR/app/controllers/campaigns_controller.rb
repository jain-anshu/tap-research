class CampaignsController < ApplicationController
  def index
    ::FetchCampaignsJob.new.perform
    campaigns = Campaign.all
    render json: campaigns
  end

  def ordered_campaigns
    campaigns = Campaign.includes(quota: :qualifications)
    campaigns = campaigns.sort_by do |c|
      c.quota.inject(0) do |cnt, q|
        cnt += q.qualifications.count
      end
    end.reverse
    dummy_campaigns = []
    campaigns.each.with_index do |c, i|
      d_c = {}
      d_c['name'] = c['name']
      d_c['length_of_interview'] = c['length_of_interview']
      d_c['cpi'] = c['cpi']
      d_c['quota'] = []
      c.quota.each.with_index do |q, j|
        d_q = {}
        d_q['name'] = q['name']
        d_q['num_respondents'] = q['num_respondents']
        d_q['campaign_id'] = q['campaign_id']
        d_q['qualifications'] = q.qualifications
        d_c['quota'] << d_q
      end
      dummy_campaigns << d_c
    end
    render json: dummy_campaigns
  end

end
