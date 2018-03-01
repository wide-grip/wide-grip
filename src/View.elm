module View exposing (..)

import Html exposing (..)
import Types exposing (..)
import Views.Home as Home
import Views.PreviousWorkouts as PreviousWorkouts


view : Model -> Html Msg
view model =
    case model.view of
        Home ->
            Home.view model

        PreviousWorkouts ->
            PreviousWorkouts.view model
