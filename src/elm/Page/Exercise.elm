module Page.Exercise exposing
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
    , exerciseId : String
    , sets : List Workout.Set
    , complete : Bool
    , currentSet : CurrentSet
    , currentUser : String
    }


type alias CurrentSet =
    { weight : Maybe Float
    , reps : Maybe Int
    }


type Msg
    = InputWeight String
    | InputReps String
    | CompleteExercise
    | SubmitSet
    | CurrentUser String
    | ReceiveProgressFromCache Encode.Value



-- Init


init : Context -> String -> ( Model, Cmd Msg )
init context exerciseId =
    ( initialModel context exerciseId
    , Ports.restoreExerciseProgressFromCache exerciseId
    )


initialModel : Context -> String -> Model
initialModel context exerciseId =
    { context = context
    , exerciseId = exerciseId
    , sets = []
    , complete = False
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
        InputWeight weight ->
            ( { model | currentSet = updateWeight weight model.currentSet }
            , Cmd.none
            )

        InputReps reps ->
            ( { model | currentSet = updateReps reps model.currentSet }
            , Cmd.none
            )

        CompleteExercise ->
            withCmd cacheProgress { model | complete = True }

        SubmitSet ->
            handleSubmitSet model |> withCmd cacheProgress

        CurrentUser user ->
            ( { model | currentUser = user }
            , Cmd.none
            )

        ReceiveProgressFromCache value ->
            ( decodeCachedProgress model value
            , Cmd.none
            )


cacheProgress : Model -> Cmd Msg
cacheProgress =
    toProgress >> Cache.encodeProgress >> Ports.cacheExerciseProgress


toProgress : Model -> Workout.Progress
toProgress model =
    { exerciseId = model.exerciseId
    , complete = model.complete
    , sets = model.sets
    }


decodeCachedProgress : Model -> Encode.Value -> Model
decodeCachedProgress model value =
    case Cache.decodeProgress value of
        Ok progress ->
            { model | sets = progress.sets, complete = progress.complete }

        _ ->
            model


handleSubmitSet : Model -> Model
handleSubmitSet model =
    if validSet model.currentSet then
        { model
            | currentSet = emptySet
            , sets = appendSet model.currentUser model.currentSet model.sets
        }

    else
        model


appendSet : String -> CurrentSet -> List Workout.Set -> List Workout.Set
appendSet user { weight, reps } sets =
    case ( weight, reps ) of
        ( Just weight_, Just reps_ ) ->
            Workout.Set user weight_ reps_ :: sets

        _ ->
            sets


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
    Ports.recevieExerciseProgressFromCache ReceiveProgressFromCache



-- View


view : Model -> Html Msg
view model =
    div []
        [ h2 [ class "mt0 mb4 ttu f4 sans-serif tracked-mega" ] [ text <| exerciseName model ]
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


exerciseName : Model -> String
exerciseName model =
    model.context.exercises
        |> Exercise.getById model.exerciseId
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
