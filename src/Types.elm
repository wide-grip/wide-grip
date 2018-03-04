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
    | SetCurrentUser User
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


type User
    = Rob
    | Andrew
    | Eine
    | Alex


type alias Workout =
    { workoutName : WorkoutName
    , exercises : Dict Int Exercise
    , currentExercise : Maybe Int
    , users : List User
    }


type alias Exercise =
    { name : String
    , sets : List Set
    , complete : Bool
    , currentSet : CurrentSet
    , currentUser : User
    }


type alias Set =
    { user : User
    , weight : Int
    , reps : Int
    }


type alias CurrentSet =
    ( Result String Int, Result String Int )
