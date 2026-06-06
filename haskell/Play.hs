module Play (run) where

import Control.DeepSeq (force)
import Control.Exception (evaluate)
import Control.Monad (unless)
import Data.Maybe (isJust)
import Data.Word (Word32)
import GHC.Clock (getMonotonicTimeNSec)
import System.Environment (lookupEnv)
import Text.Printf (printf)
import World (World)
import qualified World

worldWidth :: Word32
worldWidth = 150

worldHeight :: Word32
worldHeight = 40

run :: IO ()
run = do
  world <- World.new worldWidth worldHeight

  minimal <- isJust <$> lookupEnv "MINIMAL"

  unless minimal $
    putStrLn (World.render world)

  loop world minimal 0 (1 / 0) 0 (1 / 0)

loop :: World -> Bool -> Double -> Double -> Double -> Double -> IO ()
loop world minimal totalTick lowestTick totalRender lowestRender = do
  tickStart <- getMonotonicTimeNSec
  newWorld <- evaluate (World.doTick world)
  tickFinish <- getMonotonicTimeNSec
  let tickTime = fromIntegral (tickFinish - tickStart)
  let newTotalTick = totalTick + tickTime
  let newLowestTick = min lowestTick tickTime
  let avgTick = newTotalTick / fromIntegral (World.tick newWorld)

  renderStart <- getMonotonicTimeNSec
  rendered <- evaluate (force (World.render newWorld))
  renderFinish <- getMonotonicTimeNSec
  let renderTime = fromIntegral (renderFinish - renderStart)
  let newTotalRender = totalRender + renderTime
  let newLowestRender = min lowestRender renderTime
  let avgRender = newTotalRender / fromIntegral (World.tick newWorld)

  unless minimal $
    putStr "\ESC[H\ESC[2J"

  printf "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n"
    (World.tick newWorld)
    (_f newLowestTick)
    (_f avgTick)
    (_f newLowestRender)
    (_f avgRender)

  unless minimal $
    putStrLn rendered

  loop newWorld minimal newTotalTick newLowestTick newTotalRender newLowestRender

_f :: Double -> Double
_f value =
  -- nanoseconds -> milliseconds
  value / 1_000_000
