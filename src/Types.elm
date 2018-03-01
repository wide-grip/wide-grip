module Types exposing (..)


type alias Model =
    { view : View
    , currentWorkout : Maybe Workout
    }


type Msg
    = SetView View
    | StartWorkout Session


type View
    = Home
    | History
    | SelectSession
    | SelectExercises


type Session
    = Push
    | Pull
    | Legs
    | UserDefined String


type alias Workout =
    { session : Session
    , exercises : List String
    }
