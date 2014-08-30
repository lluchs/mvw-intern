(function() {
  'use strict';
  moment.locale('de');

  var Calendar = Ractive.extend({
    template: '#template',
    data: {
      month: moment().startOf('month'),
      weekdays: (function() {
        return [0, 1, 2, 3, 4, 5, 6].map(function(i) {
          return moment().weekday(i).format('dd');
        });
      })(),

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

      // Formats a moment date + time value.
      formatDateTime: function(t) {
        return moment(t).format('LLL');
      },

      // Returns whether the two moments are in the same week.
      isSameWeek: function(m1, m2) {
        return moment(m1).isSame(m2, 'week');
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
    },
    init: function() {
      this.on({
        'prev-month': function() {
          this.get('month').subtract(1, 'month');
          this.update('month');
        },
        'next-month': function() {
          this.get('month').add(1, 'month');
          this.update('month');
        },
        'show-event': function(e) {
          this.set('activeEvent', e.context);
        },
        'hide-event': function() {
          this.set('activeEvent', null);
        },
      });
    },
  });

  window.calendar = new Calendar({
    el: '#calendar',
    calendarEvents: [
      { start: '2014-09-01T10:00', end: '2014-09-01T12:00', title: 'Testtermin 1' },
      { start: '2014-09-08T09:00', end: '2014-09-08T11:00', title: 'Testtermin 2' },
      { start: '2014-09-23T18:00', end: '2014-09-23T19:00', title: 'Testtermin 3', desc: 'foobar' },
    ],
  });
  calendar.on({
    'ack-event': function(e) {
      // Ajax...
    },
    'nack-event': function(e) {
      // Ajax...
    },
  });
})();
