module Types exposing (..)


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
    , exercises : List Exercise
    , currentExercise : Maybe Int
    }


type alias Exercise =
    { id : Int
    , name : String
    , sets : List ( Int, Int )
    , complete : Bool
    , currentSet : ( Result String Int, Result String Int )
    }
