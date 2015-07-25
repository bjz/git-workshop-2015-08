module SlideShow
  ( Slide, SlideShow, Options, init
  , Action, goto, next, previous, first, last, current
  , update, view
  ) where

import Array exposing (Array)
import Html exposing (Html)
import Html.Attributes as Html
import Html.Events as Html
import Html.Shorthand as Html
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


type alias Options =
  { index : Int
  , slides : Array Slide
  }


init : Options -> SlideShow
init options =
  update (goto options.index)
    { currentIndex = 0
    , currentSlide = Nothing
    , slides = options.slides
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
  | Next
  | Previous
  | First
  | Last
  | NoOp


goto : Int -> Action
goto = Goto


next : Action
next = Next


previous : Action
previous = Previous


first : Action
first = First


last : Action
last = Last


current : Action
current = NoOp


update : Action -> SlideShow -> SlideShow
update action slideShow =
  let lastIndex = (Array.length slideShow.slides) - 1
      clampIndex = clamp 0 lastIndex
      nextIndex =
        case action of
          Goto index -> clampIndex index
          Next -> clampIndex (slideShow.currentIndex + 1)
          Previous -> clampIndex (slideShow.currentIndex - 1)
          First -> 0
          Last -> lastIndex
          NoOp -> slideShow.currentIndex
  in
    { slideShow
    | currentIndex <- nextIndex
    , currentSlide <- Array.get nextIndex slideShow.slides
    }


-- View


view : Address Action -> SlideShow -> Html
view address slideShow =
  let navButton class text onClick =
        Html.li [ Html.class class ]
          [ Html.a
            [ Html.href "#", Html.onClick address onClick ]
            [ Html.text text ]
          ]

      controls =
        Html.nav
          [ Html.class "controls" ]
          [ Html.ul_
            [ navButton "previous" "Previous slide" previous
            , navButton "next" "Next slide" next
            ]
          ]

      slide =
        Html.article [ Html.class "slide" ] <|
          case slideShow.currentSlide of
            Just slide -> slide.view
            Nothing -> (overflowSlide slideShow.currentIndex).view
  in
    Html.article
      [ Html.class "slideshow" ]
      [ controls, slide ]
