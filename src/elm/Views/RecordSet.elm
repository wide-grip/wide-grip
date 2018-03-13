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
        , h2 [ class "mt0 mb4 ttu f4 sans-serif tracked-mega" ] [ text <| renderCurrentExerciseName model.currentWorkout ]
        , div [ class "mv4" ] <| List.map (user model) <| currentUsers model.currentWorkout
        , div [ class "f4 tracked flex flex-wrap mw6 center" ]
            [ div [ class "w-100 w-50-ns" ]
                [ h4 [ class "ttu sans-serif mv2" ] [ text "Weight" ]
                , input
                    [ placeholder "Kg"
                    , type_ "number"
                    , class "tc outline-0 center pa2 mb3 w-80 center"
                    , value <| currentWeightInputValue model.currentWorkout
                    , onInput InputWeight
                    ]
                    []
                ]
            , div [ class "w-100 w-50-ns" ]
                [ h4 [ class "ttu sans-serif mv2" ] [ text "Reps" ]
                , input
                    [ placeholder "Reps"
                    , type_ "number"
                    , class "tc outline-0 center pa2 mb2 w-80 center"
                    , value <| currentRepsInputValue model.currentWorkout
                    , onInput InputReps
                    ]
                    []
                ]
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


renderCurrentExerciseName : Maybe Workout -> String
renderCurrentExerciseName currentWorkout =
    currentWorkout
        |> Maybe.andThen currentExerciseName
        |> Maybe.withDefault ""


currentUsers : Maybe Workout -> List User
currentUsers =
    Maybe.map .users >> Maybe.withDefault []


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
