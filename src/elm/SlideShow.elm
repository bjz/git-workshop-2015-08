module SlideShow
  ( Model, Slide, init
  , Action, goto, gotoNext, gotoPrevious, gotoFirst, gotoLast
  , update, view
  ) where

import Array exposing (Array)
import Html exposing (Html)
import Html.Attributes as Html
import String

import Slide


-- Model


type alias Slide = List Html


type alias Model =
  { currentIndex : Int
  , currentSlide : Maybe Slide
  , slides : Array Slide
  }


init : Array Slide -> Int -> Model
init slides index =
  update (goto index)
    { currentIndex = 0
    , currentSlide = Nothing
    , slides = slides
    }


lastIndex : Model -> Int
lastIndex slideShow =
  (Array.length slideShow.slides) - 1


-- Update


type Action
  = Goto Int
  | GotoNext
  | GotoPrevious
  | GotoFirst
  | GotoLast


goto : Int -> Action
goto = Goto


gotoNext : Action
gotoNext = GotoNext


gotoPrevious : Action
gotoPrevious = GotoPrevious


gotoFirst : Action
gotoFirst = GotoFirst


gotoLast : Action
gotoLast = GotoLast


update : Action -> Model -> Model
update action slideShow =
  let goto' = clamp 0 (lastIndex slideShow)
      nextIndex =
        case action of
          Goto index -> goto' index
          GotoNext -> goto' (slideShow.currentIndex + 1)
          GotoPrevious -> goto' (slideShow.currentIndex - 1)
          GotoFirst -> 0
          GotoLast -> lastIndex slideShow
  in
    { slideShow
    | currentIndex <- nextIndex
    , currentSlide <- Array.get nextIndex slideShow.slides
    }


-- View


view : Model -> Html
view slideShow =
  Html.section
    [ Html.class "slide" ]
    <| case slideShow.currentSlide of
      Just slide -> slide
      Nothing ->
        [ Html.text <| "Slide #" ++ (toString slideShow.currentIndex) ++ " does not exist!" ]
