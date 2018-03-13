module Request.Exercises exposing (..)

import Dict exposing (Dict)
import Json.Decode as Json exposing (..)
import Json.Decode.Pipeline exposing (..)
import Types exposing (..)


type alias RawExercise =
    { name : String
    , workoutName : WorkoutName
    }


decodeExercises : Value -> Result String AllExercises
decodeExercises =
    dict rawExerciseDecoder
        |> Json.map addIdToExercise
        |> decodeValue


addIdToExercise : Dict String RawExercise -> Dict String Exercise
addIdToExercise dct =
    Dict.map (\id { name, workoutName } -> Exercise id name workoutName) dct


exerciseDecoder : Decoder Exercise
exerciseDecoder =
    decode Exercise
        |> required "id" string
        |> required "name" string
        |> required "workoutName" workoutNameDecoder


rawExerciseDecoder : Decoder RawExercise
rawExerciseDecoder =
    decode RawExercise
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
