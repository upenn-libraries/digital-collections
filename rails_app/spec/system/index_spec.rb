# frozen_string_literal: true

require 'system_helper'

describe 'index page' do
  before { visit root_path }

  it 'renders blacklight interface' do
    expect(page).to have_text 'Limit your search'
  end
end
