require 'sinatra/base'
require 'sinatra/sequel'

module MvwIntern
  class App < Sinatra::Base
    register Sinatra::SequelExtension

    configure do
      set :database_url, 'sqlite://db/db.sqlite'
    end

    get '/' do
      'Hello World!'
    end
  end
end
