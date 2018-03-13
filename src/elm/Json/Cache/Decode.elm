module Json.Cache.Decode exposing (..)

import Data.Workout exposing (emptySet)
import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Types exposing (..)


workoutDecoder : Decoder Workout
workoutDecoder =
    decode Workout
        |> required "workoutName" workoutNameDecoder
        |> required "exercises" (dict exerciseProgressDecoder)
        |> required "currentExercise" (nullable exerciseDecoder)
        |> required "users" (list userDecoder)
        |> hardcoded NotSubmitted


exerciseProgressDecoder : Decoder ExerciseProgress
exerciseProgressDecoder =
    decode ExerciseProgress
        |> required "exercise" exerciseDecoder
        |> required "sets" (list recordedSetDecoder)
        |> required "complete" bool
        |> hardcoded emptySet
        |> hardcoded Rob


recordedSetDecoder : Decoder RecordedSet
recordedSetDecoder =
    decode RecordedSet
        |> required "user" userDecoder
        |> required "weight" int
        |> required "reps" int


userDecoder : Decoder User
userDecoder =
    string |> Json.Decode.andThen userFromString


userFromString : String -> Decoder User
userFromString userStr =
    case userStr of
        "Rob" ->
            succeed Rob

        "Andrew" ->
            succeed Andrew

        "Eine" ->
            succeed Eine

        "Alex" ->
            succeed Alex

        _ ->
            fail "unrecognized user"


type alias RawExercise =
    { name : String
    , workoutName : WorkoutName
    }


decodeExercises : Value -> Result String AllExercises
decodeExercises =
    dict rawExerciseDecoder
        |> Json.Decode.map addIdToExercise
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
    string |> Json.Decode.andThen workoutNameFromString


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
                Json.Decode.succeed <| UserDefined (String.dropLeft 12 str)
            else
                Json.Decode.fail "Invalid WorkoutName"
