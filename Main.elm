module Main exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Svg
import Svg.Attributes
import Time exposing (Time, second)
import Date exposing (Date)
import Http


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Errors =
    { startErr : String
    , endErr : String
    }


type alias Model =
    { startDate : String
    , endDate : String
    , errors : Errors
    , resultString : String
    }


init : ( Model, Cmd msg )
init =
    ( Model "" "" (Errors "" "") "", Cmd.none )



-- UPDATE


type Msg
    = Submit
    | StartDate String
    | EndDate String
    | NewString (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( model_, cmd_ ) =
            updateMsg msg model
    in
        ( { model_ | errors = updateErrors model_ }, cmd_ )


updateMsg : Msg -> Model -> ( Model, Cmd Msg )
updateMsg msg model =
    case msg of
        StartDate dateStr ->
            ( { model | startDate = dateStr }, Cmd.none )

        EndDate dateStr ->
            ( { model | endDate = dateStr }, Cmd.none )

        Submit ->
            ( model, submitRequest )

        NewString (Result.Ok text) ->
            ( { model | resultString = text }, Cmd.none )

        NewString (Result.Err httpErr) ->
            ( { model | resultString = httpErrToString httpErr }, Cmd.none )


getRequest : String -> Http.Request String
getRequest uri =
    Http.getString uri


submitRequest : Cmd Msg
submitRequest =
    Http.send NewString (getRequest "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cats")


httpErrToString : Http.Error -> String
httpErrToString httpErr =
    case httpErr of
        Http.BadUrl msg ->
            msg

        Http.Timeout ->
            "HTTP timeout error"

        Http.NetworkError ->
            "HTTP network error"

        Http.BadStatus _ ->
            "HTTP bad status"

        Http.BadPayload a _ ->
            a


getDateError : String -> String
getDateError dateStr =
    let
        startResult =
            Date.fromString dateStr
    in
        case startResult of
            Err message ->
                message

            _ ->
                ""


updateErrors : Model -> Errors
updateErrors model =
    let
        startErr =
            getDateError model.startDate

        endErr =
            getDateError model.endDate
    in
        Errors startErr endErr



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
        [ view_form model, view_calendar model ]


view_form : Model -> Html Msg
view_form model =
    Html.form [ Html.Events.onSubmit Submit ]
        [ Html.h1 [] [ Html.text "Google calendar get events" ]
        , Html.label [ Html.Attributes.for "start-date" ] [ Html.text "start date" ]
        , Html.input
            [ Html.Attributes.id "start-date"
            , Html.Attributes.type_ "date"
            , Html.Attributes.value model.startDate
            , Html.Events.onInput StartDate
            ]
            []
        , Html.div [] [ Html.text model.errors.startErr ]
        , Html.label [ Html.Attributes.for "end-date" ] [ Html.text "end date" ]
        , Html.input
            [ Html.Attributes.id "end-date"
            , Html.Attributes.type_ "date"
            , Html.Attributes.value model.endDate
            , Html.Events.onInput EndDate
            ]
            []
        , Html.div [] [ Html.text model.errors.endErr ]
        , Html.input [ Html.Attributes.type_ "submit" ] [ Html.text "submit" ]
        , Html.div [] [ Html.text model.resultString ]
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
