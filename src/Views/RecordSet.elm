module Views.RecordSet exposing (..)

import Data.Workout exposing (currentExerciseName, currentSet, validSet)
import Helpers.Style exposing (classes)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Types exposing (..)
import Views.Logo exposing (logo)


view : Model -> Html Msg
view model =
    div [ class "tc" ]
        [ logo "track workout"
        , h2 [ class "mt0 mb4 ttu f4 tracked-mega" ] [ text <| exerciseName model.currentWorkout ]
        , div []
            [ input
                [ placeholder "kg"
                , class "tc center"
                , value <| currentWeightInputValue model.currentWorkout
                , onInput InputWeight
                ]
                []
            , input
                [ placeholder "rep"
                , class "tc center"
                , value <| currentRepsInputValue model.currentWorkout
                , onInput InputReps
                ]
                []
            ]
        , div
            [ classes
                [ "dib ph3 pv2 mt4"
                , "ba br-pill pointer"
                , validSetStyles model.currentWorkout
                ]
            , onClick SubmitSet
            ]
            [ text "Next Set" ]
        ]


exerciseName : Maybe Workout -> String
exerciseName workout =
    workout
        |> Maybe.andThen currentExerciseName
        |> Maybe.withDefault ""


currentRepsInputValue : Maybe Workout -> String
currentRepsInputValue =
    currentSetInputValue Tuple.second


currentWeightInputValue : Maybe Workout -> String
currentWeightInputValue =
    currentSetInputValue Tuple.first


currentSetInputValue : (CurrentSet -> Result String Int) -> Maybe Workout -> String
currentSetInputValue f currentWorkout =
    currentWorkout
        |> Maybe.andThen currentSet
        |> Maybe.map (f >> Result.map toString >> Result.withDefault "")
        |> Maybe.withDefault ""


validSetStyles : Maybe Workout -> String
validSetStyles workout =
    case Maybe.map validSet workout of
        Just True ->
            "bg-navy white b--navy"

        _ ->
            "bg-white light-gray b--light-gray"
