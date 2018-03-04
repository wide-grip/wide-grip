module Views.SelectWorkoutName exposing (..)

import Data.Workout exposing (workoutNameToString)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (..)
import Types exposing (..)
import Views.Logo exposing (logo)


view : Model -> Html Msg
view model =
    div [ class "tc" ]
        [ logo "track workout"
        , selectWorkoutName Push
        , selectWorkoutName Pull
        , selectWorkoutName Legs
        ]


selectWorkoutName : WorkoutName -> Html Msg
selectWorkoutName workoutName =
    p [ onClick <| StartWorkout workoutName, class "pointer mv4 tracked ttu" ]
        [ text <| workoutNameToString workoutName ]
