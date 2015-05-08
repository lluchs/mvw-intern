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
          event = Models::Event.new
          event.set start: event_json['start'], duration: event_json['duration'], title: event_json['title'], desc: event_json['desc'], type: event_json['type']
          event.save

          event.to_json
        end

        app.put '/calendar/events' do
          halt 403 unless current_user.admin

          event_json = JSON.parse request.body.read
          event = Models::Event[event_json['id']]
          halt 404 if event.nil?

          event.set start: event_json['start'], duration: event_json['duration'], title: event_json['title'], desc: event_json['desc'], type: event_json['type']
          event.save

          event.to_json
        end

        app.delete '/calendar/events/:id' do
          halt 403 unless current_user.admin

          id = params[:id].to_i
          halt 400 if id == 0

          event = Models::Event[params[:id]]
          halt 404 if event.nil?

          event.delete
          halt 204
        end

      end
    end
  end
end
