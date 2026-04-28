# frozen_string_literal: true

# Component for displaying a set of collections
class AccordionComponent < ViewComponent::Base
  renders_one :header
  renders_one :body

  attr_reader :id, :expanded

  def initialize(id:, expanded: true)
    @id = id
    @expanded = expanded
  end
end



