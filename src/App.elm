module App exposing (..)

import Html exposing (div, img, p, text)
import Html.Attributes exposing (class, src)


main : Html.Html msg
main =
    div [ class "main" ]
        [ div [ class "card" ]
            [ img [ src "http://filmmakerseo.com/imdb/imdb11.jpg" ]
                []
            , div [ class "card-data" ]
                [ p [ class "title" ]
                    [ text "Some Movie Title" ]
                , p [ class "year" ]
                    [ text "2018" ]
                , p [ class "rating" ]
                    [ text "7" ]
                ]
            ]
        ]
