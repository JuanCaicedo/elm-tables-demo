module FantasyLegislature where

import Html exposing (..)
import StartApp
import Effects exposing (Effects, Never)
import List


type alias Legislator =
  { firstName: String
  , lastName: String
  }


type alias Model =
  { selectedLegislators: List Legislator
  , availableLegislators: List Legislator
  }


initialModel: Model
initialModel =
  { selectedLegislators = [
      { firstName = "Juan"
      , lastName = "Caicedo"
      }
    , { firstName = "Carson"
      , lastName = "Banov"
      }
    ]
  , availableLegislators = [
      { firstName = "Senator"
      , lastName = "1"
      }
    , { firstName = "Senator"
      , lastName = "2"
      }
    ]
  }


view: Signal.Address a -> Model -> Html
view address model =
  table
    []
    [ legislatorTable "Your team" model.selectedLegislators
    , legislatorTable "Available" model.availableLegislators
    ]


legislatorTable tableTitle legislators =
  div
    []
    [ h1 [] [ text tableTitle ]
    , table
        []
        (List.map legislatorView legislators)
    ]


legislatorView: Legislator -> Html
legislatorView legislator =
  tr
    []
    [ td [] [ text legislator.firstName ]
    , td [] [ text legislator.lastName ]
    ]


update action model =
  (model, Effects.none)


app =
  StartApp.start
    { init = (initialModel, Effects.none)
    , update = update
    , view = view
    , inputs = []
    }


main =
  app.html
