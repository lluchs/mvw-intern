//= require moment/moment.js
//= require moment/locale/de.js
//= require ractive/ractive.js
//= require ractive-transitions-slide/ractive-transitions-slide.js
//= require es6-promise/promise.js
//= require fetch/fetch.js

(function() {
  'use strict';
  moment.locale('de');

  var Datepicker = Ractive.extend({
    template: '{{>content}}',
    isolated: false,
    oninit: function() {
      this.observe({
        moment: function(m) {
          var m = moment(m);
          this.set('date', m.format('DD.MM.'));
          this.set('time', m.format('H:mm'));
        },
        date: function(d) {
          var m, n;
          m = moment(d, 'DD.MM.');
          n = moment(this.get('moment'))
            .month(m.month())
            .date(m.date())
          this.set('moment', n);
        },
        time: function(t) {
          var m, n;
          m = moment(t, 'H:mm');
          n = moment(this.get('moment'))
            .hour(m.hour())
            .minute(m.minute())
          this.set('moment', n);
        },
      });
    },
  });

  var MVWCalendar  = Ractive.extend({
    template: '#template',
    components: {
      datepicker: Datepicker,
    },
    data: function() {
      return {
        year: moment().year(),
        types: {
          'Auftritt': {
            className: 'event-auftritt',
          },
          'Probe': {
            className: 'event-probe',
          },
          'Ständchen': {
            className: 'event-staendchen',
          },
          'Arbeitseinsatz': {
            className: 'event-arbeitseinsatz',
          },
        },

        // Returns the event end time as moment object.
        eventEnd: function(event) {
          return moment(event.start).clone().add(moment.duration(event.duration));
        },

        // Returns the class name for the given type.
        eventClass: function(type) {
          var t = this.get('types')[type];
          return t != null ? t.className : '';
        },

        // Formats a moment time value.
        formatTime: function(t) {
          return moment(t).format('LT');
        },

        // Formats a moment date value.
        formatDate: function(t) {
          return moment(t).format('LL');
        },

        // Formats a moment date + time value.
        formatDateTime: function(t) {
          return moment(t).format('LLL');
        },

        // Returns whether the two moments are in the same week.
        isSameWeek: function(m1, m2) {
          return moment(m1).isSame(m2, 'week');
        },

        // Returns whether the two moments are on the same day.
        isSameDay: function(m1, m2) {
          return moment(m1).isSame(m2, 'day');
        },
      }
    },
    onrender: function() {
      this.on({
        'toggle-event': function(e) {
          this.set(e.keypath + '.active', !e.context.active);
        },
        'add-event': function(e) {
          var event;
          event = this.defaultEvent(moment().year(this.get('year')));
          event.active = true;
          event.editing = true;
          this.set('newEvent', event);
        },
        'edit-event': function(e) {
          var event = e.context;
          event.editing = true;
          event.inputDuration = moment.duration(e.context.duration).asHours();
          this.update(e.keypath);
        },
        'submit-event': function(e) {
          var event, match;
          e.original.preventDefault();
          event = e.context;
          event.duration = moment.duration(event.inputDuration, 'hours');
          var self = this;
          this.saveEvent(event).then(function(result) {
            if ('id' in event) {
              result.active = true;
              // TODO: Sorting
              self.set(e.keypath, result);
            } else {
              self.set('newEvent', null);
              // TODO: Sorting
              self.unshift('events', result);
            }
          }, function(error) {
            self.set(e.keypath+'.error', error);
          });
        },
      });

      this.observe({
        'year': function(year) {
          var r = this;
          r.set('eventsLoading', true);
          r.fetchEvents(year)
            .then(function(events) {
              if (r.get('year') == year) {
                r.set('events', events);
                r.set('eventsLoading', false);
              }
            })
        },
      });
    },

    // Creates an empty event for the given day.
    defaultEvent: function(day) {
      return {
        start: day.clone(),
        duration: moment.duration(1, 'hour'),
        title: '',
        desc: '',
        type: 'Auftritt',

        // Values used only for two-way binding.
        inputDuration: 1,
      };
    },

    // Sets the given year.
    setYear: function(year) {
      this.set('year', year);
    },

    // Fetches events of the given year, returning a promise.
    fetchEvents: function(year) {
      return fetch('/calendar/events/' + year)
        .then(status)
        .then(function(response) {
          return response.json();
        })
    },

    saveEvent: function(event) {
      return fetch('/calendar/events', {
        method: 'id' in event ? 'put' : 'post',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(eventToJSON(event)),
      })
        .then(status)
        .then(function(response) {
          return response.json();
        })
    },
  });

  window.calendar = new MVWCalendar({
    debug: true,
    el: '#calendar',
    data: function() {
      return {
        canEdit: true,
      }
    },

  });

  function status(response) {
    if (response.status >= 200 && response.status < 300) {
      return response
    }
    throw new Error(response.statusText)
  }

  function eventToJSON(event) {
    var obj = {
      start: event.start,
      duration: event.duration.toString(),
      title: event.title,
      desc: event.desc,
      type: event.type,
    };
    if ('id' in event) obj.id = event.id;
    return obj;
  }

})();
