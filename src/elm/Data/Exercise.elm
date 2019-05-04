module Data.Exercise exposing
    ( Category(..)
    , Exercise
    , Exercises
    , add
    , categoryFromString
    , categoryToString
    , empty
    , exercises
    , filterByCategory
    , fromList
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
    Dict Int Exercise


type alias Exercise =
    { id : Int
    , name : String
    , category : Category
    , categoryId : Int
    }



-- Construct


empty : Exercises
empty =
    Dict.empty


fromList : List Exercise -> Exercises
fromList =
    List.map (\ex -> ( ex.id, ex )) >> Dict.fromList



-- Query


getById : Int -> Exercises -> Maybe Exercise
getById =
    Dict.get


ids : Exercises -> List Int
ids =
    Dict.keys


exercises : Exercises -> List Exercise
exercises =
    Dict.values


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
