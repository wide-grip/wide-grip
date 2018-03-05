module Views.StartAnExercise exposing (..)

import Data.Workout exposing (currentExercises)
import Helpers.Html exposing (emptyProperty, renderDict)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Types exposing (..)
import Views.Icon exposing (fist, tick, wideGripHeader)


view : Model -> Html Msg
view model =
    div []
        [ wideGripHeader "start an exercise"
        , div [ class "mt5 mw5 center" ] <| createExerciseList model.currentWorkout
        ]


createExerciseList : Maybe Workout -> List (Html Msg)
createExerciseList =
    renderDict renderExercise << currentExercises


renderExercise : String -> ExerciseProgress -> Html Msg
renderExercise id exercise =
    div
        [ class "flex pointer justify-between items-center"
        , handleStart id exercise
        ]
        [ p [ class "ttu mv4 tracked" ] [ text exercise.name ]
        , renderIcon exercise
        ]


handleStart : String -> ExerciseProgress -> Attribute Msg
handleStart id exercise =
    if not exercise.complete then
        onClick <| StartExercise id
    else
        emptyProperty


renderIcon : ExerciseProgress -> Html msg
renderIcon exercise =
    if exercise.complete then
        tick
    else
        fist
