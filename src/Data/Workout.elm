module Data.Workout exposing (..)

import Dict exposing (Dict)
import Types exposing (..)


workoutNameToString : WorkoutName -> String
workoutNameToString workoutName =
    case workoutName of
        UserDefined str ->
            str

        workoutName ->
            toString workoutName


defaultExercises : WorkoutName -> Dict Int Exercise
defaultExercises session =
    case session of
        Push ->
            Dict.fromList
                [ exercise 1 "Bench press"
                , exercise 2 "Incline bench press"
                , exercise 3 "Rope pull down"
                ]

        Pull ->
            Dict.fromList
                [ exercise 4 "Pull ups"
                , exercise 5 "Seated rows"
                , exercise 6 "Bicep curls"
                ]

        Legs ->
            Dict.fromList
                [ exercise 7 "Squats"
                , exercise 8 "Lunges"
                , exercise 9 "Calf raises"
                ]

        UserDefined string ->
            Dict.empty


exercise : Int -> String -> ( Int, Exercise )
exercise n name =
    ( n
    , { name = name
      , sets = []
      , complete = False
      , currentSet = emptySet
      }
    )


emptySet : ( Result String Int, Result String Int )
emptySet =
    ( Err "not entered"
    , Err "not entered"
    )


currentExercises : Maybe Workout -> Dict Int Exercise
currentExercises =
    Maybe.map .exercises >> Maybe.withDefault Dict.empty


inputReps : String -> Workout -> Workout
inputReps string ({ currentExercise, exercises } as workout) =
    { workout
        | exercises = updateExercisesWith (updateCurrentSetReps string) currentExercise exercises
    }


inputWeight : String -> Workout -> Workout
inputWeight weightStr ({ currentExercise, exercises } as workout) =
    { workout
        | exercises = updateExercisesWith (updateCurrentSetWeight weightStr) currentExercise exercises
    }


updateExercisesWith : (Exercise -> Exercise) -> Maybe Int -> Dict Int Exercise -> Dict Int Exercise
updateExercisesWith f exerciseId exercises =
    exerciseId
        |> Maybe.map (\id -> Dict.update id (Maybe.map f) exercises)
        |> Maybe.withDefault exercises


updateCurrentSetReps : String -> Exercise -> Exercise
updateCurrentSetReps weightStr exercise =
    { exercise | currentSet = updateReps weightStr exercise.currentSet }


updateCurrentSetWeight : String -> Exercise -> Exercise
updateCurrentSetWeight weightStr exercise =
    { exercise | currentSet = updateWeight weightStr exercise.currentSet }


updateWeight : String -> CurrentSet -> CurrentSet
updateWeight weightStr ( _, reps ) =
    ( String.toInt weightStr, reps )


updateReps : String -> CurrentSet -> CurrentSet
updateReps repStr ( weight, _ ) =
    ( weight, String.toInt repStr )


updateCurrentExercise : Int -> Workout -> Workout
updateCurrentExercise exerciseId workout =
    { workout | currentExercise = Just exerciseId }


initWorkoutWithName : WorkoutName -> Workout
initWorkoutWithName name =
    { workoutName = name
    , exercises = defaultExercises name
    , currentExercise = Nothing
    }


submitSet : Exercise -> Exercise
submitSet exercise =
    { exercise
        | currentSet = emptySet
        , sets = appendSet exercise.currentSet exercise.sets
    }


appendSet : CurrentSet -> List ( Int, Int ) -> List ( Int, Int )
appendSet currentSet sets =
    case currentSet of
        ( Ok weight, Ok reps ) ->
            ( weight, reps ) :: sets

        _ ->
            sets


validSet : Workout -> Bool
validSet =
    currentSet >> Maybe.map validInputSet >> Maybe.withDefault False


validInputSet : CurrentSet -> Bool
validInputSet currentSet =
    case currentSet of
        ( Ok _, Ok _ ) ->
            True

        _ ->
            False


currentExerciseName : Workout -> Maybe String
currentExerciseName workout =
    currentExercise workout |> Maybe.map .name


currentSet : Workout -> Maybe CurrentSet
currentSet workout =
    currentExercise workout |> Maybe.map .currentSet


currentExercise : Workout -> Maybe Exercise
currentExercise workout =
    workout.currentExercise |> Maybe.andThen (\exerciseId -> Dict.get exerciseId workout.exercises)
