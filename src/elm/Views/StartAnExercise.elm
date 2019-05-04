module Views.StartAnExercise exposing (createExerciseList, handleStart, renderCurrentSubmitStatus, renderExercise, renderIcon, renderSubmitStatus, view)

import Data.Workout exposing (currentExercises)
import Helpers.Html exposing (emptyProperty, renderDict, renderDictValues)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Types exposing (..)
import Views.Icon exposing (fist, fistButton, tick, wideGripHeader)


view : Model -> Html Msg
view model =
    div []
        [ wideGripHeader "start an exercise"
        , div [ class "mt5 mw5 center" ] <| createExerciseList model.currentWorkout
        , div [ onClick SubmitWorkout, class "center tc" ] [ fistButton "finish workout" ]
        , div [ class "tc mt4" ] [ renderCurrentSubmitStatus model.currentWorkout ]
        ]


createExerciseList : Maybe Workout -> List (Html Msg)
createExerciseList =
    renderDictValues renderExercise << currentExercises


renderExercise : ExerciseProgress -> Html Msg
renderExercise progress =
    div
        [ class "flex pointer justify-between mb3 bg-animate hover-bg-navy hover-white items-center br-pill ba b--navy"
        , handleStart progress
        ]
        [ p [ class "ttu ma3 tracked" ] [ text progress.exercise.name ]
        , div [ class "ma3" ] [ renderIcon progress ]
        ]


handleStart : ExerciseProgress -> Attribute Msg
handleStart progress =
    onClick <| StartExercise progress.exercise


renderIcon : ExerciseProgress -> Html msg
renderIcon progress =
    if progress.complete then
        tick

    else
        fist


renderCurrentSubmitStatus : Maybe Workout -> Html msg
renderCurrentSubmitStatus currentWorkout =
    currentWorkout
        |> Maybe.map (.submitted >> renderSubmitStatus)
        |> Maybe.withDefault (span [] [])


renderSubmitStatus : SubmitWorkoutStatus -> Html msg
renderSubmitStatus submitWorkoutStatus =
    case submitWorkoutStatus of
        Success ->
            p [ class "green" ] [ text "Workout Saved!" ]

        Failure _ ->
            p [ class "red" ] [ text "There was a problem submitting your workout" ]

        _ ->
            span [] []
