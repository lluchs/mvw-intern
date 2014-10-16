//= require moment/moment.js
//= require moment/locale/de.js
//= require ractive/ractive.js
//= require ractive-transitions-slide/ractive-transitions-slide.js
//= require reqwest/reqwest.js

(function() {
  'use strict';
  moment.locale('de');

  var MVWCalendar  = Ractive.extend({
    template: '#template',
    data: {
      month: moment().startOf('month'),
      weekdays: (function() {
        return [0, 1, 2, 3, 4, 5, 6].map(function(i) {
          return moment().weekday(i).format('dd');
        });
      })(),
      types: [
        {
          name: 'Probe',
          color: 'blue',
        },
        {
          name: 'Auftritt',
          color: 'red',
        },
        {
          name: 'Ständchen',
          color: 'green',
        },
      ],

      // Returns all events for the given day.
      //
      // TODO: Maybe do binary search instead of O(n) filter.
      getDayEvents: function(day) {
        day = moment(day);
        return this.get('events').filter(function(event) {
          return day.isSame(event.start, 'day');
        });
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
    },
    computed: {
      monthname: function() {
        var month;
        month = this.get('month');
        return month.format('MMMM YYYY');
      },
      weeks: function() {
        var month, m, weeks, days;
        month = this.get('month');
        // Start with the first day of the given month.
        m = month.clone().startOf('month');
        // Go back to the first day of the week.
        while (m.weekday()) m.subtract(1, 'day');
        weeks = [];
        while (m.isBefore(month.clone().add(1, 'month'))) {
          days = [];
          for (var cmp = m.clone().add(1, 'week'); m.isBefore(cmp); m.add(1, 'day')) {
            days.push({
              moment: m.clone(),
              day: m.date(),
              outside: m.month() != month.month(),
            });
          }
          weeks.push({days: days});
        }
        return weeks;
      },
    },
    beforeInit: function(options) {
      this.data.events = options.calendarEvents;
      this.data.canAdd = options.canAdd;
      this.saveEvent = options.saveEvent;
    },
    onrender: function() {
      this.on({
        'prev-month': function() {
          this.get('month').subtract(1, 'month');
          this.update('month');
        },
        'next-month': function() {
          this.get('month').add(1, 'month');
          this.update('month');
        },
        'set-active-day': function(e, day) {
          this.set('activeDay', day);
        },
        'hide-active-day': function(e, day) {
          this.set('activeDay', null);
        },
        'show-event': function(e) {
          this.set('activeEvent', e.context);
          this.set('editingEvent', false);
        },
        'hide-event': function() {
          this.set('activeEvent', null);
          this.set('editingEvent', false);
        },
        'add-event': function(e) {
          var start;
          start = e.context.moment;
          this.set('activeEvent', this.defaultEvent(start));
          this.set('editingEvent', true);
        },
        'set-event-type': function(e, type) {
          this.set('activeEvent.type', type);
        },
        'submit-event': function(e) {
          var event, match;
          e.original.preventDefault();
          event = this.get('activeEvent');
          match = event.inputStart.match(/(\d+):(\d+)/);
          if (!match) {
            this.set('activeEvent.error', 'Ungültige Startzeit.');
            return;
          }
          event.start.hour(+match[1]).minute(+match[2]);
          event.end = event.start.clone().add(event.inputDuration, 'hours');
          var self = this;
          this.saveEvent(event).then(function(result) {
            self.get('events').push(JSON.parse(result));
            self.set('activeEvent', null);
          }, function(error) {
            self.set('activeEvent.error', error);
          });
        },
      });
    },

    // Creates an empty event for the given day.
    defaultEvent: function(day) {
      return {
        start: day.clone(),
        end: day.clone().add(1, 'hour'),
        title: '',
        desc: '',

        // Values used only for two-way binding.
        inputStart: moment().format('HH:mm'),
        inputDuration: 1,
      };
    },
  });

  reqwest({
    url: '/calendar/events',
    type: 'json',
  }).then(function(events) {

    window.calendar = new MVWCalendar({
      debug: true,
      el: '#calendar',
      calendarEvents: events,
      canAdd: true,

      saveEvent: function(event) {
        return reqwest({
          url: '/calendar/events',
          method: 'post',
          data: event,
        });
      },
    });
    calendar.on({
      'ack-event': function(e) {
        // Ajax...
      },
      'nack-event': function(e) {
        // Ajax...
      },
    });

  });
})();
