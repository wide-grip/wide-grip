module Types exposing (..)

import Date exposing (Date)
import Dict exposing (Dict)
import Json.Decode exposing (Value)
import Time exposing (Time)


type alias Model =
    { view : View
    , today : Date
    , exercises : Result String AllExercises
    , currentWorkout : Maybe Workout
    }


type alias Flags =
    { now : Time }


type Msg
    = SetView View
    | StartWorkout WorkoutName
    | ConfirmExercises
    | StartExercise String
    | InputWeight String
    | InputReps String
    | SetCurrentUser User
    | SubmitSet
    | FinishCurrentExercise
    | ReceiveExercises Value


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


type alias AllExercises =
    Dict String Exercise


type alias Exercise =
    { name : String
    , workoutName : WorkoutName
    }


type alias Workout =
    { workoutName : WorkoutName
    , progress : WorkoutProgress
    , currentExercise : Maybe String
    , users : List User
    }


type alias WorkoutProgress =
    Dict String ExerciseProgress


type alias ExerciseProgress =
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
