port module Data.Ports exposing (..)

import Json.Decode exposing (Value)
import Types exposing (FirebaseMessage)


port receiveExercises : (Value -> msg) -> Sub msg


port receiveSubmitWorkoutStatus : (FirebaseMessage -> msg) -> Sub msg


port submitWorkout : Value -> Cmd msg


port cacheCurrentWorkout : Value -> Cmd msg
