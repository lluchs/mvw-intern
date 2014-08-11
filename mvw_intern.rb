require 'sinatra/base'
require 'sinatra/sequel'

require './app/helpers'
require './app/routes'

module MvwIntern
  class App < Sinatra::Base
    register Sinatra::SequelExtension
    helpers Helpers

    # Database configuration
    configure do
      set :database_url, 'sqlite://db/db.sqlite'
      database
      require './app/models'
    end

    # Views configuration
    configure do
      set :views, settings.root + '/app/views'
    end

    configure do
      enable :logging
      enable :sessions
      enable :method_override
    end

    configure :development do
      set :session_secret, 'foobar'
      set :persona_audience, 'http://localhost:3000'
    end

    configure :production do
      set :session_secret, ENV['SESSION_SECRET']
      set :persona_audience, ENV['PERSONA_AUDIENCE']
    end

    before do
      unless login? || request.path.start_with?('/auth')
        halt slim :login
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
