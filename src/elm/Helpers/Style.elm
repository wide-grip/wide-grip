module Helpers.Style exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (class)


backgroundImage : String -> ( String, String )
backgroundImage src =
    ( "background-image", "url(" ++ src ++ ")" )


widthStyle : number -> ( String, String )
widthStyle number =
    ( "width", toString number ++ "px" )


heightStyle : number -> ( String, String )
heightStyle number =
    ( "height", toString number ++ "px" )


classes : List String -> Attribute msg
classes =
    String.join " " >> class
