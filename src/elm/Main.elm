import Array
import History
import Html exposing (Html)
import Html.Shorthand as Html
import Keyboard
import Signal exposing ((<~))
import String
import Task exposing (Task)

import SlideShow

-- Presentation

slides : List Html
slides =
  [ Html.section []
      [ Html.h1_ "Git"
      ]

  , Html.section []
      [ Html.p []
          [ Html.text "Most common workflow:" ]
      , Html.ol []
          [ Html.li [] [ Html.text "create" ]
          , Html.li [] [ Html.text "edit" ]
          , Html.li [] [ Html.text "save" ]
          , Html.li [] [ Html.text "goto 2" ]
          ]
      ]

  , Html.section []
      [ Html.h2_ "Starting a git repository"
      , Html.p []
          [ Html.text "In a new directory:" ]
      , Html.code []
          [ Html.text "git init" ]
      , Html.p []
          [ Html.text "This will initialize a new repository in that directory." ]
      ]
  ]

-- Model

type alias Model = SlideShow.Model

port initialHash : String

parseHash : String -> Maybe Int
parseHash src =
  case String.uncons src of
    Just ('#', x) -> Result.toMaybe (String.toInt x)
    Just (_, x) -> Nothing
    Nothing -> Nothing

slideShow : Model
slideShow =
  SlideShow.init
    (slides |> Array.fromList)
    (parseHash initialHash |> Maybe.withDefault 0)

-- Update

update : Action -> Model -> Model
update action slideShow =
  case action of
    NoOp -> slideShow
    Navigate action ->
      SlideShow.update action slideShow

-- View

view : Model -> Html
view = SlideShow.view

-- Input

type Action
  = NoOp
  | Navigate SlideShow.Action

keysToAction : { x : Int, y : Int } -> Action
keysToAction keys =
  if | keys.x > 0 -> Navigate SlideShow.gotoNext
     | keys.x < 0 -> Navigate SlideShow.gotoPrevious
     | otherwise  -> NoOp

hashToAction : String -> Action
hashToAction hash =
  case parseHash hash of
    Just index -> Navigate (SlideShow.gotoIndex index)
    Nothing    -> NoOp

input : Signal Action
input =
    Signal.mergeMany
      [ hashToAction <~ Signal.dropRepeats History.hash
      , keysToAction <~ Keyboard.arrows
      ]

slideShows : Signal Model
slideShows =
  Signal.foldp update slideShow input |> Signal.dropRepeats

-- Output

setHash slideShow =
  History.setPath ("#" ++ toString slideShow.currentIndex)

port runTask : Signal (Task error ())
port runTask = setHash <~ slideShows

makeTitle slideShow =
  "Git Tutorial Presentation (slide " ++ toString slideShow.currentIndex ++ ")"

port title : Signal String
port title = makeTitle <~ slideShows

main : Signal Html
main = view <~ slideShows
