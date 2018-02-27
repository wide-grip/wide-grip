module Views.PreviousWorkouts exposing (..)

import Html exposing (..)
import Types exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Previous Workouts" ]
        , div [] <| List.map renderWorkout model.previousWorkouts
        ]


renderWorkout : Workout -> Html Msg
renderWorkout workout =
    div [] [ text <| workoutTypeToString workout.workoutType ]


workoutTypeToString : WorkoutType -> String
workoutTypeToString workout =
    case workout of
        UserDefined str ->
            str

        workoutType ->
            toString workoutType
