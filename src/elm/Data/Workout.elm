module Data.Workout exposing
    ( Progress
    , Set
    , Workout
    , addSet
    , completeExercise
    , empty
    , fromList
    , progress
    , toList
    , workout
    )

import Dict exposing (Dict)


type alias Workout =
    Dict Int Progress


type alias Progress =
    { exerciseId : Int
    , complete : Bool
    , sets : List Set
    }


type alias Set =
    { user : String
    , weight : Float
    , reps : Int
    }



-- Construct


empty : Workout
empty =
    Dict.empty


toList : Workout -> List Progress
toList =
    Dict.values


fromList : List Progress -> Workout
fromList =
    List.map (\p -> ( p.exerciseId, p )) >> Dict.fromList


progress : Int -> Bool -> List Set -> Progress
progress =
    Progress


workout : List Progress -> Workout
workout =
    List.map (\p -> ( p.exerciseId, p )) >> Dict.fromList



-- Update


addSet : Int -> Workout -> Set -> Workout
addSet id w set =
    Dict.update id (Maybe.map (\p -> { p | sets = set :: p.sets })) w


completeExercise : Int -> Workout -> Workout
completeExercise id =
    Dict.update id (Maybe.map (\p -> { p | complete = True }))
