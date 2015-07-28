module SlideShow
  ( Slide, State, Options, init
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

import Component


-- SlideShow


type alias Slide =
  { view: List Html
  , notes: String
  }


type alias State =
  { currentIndex : Int
  , currentSlide : Maybe Slide
  , slides : Array Slide
  }


type alias Options =
  { index : Int
  , slides : Array Slide
  }


init : Component.Init Options State
init options =
  update (goto options.index)
    { currentIndex = 0
    , currentSlide = Nothing
    , slides = options.slides
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


update : Component.Update Action State
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


viewControls : Component.View Action State
viewControls address slideShow =
  let navButton class text onClick =
        Html.li
          [ Html.class class ]
          [ Html.a
            [ Html.href "#", Html.onClick address onClick ]
            [ Html.text text ]
          ]
  in
    Html.nav
      [ Html.class "controls" ]
      [ Html.ul_
        [ navButton "previous" "Previous slide" previous
        , navButton "next" "Next slide" next
        ]
      ]


viewSlide : Component.View Action Slide
viewSlide address slide =
  Html.section [ Html.class "slide" ] slide.view


-- viewClock : Component.View


view : Component.View Action State
view address slideShow =
  let slide = slideShow.currentSlide
        |> Maybe.withDefault { view = [], notes = "" }
  in
    Html.article
      [ Html.class "slideshow" ]
      [ viewControls address slideShow
      , viewSlide address slide
      ]
