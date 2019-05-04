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
    Exercise.exercises >> Encode.list encodeExercise


encodeExercise : Exercise -> Encode.Value
encodeExercise ex =
    Encode.object
        [ ( "id", Encode.int ex.id )
        , ( "name", Encode.string ex.name )
        , ( "category", Encode.string <| Exercise.categoryToString ex.category )
        , ( "categoryId", Encode.int ex.categoryId )
        ]



-- Decode


decodeExercises : Encode.Value -> Result Decode.Error Exercises
decodeExercises =
    Decode.list exerciseDecoder
        |> Decode.map Exercise.fromList
        |> Decode.decodeValue


exerciseDecoder : Decode.Decoder Exercise
exerciseDecoder =
    Decode.succeed Exercise
        |> Json.required "id" Decode.int
        |> Json.required "name" Decode.string
        |> Json.required "category" workoutNameDecoder
        |> Json.required "categoryId" Decode.int


workoutNameDecoder : Decode.Decoder Exercise.Category
workoutNameDecoder =
    let
        workoutNameFromString =
            Exercise.categoryFromString
                >> Maybe.withDefault Exercise.Push
                >> Decode.succeed
    in
    Decode.andThen workoutNameFromString Decode.string
