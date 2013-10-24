require 'bundler'
Bundler.require

class MyApp < Sinatra::Base
  set :logging, true
  set :dump_errors, true
  def base_url
    "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end

  get '/' do
    erb :index
  end

  get '/atlassian-plugin.xml' do
    content_type :xml
    erb :atlassian
  end

  post '/enabled' do
    request.body.rewind
    h = JSON.parse request.body.read
    ap h
  end
  run! if app_file == $0
end
