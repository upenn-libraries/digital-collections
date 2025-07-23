# frozen_string_literal: true

# Convert EDTF encoded values to a human readable date and year.
class EDTFIndexer
  attr_reader :original, :edtf

  # @param date [String] date encoded in EDTF
  def initialize(date)
    @original = date
    @edtf = generate_edtf_object(date)
  end

  # Returns human-readable interpretation of EDTF date value. If there isn't a better human-readable
  # interpretation, we return the original value.
  #
  # @return [String]
  def humanize
    case edtf
    when EDTF::Century, EDTF::Decade
      "between #{edtf.min.year} and #{edtf.max.year}"
    when DateTime # Date has time
      edtf.strftime('%Y-%m-%d %T')
    when NilClass
      original
    when Date
      if edtf.year.negative?
        match = edtf.humanize.match(/^-0*(\d+)/)
        "#{match[1]} B.C."
      else
        edtf.humanize
      end
    else
      edtf.humanize
    end
  end



  # Returns an array containing all the years represented by the EDTF date value.
  #
  # @return [Array]
  def years
    case edtf
    when Date, DateTime, EDTF::Season
      [edtf.year.to_s]
    when EDTF::Century, EDTF::Decade, EDTF::Set
      edtf.to_a.map(&:year).map(&:to_s).uniq
    when EDTF::Interval
      years_for_interval(edtf)
    else
      []
    end
  end

  private

  # Returns years for a EDTF::Interval. If the interval is unknown or open only returns the year specified because
  # otherwise, the intervals might be rather large and would make year search less helpful.
  #
  # @param interval [EDFT::Interval]
  # @return [Array] years
  def years_for_interval(interval)
    if interval.unknown? || interval.open?
      year = interval.to.is_a?(Date) ? interval.to.year : interval.from.year
      Array.wrap(year.to_s)
    else
      interval.to_a.map(&:year).map(&:to_s).uniq
    end
  end

  # Returns EDTF date object.
  #
  # @param date [String]
  # @return [Date, DateTime, EDTF::Interval, EDTF::Set, EDTF::Epoch, EDTF::Season]
  def generate_edtf_object(date)
    # Need to normalize the date to match the EDTF specification used by ruby-edtf
    case date
    when /^\d\d\dX$/ # Custom logic for '100X' dates
      EDTF::Decade.new(date.tr('X', '0').to_i)
    when /^\d\dXX$/ # Custom logic for '10XX' dates
      EDTF::Century.new(date.tr('X', '0').to_i)
    when /^-\d{4,5}$/ # Custom logic to create the appropriate object for negative years.
      Date.new(date.to_i).year_precision!
    else
      DateTime.edtf(adjust_open_and_unknown_intervals(date.dup))
    end
  end

  # Adjust open and unknown intervals to match the syntax edtf-ruby expects.
  #
  # @param date [String]
  # @return [String]
  def adjust_open_and_unknown_intervals(date)
    edtf_date = date.dup
    edtf_date = "unknown#{edtf_date}" if edtf_date.start_with?('/')
    edtf_date = edtf_date.gsub('..', 'unknown') if edtf_date.start_with?('../')
    edtf_date = "#{edtf_date}unknown" if edtf_date.end_with?('/')
    edtf_date = edtf_date.gsub('..', 'open') if edtf_date.end_with?('/..')
    edtf_date
  end
end
