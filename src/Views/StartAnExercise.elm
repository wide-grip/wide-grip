module Views.StartAnExercise exposing (..)

import Html exposing (..)
import Types exposing (..)
import Views.Logo exposing (logo)


view : Model -> Html Msg
view model =
    logo "big back"
