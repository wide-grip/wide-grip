module Helpers.Html exposing (..)

import Dict exposing (Dict)
import Html exposing (Attribute, Html)
import Html.Attributes exposing (..)
import Json.Encode exposing (string)


renderDict : (comparable -> a -> Html msg) -> Dict comparable a -> List (Html msg)
renderDict f =
    Dict.map f >> Dict.values


renderDictValues : (a -> Html msg) -> Dict comparable a -> List (Html msg)
renderDictValues f =
    Dict.map (always f) >> Dict.values


emptyProperty : Attribute msg
emptyProperty =
    property "" <| string ""
