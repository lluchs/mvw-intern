(function() {
  var reload = function() { location.reload() }

  $('#signin').submit(function(e) {
    var email = $('#email').val(), password = $('#password').val()

    $('#message').text('')


    $.ajax({
      type: 'post',
      url: '/auth/login',
      data: {email: email, password: password},
    })
    .then(reload, function(xhr) {
      var res = JSON.parse(xhr.responseText)
      $('#message').text(res.message)
    })

    e.preventDefault()
  })

  $('#signout').click(function() {
    $.ajax({
      type: 'post',
      url: '/auth/logout',
    })
    .then(reload, function(xhr) {
      alert('Logout fehlgeschlagen.')
    })
  })
})();
