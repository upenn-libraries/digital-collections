# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    published_json { attributes_for(:item_hash) }
  end
end
