module Data.Workout exposing
    ( appendSet
    , currentExerciseName
    , currentExerciseProgress
    , currentExercises
    , currentSet
    , currentUser
    , defaultExercises
    , emptySet
    , finishSet
    , handleFinishSet
    , initExerciseProgress
    , resetCurrentExercise
    , setCompleteToFalse
    , setCurrentUser
    , submitSet
    , updateCurrentExercise
    , updateCurrentExerciseWith
    , updateCurrentExerciseWith_
    , updateCurrentSetReps
    , updateCurrentSetWeight
    , updateCurrentUser
    , updateInputReps
    , updateInputWeight
    , updateReps
    , updateWeight
    , validInputSet
    , validSet
    , workoutNameToString
    )

import Dict exposing (Dict)
import Types exposing (..)


workoutNameToString : WorkoutName -> String
workoutNameToString workoutName =
    case workoutName of
        Push ->
            "Push"

        Pull ->
            "Pull"

        Legs ->
            "Legs"


defaultExercises : WorkoutName -> List String -> AllExercises -> WorkoutProgress
defaultExercises workoutName users allExercises =
    allExercises
        |> Dict.filter (\_ v -> v.workoutName == workoutName)
        |> Dict.map (initExerciseProgress users)


initExerciseProgress : List String -> String -> Exercise -> ExerciseProgress
initExerciseProgress users _ exercise =
    { exercise = exercise
    , sets = []
    , complete = False
    , currentSet = emptySet
    , currentUser = List.head users |> Maybe.withDefault "Rob"
    }


currentUser : Workout -> Maybe String
currentUser =
    currentExerciseProgress >> Maybe.map .currentUser


emptySet : ( Maybe Int, Maybe Int )
emptySet =
    ( Nothing
    , Nothing
    )


currentExercises : Maybe Workout -> WorkoutProgress
currentExercises =
    Maybe.map .progress >> Maybe.withDefault Dict.empty


resetCurrentExercise : Workout -> Workout
resetCurrentExercise workout =
    { workout | currentExercise = Nothing }


handleFinishSet : Workout -> Workout
handleFinishSet =
    updateCurrentExerciseWith finishSet >> resetCurrentExercise


updateCurrentUser : String -> Workout -> Workout
updateCurrentUser =
    updateCurrentExerciseWith << setCurrentUser


updateInputReps : String -> Workout -> Workout
updateInputReps =
    updateCurrentExerciseWith << updateCurrentSetReps


updateInputWeight : String -> Workout -> Workout
updateInputWeight =
    updateCurrentExerciseWith << updateCurrentSetWeight


updateCurrentExerciseWith : (ExerciseProgress -> ExerciseProgress) -> Workout -> Workout
updateCurrentExerciseWith f workout =
    { workout | progress = updateCurrentExerciseWith_ f workout.currentExercise workout.progress }


setCompleteToFalse : ExerciseProgress -> ExerciseProgress
setCompleteToFalse exerciseProgress =
    { exerciseProgress | complete = False }


updateCurrentExerciseWith_ :
    (ExerciseProgress -> ExerciseProgress)
    -> Maybe Exercise
    -> WorkoutProgress
    -> WorkoutProgress
updateCurrentExerciseWith_ f currentExercise exercises =
    currentExercise
        |> Maybe.map (\ex -> Dict.update ex.id (Maybe.map f) exercises)
        |> Maybe.withDefault exercises


setCurrentUser : String -> ExerciseProgress -> ExerciseProgress
setCurrentUser user exercise =
    { exercise | currentUser = user }


updateCurrentSetReps : String -> ExerciseProgress -> ExerciseProgress
updateCurrentSetReps weightStr exercise =
    { exercise | currentSet = updateReps weightStr exercise.currentSet }


updateCurrentSetWeight : String -> ExerciseProgress -> ExerciseProgress
updateCurrentSetWeight weightStr exercise =
    { exercise | currentSet = updateWeight weightStr exercise.currentSet }


updateWeight : String -> CurrentSet -> CurrentSet
updateWeight weightStr ( _, reps ) =
    ( String.toInt weightStr, reps )


updateReps : String -> CurrentSet -> CurrentSet
updateReps repStr ( weight, _ ) =
    ( weight, String.toInt repStr )


updateCurrentExercise : Exercise -> Workout -> Workout
updateCurrentExercise exercise workout =
    { workout | currentExercise = Just exercise }


submitSet : ExerciseProgress -> ExerciseProgress
submitSet exercise =
    { exercise
        | currentSet = emptySet
        , sets = appendSet exercise.currentUser exercise.currentSet exercise.sets
    }


finishSet : ExerciseProgress -> ExerciseProgress
finishSet exercise =
    { exercise
        | currentSet = emptySet
        , sets = appendSet exercise.currentUser exercise.currentSet exercise.sets
        , complete = True
    }


appendSet : String -> CurrentSet -> List RecordedSet -> List RecordedSet
appendSet user currentSet_ sets =
    case currentSet_ of
        ( Just weight, Just reps ) ->
            RecordedSet user weight reps :: sets

        _ ->
            sets


validSet : Workout -> Bool
validSet =
    currentSet >> Maybe.map validInputSet >> Maybe.withDefault False


validInputSet : CurrentSet -> Bool
validInputSet currentSet_ =
    case currentSet_ of
        ( Nothing, Nothing ) ->
            True

        _ ->
            False


currentExerciseName : Workout -> Maybe String
currentExerciseName =
    currentExerciseProgress >> Maybe.map (.exercise >> .name)


currentSet : Workout -> Maybe CurrentSet
currentSet =
    currentExerciseProgress >> Maybe.map .currentSet


currentExerciseProgress : Workout -> Maybe ExerciseProgress
currentExerciseProgress workout =
    workout.currentExercise
        |> Maybe.map .id
        |> Maybe.andThen (\exerciseId -> Dict.get exerciseId workout.progress)
