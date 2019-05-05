module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Context exposing (Context)
import Data.Exercise as Exercise exposing (Exercises)
import Data.Exercise.Cache
import Data.Exercise.Graphql
import Graphql.Http
import Html exposing (Html)
import Json.Encode as Encode
import Page.ChooseWorkout as ChooseWorkout
import Page.Home as Home
import Page.Workout as Workout
import Ports
import Route exposing (Route)
import Url
import Views.Layout as Layout



-- Program


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }



-- Model


type alias Flags =
    { now : Int
    , exercises : Encode.Value
    }


type Model
    = Home Home.Model
    | ChooseWorkout ChooseWorkout.Model
    | Workout Workout.Model


type Msg
    = HomeMsg Home.Msg
    | ChooseWorkoutMsg ChooseWorkout.Msg
    | WorkoutMsg Workout.Msg
    | GotCachedExercises Encode.Value
    | GotExercises GQLResult
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


type alias GQLResult =
    Result (Graphql.Http.Error Exercises) Exercises



-- Init


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    emptyPage key flags
        |> changeRouteTo (Route.fromUrl url)
        |> addCmd getExercises


emptyPage : Navigation.Key -> Flags -> Model
emptyPage key flags =
    initialContext key flags
        |> Home.init
        |> Tuple.first
        |> Home


initialContext : Navigation.Key -> Flags -> Context
initialContext key flags =
    Context.empty key flags.now <| decodeExercises flags.exercises



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( HomeMsg msg_, Home model_ ) ->
            Home.update msg_ model_ |> updateHome

        ( ChooseWorkoutMsg msg_, ChooseWorkout model_ ) ->
            ChooseWorkout.update msg_ model_ |> updateChooseWorkout

        ( WorkoutMsg msg_, Workout model_ ) ->
            Workout.update msg_ model_ |> updateWorkout

        ( LinkClicked urlRequest, _ ) ->
            handleLinkClicked model urlRequest

        ( UrlChanged url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( GotCachedExercises exercises, _ ) ->
            ( updateContext (Context.updateExercises <| decodeExercises exercises) model, Cmd.none )

        ( GotExercises (Ok exercises), _ ) ->
            ( updateContext (Context.updateExercises exercises) model, cacheExercises exercises )

        _ ->
            ( model, Cmd.none )


cacheExercises : Exercises -> Cmd Msg
cacheExercises =
    Data.Exercise.Cache.encodeExercises
        >> Ports.cacheExercises


decodeExercises : Encode.Value -> Exercises
decodeExercises =
    Data.Exercise.Cache.decodeExercises
        >> Result.toMaybe
        >> Maybe.withDefault Exercise.empty


handleLinkClicked : Model -> Browser.UrlRequest -> ( Model, Cmd Msg )
handleLinkClicked model urlRequest =
    case urlRequest of
        Browser.Internal url ->
            ( model
            , Navigation.pushUrl (getContext model |> .navKey) (Url.toString url)
            )

        Browser.External href ->
            ( model
            , Navigation.load href
            )


getExercises : Cmd Msg
getExercises =
    Data.Exercise.Graphql.exercisesQuery
        |> Graphql.Http.queryRequest "http://localhost:8080/v1alpha1/graphql"
        |> Graphql.Http.send GotExercises



-- Update Helpers


updateHome : ( Home.Model, Cmd Home.Msg ) -> ( Model, Cmd Msg )
updateHome =
    updateWith Home HomeMsg


updateChooseWorkout : ( ChooseWorkout.Model, Cmd ChooseWorkout.Msg ) -> ( Model, Cmd Msg )
updateChooseWorkout =
    updateWith ChooseWorkout ChooseWorkoutMsg


updateWorkout : ( Workout.Model, Cmd Workout.Msg ) -> ( Model, Cmd Msg )
updateWorkout =
    updateWith Workout WorkoutMsg


updateWith :
    (pageModel -> model)
    -> (pageMsg -> msg)
    -> ( pageModel, Cmd pageMsg )
    -> ( model, Cmd msg )
updateWith modelF msgF ( pageModel, pageCmd ) =
    ( modelF pageModel
    , Cmd.map msgF pageCmd
    )


addCmd : Cmd Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
addCmd cmd2 ( model, cmd1 ) =
    ( model, Cmd.batch [ cmd1, cmd2 ] )



-- Router


changeRouteTo : Maybe Route.Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        context =
            getContext model
    in
    case maybeRoute of
        Just Route.Home ->
            Home.init context |> updateHome

        Just Route.ChooseWorkout ->
            ChooseWorkout.init context |> updateChooseWorkout

        Just Route.Workout ->
            Workout.init context |> updateWorkout

        Nothing ->
            Home.init context |> updateHome



-- Context


getContext : Model -> Context
getContext page =
    case page of
        Home m ->
            m.context

        ChooseWorkout m ->
            m.context

        Workout m ->
            m.context


updateContext : (Context -> Context) -> Model -> Model
updateContext f model =
    let
        update_ m =
            { m | context = f m.context }
    in
    case model of
        Home m ->
            Home <| update_ m

        ChooseWorkout m ->
            ChooseWorkout <| update_ m

        Workout m ->
            Workout <| update_ m



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.receiveExercises GotCachedExercises
        , pageSubscriptions model
        ]


pageSubscriptions : Model -> Sub Msg
pageSubscriptions page =
    case page of
        Home model ->
            Home.subscriptions model |> Sub.map HomeMsg

        ChooseWorkout model ->
            ChooseWorkout.subscriptions model |> Sub.map ChooseWorkoutMsg

        Workout model ->
            Workout.subscriptions model |> Sub.map WorkoutMsg



-- View


view : Model -> Browser.Document Msg
view model =
    { title = "Wide Grip"
    , body = [ view_ model ]
    }


view_ : Model -> Html Msg
view_ page =
    case page of
        Home model ->
            Layout.layout "wide grip"
                [ Html.map HomeMsg <| Home.view model ]

        ChooseWorkout model ->
            Layout.layout "choose workout"
                [ Html.map ChooseWorkoutMsg <| ChooseWorkout.view model ]

        Workout model ->
            Layout.layout "workout"
                [ Html.map WorkoutMsg <| Workout.view model ]
