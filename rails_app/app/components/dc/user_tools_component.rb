# frozen_string_literal: true

module DC
  # User tools
  class UserToolsComponent < ViewComponent::Base
    attr_accessor :user

    def initialize(user:)
      @user = user
    end
  end
end
