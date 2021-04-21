# frozen_string_literal: true

class CampaignsController < ApplicationController
  def ordered_campaigns
    campaigns = Campaign.includes(quota: :qualifications)
    campaigns = sort_by_count campaigns
    payload = campaigns.as_json(
      include: { quota: {
        include:  :qualifications
      } }
    )
    render json: payload
  end

  private

  def sort_by_count(campaigns)
    campaigns.sort_by do |c|
      c.quota.inject(0) do |cnt, q|
        cnt + q.qualifications.count
      end
    end.reverse
  end
end
