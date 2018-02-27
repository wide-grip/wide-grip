module Views.Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Helpers.Style exposing (..)


view : Model -> Html Msg
view model =
    div [ class "tc mt5 tracked-mega ttu" ]
        [ div
            [ style
                [ backgroundImage "image/wide-grip-logo.png"
                , heightStyle 100
                ]
            , class "bg-center contain mw6 center"
            ]
            []
        , p [ onClick <| SetView Home ] [ text "Track Session" ]
        , p [ onClick <| SetView PreviousWorkouts ] [ text "Your Gainz" ]
        ]
