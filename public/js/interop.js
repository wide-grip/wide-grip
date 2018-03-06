var AttachPorts = function (elmApp, db) {

  var { successMessage, errorMessage, getExercises, submitWorkout } = window.DB
  var { ports } = elmApp

  // calls all below functions
  init()

  function init () {
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
