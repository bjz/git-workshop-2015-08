module Slide
  ( Group, Node
  , item, group, appear
  , renderNode, render
  , stepForward, stepBackward
  ) where

import Html exposing (Html)
import Markdown

{-| A slide that can be animated to update incrementally.

Not currently used

-}

-- Model

type alias Group = List Node

{-| Animation state -}
type State
  = Pending
  | Complete

{-| A node in the slide layout -}
type Node
  = ItemNode Html
  | GroupNode (List Html -> Html) (Group)
  | Animation State Node

item : Html -> Node
item = ItemNode

group : (List Html -> Html) -> Group -> Node
group = GroupNode

appear : Node -> Node
appear = Animation Pending

-- View

renderNode : Node -> Maybe Html
renderNode node =
  case node of
    ItemNode x               -> Just x
    GroupNode f nodes        -> Just (f (List.filterMap renderNode nodes))
    Animation Pending _      -> Nothing
    Animation Complete node  -> renderNode node

render : Group -> List Html
render nodes =
  List.filterMap renderNode nodes

-- Update

{-| Steps the animation forward once, returning Nothing if there is no more
animation to be done -}
stepForward : Group -> Maybe Group
stepForward nodes =
  let stepCons node rest =
        Maybe.map (\rest -> node :: rest)
                  (stepForward rest)
  in
    case nodes of
      ItemNode x              :: rest  -> stepCons (ItemNode x) rest
      GroupNode f nodes       :: rest  -> stepCons (GroupNode f nodes) rest
      Animation Complete node :: rest  -> stepCons (Animation Complete node) rest
      Animation Pending node  :: rest  -> Just (Animation Complete node :: rest)
      []                               -> Nothing

{-| Steps the animation backward once, returning Nothing if there is no more
animation to be undone -}
stepBackward : Group -> Maybe Group
stepBackward nodes =
  let stepBackward' nodes acc = Nothing
  in
    -- TODO
    stepBackward' nodes []

-- Test data

testSlides : List Group
testSlides =
  [ [ item <| Html.h1 [] [ Html.text "Git Presentation" ]
    ]
  , [ item <| Html.h1 [] [ Html.text "A typical git workflow" ]
    , group (Html.code [])
        [ item >> appear <| Html.text "$ git init my_project"
        , item >> appear <| Html.text "$ cd my_project"
        , item >> appear <| Html.text "$ git add ."
        , item >> appear <| Html.text "$ git commit -m \"Initial commit\""
        ]
    ]
  ]
