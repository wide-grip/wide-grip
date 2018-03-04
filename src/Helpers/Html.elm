module Helpers.Html exposing (..)

import Dict exposing (Dict)
import Html exposing (Html)


renderDict : (comparable -> a -> Html msg) -> Dict comparable a -> List (Html msg)
renderDict f =
    Dict.map f >> Dict.values


renderDictValues : (a -> Html msg) -> Dict comparable a -> List (Html msg)
renderDictValues f =
    Dict.map (always f) >> Dict.values
