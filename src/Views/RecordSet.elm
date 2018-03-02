module Views.RecordSet exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onInput)
import Types exposing (..)
import Views.Logo exposing (logo)


view : Model -> Html Msg
view model =
    div []
        [ logo "track workout"
        , div [ class "center" ]
            [ input [ placeholder "kg", class "tc center", onInput InputWeight ] []
            , input [ placeholder "rep", class "tc center", onInput InputReps ] []
            ]
        ]
