module Views.StartAnExercise exposing (..)

import Data.Workout exposing (currentExercises)
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
    List.map
        (\exercise -> p [ onClick <| StartExercise exercise.id, class "pointer" ] [ text exercise.name ])
    <|
        currentExercises currentWorkout
