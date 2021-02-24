class CmsRouterMiddleware
  def initialize(app, redirect_file_path)
    @app = app
    @redirect_file_path = redirect_file_path
  end

  def call(env)
    path = Rack::Request.new(env).path
    branch_data = load_redirects
    branch_data['site_redirects'].each do |redir|
      return exec(path, redir, env) if match(path, redir)
    end

    # Here we use the passthru - the middleware is placed before static file serving
    # You could perhaps invoke a static file middleware directly or do it yourself
    dest = branch_data['page_redirects'][path]
    return passthru(env, dest) if dest
    @app.call(env)
  end

  def load_redirects
    branch_data = JSON.parse(File.read(@redirect_file_path))
  rescue => error
    report_error error
    return {
      'site_redirects' => [],
      'page_redirects' => {},
    }
  end

  def match(path, redir)
    case redir['redirect_url_type']
    when 'EXACT'
      path == redir['redirect_url']
    when 'EXACTICASE'
      path.downcase == redir['redirect_url'].downcase
    when 'BEGINS'
      path.start_with? redir['redirect_url']
    when 'BEGINSICASE'
      path.downcase.start_with? redir['redirect_url'].downcase
    when 'REGEX'
      path.match? Regexp.new(redir['redirect_url'])
    when 'REGEXICASE'
      path.match? Regexp.new(redir['redirect_url'], true)
    else
      false
    end
  end

  def exec(path, redir, env)
    case redir['redirect_http_code']
    when '301'
      redirect 301, dest_path(path, redir)
    when '302'
      redirect 302, dest_path(path, redir)
    when 'PASSTHRU'
      passthru env, dest_path(path, redir)
    else
      report_error 'redirect code unknown'
      @app.call(env)
    end
  end

  def dest_path(path, redir)
    case redir['redirect_url_type']
    when 'REGEX'
      path.sub Regexp.new(redir['redirect_url']), redir['redirect_dest'].gsub(/\$(\d+)/, '\\\1')
    when 'REGEXICASE'
      path.sub Regexp.new(redir['redirect_url'], true), redir['redirect_dest'].gsub(/\$(\d+)/, '\\\1')
    else
      redir['redirect_dest']
    end
  end

  def redirect(code, url)
    [code.to_i, {'Location' => url, 'Content-Type' => Rack::Mime.mime_type(::File.extname(url))}, [""]]
  end

  def passthru(env, url)
    # Continue with standard routing
    # You could perhaps check for fully qualified urls and load a remote file
    @app.call(env.merge({'PATH_INFO' => url}))
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