# frozen_string_literal: true

require 'system_helper'

describe 'Index Page' do
  before { visit root_path }

  it 'loads the index text' do
    expect(page).to have_text 'This is a test!'
  end
end
