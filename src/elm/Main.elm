import Array
import History
import Html exposing (Html)
import Html.Attributes as Html
import Html.Events as Html
import Html.Shorthand as Html
import Keyboard
import Mouse
import Signal exposing (Mailbox, Address, (<~), (~))
import String
import Task exposing (Task)
import Window

import SlideShow exposing (Slide)


-- Presentation

slides : List Slide
slides =
  [ { view =
        [ Html.h1_ "Git"
        ]
    , notes = ""
    }

  , { view =
        [ Html.p []
            [ Html.text "Most common workflow:" ]
        , Html.ol []
            [ Html.li [] [ Html.text "create" ]
            , Html.li [] [ Html.text "edit" ]
            , Html.li [] [ Html.text "save" ]
            , Html.li [] [ Html.text "goto 2" ]
            ]
        ]
    , notes = ""
    }

  , { view =
        [ Html.h2_ "Starting a git repository"
        , Html.p []
            [ Html.text "In a new directory:" ]
        , Html.code []
            [ Html.text "git init" ]
        , Html.p []
            [ Html.text "This will initialize a new repository in that directory." ]
        ]
    , notes = ""
    }
  ]

-- Model

port initialHash : String

parseHash : String -> Maybe Int
parseHash src =
  case String.uncons src of
    Just ('#', x) -> Result.toMaybe (String.toInt x)
    Just (_, x) -> Nothing
    Nothing -> Nothing

slideShow : SlideShow.State
slideShow =
  SlideShow.init
    { index = Maybe.withDefault 0 (parseHash initialHash)
    , slides = Array.fromList slides
    }

-- Update

update : Action -> SlideShow.State -> SlideShow.State
update action slideShow =
  case action of
    NoOp -> slideShow
    SlideShow action ->
      SlideShow.update action slideShow

-- View

view : Address Action -> SlideShow.State -> Html
view address slideShow =
  let slideAddress =
        Signal.forwardTo address SlideShow
  in
    SlideShow.view slideAddress slideShow

-- Input

type Action
  = SlideShow SlideShow.Action
  | NoOp

actions : Mailbox Action
actions =
  Signal.mailbox NoOp

input : Signal Action
input =
  let keyToAction key =
        case key of
          0  -> SlideShow SlideShow.next -- space
          32 -> SlideShow SlideShow.next -- space (?)
          39 -> SlideShow SlideShow.next -- right arrow
          37 -> SlideShow SlideShow.previous -- left arrow
          _  -> NoOp

      hashToAction hash =
        case parseHash hash of
          Just index -> SlideShow (SlideShow.goto index)
          Nothing -> NoOp
  in
    Signal.mergeMany
      [ actions.signal
      , hashToAction <~ Signal.dropRepeats History.hash
      , keyToAction <~ Keyboard.presses
      ]

states : Signal SlideShow.State
states =
  Signal.foldp update slideShow input

-- Output

setHash slideShow =
  History.replacePath ("#" ++ toString slideShow.currentIndex)

port runTask : Signal (Task error ())
port runTask = setHash <~ states

makeTitle slideShow =
  "Git Tutorial Presentation (slide " ++ toString slideShow.currentIndex ++ ")"

port title : Signal String
port title = makeTitle <~ states

main : Signal Html
main =
    view actions.address <~ states
