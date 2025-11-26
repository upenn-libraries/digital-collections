# frozen_string_literal: true

# Controller to receive publish/unpublish requests form the Digital Repository.
class DigitalRepositoryWebhookController < ApplicationController
  class InvalidEvent < StandardError; end

  before_action :token_authentication

  PUBLISH_EVENT = 'publish'
  UNPUBLISH_EVENT = 'unpublish'

  # Listen for requests from the Digital Repository.
  def listen
    case params['event']
    when PUBLISH_EVENT then publish_item
    when UNPUBLISH_EVENT then unpublish_item
    else
      raise InvalidEvent, "Invalid event: #{params['event']}"
    end
  rescue ActiveRecord::RecordNotFound
    render json: { status: 'error', message: 'Resource not found.' }, status: :not_found
  rescue ActiveRecord::RecordInvalid, InvalidEvent => e
    render json: { status: 'error', message: e.message }, status: :bad_request
  rescue StandardError => e
    render json: { status: 'error', message: e.message }, status: :internal_server_error
  end

  private

  def publish_item
    item = Item.find_or_initialize_by(id: item_json['id'])

    Item.transaction do
      item.published_json = item_json
      item.save!
      item.add_to_solr!
    end

    render json: { status: 'success', data: { item: solr_document_url(item.id) } }
  end

  def unpublish_item
    item = Item.find_by!(id: item_json['id'])

    Item.transaction do
      item.destroy!
      item.remove_from_solr!
    end

    render json: { status: 'success' }
  end

  def item_json
    params['data']['item']
  end

  def token_authentication
    authenticate_or_request_with_http_token do |token, _options|
      ActiveSupport::SecurityUtils.secure_compare(token, Settings.digital_repository.webhook_token)
    end
  end
end
