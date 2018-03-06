var DB = (function () {

  var config = {
    apiKey: "AIzaSyAS81CgQloq4VMbaVR6PBkAIIWyxD-UDOo",
    authDomain: "wide-grip.firebaseapp.com",
    databaseURL: "https://wide-grip.firebaseio.com",
    projectId: "wide-grip",
    storageBucket: "wide-grip.appspot.com",
    messagingSenderId: "673417757978"
  }

  function initDB (email, password) {
    var firebase = window.firebase
    firebase.initializeApp(config)
    return _authenticate(firebase, email, password)
  }

  function _authenticate (firebase, email, password) {
    return firebase.auth()
      .signInWithEmailAndPassword(email, password)
      .then(() => ({
        database: firebase.database(),
        exercises: firebase.database().ref("/exercises"),
        workouts: firebase.database().ref("/workouts")
      }))
  }

  function addExercises (db) {
    return [
      { name: "Bench Press", workoutName: "Push" },
      { name: "Incline Bench Press", workoutName: "Push" },
      { name: "Rope Pull Down", workoutName: "Push" },
      { name: "Pull Ups", workoutName: "Pull" },
      { name: "Seated Rows", workoutName: "Pull" },
      { name: "Bicep Curls", workoutName: "Pull" },
      { name: "Squats", workoutName: "Legs" },
      { name: "Lunges", workoutName: "Legs" },
      { name: "Calf Raises", workoutName: "Legs" },
    ]
    .forEach(ex => { addNewExercise(db, ex) })
  }

  // Exercise { name: String, workoutName: String }
  function addNewExercise (db, exercise) {
    return db.exercises.push().set(exercise)
  }

  function getExercises (db) {
    return db.exercises.once('value').then(snapshot => snapshot.val())
  }

  function submitWorkout (db, workout) {
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

  function successMessage () {
    return { success: true, reason: "" }
  }

  function errorMessage (reason) {
    return { success: false, reason: reason }
  }

  return {
    getExercises: getExercises,
    addExercises: addExercises,
    submitWorkout: submitWorkout,
    addNewExercise: addNewExercise,
    initDB: initDB,
    successMessage: successMessage,
    errorMessage: errorMessage
  }

}())
