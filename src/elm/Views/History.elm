module Views.History exposing (renderWorkout, view)

import Data.Workout exposing (workoutNameToString)
import Html exposing (..)
import Types exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Previous Workouts" ]
        ]


renderWorkout : Workout -> Html Msg
renderWorkout workout =
    div [] [ text <| workoutNameToString workout.workoutName ]
