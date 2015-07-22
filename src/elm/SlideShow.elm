module SlideShow
  ( SlideShow, Slide, init
  , Action, goto, gotoNext, gotoPrevious, gotoFirst, gotoLast
  , update, view
  ) where

import Array exposing (Array)
import Html exposing (Html)
import Html.Attributes as Html
import TypedStyles as Style exposing (px)
import String


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


{-| A slide to be shown if the index is out of bounds -}
overflowSlide : Int -> Slide
overflowSlide index =
  [ Html.text <| "Slide #" ++ (toString index) ++ " does not exist!" ]


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
  let lastIndex = (Array.length slideShow.slides) - 1
      clampIndex = clamp 0 lastIndex
      nextIndex =
        case action of
          Goto index -> clampIndex index
          GotoNext -> clampIndex (slideShow.currentIndex + 1)
          GotoPrevious -> clampIndex (slideShow.currentIndex - 1)
          GotoFirst -> 0
          GotoLast -> lastIndex
  in
    { slideShow
    | currentIndex <- nextIndex
    , currentSlide <- Array.get nextIndex slideShow.slides
    }


-- View


view : { width : Int, height : Int } -> SlideShow -> Html
view dimensions slideShow =
  Html.section
    [ Html.class "slide"
    , Html.style
        [ Style.width dimensions.width px
        , Style.height dimensions.height px
        ]
    ] <|
    case slideShow.currentSlide of
      Just slide -> slide
      Nothing -> overflowSlide slideShow.currentIndex
