module Views.SelectExercisesForWorkout exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Types exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ div [] <| List.map renderExercise <| getCurrentExercises model
        , button [ onClick ConfirmExercises ] [ text "Start (fist)" ]
        ]


getCurrentExercises : Model -> List String
getCurrentExercises model =
    model.currentWorkout
        |> Maybe.map .exercises
        |> Maybe.withDefault []


renderExercise : String -> Html Msg
renderExercise exercise =
    p [] [ text exercise ]
