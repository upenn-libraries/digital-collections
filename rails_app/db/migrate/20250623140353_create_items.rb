# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items, id: :uuid do |t|
      t.jsonb :published_json, null: false

      t.timestamps
    end
  end
end
