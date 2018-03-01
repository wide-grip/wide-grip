module Views.SelectSession exposing (..)

import Data.Workout exposing (sessionTypeToString)
import Html exposing (..)
import Html.Events exposing (..)
import Types exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ selectSession Push
        , selectSession Pull
        , selectSession Legs
        ]


selectSession : Session -> Html Msg
selectSession session =
    p [ onClick <| StartWorkout session ] [ text <| sessionTypeToString session ]
