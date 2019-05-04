module Types exposing
    ( AllExercises
    , CurrentSet
    , Exercise
    , ExerciseProgress
    , FirebaseMessage
    , Flags
    , Model
    , Msg(..)
    , RecordedSet
    , SubmitWorkoutStatus(..)
    , View(..)
    , Workout
    , WorkoutName(..)
    , WorkoutProgress
    )

import Dict exposing (Dict)
import Json.Decode exposing (Value)
import Time


type alias Model =
    { view : View
    , today : Time.Posix
    , exercises : Maybe AllExercises
    , currentWorkout : Maybe Workout
    }


type alias Flags =
    { now : Int }


type Msg
    = SetView View
    | StartWorkout WorkoutName
    | ConfirmExercises
    | StartExercise Exercise
    | InputWeight String
    | InputReps String
    | SetCurrentUser User
    | SubmitSet
    | FinishCurrentExercise
    | ReceiveExercises Value
    | SubmitWorkout
    | ReceiveSubmitWorkoutStatus FirebaseMessage
    | ReceiveCachedCurrentWorkoutState Value


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


type alias User =
    String


type alias AllExercises =
    Dict String Exercise


type alias Exercise =
    { id : String
    , name : String
    , workoutName : WorkoutName
    }


type alias Workout =
    { workoutName : WorkoutName
    , progress : WorkoutProgress
    , currentExercise : Maybe Exercise
    , users : List String
    , submitted : SubmitWorkoutStatus
    }


type alias WorkoutProgress =
    Dict String ExerciseProgress


type alias ExerciseProgress =
    { exercise : Exercise
    , sets : List RecordedSet
    , complete : Bool
    , currentSet : CurrentSet
    , currentUser : User
    }


type alias RecordedSet =
    { user : String
    , weight : Int
    , reps : Int
    }


type alias CurrentSet =
    ( Maybe Int, Maybe Int )


type alias FirebaseMessage =
    { success : Bool
    , reason : String
    }


type SubmitWorkoutStatus
    = NotSubmitted
    | Success
    | Failure String
