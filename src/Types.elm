module Types exposing (..)


type alias Model =
    { view : View
    , currentWorkout : Maybe Workout
    }


type Msg
    = SetView View
    | StartWorkout WorkoutName
    | ConfirmExercises


type View
    = Home
    | History
    | SelectSession
    | SelectExercisesForWorkout
    | StartAnExercise


type WorkoutName
    = Push
    | Pull
    | Legs
    | UserDefined String


type alias Workout =
    { workoutName : WorkoutName
    , exercises : List String
    }
