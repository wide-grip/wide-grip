module Data.Exercise.Cache exposing
    ( decodeExercises
    , encodeExercises
    )

import Data.Exercise as Exercise exposing (Category, Exercise, Exercises)
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
        , ( "category", encodeCategory ex.category )
        ]


encodeCategory : Category -> Encode.Value
encodeCategory cat =
    Encode.object
        [ ( "id", Encode.int cat.id )
        , ( "name", Encode.string cat.name )
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
        |> Json.required "category" categoryDecoder


categoryDecoder : Decode.Decoder Category
categoryDecoder =
    Decode.succeed Category
        |> Json.required "id" Decode.int
        |> Json.required "name" Decode.string
