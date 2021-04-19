class CreateQuota < ActiveRecord::Migration[5.0]
  def change
    create_table :quota do |t|
      t.integer :original_quotum_id, null: false
      t.string :name
      t.integer :num_respondents, null: false
      t.integer :campaign_id, null: false
      t.timestamps
    end
  end
end
