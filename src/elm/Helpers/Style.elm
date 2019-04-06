module Helpers.Style exposing (backgroundImage, classes, height, width)

import Html exposing (Attribute)
import Html.Attributes exposing (class, style)


backgroundImage : String -> Attribute msg
backgroundImage src =
    style "background-image" <| "url(" ++ src ++ ")"


width : Float -> Attribute msg
width number =
    style "width" <| String.fromFloat number ++ "px"


height : Float -> Attribute msg
height number =
    style "height" <| String.fromFloat number ++ "px"


classes : List String -> Attribute msg
classes =
    String.join " " >> class
