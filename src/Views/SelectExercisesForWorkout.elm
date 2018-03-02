module Views.SelectExercisesForWorkout exposing (..)

import Data.Workout exposing (currentExercises)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (..)
import Types exposing (..)
import Views.Logo exposing (logo)


view : Model -> Html Msg
view model =
    div [ class "tc" ]
        [ logo "track workout"
        , div [] <| List.map renderExercise <| currentExercises model.currentWorkout
        , button [ onClick ConfirmExercises ] [ text "Start (fist)" ]
        ]


renderExercise : String -> Html Msg
renderExercise exercise =
    p [] [ text exercise ]
