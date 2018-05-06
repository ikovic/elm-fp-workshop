module App exposing (..)

import Http
import Html exposing (div, img, p, text, h3, fieldset, input, label)
import Html.Attributes exposing (class, src, type_, checked)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (field, list, map4, Decoder, int, string, float)


type alias Movie =
    { poster : String, rating : Float, title : String, year : Int, genre : List String }


type alias Model =
    { movies : List Movie
    , genreFilter : List String
    , error : String
    }


type Msg
    = LoadMovies (Result Http.Error (List Movie))
    | ToggleGenreFilter String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadMovies (Ok loadedMovies) ->
            ( { model | movies = loadedMovies }, Cmd.none )

        LoadMovies (Err loadError) ->
            ( { model | error = toString loadError }, Cmd.none )

        ToggleGenreFilter filterValue ->
            ( { model | genreFilter = (updateGenreFilter filterValue model.genreFilter) }, Cmd.none )


view : Model -> Html.Html Msg
view model =
    div [ class "layout" ]
        [ renderGenreFilter model.genreFilter
        , div
            [ class "cardHolder" ]
            (List.map renderCard (getFilteredMovies model.movies model.genreFilter))
        , p [] [ text model.error ]
        ]


init : ( Model, Cmd Msg )
init =
    ( { movies = [], genreFilter = [], error = "" }, getMovies )


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , update = update
        , init = init
        , subscriptions = \_ -> Sub.none
        }


updateGenreFilter : String -> List String -> List String
updateGenreFilter filterValue filters =
    if List.member filterValue filters then
        List.filter (\filter -> filter /= filterValue) filters
    else
        filterValue :: filters


genreFilterValues : List String
genreFilterValues =
    [ "Animation", "Horror", "Comedy", "Drama", "Musical", "Crime", "Thriller", "Action", "Sci-Fi", "Fantasy", "Adventure" ]


filterMovie : Movie -> List String -> Bool
filterMovie movie genreFilter =
    List.any (\genre -> List.member genre genreFilter) movie.genre


getFilteredMovies :
    List Movie
    -> List String
    -> List Movie
getFilteredMovies movies genreFilter =
    case genreFilter of
        [] ->
            movies

        _ ->
            List.filter (\movie -> filterMovie movie genreFilter) movies


renderCheckbox : String -> Bool -> Html.Html Msg
renderCheckbox name isChecked =
    label []
        [ input [ type_ "checkbox", checked isChecked, onClick (ToggleGenreFilter name) ] []
        , text name
        ]


renderGenreFilter : List String -> Html.Html Msg
renderGenreFilter genreFilter =
    div [ class "genreHolder" ]
        [ h3 [] [ text "Filter by Genre" ]
        , fieldset [ class "checkboxes" ] (List.map (\filterValue -> (renderCheckbox filterValue (List.member filterValue genreFilter))) genreFilterValues)
        ]


renderCard : Movie -> Html.Html msg
renderCard movie =
    div [ class "card" ]
        [ img [ src movie.poster ]
            []
        , div [ class "cardData" ]
            [ p [ class "title" ]
                [ text movie.title ]
            , p [ class "year" ]
                [ text (toString movie.year) ]
            , p [ class "rating" ]
                [ text (toString movie.rating) ]
            ]
        ]


getMovies : Cmd Msg
getMovies =
    Http.send LoadMovies (Http.get "http://localhost:3001/movies" movieListDecoder)


movieListDecoder : Decoder (List Movie)
movieListDecoder =
    Decode.list movieDecoder


movieDecoder : Decoder Movie
movieDecoder =
    Decode.map5 Movie
        (field "poster" Decode.string)
        (field "rating" Decode.float)
        (field "title" Decode.string)
        (field "year" Decode.int)
        (field "genre" (Decode.list Decode.string))
