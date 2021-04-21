# frozen_string_literal: true

class CreateCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns do |t|
      t.integer :original_campaign_id, null: false
      t.string :name, null: false
      t.float :length_of_interview, null: false
      t.float :cpi, null: false
    end
  end
end
