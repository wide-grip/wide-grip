port module Ports exposing
    ( cacheWorkout
    , receiveExercises
    , receiveWorkoutFromCache
    , receiveWorkoutInProgress
    , restoreWorkoutFromCache
    , workoutInProgress
    )

import Json.Encode as Encode


port receiveExercises : (Encode.Value -> msg) -> Sub msg


port cacheWorkout : Encode.Value -> Cmd msg


port receiveWorkoutFromCache : (Encode.Value -> msg) -> Sub msg


port restoreWorkoutFromCache : () -> Cmd msg


port workoutInProgress : () -> Cmd msg


port receiveWorkoutInProgress : (Bool -> msg) -> Sub msg
