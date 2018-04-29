module App exposing (..)

import Http
import Html exposing (div, img, p, text)
import Html.Attributes exposing (class, src)
import Json.Decode as Decode exposing (field, list, map4, Decoder, int, string, float)


type alias Movie =
    { poster : String, rating : Float, title : String, year : Int }


type alias Model =
    { movies : List Movie
    , error : String
    }


type Msg
    = LoadMovies (Result Http.Error (List Movie))


view : Model -> Html.Html msg
view model =
    div []
        [ div [ class "cardHolder" ] (List.map renderCard model.movies)
        , p [] [ text model.error ]
        ]


renderCard : Movie -> Html.Html msg
renderCard movie =
    div [ class "card" ]
        [ img [ src movie.poster ]
            []
        , div [ class "card-data" ]
            [ p [ class "title" ]
                [ text movie.title ]
            , p [ class "year" ]
                [ text (toString movie.year) ]
            , p [ class "rating" ]
                [ text (toString movie.rating) ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadMovies (Ok loadedMovies) ->
            ( { model | movies = loadedMovies }, Cmd.none )

        LoadMovies (Err loadError) ->
            ( { model | error = toString loadError }, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , update = update
        , init = init
        , subscriptions = \_ -> Sub.none
        }


init : ( Model, Cmd Msg )
init =
    ( { movies = [], error = "" }, getMovies )


getMovies : Cmd Msg
getMovies =
    Http.send LoadMovies (Http.get "http://localhost:3001/movies" movieListDecoder)


movieListDecoder : Decoder (List Movie)
movieListDecoder =
    Decode.list movieDecoder


movieDecoder : Decoder Movie
movieDecoder =
    Decode.map4 Movie
        (field "poster" Decode.string)
        (field "rating" Decode.float)
        (field "title" Decode.string)
        (field "year" Decode.int)
