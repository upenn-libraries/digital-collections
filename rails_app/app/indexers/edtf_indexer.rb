# frozen_string_literal: true

# Convert EDTF encoded values to a human readable date and year.
#
# @todo: More logic to fully convert EDTF dates to a human readable format and year is needed.
class EDTFIndexer
  attr_reader :original

  # @param original [String] date encoded in EDTF
  def initialize(original)
    @original = original
  end

  # Returns human-readable interpretation of EDTF date value. If there isn't a better human-readable
  # interpretation, we return the original value.
  #
  # @return [String]
  def humanize
    if original.match?(/^\d\d(\d|X)X$/)
      "#{original.tr('X', '0')}s"
    else
      original
    end
  end

  # Returns an array containing all the years represented by the EDTF date value.
  #
  # @return [Array]
  def years
    if original.match?(/^\d\d(\d|X)X$/) # 10XX, 100X
      Range.new(original.tr('X', '0').to_i, original.tr('X', '9').to_i).to_a.map(&:to_s)
    elsif original.match?(/^\d\d\d\d(-\d\d(-\d\d)?)?$/) # 2002, 2002-02, 2002-02-02
      Array.wrap(original[0..3])
    else
      []
    end
  end
end
