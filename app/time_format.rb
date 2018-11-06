class TimeFormat
  DEFAULT_COMPOSITION = %w[year month day].freeze
  FORMAT_MAPPING = { 'year' => '%Y', 'month' => '%m', 'day' => '%d',
                     'hour' => '%H', 'minute' => '%M', 'second' => '%S' }.freeze

  def initialize(params)
    @composition_format = if params.key?('format')
                            params['format'].split(',')
                          else
                            DEFAULT_COMPOSITION
                          end
  end

  def valid?
    invalid_params.empty?
  end

  def time
    Time.now.strftime(string_format_time)
  end

  def invalid_params
    @invalid_params ||= @composition_format - FORMAT_MAPPING.keys
  end

  private

  def string_format_time
    @composition_format.select { |format| FORMAT_MAPPING.key?(format) }
                       .map { |format| FORMAT_MAPPING[format] }.join('-')
  end
end
