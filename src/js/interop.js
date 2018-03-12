import * as firebase from './firebase.js'
import * as localStorage from './localstorage.js'

export function init(elmApp, db) {

  const { ports } = elmApp

  attachPorts()

  function attachPorts () {
    return Promise.resolve()
      .then(subscribeSubmitWorkout)
      .then(handleGetExercises)
      .then(subscribeCacheCurrentWorkout)
  }

  function subscribeSubmitWorkout () {
    ports.submitWorkout.subscribe(sendSubmitWorkoutStatuses)
  }

  function sendSubmitWorkoutStatuses (workoutData) {
    var submitPort = ports.receiveSubmitWorkoutStatus
    var success    = firebase.successMessage()
    var error      = firebase.errorMessage("could not submit workout")

    return firebase.submitWorkout(db, workoutData)
      .then(() => submitPort.send(success))
      .then(() => localStorage.removeCurrentWorkout())
      .catch(() => submitPort.send(error))
  }

  function sendExercisesToIncomingPort (exercises) {
    ports.receiveExercises.send(exercises)
  }

  function handleGetExercises () {
    if (localStorage.getExercises()) {
      const exercises = JSON.parse(localStorage.getExercises())
      sendExercisesToIncomingPort(exercises)
      refreshExerciseCache()
    } else {
      refreshExerciseCache()
    }
  }

  function refreshExerciseCache () {
    firebase.getExercises(db)
      .then(exercises => {
        localStorage.setExercises(exercises)
        sendExercisesToIncomingPort(exercises)
      })
  }

  function subscribeCacheCurrentWorkout () {
    ports.cacheCurrentWorkout.subscribe(currentWorkout => localStorage.setCurrentWorkout(currentWorkout))
  }
}
