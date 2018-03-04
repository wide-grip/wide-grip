module Views.StartAnExercise exposing (..)

import Data.Workout exposing (currentExercises)
import Helpers.Html exposing (renderDict)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Types exposing (..)
import Views.Logo exposing (logo)


view : Model -> Html Msg
view model =
    div []
        [ logo "start an exercise"
        , div [ class "tc mt5" ] <| createExerciseList model.currentWorkout
        ]


createExerciseList : Maybe Workout -> List (Html Msg)
createExerciseList =
    renderDict renderExercise << currentExercises


renderExercise : Int -> Exercise -> Html Msg
renderExercise id exercise =
    p [ onClick <| StartExercise id, class "pointer ttu mv4 tracked" ]
        [ text exercise.name ]
