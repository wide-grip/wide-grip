module Views.History exposing (..)

import Html exposing (..)
import Types exposing (..)
import Data.Workout exposing (workoutNameToString)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Previous Workouts" ]
        ]


renderWorkout : Workout -> Html Msg
renderWorkout workout =
    div [] [ text <| workoutNameToString workout.workoutName ]
