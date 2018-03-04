module Views.SelectExercisesForWorkout exposing (..)

import Data.Workout exposing (currentExercises)
import Helpers.Html exposing (renderDictValues)
import Helpers.Style exposing (classes)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (..)
import Types exposing (..)
import Views.Logo exposing (logo)


view : Model -> Html Msg
view model =
    div [ class "tc" ]
        [ logo "track workout"
        , div [] <| renderDictValues renderExercise <| currentExercises model.currentWorkout
        , div
            [ onClick ConfirmExercises
            , classes
                [ "ph3 pv2 mt3 dib br-pill"
                , "bg-navy white"
                , "ttu tracked"
                , "pointer"
                ]
            ]
            [ text "Start (fist)" ]
        ]


renderExercise : Exercise -> Html Msg
renderExercise exercise =
    p [ class "mv4 ttu tracked" ] [ text exercise.name ]
