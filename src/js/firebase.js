import firebase from 'firebase/app'
import 'firebase/auth'
import 'firebase/database'

const config = {
  apiKey: "AIzaSyAS81CgQloq4VMbaVR6PBkAIIWyxD-UDOo",
  authDomain: "wide-grip.firebaseapp.com",
  databaseURL: "https://wide-grip.firebaseio.com",
  projectId: "wide-grip",
  storageBucket: "wide-grip.appspot.com",
  messagingSenderId: "673417757978"
}

export function initDB (email, password) {
  firebase.initializeApp(config)
  return _authenticate(firebase, email, password)
}

function _authenticate (_firebase, email, password) {
  return _firebase.auth()
    .signInWithEmailAndPassword(email, password)
    .then(() => ({
      database: _firebase.database(),
      exercises: _firebase.database().ref("/exercises"),
      workouts: _firebase.database().ref("/workouts")
    }))
}

// Exercise { name: String, workoutName: String }
export function addNewExercise (db, exercise) {
  return db.exercises.push().set(exercise)
}

export function getExercises (db) {
  return db.exercises.once('value').then(snapshot => snapshot.val())
}

export function submitWorkout (db, workout) {
  return db.workouts.once('value')
    .then(snapshot => snapshot.val())
    .then(snapVal => _addWorkoutToSnapshotValue(workout, snapVal))
    .then(snapVal => db.workouts.set(snapVal))
}

function _addWorkoutToSnapshotValue (workout, snapVal) {
  var newSnapshot = snapVal || {}
  newSnapshot[workout.date] = workout
  return newSnapshot
}

export function successMessage () {
  return { success: true, reason: "" }
}

export function errorMessage (reason) {
  return { success: false, reason: reason }
}
