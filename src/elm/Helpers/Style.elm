module Helpers.Style exposing (backgroundImage, classes, heightStyle, widthStyle)

import Html exposing (Attribute)
import Html.Attributes exposing (class)


backgroundImage : String -> ( String, String )
backgroundImage src =
    ( "background-image", "url(" ++ src ++ ")" )


widthStyle : Float -> ( String, String )
widthStyle number =
    ( "width", String.fromFloat number ++ "px" )


heightStyle : Float -> ( String, String )
heightStyle number =
    ( "height", String.fromFloat number ++ "px" )


classes : List String -> Attribute msg
classes =
    String.join " " >> class
