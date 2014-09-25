# Calendar and event routes

module MvwIntern
  module Routes
    module Calendar
      def self.registered(app)
        
        app.get '/calendar' do
          slim :calendar
        end


      end
    end
  end
end
