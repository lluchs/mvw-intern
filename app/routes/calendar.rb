# Calendar and event routes

require 'pry'
module MvwIntern
  module Routes
    module Calendar
      def self.registered(app)
        
        app.get '/calendar' do
          slim :calendar
        end

        app.get '/calendar/events' do
          Models::Event.all.order(:start).to_json
        end

        app.get '/calendar/events/:year' do
          Models::Event
            .where('EXTRACT(YEAR FROM start) = :year', year: params[:year])
            .order(:start)
            .to_json
        end

        app.post '/calendar/events' do
          halt 403 unless current_user.admin

          event_json = JSON.parse request.body.read
          puts event_json
          event = Models::Event.new
          event.set start: event_json['start'], duration: event_json['duration'], title: event_json['title'], desc: event_json['desc'], type: event_json['type']
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
