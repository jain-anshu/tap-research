# frozen_string_literal: true

class CreateQuotas < ActiveRecord::Migration[5.0]
  def change
    create_table :quotas do |t|
      t.string :name, null: false
      t.integer :num_respondents
    end
  end
end
