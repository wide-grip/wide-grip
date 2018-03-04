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


defaultExercises : List User -> WorkoutName -> Dict Int Exercise
defaultExercises users session =
    case session of
        Push ->
            Dict.fromList
                [ exercise 1 "Bench press" users
                , exercise 2 "Incline bench press" users
                , exercise 3 "Rope pull down" users
                ]

        Pull ->
            Dict.fromList
                [ exercise 4 "Pull ups" users
                , exercise 5 "Seated rows" users
                , exercise 6 "Bicep curls" users
                ]

        Legs ->
            Dict.fromList
                [ exercise 7 "Squats" users
                , exercise 8 "Lunges" users
                , exercise 9 "Calf raises" users
                ]

        UserDefined string ->
            Dict.empty


exercise : Int -> String -> List User -> ( Int, Exercise )
exercise n name users =
    ( n
    , { name = name
      , sets = []
      , complete = False
      , currentSet = emptySet
      , currentUser = List.head users |> Maybe.withDefault Rob
      }
    )


currentUser : Workout -> Maybe User
currentUser workout =
    workout
        |> currentExercise
        |> Maybe.map .currentUser


emptySet : ( Result String Int, Result String Int )
emptySet =
    ( Err "not entered"
    , Err "not entered"
    )


currentExercises : Maybe Workout -> Dict Int Exercise
currentExercises =
    Maybe.map .exercises >> Maybe.withDefault Dict.empty


updateCurrentUser : User -> Workout -> Workout
updateCurrentUser =
    setCurrentUser >> updateCurrentExerciseWith


updateInputReps : String -> Workout -> Workout
updateInputReps =
    updateCurrentSetReps >> updateCurrentExerciseWith


updateInputWeight : String -> Workout -> Workout
updateInputWeight =
    updateCurrentSetWeight >> updateCurrentExerciseWith


updateCurrentExerciseWith : (Exercise -> Exercise) -> Workout -> Workout
updateCurrentExerciseWith f workout =
    { workout | exercises = updateCurrentExerciseWith_ f workout.currentExercise workout.exercises }


updateCurrentExerciseWith_ : (Exercise -> Exercise) -> Maybe Int -> Dict Int Exercise -> Dict Int Exercise
updateCurrentExerciseWith_ f exerciseId exercises =
    exerciseId
        |> Maybe.map (\id -> Dict.update id (Maybe.map f) exercises)
        |> Maybe.withDefault exercises


setCurrentUser : User -> Exercise -> Exercise
setCurrentUser user exercise =
    { exercise | currentUser = user }


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


initWorkout : List User -> WorkoutName -> Workout
initWorkout users name =
    { workoutName = name
    , exercises = defaultExercises users name
    , currentExercise = Nothing
    , users = users
    }


submitSet : Exercise -> Exercise
submitSet exercise =
    { exercise
        | currentSet = emptySet
        , sets = appendSet exercise.currentUser exercise.currentSet exercise.sets
    }


appendSet : User -> CurrentSet -> List Set -> List Set
appendSet user currentSet sets =
    case currentSet of
        ( Ok weight, Ok reps ) ->
            Set user weight reps :: sets

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
