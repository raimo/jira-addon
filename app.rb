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
    consumer = OAuth::Consumer.new(h['clientKey'], h['publicKey'], private_key_file: 'private-key.pem', signature_method: 'RSA-SHA1', site: 'http://localhost:2990')
    puts 'Making "find anything" call.'
    ap consumer.request(:get, '/jira/rest/api/2/search')
  end
  run! if app_file == $0
end
