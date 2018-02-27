module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)


view : Model -> Html Msg
view model =
    div [ class "tc mt5 tracked-mega ttu" ] [ p [] [ text "Gainz" ] ]
