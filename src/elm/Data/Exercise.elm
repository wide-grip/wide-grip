module Data.Exercise exposing
    ( Category
    , Exercise
    , Exercises
    , add
    , categories
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


type alias Category =
    { id : Int
    , name : String
    }


type alias Exercises =
    Dict Int Exercise


type alias Exercise =
    { id : Int
    , name : String
    , category : Category
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


categories : Exercises -> List Category
categories =
    exercises >> List.map .category >> unique


unique : List Category -> List Category
unique =
    List.map (\cat -> ( cat.id, cat )) >> Dict.fromList >> Dict.values


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
