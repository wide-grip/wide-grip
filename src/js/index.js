import { initDB } from './firebase.js'
import { getUser, setUser } from './localstorage.js'
import * as interop from './interop.js'
const { Elm } = window

const app = Elm.Main.fullscreen({
  now: Date.now()
})

setUser('robertefrancis18@gmail.com', 'wide-grip')
const { email, password } = getUser()

initDB(email, password)
  .then(db => interop.init(app, db))
