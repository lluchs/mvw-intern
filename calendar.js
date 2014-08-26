(function() {
  'use strict';
  moment.locale('de');

  var Calendar = Ractive.extend({
    template: '#template',
    data: {
      month: 8,
      year: 2014,
      weekdays: (function() {
        return [0, 1, 2, 3, 4, 5, 6].map(function(i) {
          return moment().weekday(i).format('dd');
        });
      })(),
    },
    computed: {
      monthname: function() {
        var month, year;
        month = this.get('month');
        year = this.get('year');
        return moment([year, month]).format('MMMM YYYY');
      },
      weeks: function() {
        var month, year, m, weeks, days;
        month = this.get('month');
        year = this.get('year');
        // Start with the first day of the given month.
        m = moment([year, month]);
        // Go back to the first day of the week.
        while (m.weekday()) m.subtract(1, 'day');
        weeks = [];
        while (m.isBefore(moment([year, month]).add(1, 'month'))) {
          days = [];
          for (var cmp = m.clone().add(1, 'week'); m.isBefore(cmp); m.add(1, 'day')) {
            days.push({
              day: m.date(),
              outside: m.month() != month,
            });
          }
          weeks.push({days: days});
        }
        return weeks;
      },
    },
  });

  window.calendar = new Calendar({
    el: '#calendar',
  });
})();
