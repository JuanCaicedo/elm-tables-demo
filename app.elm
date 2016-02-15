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
  List Legislator


initialModel: List Legislator
initialModel =
  [
    { firstName = "Juan"
    , lastName = "Caicedo"
    }
  , { firstName = "Carson"
    , lastName = "Banov"
    }
  ]


view: Signal.Address a -> Model -> Html
view address model =
  div
    []
    [ h1 [] [ text "Your team" ]
    , table
        []
        (List.map legislatorView model)
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
