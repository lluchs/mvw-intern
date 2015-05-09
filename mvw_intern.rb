require 'sinatra/base'
require 'sinatra/sequel'
require 'maildir'

require './app/helpers'
require './app/routes'

module MvwIntern
  class App < Sinatra::Base
    register Sinatra::SequelExtension
    helpers Helpers

    # Database configuration
    configure do
      set :database_url, ENV['DATABASE_URL'] || 'postgres://localhost:5432/mvw-intern'
      database
      require './app/models'
    end

    # Views configuration
    configure do
      set :views, settings.root + '/app/views'
    end

    configure do
      enable :logging
      enable :method_override
    end

    configure :development do
      enable :sessions
      set :session_secret, 'foobar'
      set :persona_audience, 'http://localhost:3000'
      set :maildir, 'maildir'
    end

    configure :production do
      # Fixes issue with proxying POST
      use Rack::Session::Cookie,
        key: 'session',
        path: '/',
        secret: ENV['SESSION_SECRET']
      set :persona_audience, ENV['PERSONA_AUDIENCE']
      set :maildir, ENV['MAILDIR']
    end

    before do
      unless login? || request.path.start_with?('/auth')
        halt 401, slim(:login)
      end
    end

    get '/' do
      slim :index
    end

    get '/users' do
      Models::User.all.to_s
    end

    get '/s' do
      "value = " << session[:value].inspect
    end

    get '/s/:value' do
      session[:value] = params[:value]
    end

    register Routes

  end
end
