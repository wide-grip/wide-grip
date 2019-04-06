module Main exposing (main)

import Browser
import Cache.Decode
import Cache.Encode
import Firebase.Encode
import Helpers.Html exposing (renderDictValues)
import Helpers.Style exposing (classes)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Icons
import Json.Decode exposing (Value, decodeValue)
import Ports exposing (..)
import Time
import Workout exposing (..)



-- Program


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    { view : View
    , today : Time.Posix
    , exercises : Maybe AllExercises
    , currentWorkout : Maybe Workout
    }


type alias Flags =
    { now : Int }


type Msg
    = SetView View
    | StartWorkout WorkoutName
    | ConfirmExercises
    | StartExercise Exercise
    | InputWeight String
    | InputReps String
    | SetCurrentUser String
    | SubmitSet
    | FinishCurrentExercise
    | ReceiveExercises Value
    | SubmitWorkout
    | ReceiveSubmitWorkoutStatus FirebaseMessage
    | ReceiveCachedCurrentWorkoutState Value


type View
    = Home
    | History
    | SelectSession
    | SelectExercisesForWorkout
    | StartAnExercise
    | RecordSet



-- Init


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initialModel flags
    , Cmd.none
    )


initialModel : Flags -> Model
initialModel flags =
    { view = Home
    , today = Time.millisToPosix flags.now
    , exercises = Nothing
    , currentWorkout = Nothing
    }



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetView currentView ->
            ( setView currentView model
            , Cmd.none
            )

        StartWorkout workoutName ->
            ( handleStartWorkout workoutName model
            , Cmd.none
            )

        ConfirmExercises ->
            ( setView StartAnExercise model
            , Cmd.none
            )

        StartExercise exercise ->
            ( model
                |> updateCurrentWorkout (updateCurrentExercise exercise)
                |> updateCurrentWorkout (updateCurrentExerciseWith setCompleteToFalse)
                |> setView RecordSet
            , Cmd.none
            )

        InputWeight weightStr ->
            ( updateCurrentWorkout (updateInputWeight weightStr) model
            , Cmd.none
            )

        InputReps repStr ->
            ( updateCurrentWorkout (updateInputReps repStr) model
            , Cmd.none
            )

        SetCurrentUser user ->
            ( updateCurrentWorkout (updateCurrentUser user) model
            , Cmd.none
            )

        SubmitSet ->
            updateCurrentWorkout handleSubmitSet model
                |> withCmd handleCacheWorkout

        FinishCurrentExercise ->
            model
                |> updateCurrentWorkout handleFinishSet
                |> setView StartAnExercise
                |> withCmd handleCacheWorkout

        ReceiveExercises val ->
            ( { model | exercises = Result.toMaybe <| Cache.Decode.decodeExercises val }
            , Cmd.none
            )

        SubmitWorkout ->
            ( model
            , handleSubmitWorkout model
            )

        ReceiveSubmitWorkoutStatus message ->
            ( handleSubmitWorkoutStatus message model
            , Cmd.none
            )

        ReceiveCachedCurrentWorkoutState val ->
            ( handleRestoreCurrentWorkoutFromCache val model
            , Cmd.none
            )


withCmd : (Model -> Cmd Msg) -> Model -> ( Model, Cmd Msg )
withCmd cmdF model =
    ( model, cmdF model )


handleRestoreCurrentWorkoutFromCache : Value -> Model -> Model
handleRestoreCurrentWorkoutFromCache workoutValue model =
    case decodeValue Cache.Decode.workoutDecoder workoutValue of
        Ok workout ->
            { model
                | currentWorkout = Just workout
                , view = viewFromCachedWorkout workout
            }

        Err _ ->
            model


viewFromCachedWorkout : Workout -> View
viewFromCachedWorkout workout =
    case workout.currentExercise of
        Just _ ->
            RecordSet

        Nothing ->
            StartAnExercise


setView : View -> Model -> Model
setView currentView model =
    { model | view = currentView }


handleCacheWorkout : Model -> Cmd Msg
handleCacheWorkout model =
    model.currentWorkout
        |> Maybe.andThen (Cache.Encode.encodeWorkout model.today)
        |> Maybe.map cacheCurrentWorkout
        |> Maybe.withDefault Cmd.none


handleSubmitWorkout : Model -> Cmd Msg
handleSubmitWorkout model =
    model.currentWorkout
        |> Maybe.andThen (Cache.Encode.encodeWorkout model.today)
        |> Maybe.map submitWorkout
        |> Maybe.withDefault Cmd.none


handleStartWorkout : WorkoutName -> Model -> Model
handleStartWorkout workoutName model =
    case model.exercises of
        Just allExercises ->
            { model
                | currentWorkout = initWorkout workoutName [ "Andrew", "Rob" ] allExercises
                , view = SelectExercisesForWorkout
            }

        Nothing ->
            model


handleSubmitWorkoutStatus : FirebaseMessage -> Model -> Model
handleSubmitWorkoutStatus firebaseMessage model =
    let
        submitStatus =
            messageToSubmitWorkoutStatus firebaseMessage
    in
    updateCurrentWorkout (\w -> { w | submitted = submitStatus }) model


messageToSubmitWorkoutStatus : FirebaseMessage -> SubmitWorkoutStatus
messageToSubmitWorkoutStatus message =
    if message.success then
        Success

    else
        Failure message.reason


initWorkout : WorkoutName -> List String -> AllExercises -> Maybe Workout
initWorkout workoutName users allExercises =
    Just
        { workoutName = workoutName
        , progress = defaultExercises workoutName users allExercises
        , currentExercise = Nothing
        , users = users
        , submitted = NotSubmitted
        }


