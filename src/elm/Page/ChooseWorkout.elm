module Page.ChooseWorkout exposing
    ( Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Context exposing (Context)
import Data.Exercise as Exercise exposing (Exercise, Exercises)
import Data.Workout as Workout
import Data.Workout.Cache as Cache
import Dict
import Html exposing (..)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Ports
import Route
import Views.Icons as Icons



-- Model


type alias Model =
    { context : Context
    , selectedCategory : Maybe Exercise.Category
    , selectedExercises : Exercise.Exercises
    , view : View
    }


type View
    = Category
    | Exercises


type Msg
    = SelectCategory Exercise.Category
    | SelectExercise Exercise.Exercise



-- Init


init : Context -> ( Model, Cmd Msg )
init context =
    ( initialModel context
    , Cmd.none
    )


initialModel : Context -> Model
initialModel context =
    { context = context
    , selectedCategory = Nothing
    , selectedExercises = Exercise.empty
    , view = Category
    }



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectCategory category ->
            { model
                | selectedCategory = Just category
                , selectedExercises = Exercise.filterByCategory category model.context.exercises
                , view = Exercises
            }
                |> withCmd cacheWorkout

        SelectExercise exercise ->
            model
                |> handleToggleExercise exercise
                |> withCmd cacheWorkout


handleToggleExercise : Exercise -> Model -> Model
handleToggleExercise exercise model =
    { model | selectedExercises = toggleExercise model.selectedExercises exercise }


toggleExercise : Exercises -> Exercise -> Exercises
toggleExercise exercises exercise =
    if Exercise.member exercise exercises then
        Exercise.remove exercise exercises

    else
        Exercise.add exercise exercises


cacheWorkout : Model -> Cmd Msg
cacheWorkout =
    .selectedExercises
        >> Exercise.ids
        >> toEmptyWorkout
        >> Cache.encodeWorkout
        >> Ports.cacheWorkout


toEmptyWorkout : List Int -> Workout.Workout
toEmptyWorkout =
    List.map (\id -> Workout.progress id False []) >> Workout.workout


withCmd : (Model -> Cmd Msg) -> Model -> ( Model, Cmd Msg )
withCmd cmdF model =
    ( model
    , cmdF model
    )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- View


view : Model -> Html Msg
view model =
    case model.view of
        Category ->
            chooseCategory model

        Exercises ->
            chooseExercises model


chooseCategory : Model -> Html Msg
chooseCategory model =
    div []
        [ selectCategory Exercise.Push
        , selectCategory Exercise.Pull
        , selectCategory Exercise.Legs
        ]


selectCategory : Exercise.Category -> Html Msg
selectCategory category =
    p
        [ onClick <| SelectCategory category
        , class "pointer mv4 headline tracked ttu bg-animate hover-bg-navy bg-gray pa3 br-pill white mw5 center"
        ]
        [ text <| Exercise.categoryToString category ]


chooseExercises : Model -> Html Msg
chooseExercises model =
    div []
        [ div [ class "flex flex-column mw5 w-30 center" ] <| List.map (renderExercise model.selectedExercises) <| filterExercises model.selectedCategory model.context.exercises
        , confirm model.selectedExercises
        ]


confirm : Exercises -> Html Msg
confirm selectedExercises =
    if Exercise.isEmpty selectedExercises then
        div [ class "o-30" ]
            [ Icons.fistButton "start"
            ]

    else
        a [ Route.href Route.Workout ]
            [ Icons.fistButton "start"
            ]


filterExercises : Maybe Exercise.Category -> Exercise.Exercises -> List Exercise.Exercise
filterExercises selectedCategory exercises =
    selectedCategory
        |> Maybe.map (\category -> Exercise.filterByCategory category exercises)
        |> Maybe.map Dict.values
        |> Maybe.withDefault []


renderExercise : Exercise.Exercises -> Exercise.Exercise -> Html Msg
renderExercise exercises exercise =
    p
        [ class "mt0 mb4 ttu tracked pointer pa3"
        , classList
            [ ( "bg-dark-blue white br-pill no-select", Exercise.member exercise exercises )
            , ( "dark-blue", not <| Exercise.member exercise exercises )
            ]
        , onClick <| SelectExercise exercise
        ]
        [ text exercise.name ]
