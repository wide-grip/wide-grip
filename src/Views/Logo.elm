module Views.Logo exposing (..)

import Helpers.Style exposing (backgroundImage, heightStyle)
import Html exposing (..)
import Html.Attributes exposing (..)


logo : String -> Html msg
logo title =
    div [ class "tc center mb5" ]
        [ div
            [ style
                [ backgroundImage "image/wide-grip-logo-2.png"
                , heightStyle 100
                ]
            , class "bg-center contain mw6 center"
            ]
            []
        , h1 [ class "mt0 ttu tracked-mega navy" ] [ text title ]
        ]
