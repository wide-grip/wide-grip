module Views.SelectExercisesForWorkout exposing (..)

import Data.Workout exposing (currentExercises)
import Helpers.Html exposing (renderDictValues)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Views.Icon exposing (fist, fistButton, wideGripHeader)


view : Model -> Html Msg
view model =
    div [ class "tc" ]
        [ wideGripHeader "track workout"
        , div [] <| renderDictValues renderExercise <| currentExercises model.currentWorkout
        , div [ onClick ConfirmExercises ]
            [ fistButton "start"
            ]
        ]


renderExercise : ExerciseProgress -> Html Msg
renderExercise progress =
    p [ class "mv4 ttu tracked" ] [ text progress.exercise.name ]
