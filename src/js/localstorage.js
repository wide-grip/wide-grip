const localStorage = window.localStorage
const emailKey = 'wide-grip-email'
const passwordKey = 'wide-grip-password'

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

module.exports = {
  setUser,
  getUser
}
