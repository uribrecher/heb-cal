module Main exposing (..)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)
import Set exposing (..)
import Keyboard
import Random


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    Int


init : ( Model, Cmd msg )
init =
    ( 0, Cmd.none )



-- UPDATE


type Msg
    = Tick Float
    | KeyDown Int
    | KeyUp Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyDown
        , Keyboard.ups KeyUp
        , Time.every second Tick
        ]



-- VIEW


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text "hello "
        ]
