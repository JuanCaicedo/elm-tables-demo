module FantasyLegislature where

import Html exposing (..)
import Html.Events exposing (..)
import StartApp
import Effects exposing (Effects, Never)
import List


type Action
  = Toggle Choice Legislator


type Choice
  = Select
  | Drop


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


view: Signal.Address Action -> Model -> Html
view address model =
  table
    []
    [ legislatorTable address Drop "Your team" model.selectedLegislators
    , legislatorTable address Select "Available" model.availableLegislators
    ]


legislatorTable: Signal.Address Action -> Choice -> String -> List Legislator -> Html
legislatorTable address choice tableTitle legislators =
  div
    []
    [ h1 [] [ text tableTitle ]
    , table
        []
        (List.map (legislatorView address choice) legislators)
    ]


legislatorView: Signal.Address Action -> Choice -> Legislator -> Html
legislatorView address choice legislator =
  tr
    [ onClick address (Toggle choice legislator) ]
    [ td [] [ text legislator.firstName ]
    , td [] [ text legislator.lastName ]
    ]


update action model =
  case action of
    Toggle choice legislator ->
      let
        legislatorFilter currentLegislator =
          not (currentLegislator.firstName == legislator.firstName &&  currentLegislator.lastName == legislator.lastName )
      in
        case choice of
         Drop ->
           ({ model
              | availableLegislators = legislator :: model.availableLegislators
              , selectedLegislators = (List.filter legislatorFilter model.selectedLegislators)
              }
           , Effects.none)
         Select ->
           ({ model
              | selectedLegislators = legislator :: model.selectedLegislators
              , availableLegislators = (List.filter legislatorFilter model.availableLegislators)
              }
           , Effects.none)


app =
  StartApp.start
    { init = (initialModel, Effects.none)
    , update = update
    , view = view
    , inputs = []
    }


main =
  app.html
