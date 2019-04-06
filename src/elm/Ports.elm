port module Ports exposing
    ( cacheCurrentWorkout
    , receiveCurrentWorkoutState
    , receiveExercises
    , receiveSubmitWorkoutStatus
    , submitWorkout
    )

import Json.Decode exposing (Value)
import Workout exposing (FirebaseMessage)


port receiveExercises : (Value -> msg) -> Sub msg


port receiveSubmitWorkoutStatus : (FirebaseMessage -> msg) -> Sub msg


port receiveCurrentWorkoutState : (Value -> msg) -> Sub msg


port submitWorkout : Value -> Cmd msg


port cacheCurrentWorkout : Value -> Cmd msg
