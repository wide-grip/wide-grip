module Main exposing (..)

import Html
import State exposing (init, subscriptions, update)
import Types exposing (Model, Msg)
import View exposing (view)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
