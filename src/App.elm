module App exposing (..)

import Html exposing (div, text)
import Html.Attributes exposing (class)

main : Html.Html msg
main =
    div [class "hello-world"] [text "Hello World"]
