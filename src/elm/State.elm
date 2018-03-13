module State exposing (..)

import Data.Ports exposing (..)
import Data.Workout exposing (..)
import Date
import Json.Cache.Decode as DecodeCache
import Json.Cache.Encode as EncodeCache
import Json.Firebase.Encode as EncodeFirebase
import Json.Decode exposing (Value, decodeValue)
import Types exposing (..)


-- INIT


init : Flags -> ( Model, Cmd Msg )
init flags =
    initialModel flags ! []


initialModel : Flags -> Model
initialModel flags =
    { view = Home
    , today = Date.fromTime flags.now
    , exercises = Err "no exercises yet"
    , currentWorkout = Nothing
    }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetView view ->
            setView view model ! []

        StartWorkout workoutName ->
            handleStartWorkout workoutName model ! []

        ConfirmExercises ->
            setView StartAnExercise model ! []

        StartExercise exercise ->
            (model
                |> updateCurrentWorkout (updateCurrentExercise exercise)
                |> setView RecordSet
            )
                ! []

        InputWeight weightStr ->
            updateCurrentWorkout (updateInputWeight weightStr) model ! []

        InputReps repStr ->
            updateCurrentWorkout (updateInputReps repStr) model ! []

        SetCurrentUser user ->
            updateCurrentWorkout (updateCurrentUser user) model ! []

        SubmitSet ->
            let
                newModel =
                    updateCurrentWorkout handleSubmitSet model
            in
                newModel ! [ handleCacheWorkout newModel ]

        FinishCurrentExercise ->
            let
                newModel =
                    model
                        |> updateCurrentWorkout handleFinishSet
                        |> setView StartAnExercise
            in
                newModel ! [ handleCacheWorkout newModel ]

        ReceiveExercises val ->
            { model | exercises = DecodeCache.decodeExercises val } ! []

        SubmitWorkout ->
            model ! [ handleSubmitWorkout model ]

        ReceiveSubmitWorkoutStatus message ->
            handleSubmitWorkoutStatus message model ! []

        ReceiveCachedCurrentWorkoutState val ->
            handleRestoreCurrentWorkoutFromCache val model ! []


handleRestoreCurrentWorkoutFromCache : Value -> Model -> Model
handleRestoreCurrentWorkoutFromCache workoutValue model =
    case decodeValue DecodeCache.workoutDecoder workoutValue of
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
setView view model =
    { model | view = view }


handleCacheWorkout : Model -> Cmd Msg
handleCacheWorkout model =
    EncodeCache.encodeCurrentWorkout model
        |> Maybe.map cacheCurrentWorkout
        |> Maybe.withDefault Cmd.none


handleSubmitWorkout : Model -> Cmd Msg
handleSubmitWorkout model =
    EncodeFirebase.encodeCurrentWorkout model
        |> Maybe.map submitWorkout
        |> Maybe.withDefault Cmd.none


handleStartWorkout : WorkoutName -> Model -> Model
handleStartWorkout workoutName model =
    case model.exercises of
        Ok allExercises ->
            { model
                | currentWorkout = initWorkout workoutName [ Andrew, Rob ] allExercises
                , view = SelectExercisesForWorkout
            }

        Err _ ->
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


initWorkout : WorkoutName -> List User -> AllExercises -> Maybe Workout
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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ receiveExercises ReceiveExercises
        , receiveSubmitWorkoutStatus ReceiveSubmitWorkoutStatus
        , receiveCurrentWorkoutState ReceiveCachedCurrentWorkoutState
        ]
