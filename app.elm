module FantasyLegislature where

import Html exposing (..)
import StartApp
import Effects exposing (Effects, Never)


type alias Model = String


initialModel = "Fantasy Legislature"


view address model =
  h1 [] [ text model ]


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
