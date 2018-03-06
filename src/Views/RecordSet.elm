module Views.RecordSet exposing (..)

import Data.Workout exposing (currentExerciseName, currentSet, currentUser, validSet)
import Helpers.Style exposing (classes)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Types exposing (..)
import Views.Icon exposing (fistButton, fistButtonDisabled, fistButtonInverse, wideGripHeader)


view : Model -> Html Msg
view model =
    div [ class "tc" ]
        [ wideGripHeader "track workout"
        , h2 [ class "mt0 mb4 ttu f4 sans-serif tracked-mega" ] [ text <| exerciseName model.currentWorkout ]
        , div [ class "mv4" ] <| List.map (user model) <| currentUsers model.currentWorkout
        , div []
            [ input
                [ placeholder "kg"
                , class "tc outline-0 center pa2"
                , value <| currentWeightInputValue model.currentWorkout
                , onInput InputWeight
                ]
                []
            , input
                [ placeholder "rep"
                , class "tc outline-0 center pa2"
                , value <| currentRepsInputValue model.currentWorkout
                , onInput InputReps
                ]
                []
            ]
        , nextSetButton model.currentWorkout
        , div [] [ div [ class "dib", onClick FinishCurrentExercise ] [ fistButtonInverse "finished" ] ]
        ]


nextSetButton : Maybe Workout -> Html Msg
nextSetButton workout =
    case Maybe.map validSet workout of
        Just True ->
            div [ onClick SubmitSet ] [ fistButton "next set" ]

        _ ->
            fistButtonDisabled "next set"


user : Model -> User -> Html Msg
user model u =
    div
        [ classes
            [ "dib ba no-select pointer"
            , "br-pill"
            , "ph3 pv2 mh2"
            , "ttu tracked f6"
            ]
        , classList
            [ ( "bg-navy b--navy white", isCurrentUser u model.currentWorkout )
            , ( "bg-white b--dark-gray dark-gray", not <| isCurrentUser u model.currentWorkout )
            ]
        , onClick <| SetCurrentUser u
        ]
        [ text <| toString u ]


isCurrentUser : User -> Maybe Workout -> Bool
isCurrentUser user workout =
    workout
        |> Maybe.andThen currentUser
        |> Maybe.map ((==) user)
        |> Maybe.withDefault False


currentUsers : Maybe Workout -> List User
currentUsers =
    Maybe.map .users >> Maybe.withDefault []


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
