module Slide
  ( Slide, slide
  , Node, html, node, fragment
  , renderNode, render
  , stepForward, stepBackward
  ) where

import Html exposing (Html, code, h1, text)
import Markdown

{-| A HTML slide that can be animated to update incrementally.

Not currently used

-}

-- Model

type Slide
  = Slide (List Node)

slide : List Node -> Slide
slide = Slide

{-| Animation state -}
type State
  = Pending
  | Complete

{-| A node in the slide layout -}
type Node
  = StaticHtml Html
  | StaticNode (List Html -> Html) (List Node)
  | Fragment State Html

html : Html -> Node
html = StaticHtml

node : (List Html -> Html) -> List Node -> Node
node = StaticNode

fragment : Html -> Node
fragment = Fragment Pending

-- View

renderNode : Node -> Maybe Html
renderNode node =
  case node of
    StaticHtml html        -> Just html
    StaticNode f nodes     -> Just (f (List.filterMap renderNode nodes))
    Fragment Pending _     -> Nothing
    Fragment Complete html -> Just html

render : Slide -> List Html
render (Slide nodes) =
  List.filterMap renderNode nodes

-- Update

stepForward : Slide -> Maybe Slide
stepForward (Slide nodes) =
  Nothing -- TODO

stepBackward : Slide -> Maybe Slide
stepBackward (Slide nodes) =
  Nothing -- TODO

-- Test data

testSlides : List Slide
testSlides =
  [ slide
      [ html <| h1 [] [text "Git Presentation"]
      ]
  , slide
      [ html <| h1 [] [text "A typical git workflow"]
      , node (code [])
          [ fragment <| text "$ git init my_project"
          , fragment <| text "$ cd my_project"
          , fragment <| text "$ git add ."
          , fragment <| text "$ git commit -m \"Initial commit\""
          ]
      ]
  ]
