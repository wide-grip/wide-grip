module Helpers.Style exposing (..)


backgroundImage : String -> ( String, String )
backgroundImage src =
    ( "background-image", "url(" ++ src ++ ")" )


widthStyle : number -> ( String, String )
widthStyle number =
    ( "width", toString number ++ "px" )


heightStyle : number -> ( String, String )
heightStyle number =
    ( "height", toString number ++ "px" )
