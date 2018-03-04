module Views.SelectExercisesForWorkout exposing (..)

import Data.Workout exposing (currentExercises)
import Dict exposing (Dict)
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
        , button [ onClick ConfirmExercises, class "pointer" ] [ text "Start (fist)" ]
        ]


renderExercise : Exercise -> Html Msg
renderExercise exercise =
    p [] [ text exercise.name ]


renderDictValues : (a -> Html msg) -> Dict comparable a -> List (Html msg)
renderDictValues f =
    Dict.map (always f) >> Dict.values
