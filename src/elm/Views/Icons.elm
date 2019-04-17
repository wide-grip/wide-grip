module Views.Icons exposing
    ( fist
    , fistButton
    , fistButtonDisabled
    , fistButtonInverse
    , tick
    , wideGripHeader
    )

import Helpers.Style exposing (backgroundImage, classes, height, width)
import Html exposing (..)
import Html.Attributes exposing (class, style)
import Route


wideGripHeader : String -> Html msg
wideGripHeader title =
    div [ class "tc center mb5 relative" ]
        [ div
            [ backgroundImage "img/wide-grip-logo.png"
            , height 100
            , class "bg-center contain mw6 center relative z-1"
            ]
            []
        , div
            [ class "bg-navy absolute w-100 z-0 dn db-ns"
            , style "top" "42px"
            , height 14
            ]
            []
        , a
            [ Route.href Route.Home
            , class "no-underline"
            ]
            [ h1 [ class "mt0 ttu tracked-mega navy" ] [ text title ] ]
        ]


type ButtonStyle
    = Regular
    | Inverse
    | Disabled


fistButtonDisabled : String -> Html msg
fistButtonDisabled =
    fistButton_ Disabled


fistButtonInverse : String -> Html msg
fistButtonInverse =
    fistButton_ Inverse


fistButton : String -> Html msg
fistButton =
    fistButton_ Regular


fistButton_ : ButtonStyle -> String -> Html msg
fistButton_ buttonStyle buttonText =
    div
        [ classes
            [ "ph3 pv2 mt3 dib br-pill"
            , "ba"
            , "ttu tracked"
            , fistButtonColors buttonStyle
            ]
        ]
        [ div [ class "flex items-center" ]
            [ p [ class "ma0 mr2 no-select" ] [ text buttonText ]
            , span [] [ fist ]
            ]
        ]


fistButtonColors : ButtonStyle -> String
fistButtonColors buttonStyle =
    case buttonStyle of
        Regular ->
            "bg-navy white b--navy pointer"

        Inverse ->
            "bg-white navy b--navy pointer"

        Disabled ->
            "bg-white o-10"


tick : Html msg
tick =
    smallIcon "/img/tick.png"


fist : Html msg
fist =
    smallIcon "/img/fist.png"


smallIcon : String -> Html msg
smallIcon imgSrc =
    div
        [ width 25
        , height 25
        , backgroundImage imgSrc
        , class "bg-center contain"
        ]
        []
