module Views.Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Views.Icon exposing (wideGripHeader)


view : Model -> Html Msg
view model =
    div [ class "tc tracked-mega ttu" ]
        [ wideGripHeader "wide grip"
        , renderOptions model.exercises
        ]


renderOptions : Result String AllExercises -> Html Msg
renderOptions allExercises =
    case allExercises of
        Ok _ ->
            div []
                [ p
                    [ onClick <| SetView SelectSession
                    , class "white headline pointer mb4 bg-navy pa4 br-pill mw5 center"
                    ]
                    [ text "Track Workout" ]
                , p
                    [ onClick <| SetView History
                    , class "white headline pointer mb4 bg-red pa4 br-pill mw5 center"
                    ]
                    [ text "Your Gainz" ]
                ]

        Err _ ->
            p [] [ text "Loading..." ]
