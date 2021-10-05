class CmsClientjsMiddleware
  def initialize(app, clientjs_url)
    @app = app
    @clientjs_url = clientjs_url
  end

  def call(env)
    path = Rack::Request.new(env).path
    return [200, {'Content-Type' => 'application/javascript'}, [load_file]] if path == @clientjs_url

    @app.call(env)
  end

  def load_file
    File.read(File.dirname(__FILE__)+'/clientjs/jsHarmonyCmsEditor.min.js')
  rescue => error
    report_error error
    return ""
  end

  def report_error(error)
    if Object.const_defined?('Rails')
      if Rails.env.test?
        p error
      else
        Rails.logger.error error
      end
    else
      p error
    end
  end
end