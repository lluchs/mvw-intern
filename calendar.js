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
              day: m.date(),
              outside: m.month() != month.month(),
            });
          }
          weeks.push({days: days});
        }
        return weeks;
      },
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
  });
})();
