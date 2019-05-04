module Context exposing
    ( Context
    , empty
    , updateAllExercises
    )

import Browser.Navigation as Navigation
import Data.Exercise as Exercise exposing (Exercises)
import Data.Exercise.Cache as Cache
import Json.Encode as Encode
import Time


type alias Context =
    { today : Time.Posix
    , users : List String
    , exercises : Exercises
    , navKey : Navigation.Key
    }


empty : Navigation.Key -> Int -> Encode.Value -> Context
empty navKey now exercises =
    { today = Time.millisToPosix now
    , users = [ "Rob", "Andrew" ]
    , exercises = decodeExercises exercises
    , navKey = navKey
    }


updateAllExercises : Encode.Value -> Context -> Context
updateAllExercises exercises context =
    { context | exercises = decodeExercises exercises }


decodeExercises : Encode.Value -> Exercises
decodeExercises =
    Cache.decodeExercises
        >> Result.toMaybe
        >> Maybe.withDefault Exercise.empty