updateCurrentWorkout : (Workout -> Workout) -> Model -> Model
updateCurrentWorkout f model =
    { model | currentWorkout = Maybe.map f model.currentWorkout }


handleSubmitSet : Workout -> Workout
handleSubmitSet workout =
    if validSet workout then
        updateCurrentExerciseWith submitSet workout

    else
        workout



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ receiveExercises ReceiveExercises
        , receiveSubmitWorkoutStatus ReceiveSubmitWorkoutStatus
        , receiveCurrentWorkoutState ReceiveCachedCurrentWorkoutState
        ]



-- View


view : Model -> Browser.Document Msg
view model =
    { title = "Wide Grip"
    , body = [ view_ model ]
    }


view_ : Model -> Html Msg
view_ model =
    case model.view of
        Home ->
            home model

        History ->
            history

        SelectSession ->
            selectSession model

        SelectExercisesForWorkout ->
            selectExercisesForWorkout model

        StartAnExercise ->
            startAnExercise model

        RecordSet ->
            recordSet model



-- Home


home : Model -> Html Msg
home model =
    div [ class "tc tracked-mega ttu" ]
        [ Icons.wideGripHeader "wide grip"
        , renderOptions model.exercises
        ]


renderOptions : Maybe AllExercises -> Html Msg
renderOptions allExercises =
    case allExercises of
        Just _ ->
            div []
                [ p
                    [ onClick <| SetView SelectSession
                    , class "white headline pointer mb4 bg-navy pa4 br-pill mw5 center"
                    ]
                    [ text "Track Workout" ]
                , p
                    [ onClick <| SetView History
                    , class "white headline pointer mb4 bg-red pa4 br-pill mw5 center"
                    ]
                    [ text "Your Gainz" ]
                ]

        Nothing ->
            p [] [ text "Loading..." ]



-- History


history =
    div []
        [ h1 [] [ text "Previous Workouts" ]
        ]



-- Select Session


selectSession : Model -> Html Msg
selectSession model =
    div [ class "tc" ]
        [ Icons.wideGripHeader "track workout"
        , selectWorkoutName Push
        , selectWorkoutName Pull
        , selectWorkoutName Legs
        ]


selectWorkoutName : WorkoutName -> Html Msg
selectWorkoutName workoutName =
    p
        [ onClick <| StartWorkout workoutName
        , class "pointer mv4 headline tracked ttu bg-animate hover-bg-navy bg-gray pa3 br-pill white mw5 center"
        ]
        [ text <| workoutNameToString workoutName ]



-- Select Exercises for Workout


selectExercisesForWorkout : Model -> Html Msg
selectExercisesForWorkout model =
    div [ class "tc" ]
        [ Icons.wideGripHeader "track workout"
        , div [] <| renderDictValues renderExercise <| currentExercises model.currentWorkout
        , div [ onClick ConfirmExercises ]
            [ Icons.fistButton "start"
            ]
        ]


renderExercise : ExerciseProgress -> Html Msg
renderExercise progress =
    p [ class "mv4 ttu tracked" ] [ text progress.exercise.name ]



-- Start an Exercise


startAnExercise : Model -> Html Msg
startAnExercise model =
    div []
        [ Icons.wideGripHeader "start an exercise"
        , div [ class "mt5 mw5 center" ] <| createExerciseList model.currentWorkout
        , div [ onClick SubmitWorkout, class "center tc" ] [ Icons.fistButton "finish workout" ]
        , div [ class "tc mt4" ] [ renderCurrentSubmitStatus model.currentWorkout ]
        ]


createExerciseList : Maybe Workout -> List (Html Msg)
createExerciseList =
    renderDictValues startExercise << currentExercises


startExercise : ExerciseProgress -> Html Msg
startExercise progress =
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
        Icons.tick

    else
        Icons.fist


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



-- Record Set


recordSet : Model -> Html Msg
recordSet model =
    div [ class "tc" ]
        [ Icons.wideGripHeader "track workout"
        , h2 [ class "mt0 mb4 ttu f4 sans-serif tracked-mega" ] [ text <| renderCurrentExerciseName model.currentWorkout ]
        , div [ class "mv4" ] <| List.map (user_ model) <| currentUsers model.currentWorkout
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
        , div []
            [ div
                [ class "dib"
                , onClick FinishCurrentExercise
                ]
                [ Icons.fistButtonInverse "finished" ]
            ]
        ]


nextSetButton : Maybe Workout -> Html Msg
nextSetButton workout =
    case Maybe.map validSet workout of
        Just True ->
            div [ onClick SubmitSet ] [ Icons.fistButton "next set" ]

        _ ->
            Icons.fistButtonDisabled "next set"


user_ : Model -> String -> Html Msg
user_ model u =
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
        [ text u ]


isCurrentUser : String -> Maybe Workout -> Bool
isCurrentUser u workout =
    workout
        |> Maybe.andThen currentUser
        |> Maybe.map ((==) u)
        |> Maybe.withDefault False


renderCurrentExerciseName : Maybe Workout -> String
renderCurrentExerciseName currentWorkout =
    currentWorkout
        |> Maybe.andThen currentExerciseName
        |> Maybe.withDefault ""


currentUsers : Maybe Workout -> List String
currentUsers =
    Maybe.map .users >> Maybe.withDefault []


currentRepsInputValue : Maybe Workout -> String
currentRepsInputValue =
    currentSetInputValue Tuple.second


currentWeightInputValue : Maybe Workout -> String
currentWeightInputValue =
    currentSetInputValue Tuple.first


currentSetInputValue : (CurrentSet -> Maybe Int) -> Maybe Workout -> String
currentSetInputValue f currentWorkout =
    currentWorkout
        |> Maybe.andThen currentSet
        |> Maybe.andThen (f >> Maybe.map String.fromInt)
        |> Maybe.withDefault ""
