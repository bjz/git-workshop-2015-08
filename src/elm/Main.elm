import Array
import History
import Html exposing (Html)
import Html.Shorthand as Html
import Keyboard
import Mouse
import Signal exposing ((<~), (~))
import String
import Task exposing (Task)
import Window

import SlideShow exposing (SlideShow, Slide)

-- Presentation

slides : List Slide
slides =
  [ [ Html.h1_ "Git"
    ]

  , [ Html.p []
        [ Html.text "Most common workflow:" ]
    , Html.ol []
        [ Html.li [] [ Html.text "create" ]
        , Html.li [] [ Html.text "edit" ]
        , Html.li [] [ Html.text "save" ]
        , Html.li [] [ Html.text "goto 2" ]
        ]
    ]

  , [ Html.h2_ "Starting a git repository"
    , Html.p []
        [ Html.text "In a new directory:" ]
    , Html.code []
        [ Html.text "git init" ]
    , Html.p []
        [ Html.text "This will initialize a new repository in that directory." ]
    ]
  ]

-- Model

port initialHash : String

parseHash : String -> Maybe Int
parseHash src =
  case String.uncons src of
    Just ('#', x) -> Result.toMaybe (String.toInt x)
    Just (_, x) -> Nothing
    Nothing -> Nothing

slideShow : SlideShow
slideShow =
  SlideShow.init
    (slides |> Array.fromList)
    (parseHash initialHash |> Maybe.withDefault 0)

-- Update

update : Action -> SlideShow -> SlideShow
update action slideShow =
  case action of
    NoOp -> slideShow
    Navigate action ->
      SlideShow.update action slideShow

-- View

view : (Int, Int) -> SlideShow -> Html
view (w, h) =
  SlideShow.view { width = w, height = h }

-- Input

type Action
  = NoOp
  | Navigate SlideShow.Action

input : Signal Action
input =
  let keysToAction keys =
        if | keys.x > 0 -> Navigate SlideShow.gotoNext
           | keys.x < 0 -> Navigate SlideShow.gotoPrevious
           | otherwise  -> NoOp

      clicksToAction () =
        Navigate SlideShow.gotoNext

      hashToAction hash =
        case parseHash hash of
          Just index -> Navigate (SlideShow.goto index)
          Nothing -> NoOp
  in
    Signal.mergeMany
      [ hashToAction <~ Signal.dropRepeats History.hash
      , clicksToAction <~ Mouse.clicks
      , keysToAction <~ Keyboard.arrows
      ]

slideShows : Signal SlideShow
slideShows =
  Signal.foldp update slideShow input

-- Output

setHash slideShow =
  History.replacePath ("#" ++ toString slideShow.currentIndex)

port runTask : Signal (Task error ())
port runTask = setHash <~ slideShows

makeTitle slideShow =
  "Git Tutorial Presentation (slide " ++ toString slideShow.currentIndex ++ ")"

port title : Signal String
port title = makeTitle <~ slideShows

main : Signal Html
main = view <~ Window.dimensions ~ slideShows
