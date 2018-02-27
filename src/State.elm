module State exposing (..)

import Types exposing (..)


init : ( Model, Cmd Msg )
init =
    { view = Home, previousWorkouts = [ Workout Push, Workout Pull ] } ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetView view ->
            { model | view = view } ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
