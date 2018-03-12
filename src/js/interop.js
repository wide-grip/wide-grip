const {
  successMessage,
  errorMessage,
  getExercises,
  submitWorkout
} = require('./firebase.js')

function init(elmApp, db) {

  const { ports } = elmApp

  attachPorts()

  function attachPorts () {
    return Promise.resolve()
      .then(subscribeSubmitWorkout)
      .then(() => getExercises(db))
      .then(sendExercisesToIncomingPort)
  }

  function subscribeSubmitWorkout () {
    ports.submitWorkout.subscribe(sendSubmitWorkoutStatuses)
  }

  function sendSubmitWorkoutStatuses (workoutData) {
    var submitPort = ports.receiveSubmitWorkoutStatus
    var success    = successMessage()
    var error      = errorMessage("could not submit workout")

    return submitWorkout(db, workoutData)
      .then(() => submitPort.send(success))
      .catch(() => submitPort.send(error))
  }

  function sendExercisesToIncomingPort (exercises) {
    ports.receiveExercises.send(exercises)
  }
}

module.exports = {
  init
}
