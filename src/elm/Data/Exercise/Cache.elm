module Data.Exercise.Cache exposing
    ( decodeExercises
    , encodeExercises
    )

import Data.Exercise as Exercise exposing (Exercise, Exercises)
import Dict exposing (Dict)
import Json.Decode as Decode
import Json.Decode.Pipeline as Json
import Json.Encode as Encode



-- Encode


encodeExercises : Exercises -> Encode.Value
encodeExercises =
    Encode.dict identity encodeExercise


encodeExercise : Exercise -> Encode.Value
encodeExercise ex =
    Encode.object
        [ ( "exerciseId", Encode.string ex.id )
        , ( "name", Encode.string ex.name )
        , ( "category", Encode.string <| Exercise.categoryToString ex.category )
        ]



-- Decode


type alias RawExercise =
    { name : String
    , workoutName : Exercise.Category
    }


decodeExercises : Encode.Value -> Result Decode.Error Exercises
decodeExercises =
    Decode.dict rawExerciseDecoder
        |> Decode.map addIdToExercise
        |> Decode.decodeValue


addIdToExercise : Dict String RawExercise -> Exercises
addIdToExercise dct =
    Dict.map (\id { name, workoutName } -> Exercise id name workoutName) dct


rawExerciseDecoder : Decode.Decoder RawExercise
rawExerciseDecoder =
    Decode.succeed RawExercise
        |> Json.required "name" Decode.string
        |> Json.required "workoutName" workoutNameDecoder


workoutNameDecoder : Decode.Decoder Exercise.Category
workoutNameDecoder =
    let
        workoutNameFromString =
            Exercise.categoryFromString
                >> Maybe.withDefault Exercise.Push
                >> Decode.succeed
    in
    Decode.andThen workoutNameFromString Decode.string
