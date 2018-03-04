port module Data.Ports exposing (..)

import Json.Decode exposing (Value)


port receiveExercises : (Value -> msg) -> Sub msg
