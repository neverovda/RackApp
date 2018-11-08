require_relative 'app/time_format'

class App
  def call(env)
    request = Rack::Request.new(env)

    if request.get? && request.path == '/time'
      time_format(request.params)
    else
      make_response 404, 'Not found'
    end
  end

  private

  def time_format(params)
    formatter = TimeFormat.new(params)
    if formatter.valid?
      make_response 200, formatter.time.to_s
    else
      make_response 400, "Unknows time formats [#{formatter.invalid_params.join(', ')}]"
    end
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def make_response(code, text_body)
    [code, headers, [text_body + "\n"]]
  end
end
