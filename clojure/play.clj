(ns play
  (:require [world :as w]))

(def WORLD_WIDTH 150)
(def WORLD_HEIGHT 40)

(defn _f [value]
  ;; nanoseconds -> milliseconds
  (/ value 1000000.0))

(defn run []
  (let [world (w/new-world WORLD_WIDTH WORLD_HEIGHT)
        minimal (some? (System/getenv "MINIMAL"))]

    (when-not minimal
      (println (w/render world)))

    (loop [world world
           total-tick 0
           lowest-tick Double/POSITIVE_INFINITY
           total-render 0
           lowest-render Double/POSITIVE_INFINITY]

      (let [tick-start (System/nanoTime)
            world (w/tick world)
            tick-finish (System/nanoTime)
            tick-time (- tick-finish tick-start)
            total-tick (+ total-tick tick-time)
            lowest-tick (min lowest-tick tick-time)
            avg-tick (/ total-tick (:tick world))

            render-start (System/nanoTime)
            rendered (w/render world)
            render-finish (System/nanoTime)
            render-time (- render-finish render-start)
            total-render (+ total-render render-time)
            lowest-render (min lowest-render render-time)
            avg-render (/ total-render (:tick world))]

        (when-not minimal
          (println "\u001b[H\u001b[2J"))

        (println
         (format "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)"
                 (:tick world)
                 (_f lowest-tick)
                 (_f avg-tick)
                 (_f lowest-render)
                 (_f avg-render)))

        (when-not minimal
          (println rendered))

        (recur world
               total-tick
               lowest-tick
               total-render
               lowest-render)))))

(run)
