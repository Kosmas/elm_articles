module Main exposing (..)

import Html exposing (text, Html, div)
import Html.Attributes exposing (class)

import Components.ArticleList as ArticleList

main : Html a
main =
  div [ class "elm-app" ] [ ArticleList.view ]
