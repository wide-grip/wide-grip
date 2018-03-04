module Types exposing (..)

import Dict exposing (Dict)


type alias Model =
    { view : View
    , currentWorkout : Maybe Workout
    }


type Msg
    = SetView View
    | StartWorkout WorkoutName
    | ConfirmExercises
    | StartExercise Int
    | InputWeight String
    | InputReps String
    | SubmitSet


type View
    = Home
    | History
    | SelectSession
    | SelectExercisesForWorkout
    | StartAnExercise
    | RecordSet


type WorkoutName
    = Push
    | Pull
    | Legs
    | UserDefined String


type alias Workout =
    { workoutName : WorkoutName
    , exercises : Dict Int Exercise
    , currentExercise : Maybe Int
    }


type alias Exercise =
    { name : String
    , sets : List ( Int, Int )
    , complete : Bool
    , currentSet : CurrentSet
    }


type alias CurrentSet =
    ( Result String Int, Result String Int )
