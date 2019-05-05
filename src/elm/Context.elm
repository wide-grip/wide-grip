module Context exposing
    ( Context
    , empty
    , updateExercises
    )

import Browser.Navigation as Navigation
import Data.Exercise as Exercise exposing (Exercises)
import Data.Exercise.Cache as Cache
import Data.Exercise.Graphql
import Graphql.Http
import Json.Encode as Encode
import Time


type alias Context =
    { today : Time.Posix
    , users : List String
    , exercises : Exercises
    , navKey : Navigation.Key
    }


empty : Navigation.Key -> Int -> Exercises -> Context
empty navKey now exercises =
    { today = Time.millisToPosix now
    , users = [ "Rob", "Andrew" ]
    , exercises = exercises
    , navKey = navKey
    }


updateExercises : Exercises -> Context -> Context
updateExercises exercises context =
    { context | exercises = exercises }
