module Types exposing (..)

import Date exposing (Date)


type alias Model =
    { view : View
    , previousWorkouts : List Workout
    }


type Msg
    = SetView View


type View
    = Home
    | PreviousWorkouts


type WorkoutType
    = Push
    | Pull
    | Legs
    | UserDefined String


type alias Workout =
    { workoutType : WorkoutType
    }
