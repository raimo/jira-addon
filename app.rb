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
    puts 'Getting these back from JIRA'
    ap h
    ap 'Initializing new OAuth::Consumer using oauth gem'
    consumer = OAuth::Consumer.new(h['key'], OpenSSL::PKey::RSA.new(IO.read("#{File.dirname(__FILE__)}/private-key.pem")), signature_method: 'RSA-SHA1', site: 'http://localhost:2990')
    puts 'Making "find anything" call.'
    ap JSON.parse(consumer.request(:get, '/jira/rest/api/2/search?user_id=admin').body) rescue {}
  end
  run! if app_file == $0
end
