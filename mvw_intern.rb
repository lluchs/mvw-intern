require 'sinatra/base'
require 'sinatra/sequel'

module MvwIntern
  class App < Sinatra::Base
    register Sinatra::SequelExtension

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

    get '/' do
      slim :index
    end

    get '/users' do
      Models::User.all.to_s
    end
  end
end
