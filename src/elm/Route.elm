module Route exposing
    ( Route(..)
    , fromUrl
    , href
    , pushUrl
    , replaceUrl
    )

import Browser.Navigation as Navigation
import Data.Exercise exposing (..)
import Html exposing (Attribute)
import Html.Attributes as Attribute
import Url
import Url.Builder exposing (absolute, string)
import Url.Parser as Parser exposing ((<?>), Parser, oneOf, s)
import Url.Parser.Query as Query


type Route
    = Home
    | SelectWorkout
    | Workout
    | Exercise (Maybe String)


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map SelectWorkout (s "select-workout")
        , Parser.map Workout (s "workout")
        , Parser.map Exercise (s "exercise" <?> parseExerciseId)
        ]


parseExerciseId : Query.Parser (Maybe String)
parseExerciseId =
    Query.string "id"


pushUrl : Navigation.Key -> Route -> Cmd msg
pushUrl key =
    Navigation.pushUrl key << routeToString


replaceUrl : Navigation.Key -> Route -> Cmd msg
replaceUrl key =
    Navigation.replaceUrl key << routeToString


fromUrl : Url.Url -> Maybe Route
fromUrl =
    Parser.parse parser


href : Route -> Attribute msg
href =
    Attribute.href << routeToString


routeToString : Route -> String
routeToString route =
    case route of
        Home ->
            absolute [] []

        SelectWorkout ->
            absolute [ "select-workout" ] []

        Workout ->
            absolute [ "workout" ] []

        Exercise id ->
            case id of
                Just id_ ->
                    absolute [ "exercise" ] [ string "id" id_ ]

                Nothing ->
                    absolute [ "exercise" ] []
