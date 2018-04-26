module App exposing (..)

import Html exposing (div, img, p, text)
import Html.Attributes exposing (class, src)


type alias Movie =
    { poster : String, rating : Float, title : String, year : Int }


type alias Model =
    { movies : List Movie
    }


initialModel : { movies : List Movie }
initialModel =
    { movies =
        [ { title = "Logan"
          , year = 2017
          , rating = 8.1
          , poster = "https://images-na.ssl-images-amazon.com/images/M/MV5BMjI1MjkzMjczMV5BMl5BanBnXkFtZTgwNDk4NjYyMTI@._V1_SX300.jpg"
          }
        , { title = "The Green Mile"
          , year = 1999
          , rating = 8.5
          , poster = "https://images-na.ssl-images-amazon.com/images/M/MV5BMTUxMzQyNjA5MF5BMl5BanBnXkFtZTYwOTU2NTY3._V1_SX300.jpg"
          }
        ]
    }


view : Model -> Html.Html msg
view model =
    div [ class "cardHolder" ] (List.map renderCard model.movies)


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


update : a -> b -> b
update msg model =
    model


main : Program Never { movies : List Movie } msg
main =
    Html.beginnerProgram
        { view = view
        , update = update
        , model = initialModel
        }
