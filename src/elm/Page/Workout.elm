module Page.Workout exposing
    ( Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Context exposing (Context)
import Data.Exercise as Exercise exposing (Exercise)
import Data.Workout as Workout
import Data.Workout.Cache as Cache
import Helpers.Style exposing (classes)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Decode as Decode
import Json.Decode.Pipeline as Json
import Json.Encode as Encode
import Ports
import Route
import Views.Icons as Icons



-- Model


type alias Model =
    { context : Context
    , workout : Workout.Workout
    , currentExerciseId : Maybe Int
    , currentSet : CurrentSet
    , currentUser : String
    }


type alias CurrentSet =
    { weight : Maybe Float
    , reps : Maybe Int
    }


type Msg
    = SelectExercise Int
    | InputWeight String
    | InputReps String
    | CompleteExercise
    | SubmitSet
    | CurrentUser String
    | ReceiveWorkoutFromCache Encode.Value



-- Init


init : Context -> ( Model, Cmd Msg )
init context =
    ( initialModel context
    , Ports.restoreWorkoutFromCache ()
    )


initialModel : Context -> Model
initialModel context =
    { context = context
    , workout = Workout.empty
    , currentExerciseId = Nothing
    , currentSet = emptySet
    , currentUser = firstUser context.users
    }


emptySet : CurrentSet
emptySet =
    { reps = Nothing
    , weight = Nothing
    }


firstUser : List String -> String
firstUser =
    List.head >> Maybe.withDefault "Rob"



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectExercise id ->
            ( { model | currentExerciseId = Just id }
            , Cmd.none
            )

        InputWeight weight ->
            ( { model | currentSet = updateWeight weight model.currentSet }
            , Cmd.none
            )

        InputReps reps ->
            ( { model | currentSet = updateReps reps model.currentSet }
            , Cmd.none
            )

        CompleteExercise ->
            handleCompleteExercise model |> withCmd cacheWorkout

        SubmitSet ->
            handleSubmitSet model |> withCmd cacheWorkout

        CurrentUser user ->
            ( { model | currentUser = user }
            , Cmd.none
            )

        ReceiveWorkoutFromCache value ->
            ( decodeWorkout model value
            , Cmd.none
            )


cacheWorkout : Model -> Cmd Msg
cacheWorkout =
    .workout >> Cache.encodeWorkout >> Ports.cacheWorkout


decodeWorkout : Model -> Encode.Value -> Model
decodeWorkout model value =
    case Cache.decodeWorkout value of
        Ok workout ->
            { model | workout = workout }

        _ ->
            model


handleCompleteExercise : Model -> Model
handleCompleteExercise model =
    case model.currentExerciseId of
        Just id ->
            { model | workout = Workout.completeExercise id model.workout, currentExerciseId = Nothing }

        Nothing ->
            model


handleSubmitSet : Model -> Model
handleSubmitSet model =
    if validSet model.currentSet then
        { model
            | currentSet = emptySet
            , workout = appendSet model.currentUser model.currentExerciseId model.currentSet model.workout
        }

    else
        model


appendSet : String -> Maybe Int -> CurrentSet -> Workout.Workout -> Workout.Workout
appendSet user exerciseId { weight, reps } workout =
    case ( weight, reps, exerciseId ) of
        ( Just weight_, Just reps_, Just id ) ->
            Workout.Set user weight_ reps_ |> Workout.addSet id workout

        _ ->
            workout


updateWeight : String -> CurrentSet -> CurrentSet
updateWeight weight currentSet =
    { currentSet | weight = String.toFloat weight }


updateReps : String -> CurrentSet -> CurrentSet
updateReps reps currentSet =
    { currentSet | reps = String.toInt reps }


validSet : CurrentSet -> Bool
validSet { weight, reps } =
    weight /= Nothing && reps /= Nothing


withCmd : (Model -> Cmd Msg) -> Model -> ( Model, Cmd Msg )
withCmd cmdF model =
    ( model, cmdF model )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.receiveWorkoutFromCache ReceiveWorkoutFromCache



-- View


view : Model -> Html Msg
view model =
    case model.currentExerciseId of
        Just id ->
            recordExercise id model

        Nothing ->
            chooseExercise model



-- Choose Exercise


chooseExercise : Model -> Html Msg
chooseExercise model =
    div []
        [ div [ class "mt5 mw5 center" ] <| renderExercises model
        , div [ class "center tc" ] [ Icons.fistButton "finish workout" ]
        ]


renderExercises : Model -> List (Html Msg)
renderExercises model =
    model.workout
        |> Workout.toList
        |> List.map (startExercise model)


startExercise : Model -> Workout.Progress -> Html Msg
startExercise model progress =
    div
        [ class "flex navy pointer justify-between mb3 bg-animate hover-bg-navy hover-white items-center br-pill ba b--navy"
        , onClick <| SelectExercise progress.exerciseId
        ]
        [ p [ class "ttu ma3 tracked" ] [ text <| Maybe.withDefault "" <| exerciseNameFromProgress progress model.context.exercises ]
        , div [ class "ma3" ] [ renderIcon progress ]
        ]


exerciseNameFromProgress : Workout.Progress -> Exercise.Exercises -> Maybe String
exerciseNameFromProgress progress =
    Exercise.getById progress.exerciseId >> Maybe.map .name


renderIcon : Workout.Progress -> Html msg
renderIcon progress =
    if progress.complete then
        Icons.tick

    else
        Icons.fist



-- Record Exercise


recordExercise : Int -> Model -> Html Msg
recordExercise exerciseId model =
    div []
        [ h2 [ class "mt0 mb4 ttu f4 sans-serif tracked-mega" ] [ text <| exerciseName exerciseId model ]
        , div [ class "mv4" ] <| List.map (renderUser model) model.context.users
        , div [ class "f4 tracked flex flex-wrap mw6 center" ]
            [ div [ class "w-100 w-50-ns" ]
                [ h4 [ class "ttu sans-serif mv2" ] [ text "Weight" ]
                , input
                    [ placeholder "Kg"
                    , type_ "number"
                    , class "tc outline-0 center pa2 mb3 w-80 center"
                    , value <| weightToString model.currentSet
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
                    , value <| repsToString model.currentSet
                    , onInput InputReps
                    ]
                    []
                ]
            ]
        , nextSetButton model.currentSet
        , div []
            [ a [ Route.href Route.Workout ]
                [ div
                    [ class "dib"
                    , onClick CompleteExercise
                    ]
                    [ Icons.fistButtonInverse "finished" ]
                ]
            ]
        ]


exerciseName : Int -> Model -> String
exerciseName exerciseId model =
    model.context.exercises
        |> Exercise.getById exerciseId
        |> Maybe.map .name
        |> Maybe.withDefault ""


weightToString : CurrentSet -> String
weightToString =
    .weight >> Maybe.map String.fromFloat >> Maybe.withDefault ""


repsToString : CurrentSet -> String
repsToString =
    .reps >> Maybe.map String.fromInt >> Maybe.withDefault ""


nextSetButton : CurrentSet -> Html Msg
nextSetButton currentSet =
    if validSet currentSet then
        div [ onClick SubmitSet ] [ Icons.fistButton "next set" ]

    else
        Icons.fistButtonDisabled "next set"


renderUser : Model -> String -> Html Msg
renderUser model user =
    div
        [ classes
            [ "dib ba no-select pointer"
            , "br-pill"
            , "ph3 pv2 mh2"
            , "ttu tracked f6"
            ]
        , classList
            [ ( "bg-navy b--navy white", user == model.currentUser )
            , ( "bg-white b--dark-gray dark-gray", user /= model.currentUser )
            ]
        , onClick <| CurrentUser user
        ]
        [ text user ]
