# frozen_string_literal: true

# Remove entries from the Searches table that are:
# - without a linked user_id
# - older than a certain number of days
class CleanupSearchesJob
  include Sidekiq::Job

  sidekiq_options queue: 'low'

  MAX_DAYS_OLD = 7

  def perform
    Search.delete_old_searches MAX_DAYS_OLD
  end
end
