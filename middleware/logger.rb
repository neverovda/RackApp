require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    params = Rack::Utils.parse_nested_query env['QUERY_STRING']
    @logger.info params
    @app.call(env)
  end
end
