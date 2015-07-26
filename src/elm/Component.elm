module Component
  ( Init, Update, View
  ) where

{-| Types common to components -}

import Html exposing (Html)
import Signal exposing (Address)


{-| A function that initialises a component -}
type alias Init options state = options -> state


{-| A function that initialises a component -}
type alias Update action state = action -> state -> state


{-| A function that initialises a component -}
type alias View action state = Address action -> state -> Html
