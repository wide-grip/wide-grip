module View exposing (view)

import Browser exposing (Document)
import Html exposing (..)
import Types exposing (..)
import Views.History as History
import Views.Home as Home
import Views.RecordSet as RecordSet
import Views.SelectExercisesForWorkout as SelectExercisesForWorkout
import Views.SelectWorkoutName as SelectWorkoutName
import Views.StartAnExercise as StartAnExercise


view : Model -> Document Msg
view model =
    { title = "Wide Grip"
    , body = [ view_ model ]
    }


view_ : Model -> Html Msg
view_ model =
    case model.view of
        Home ->
            Home.view model

        History ->
            History.view model

        SelectSession ->
            SelectWorkoutName.view model

        SelectExercisesForWorkout ->
            SelectExercisesForWorkout.view model

        StartAnExercise ->
            StartAnExercise.view model

        RecordSet ->
            RecordSet.view model
