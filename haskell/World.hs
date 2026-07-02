module World (World, tick, new, doTick, render) where

import Cell (Cell(..))
import qualified Cell
import Control.DeepSeq (force)
import Control.Exception (Exception, throwIO)
import Control.Monad (foldM)
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map
import Data.Word (Word32)
import System.Random (randomIO)

data LocationOccupied = LocationOccupied Word32 Word32 deriving (Show)
instance Exception LocationOccupied

data World = World
  { tick :: !Word32
  , width :: !Word32
  , height :: !Word32
  , cells :: !(Map String Cell)
  } deriving (Show)

directions :: [(Int, Int)]
directions =
  [ (-1, 1),  (0, 1),  (1, 1),  -- above
    (-1, 0),           (1, 0),  -- sides
    (-1, -1), (0, -1), (1, -1)  -- below
  ]

new :: Word32 -> Word32 -> IO World
new width height = do
  let world = World
        { tick = 0
        , width = width
        , height = height
        , cells = Map.empty
        }

  populated <- populateCells world
  -- $! builds the world now, so the work isn't deferred into the first doTick
  return $! prepopulateNeighbours populated

doTick :: World -> World
doTick world =
  let newCells = Map.map
        (\cell ->
          let aliveNeighbours = Cell.aliveNeighbours cell (cells world)
          in if not (alive cell) && aliveNeighbours == 3
               then cell { alive = True }
               else if aliveNeighbours < 2 || aliveNeighbours > 3
                 then cell { alive = False }
                 else cell)
        (cells world)
  in world { tick = tick world + 1, cells = newCells }

render :: World -> String
render world =
  -- The following is slower
  -- foldl
  --   (\rendering y ->
  --     foldl
  --       (\line x -> case cellAt world x y of
  --         Just cell -> line ++ [Cell.toChar cell]
  --         Nothing -> line)
  --       rendering
  --       [0 .. width world - 1]
  --     ++ "\n")
  --   ""
  --   [0 .. height world - 1]

  -- The following is the fastest
  concat
    [ [ Cell.toChar cell
      | x <- [0 .. width world - 1]
      , Just cell <- [cellAt world x y]
      ] ++ "\n"
    | y <- [0 .. height world - 1]
    ]

makeKey :: Int -> Int -> String
makeKey x y =
  -- The following is slower
  -- show x ++ "-" ++ show y

  -- The following is slower
  -- concat [show x, "-", show y]

  -- The following is the fastest
  shows x ('-' : shows y "")

cellAt :: World -> Word32 -> Word32 -> Maybe Cell
cellAt world x y =
  let key = makeKey (fromIntegral x) (fromIntegral y)
  in Map.lookup key (cells world)

populateCells :: World -> IO World
populateCells world =
  foldM
    (\yWorld y ->
      foldM
        (\xWorld x -> do
          rand <- randomIO :: IO Double
          let alive = (rand <= 0.2)
          (newWorld, _) <- addCell xWorld x y alive
          return newWorld)
        yWorld
        [0 .. width world - 1])
    world
    [0 .. height world - 1]

addCell :: World -> Word32 -> Word32 -> Bool -> IO (World, Bool)
addCell world x y alive = do
  let existing = cellAt world x y
  case existing of
    Just _ -> throwIO (LocationOccupied x y)
    Nothing -> return ()

  let key = makeKey (fromIntegral x) (fromIntegral y)
  let cell = Cell.new x y alive
  let newWorld = world { cells = Map.insert key cell (cells world) }
  return (newWorld, True)

prepopulateNeighbours :: World -> World
prepopulateNeighbours world =
  let newCells = Map.map
        (\cell ->
          let neighbours =
                [ key
                | (relX, relY) <- directions
                , let nx = fromIntegral (x cell) + relX
                , let ny = fromIntegral (y cell) + relY
                , not (nx < 0 || ny < 0)
                , not (nx >= fromIntegral (width world) || ny >= fromIntegral (height world))
                , let key = makeKey nx ny
                , Map.member key (cells world)
                ]
          -- force builds the keys now, so they aren't deferred into the first doTick
          in cell { neighbours = force neighbours })
        (cells world)
  in world { cells = newCells }
