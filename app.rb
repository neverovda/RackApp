require_relative 'app/time_format'

class App
  def call(env)
    path = [env['REQUEST_METHOD'], env['REQUEST_PATH']]
    if paths.key?(path)
      controller = paths[path][:controller]
      method = paths[path][:method]
      response_params = controller.new(env['QUERY_STRING']).send(method)
    else
      response_params = not_found
    end
    make_response(response_params)
  end

  private

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def paths
    { ['GET', '/time'] => { controller: TimeFormat, method: :get } }
  end

  def not_found
    { code: 404, body: ['Not found'] }
  end

  def make_response(params)
    [
      params[:code],
      headers,
      params[:body]
    ]
  end
end
