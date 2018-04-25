module App exposing (..)

import Html exposing (div, img, p, text)
import Html.Attributes exposing (class, src)


type alias Movie =
    { poster : String, rating : Float, title : String, year : Int }


logan : Movie
logan =
    { title = "Logan"
    , year = 2017
    , rating = 8.1
    , poster = "https://images-na.ssl-images-amazon.com/images/M/MV5BMjI1MjkzMjczMV5BMl5BanBnXkFtZTgwNDk4NjYyMTI@._V1_SX300.jpg"
    }


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


main : Html.Html msg
main =
    div [ class "main" ]
        [ renderCard logan
        ]
