module Data.Exercise.Graphql exposing (exerciseSelection, exercisesQuery)

import Api.Object
import Api.Object.Categories as Categories
import Api.Object.Exercises as Exercises
import Api.Query as Query
import Data.Exercise as Exercise
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)


exercisesQuery : SelectionSet Exercise.Exercises RootQuery
exercisesQuery =
    Query.exercises identity exerciseSelection |> SelectionSet.map Exercise.fromList


exerciseSelection : SelectionSet Exercise.Exercise Api.Object.Exercises
exerciseSelection =
    SelectionSet.succeed Exercise.Exercise
        |> with Exercises.id
        |> with Exercises.name
        |> with (Exercises.category categorySelection)


categorySelection : SelectionSet Exercise.Category Api.Object.Categories
categorySelection =
    SelectionSet.succeed Exercise.Category
        |> with Categories.id
        |> with Categories.name
