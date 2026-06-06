module Cell (Cell(..), new, toChar, aliveNeighbours) where

-- import Data.List (foldl') -- used by the slower aliveNeighbours variant
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map
-- import qualified Data.Set as Set -- used by the slower aliveNeighbours variant
import Data.Word (Word32)

data Cell = Cell
  { x :: !Word32
  , y :: !Word32
  , alive :: !Bool
  , neighbours :: ![String]
  } deriving (Show)

new :: Word32 -> Word32 -> Bool -> Cell
new x y alive =
  Cell
    { x = x
    , y = y
    , alive = alive
    , neighbours = []
    }

toChar :: Cell -> Char
toChar cell = if alive cell then 'o' else ' '

aliveNeighbours :: Cell -> Map String Cell -> Word32
aliveNeighbours cell cells =
  -- The following is slower
  -- fromIntegral (length (filter alive (Map.elems (Map.restrictKeys cells (Set.fromList (neighbours cell))))))

  -- The following is slower
  -- foldl'
  --   (\count key -> case Map.lookup key cells of
  --     Just neighbour | alive neighbour -> count + 1
  --     _ -> count)
  --   0
  --   (neighbours cell)

  -- The following is the fastest
  fromIntegral (length [ neighbour | key <- neighbours cell, Just neighbour <- [Map.lookup key cells], alive neighbour ])
