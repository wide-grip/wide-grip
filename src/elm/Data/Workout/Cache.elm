module Data.Workout.Cache exposing
    ( decodeProgress
    , decodeWorkout
    , encodeProgress
    , encodeWorkout
    )

import Data.Workout as Workout
import Json.Decode as Decode
import Json.Decode.Pipeline as Json
import Json.Encode as Encode



-- Encode


encodeWorkout : Workout.Workout -> Encode.Value
encodeWorkout =
    Encode.dict identity encodeProgress


encodeProgress : Workout.Progress -> Encode.Value
encodeProgress progress =
    Encode.object
        [ ( "exerciseId", Encode.string progress.exerciseId )
        , ( "complete", Encode.bool progress.complete )
        , ( "sets", Encode.list encodeSet progress.sets )
        ]


encodeSet : Workout.Set -> Encode.Value
encodeSet set =
    Encode.object
        [ ( "user", Encode.string set.user )
        , ( "weight", Encode.float set.weight )
        , ( "reps", Encode.int set.reps )
        ]



-- Decode


decodeWorkout : Encode.Value -> Result Decode.Error Workout.Workout
decodeWorkout =
    Decode.decodeValue <| Decode.dict progressDecoder


decodeProgress : Encode.Value -> Result Decode.Error Workout.Progress
decodeProgress =
    Decode.decodeValue progressDecoder


progressDecoder : Decode.Decoder Workout.Progress
progressDecoder =
    Decode.succeed Workout.Progress
        |> Json.required "exerciseId" Decode.string
        |> Json.optional "complete" Decode.bool False
        |> Json.optional "sets" (Decode.list setDecoder) []


setDecoder : Decode.Decoder Workout.Set
setDecoder =
    Decode.succeed Workout.Set
        |> Json.required "user" Decode.string
        |> Json.required "weight" Decode.float
        |> Json.required "reps" Decode.int
