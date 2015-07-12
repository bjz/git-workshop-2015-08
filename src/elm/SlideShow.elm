module SlideShow
  ( Slides, SlideShow, new, toHtml
  , Update, gotoIndex, gotoNext, gotoPrevious, gotoFirst, gotoLast
  ) where

import Array exposing (Array)
import Html exposing (Html)
import String

import Slide

-- SlideShow

type alias Slides = Array Html

type alias SlideShow =
  { currentIndex : Int
  , slides : Slides
  }

getCurrent : SlideShow -> Maybe Html
getCurrent slideShow =
  Array.get slideShow.currentIndex slideShow.slides

lastIndex : SlideShow -> Int
lastIndex slideShow =
  (Array.length slideShow.slides) - 1

new : Slides -> Int -> SlideShow
new slides index =
  { currentIndex = index
  , slides = slides
  }

toHtml : SlideShow -> Html
toHtml slideShow =
  case getCurrent slideShow of
    Just slide -> slide
    Nothing -> Html.text <|
      "Error: slideShow.currentIndex = " ++ (toString slideShow.currentIndex) ++ " does not exist!"

-- Navigation

type alias Update = SlideShow -> SlideShow

gotoIndex : Int -> Update
gotoIndex index slideShow =
  { slideShow | currentIndex <- clamp 0 (lastIndex slideShow) index }

gotoNext : Update
gotoNext slideShow =
  gotoIndex (slideShow.currentIndex + 1) slideShow

gotoPrevious : Update
gotoPrevious slideShow =
  gotoIndex (slideShow.currentIndex - 1) slideShow

gotoFirst : Update
gotoFirst slideShow =
  { slideShow | currentIndex <- 0 }

gotoLast : Update
gotoLast slideShow =
  { slideShow | currentIndex <- lastIndex slideShow }
