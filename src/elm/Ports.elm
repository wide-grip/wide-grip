port module Ports exposing
    ( cacheExerciseProgress
    , cacheWorkout
    , receiveExercises
    , receiveWorkoutFromCache
    , receiveWorkoutInProgress
    , recevieExerciseProgressFromCache
    , restoreExerciseProgressFromCache
    , restoreWorkoutFromCache
    , workoutInProgress
    )

import Json.Encode as Encode


port receiveExercises : (Encode.Value -> msg) -> Sub msg


port cacheWorkout : Encode.Value -> Cmd msg


port cacheExercise : Encode.Value -> Cmd msg


port restoreExerciseProgressFromCache : String -> Cmd msg


port restoreWorkoutFromCache : () -> Cmd msg


port receiveWorkoutFromCache : (Encode.Value -> msg) -> Sub msg


port recevieExerciseProgressFromCache : (Encode.Value -> msg) -> Sub msg


port cacheExerciseProgress : Encode.Value -> Cmd msg


port workoutInProgress : () -> Cmd msg


port receiveWorkoutInProgress : (Bool -> msg) -> Sub msg
