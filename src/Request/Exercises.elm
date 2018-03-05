module Request.Exercises exposing (..)

import Json.Decode as Json exposing (..)
import Json.Decode.Pipeline exposing (..)
import Types exposing (..)


decodeExercises : Value -> Result String AllExercises
decodeExercises =
    decodeValue <| dict exerciseDecoder


exerciseDecoder : Decoder Exercise
exerciseDecoder =
    decode Exercise
        |> required "name" string
        |> required "workoutName" workoutNameDecoder


workoutNameDecoder : Decoder WorkoutName
workoutNameDecoder =
    string |> Json.andThen workoutNameFromString


workoutNameFromString : String -> Decoder WorkoutName
workoutNameFromString string =
    case string of
        "Push" ->
            succeed Push

        "Pull" ->
            succeed Pull

        "Legs" ->
            succeed Legs

        str ->
            if String.startsWith "UserDefined " str then
                Json.succeed <| UserDefined (String.dropLeft 12 str)
            else
                Json.fail "Invalid WorkoutName"
