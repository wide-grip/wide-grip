module Request.DecodeCurrentWorkout exposing (..)

import Data.Workout exposing (emptySet)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Request.Exercises exposing (exerciseDecoder, workoutNameDecoder)
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
