require 'sinatra/base'
require 'sinatra/json'
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
      set :hmac_secret, 'foobar'
      set :maildir, 'maildir'
    end

    configure :production do
      # Fixes issue with proxying POST
      use Rack::Session::Cookie,
        key: 'session',
        path: '/',
        secret: ENV['SESSION_SECRET']
      set :hmac_secret, ENV['HMAC_SECRET'] || abort('HMAC_SECRET not set')
      set :maildir, ENV['MAILDIR']
    end

    before do
      # Auth is needed for logging in, calendar can be viewed without login to allow linking from emails.
      if login? || request.path.start_with?('/auth') || request.path.start_with?('/calendar')
        @show_login_button = true
      else
        halt 401, slim(:login)
      end
    end

    get '/' do
      n = 5
      @events = Models::Event.future(n)
      @messages = get_maildir_contents
        .sort_by { |msg| msg.data.date }
        .reverse
        .slice(0, n)
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
