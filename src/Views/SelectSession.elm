module Views.SelectSession exposing (..)

import Data.Workout exposing (sessionTypeToString)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (..)
import Types exposing (..)
import Views.Logo exposing (logo)


view : Model -> Html Msg
view model =
    div [ class "tc" ]
        [ logo "track workout"
        , selectSession Push
        , selectSession Pull
        , selectSession Legs
        ]


selectSession : Session -> Html Msg
selectSession session =
    p [ onClick <| StartWorkout session, class "pointer" ] [ text <| sessionTypeToString session ]
