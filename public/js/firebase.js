var DB = (function () {

  function initDB (email, password) {
    var firebase = window.firebase
    var config = {
      apiKey: "AIzaSyAS81CgQloq4VMbaVR6PBkAIIWyxD-UDOo",
      authDomain: "wide-grip.firebaseapp.com",
      databaseURL: "https://wide-grip.firebaseio.com",
      projectId: "wide-grip",
      storageBucket: "wide-grip.appspot.com",
      messagingSenderId: "673417757978"
    }
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

  // { exercise: String, workoutName: String }
  function addNewExercise (db, exercise) {
    return db.exercises.push().set(exercise)
  }

  function getExercises (db) {
    return db.exercises.once('value').then(snapshot => snapshot.val())
  }

  return {
    getExercises: getExercises,
    addNewExercise: addNewExercise,
    initDB: initDB
  }

}())
