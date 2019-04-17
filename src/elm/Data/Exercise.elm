module Data.Exercise exposing
    ( Category(..)
    , Exercise
    , Exercises
    , add
    , categoryFromString
    , categoryToString
    , empty
    , filterByCategory
    , getById
    , ids
    , isEmpty
    , member
    , remove
    )

import Dict exposing (Dict)


type Category
    = Push
    | Pull
    | Legs


type alias Exercises =
    Dict String Exercise


type alias Exercise =
    { id : String
    , name : String
    , category : Category
    }



-- Construct


empty : Exercises
empty =
    Dict.empty



-- Query


getById : String -> Exercises -> Maybe Exercise
getById =
    Dict.get


ids : Exercises -> List String
ids =
    Dict.keys


filterByCategory : Category -> Exercises -> Exercises
filterByCategory category =
    Dict.filter (\_ exercise -> exercise.category == category)


isEmpty : Exercises -> Bool
isEmpty =
    Dict.isEmpty


member : Exercise -> Exercises -> Bool
member exercise =
    Dict.member exercise.id



-- Update


add : Exercise -> Exercises -> Exercises
add exercise =
    Dict.insert exercise.id exercise


remove : Exercise -> Exercises -> Exercises
remove exercise =
    Dict.remove exercise.id



-- String


categoryToString : Category -> String
categoryToString category =
    case category of
        Push ->
            "Push"

        Pull ->
            "Pull"

        Legs ->
            "Legs"


categoryFromString : String -> Maybe Category
categoryFromString string =
    case string of
        "Push" ->
            Just Push

        "Pull" ->
            Just Pull

        "Legs" ->
            Just Legs

        _ ->
            Nothing
