# Calendar and event routes

module MvwIntern
  module Routes
    module Calendar
      def self.registered(app)
        
        app.get '/calendar' do
          slim :calendar
        end

        app.get '/calendar/events' do
          Models::Event.all.to_json
        end

        app.post '/calendar/events' do
          halt 403 unless current_user.admin

          event = Models::Event.new
          event.set_fields(params, [:start, :duration, :title, :desc, :type])
          event.save

          event.to_json
        end

        app.put '/calendar/events' do
          halt 403 unless current_user.admin

          event = Models::Event[params[:id]]
          halt 404 if event.nil?

          event.set_fields(params, [:start, :duration, :title, :desc, :type])
          event.save

          event.to_json
        end

      end
    end
  end
end
