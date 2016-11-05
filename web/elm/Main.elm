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
