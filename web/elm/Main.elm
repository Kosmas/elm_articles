module Main exposing (..)

import Html exposing (text, Html, div)
import Html.Attributes exposing (class)
import Html.App

import Components.ArticleList as ArticleList

-- MODEL

type alias Model =
  { articleListModel : ArticleList.Model }

initialModel : Model
initialModel =
  { articleListModel = ArticleList.initialModel }

init : (Model, Cmd Msg)
init =
  ( initialModel, Cmd.none )

-- UPDATE

type Msg
  = NoOp
  | Fetch
  | FetchSucceed ( List Article.Model)
  | FetchFail Http.Error

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    Fetch ->
      (model, fetchArticles)
    FetchSucceed articleList ->
      (Model articleList, Cmd.none)
    FetchFail error ->
      case error of
        Http.UnexpectedPayload errorMessage ->
          Debug.log errorMessage
          (model, Cmd.none)
        _ ->
          (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW

view : Model -> Html Msg
view model =
  div [ class "elm-app" ]
    [ Html.App.map ArticleListMsg (ArticleList.view model.articleListModel) ]

-- MAIN

main : Program Never
main =
  Html.App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- HTTP calls
fetchArticles : Cmd Msg
fetchArticles =
  let
    url = "/api/articles"
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeArticleFetch url)

-- Fetch the articles out of the "data" key
decodeArticleFetch : Json.Decoder (List Article.Model)
decodeArticleFetch =
  Json.at ["data"] decodeArticleList

-- Then decode the "data" key into a List of Article.Models
decodeArticleList : Json.Decoder (List Article.Model)
decodeArticleList =
  Json.list decodeArticleData

-- Finally, build the decoder for each individual Article.Model
decodeArticleData : Json.Decoder Article.Model
decodeArticleData =
  Json.object4 Article.Model
    ("title" := Json.string)
    ("url" := Json.string)
    ("posted_by" := Json.string)
    ("posted_on" := Json.string)
