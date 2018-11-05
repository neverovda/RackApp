class TimeFormat
  def initialize(query_string)
    @params = Rack::Utils.parse_nested_query query_string
  end

  def get
    return unknows_format if unknows_format
    required_format
  end

  private

  def unknows_format
    unknows_formats = composition_format - hash_time.keys
    return unless unknows_formats.any?
    body = ["Unknows time formats [#{unknows_formats.join(', ')}]\n"]
    { code: 400, body: body }
  end

  def required_format
    response = []
    composition_format.each do |format|
      response << hash_time[format] if hash_time.key?(format)
    end
    body = ["#{response.join('-')}\n"]
    { code: 200, body: body }
  end

  attr_reader :params

  def composition_format
    return @composition_format if @composition_format
    @composition_format = if params.key?('format')
                            params['format'].split(',')
                          else
                            default_composition
                          end
  end

  def default_composition
    %w[year month day]
  end

  def hash_time
    return @hash_time if @hash_time
    time = Time.now
    @hash_time = { 'year' => time.year,
                   'month' => time.mon,
                   'day' => time.day,
                   'hour' => time.hour,
                   'minute' => time.min,
                   'second' => time.sec }
  end
end
