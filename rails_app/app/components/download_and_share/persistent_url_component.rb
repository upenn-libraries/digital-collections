# frozen_string_literal: true

module DownloadAndShare
  # Renders persistent url link.
  class PersistentUrlComponent < ViewComponent::Base
    def initialize(document:)
      @document = document
    end
  end
end
