var User = (function () {

  var localStorage = window.localStorage
  var emailKey = 'wide-grip-email'
  var passwordKey = 'wide-grip-password'

  function setUser (email, password) {
    localStorage.setItem(emailKey, email)
    localStorage.setItem(passwordKey, password)
  }

  function getUser () {
    return {
      email: localStorage.getItem(emailKey),
      password: localStorage.getItem(passwordKey)
    }
  }

  return {
    setUser: setUser,
    getUser: getUser
  }

}())
