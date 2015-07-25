module SlideShow
  ( SlideShow, Slide, init
  , Action, goto, gotoNext, gotoPrevious, gotoFirst, gotoLast, gotoCurrent
  , update, view
  ) where

import Array exposing (Array)
import Html exposing (Html)
import Html.Attributes as Html
import Html.Events as Html
import Signal exposing (Address)
import String


-- SlideShow


type alias Slide =
  { view: List Html
  , notes: String
  }


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


{-| A slide to be shown if the index is out of bounds -}
overflowSlide : Int -> Slide
overflowSlide index =
  { view = [ Html.text <| "Slide #" ++ toString index ++ " does not exist!" ]
  , notes = ""
  }


-- Update


type Action
  = Goto Int
  | GotoNext
  | GotoPrevious
  | GotoFirst
  | GotoLast
  | NoOp


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


gotoCurrent : Action
gotoCurrent = NoOp


update : Action -> SlideShow -> SlideShow
update action slideShow =
  let lastIndex = (Array.length slideShow.slides) - 1
      clampIndex = clamp 0 lastIndex
      nextIndex =
        case action of
          Goto index -> clampIndex index
          GotoNext -> clampIndex (slideShow.currentIndex + 1)
          GotoPrevious -> clampIndex (slideShow.currentIndex - 1)
          GotoFirst -> 0
          GotoLast -> lastIndex
          NoOp -> slideShow.currentIndex
  in
    { slideShow
    | currentIndex <- nextIndex
    , currentSlide <- Array.get nextIndex slideShow.slides
    }


-- View

prevButton address =
  Html.a
    [ Html.href "#"
    , Html.onClick address gotoPrevious
    ]
    [ Html.text "prev"
    ]

nextButton address =
  Html.a
    [ Html.href "#"
    , Html.onClick address gotoNext
    ]
    [ Html.text "next"
    ]


view : Address Action -> SlideShow -> Html
view address slideShow =
  Html.section [ Html.class "slideshow" ]
    [ Html.nav
      [ Html.class "controls" ]
      [ prevButton address
      , Html.text " "
      , nextButton address
      ]
    , Html.section [ Html.class "slide" ] <|
        case slideShow.currentSlide of
          Just slide -> slide.view
          Nothing -> (overflowSlide slideShow.currentIndex).view
    ]
