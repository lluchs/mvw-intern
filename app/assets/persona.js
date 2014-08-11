(function() {
  $('#signin').click(function() { navigator.id.request(); });
  $('#signout').click(function() { navigator.id.logout(); });

  var currentUser = $('body').data('login') || null;

  navigator.id.watch({
    loggedInUser: currentUser,
    onlogin: function(assertion) {
      $.ajax({
        type: 'POST',
        url: '/auth/login',
        data: {assertion: assertion},
        success: function(res, status, xhr) { window.location.reload(); },
        error: function(xhr, status, err) {
          navigator.id.logout();
          var reason = '';
          try {
            reason = JSON.parse(xhr.responseText).message;
          } catch(err) {}
          alert('Anmeldung fehlgeschlagen. ' + reason);
        }
      });
    },
    onlogout: function() {
      $.ajax({
        type: 'POST',
        url: '/auth/logout',
        success: function(res, status, xhr) { window.location.reload(); },
        error: function(xhr, status, err) { alert("Logout failure: " + err); }
      });
    }
  });
})();
