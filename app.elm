module FantasyLegislature where

import Html exposing (..)
import StartApp
import Effects exposing (Effects, Never)

type alias Model =
  { firstName: String
  , lastName: String
  }

initialModel: Model
initialModel =
  { firstName = "Juan"
  , lastName = "Caicedo"
  }


view: Signal.Address a -> Model -> Html
view address model =
  div
    []
    [ h1 [] [ text "Your team" ]
    , table
        []
        [ tr
            []
            [ td [] [ text model.firstName ]
            , td [] [ text model.lastName ]
            ]
        ]
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
