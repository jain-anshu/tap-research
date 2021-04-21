# frozen_string_literal: true

class CreateQualifications < ActiveRecord::Migration[5.0]
  def change
    create_table :qualifications do |t|
      t.integer :question_id, null: false
      t.text :pre_codes
      t.integer :quotum_id, null: false
    end
  end
end
