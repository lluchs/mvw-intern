require 'sinatra/base'
require 'sinatra/sequel'

module MvwIntern
  class App < Sinatra::Base
    register Sinatra::SequelExtension

    configure do
      set :database_url, 'sqlite://db/db.sqlite'
      database
      require './app/models'
    end

    get '/' do
      'Hello World!'
    end

    get '/users' do
      Models::User.all.to_s
    end
  end
end
