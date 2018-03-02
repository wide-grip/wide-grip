module View exposing (..)

import Html exposing (..)
import Types exposing (..)
import Views.History as History
import Views.Home as Home
import Views.SelectExercisesForWorkout as SelectExercisesForWorkout
import Views.SelectWorkoutName as SelectWorkoutName
import Views.StartAnExercise as StartAnExercise


view : Model -> Html Msg
view model =
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
