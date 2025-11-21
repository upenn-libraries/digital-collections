# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    id { published_json['id'] || published_json[:id] }
    published_json { attributes_for(:item_hash) }
  end
end
