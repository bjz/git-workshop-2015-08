module SlideShow
  ( SlideShow, Slide, init
  , Action, goto, gotoNext, gotoPrevious, gotoFirst, gotoLast
  , update, view
  ) where

import Array exposing (Array)
import Html exposing (Html)
import Html.Attributes as Html
import String

import Slide


-- SlideShow


type alias Slide = List Html


type alias SlideShow =
  { currentIndex : Int
  , currentSlide : Maybe Slide
  , slides : Array Slide
  }


init : Array Slide -> Int -> SlideShow
init slides index =
  update (goto index)
    { currentIndex = 0
    , currentSlide = Nothing
    , slides = slides
    }


lastIndex : SlideShow -> Int
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


update : Action -> SlideShow -> SlideShow
update action slideShow =
  let clampIndex = clamp 0 (lastIndex slideShow)
      nextIndex =
        case action of
          Goto index -> clampIndex index
          GotoNext -> clampIndex (slideShow.currentIndex + 1)
          GotoPrevious -> clampIndex (slideShow.currentIndex - 1)
          GotoFirst -> 0
          GotoLast -> lastIndex slideShow
  in
    { slideShow
    | currentIndex <- nextIndex
    , currentSlide <- Array.get nextIndex slideShow.slides
    }


-- View


view : SlideShow -> Html
view slideShow =
  Html.section [ Html.class "slide" ] <|
    case slideShow.currentSlide of
      Just slide -> slide
      Nothing -> [ Html.text <| "Slide #" ++ (toString slideShow.currentIndex) ++ " does not exist!" ]
