module Git
    ( User, Commit, Refs, Repository, Sha1
    ) where

{-| A completely overkill git repository diagramming thing
-}

import Color
import Debug
import Dict exposing (Dict)
import Text

import Diagrams.Core as DCore
import Diagrams.FillStroke as DFill
import Diagrams.Pad as DPad

-- Model

type alias Sha1 = String

type alias User =
  { name : String
  , email : String
  }

type alias Commit =
  { author : User
  , date : String
  , message : String
  , parents : List Sha1
  }

type alias Refs =
  { heads : Dict String Sha1
  , remotes : Dict String (Dict String Sha1)
  , tags : Dict String Sha1
  }

type alias Repository =
  { commits : Dict Sha1 Commit
  , head : String
  , refs : Refs
  }

-- Styles

baseText : Text.Style
baseText =
  { typeface = []
  , height = Nothing
  , color = Color.black
  , bold = False
  , italic = False
  , line = Nothing
  }

commitText : Text.Style
commitText =
  { baseText | height <- Just 11 }

-- View

commitNode : Sha1 -> DCore.Diagram t a
commitNode sha1 =
  let fill = DFill.justSolidFill Color.grey
  in
    DCore.text sha1 commitText
      |> DPad.pad 5
      |> DPad.background fill

commitGraph : Repository -> DCore.Diagram t a
commitGraph _ = Debug.crash ""

-- Test Data

alexia  = { name = "Alexia"  , email = "alexia@example.com"  }
brendan = { name = "Brendan" , email = "brendan@example.com" }
di      = { name = "Di"      , email = "di@example.com"      }


{-

[0]
 |
[1]
 | \
[2] [4]
 |   |
[3] [5]
 | /
[6]
 |
[7]

-}

commit00 =
  ( "4bb0b8b"
  , { author = brendan
    , date = "2015-07-10"
    , message = "Initial commit"
    , parents = []
    }
  )
commit01 =
  ( "6892e49"
  , { author = brendan
    , date = "2015-07-10"
    , message = "Fix spelling"
    , parents = [ fst commit00 ]
    }
  )
commit02 =
  ( "39d5e68"
  , { author = di
    , date = "2015-07-11"
    , message = "Add logo"
    , parents = [ fst commit01 ]
    }
  )
commit03 =
  ( "13e4597"
  , { author = brendan
    , date = "2015-07-11"
    , message = "Fix formatting"
    , parents = [ fst commit02 ]
    }
  )
commit04 =
  ( "9f3d219"
  , { author = alexia
    , date = "2015-07-11"
    , message = "Implement feature"
    , parents = [ fst commit01 ]
    }
  )
commit05 =
  ( "3679ed4"
  , { author = alexia
    , date = "2015-07-11"
    , message = "Add Tutorial"
    , parents = [ fst commit04 ]
    }
  )
commit06 =
  ( "536f3a2"
  , { author = brendan
    , date = "2015-07-12"
    , message = "Merge alexiasfeature into master"
    , parents = [ fst commit04, fst commit03 ]
    }
  )
commit07 =
  ( "d0bc722"
  , { author = alexia
    , date = "2015-07-12"
    , message = "Fix Grammar"
    , parents = [ fst commit06 ]
    }
  )

repo =
  { commits = Dict.fromList
      [ commit00
      , commit01
      , commit02
      , commit03
      , commit04
      , commit05
      , commit06
      , commit07
      ]
  , head = fst commit07
  , refs =
    { heads = Dict.fromList
        [ ("master", fst commit07)
        , ("alexiasfeature", fst commit05)
        ]
    , remotes = Dict.fromList []
    , tags = Dict.fromList []
    }
  }