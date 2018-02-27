module State exposing (..)

import Types exposing (..)


init : ( Model, Cmd Msg )
init =
    {} ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        House ->
            model ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
