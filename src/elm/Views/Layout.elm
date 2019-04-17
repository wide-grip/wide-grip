module Views.Layout exposing (layout)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Views.Icons as Icons


layout : String -> List (Html msg) -> Html msg
layout pageTitle content =
    div [ class "tc tracked-mega ttu" ]
        [ Icons.wideGripHeader pageTitle
        , div [] content
        ]
