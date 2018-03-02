module Views.StartAnExercise exposing (..)

import Data.Workout exposing (currentExercises)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Types exposing (..)
import Views.Logo exposing (logo)


view : Model -> Html Msg
view model =
    div []
        [ logo "start an exercise"
        , div [ class "tc" ] <| createExerciseList model.currentWorkout
        ]


createExerciseList : Maybe Workout -> List (Html Msg)
createExerciseList currentWorkout =
    Dict.values <|
        Dict.map
            (\id exercise -> p [ onClick <| StartExercise id, class "pointer" ] [ text exercise.name ])
        <|
            currentExercises currentWorkout
