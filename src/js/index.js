var { initDB } = require('./firebase.js')
var { getUser, setUser } = require('./localstorage.js')
var interop = require('./interop.js')
var Elm = window.Elm

var app = Elm.Main.fullscreen({
  now: Date.now()
})

setUser('robertefrancis18@gmail.com', 'wide-grip')
var { email, password } = getUser()

initDB(email, password)
  .then(db => interop.init(app, db))
