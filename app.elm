module FantasyLegislature where

import Html exposing (..)
import Html.Events exposing (..)
import Http
import Task
import StartApp
import Effects exposing (Effects, Never)
import List
import Json.Decode as Json exposing ((:=))


type Action
  = Toggle Choice Legislator
  | PopulateAvailableLegislators (Result Http.Error (List Legislator))


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
      , lastName = "one"
      }
    , { firstName = "Senator"
      , lastName = "two"
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
    PopulateAvailableLegislators result ->
      case result of
        Ok legislators ->
          ({ model
             | availableLegislators = legislators
           }
          , Effects.none)
        Err error ->
          (model, Effects.none)


legislatorDecoder : Json.Decoder (List Legislator)
legislatorDecoder =
  let
    result =
      Json.object2 Legislator
        ("first_name" := Json.string)
        ("last_name" := Json.string)
  in
    "results" := Json.list result


legislatorsUrl =
  Http.url "https:congress.api.sunlightfoundation.com/legislators"
    [ ("apikey", "d6ef0d61cbd241bc9d89109e4f70e128")
    , ("per_page", "all")
    ]


getLegislators : Effects Action
getLegislators =
  Http.get legislatorDecoder legislatorsUrl
    |> Task.toResult
    |> Task.map PopulateAvailableLegislators
    |> Effects.task


app =
  StartApp.start
    { init = (initialModel, getLegislators)
    , update = update
    , view = view
    , inputs = []
    }


main =
  app.html


port runner : Signal (Task.Task Never())
port runner =
  app.tasks
