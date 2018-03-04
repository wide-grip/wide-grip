module Views.Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Views.Logo exposing (logo)


view : Model -> Html Msg
view model =
    div [ class "tc tracked-mega ttu" ]
        [ logo "wide grip"
        , div []
            [ p [ onClick <| SetView SelectSession, class "pointer" ] [ text "Track Workout" ]
            , p [ onClick <| SetView History, class "pointer" ] [ text "Your Gainz" ]
            ]
        ]
