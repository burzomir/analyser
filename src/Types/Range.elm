module Types.Range exposing (..)

import List exposing (drop, length, take)


type alias From =
    Int


type alias To =
    Int


type alias Range =
    ( From, To )


slice : Range -> List a -> List a
slice ( from, to ) list =
    drop from list |> take (to - from)


full : List a -> Range
full list =
    ( 0, length list )
