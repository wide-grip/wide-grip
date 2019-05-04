module Json.Cache.Decode exposing
    ( RawExercise
    , addIdToExercise
    , decodeExercises
    , exerciseDecoder
    , exerciseProgressDecoder
    , rawExerciseDecoder
    , recordedSetDecoder
    , workoutDecoder
    , workoutNameDecoder
    , workoutNameFromString
    )

import Data.Workout exposing (emptySet)
import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Types exposing (..)


workoutDecoder : Decoder Workout
workoutDecoder =
    succeed Workout
        |> required "workoutName" workoutNameDecoder
        |> required "exercises" (dict exerciseProgressDecoder)
        |> required "currentExercise" (nullable exerciseDecoder)
        |> required "users" (list string)
        |> hardcoded NotSubmitted


exerciseProgressDecoder : Decoder ExerciseProgress
exerciseProgressDecoder =
    succeed ExerciseProgress
        |> required "exercise" exerciseDecoder
        |> required "sets" (list recordedSetDecoder)
        |> required "complete" bool
        |> hardcoded emptySet
        |> hardcoded "Rob"


recordedSetDecoder : Decoder RecordedSet
recordedSetDecoder =
    succeed RecordedSet
        |> required "user" string
        |> required "weight" int
        |> required "reps" int


type alias RawExercise =
    { name : String
    , workoutName : WorkoutName
    }


decodeExercises : Value -> Result Error AllExercises
decodeExercises =
    dict rawExerciseDecoder
        |> Json.Decode.map addIdToExercise
        |> decodeValue


addIdToExercise : Dict String RawExercise -> Dict String Exercise
addIdToExercise dct =
    Dict.map (\id { name, workoutName } -> Exercise id name workoutName) dct


exerciseDecoder : Decoder Exercise
exerciseDecoder =
    succeed Exercise
        |> required "id" string
        |> required "name" string
        |> required "workoutName" workoutNameDecoder


rawExerciseDecoder : Decoder RawExercise
rawExerciseDecoder =
    succeed RawExercise
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

        _ ->
            Json.Decode.fail "Invalid WorkoutName"
