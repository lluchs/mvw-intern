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
      });
    },
  });

  window.calendar = new Calendar({
    el: '#calendar',
    calendarEvents: [
      { start: '2014-09-01T10:00', end: '2014-09-01T12:00', title: 'Testtermin 1' },
      { start: '2014-09-02T10:00', end: '2014-09-02T12:00', title: 'Testtermin 2' },
      { start: '2014-09-03T10:00', end: '2014-09-03T12:00', title: 'Testtermin 3' },
    ],
  });
})();
