module Main exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Svg
import Svg.Attributes
import Time exposing (Time, second)
import Set
import Keyboard
import Random
import Date exposing (Date)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { startDate : String
    , endDate : String
    }


init : ( Model, Cmd msg )
init =
    ( Model "" "", Cmd.none )



-- UPDATE


type Msg
    = Submit
    | StartDate String
    | EndDate String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartDate dateStr ->
            ( { model | startDate = dateStr }, Cmd.none )

        EndDate dateStr ->
            ( { model | endDate = dateStr }, Cmd.none )

        Submit ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



{--
    Sub.batch
        [ Keyboard.downs KeyDown
        , Keyboard.ups KeyUp
        , Time.every second Tick
        ]

--}
-- VIEW


view : Model -> Html Msg
view model =
    Html.div []
        [ view_form, view_calendar model ]


view_form : Html Msg
view_form =
    Html.form [ Html.Events.onSubmit Submit ]
        [ Html.h1 [] [ Html.text "Google calendar get events" ]
        , Html.label [ Html.Attributes.for "start-date" ] [ Html.text "start date" ]
        , Html.input
            [ Html.Attributes.id "start-date"
            , Html.Attributes.type_ "date"
            , Html.Attributes.placeholder "begin"
            , Html.Events.onInput StartDate
            ]
            []
        , Html.div [] []
        , Html.label [ Html.Attributes.for "end-date" ] [ Html.text "end date" ]
        , Html.input
            [ Html.Attributes.id "end-date"
            , Html.Attributes.type_ "date"
            , Html.Attributes.placeholder "end"
            , Html.Events.onInput EndDate
            ]
            []
        , Html.div [] []
        , Html.input [ Html.Attributes.type_ "submit" ] [ Html.text "submit" ]
        , Html.div [] []
        ]


view_calendar : Model -> Html Msg
view_calendar model =
    Svg.svg [ Svg.Attributes.viewBox "0 0 100 100", Svg.Attributes.width "500px" ]
        [ view_background
        ]


view_background : Html Msg
view_background =
    Svg.rect
        [ Svg.Attributes.fill "#ffffff"
        , Svg.Attributes.stroke "#000000"
        , Svg.Attributes.x "10"
        , Svg.Attributes.y "10"
        , Svg.Attributes.width "20"
        , Svg.Attributes.height "20"
        ]
        []
