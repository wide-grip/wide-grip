module State exposing (..)

import Data.Workout exposing (defaultExercises)
import Types exposing (..)


-- INIT


init : ( Model, Cmd Msg )
init =
    initialModel ! []


initialModel : Model
initialModel =
    { view = Home
    , currentWorkout = Nothing
    }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetView view ->
            { model | view = view } ! []

        StartWorkout session ->
            { model
                | currentWorkout = initWorkoutWithSession session
                , view = SelectExercisesForWorkout
            }
                ! []

        ConfirmExercises ->
            { model | view = StartAnExercise } ! []


initWorkoutWithSession : Session -> Maybe Workout
initWorkoutWithSession session =
    Just
        { session = session
        , exercises = defaultExercises session
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
