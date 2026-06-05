(ns world
  (:require [cell :as c]
            [clojure.string :as string]))

(defrecord World [tick width height cells])

(defn location-occupied-exception [x y]
  (ex-info (str "LocationOccupied(" x "-" y ")") {:x x :y y}))

(def directions
  [[-1 1]  [0 1]  [1 1]  ; above
   [-1 0]         [1 0]  ; sides
   [-1 -1] [0 -1] [1 -1] ; below
   ])

(declare make-key cell-at populate-cells add-cell prepopulate-neighbours)

(defn new-world [width height]
  (let [world (->World 0 width height {})]
    (-> world
        populate-cells
        prepopulate-neighbours)))

(defn tick [world]
  (let [cells (:cells world)
        updated-cells
        (persistent!
         (reduce-kv
          (fn [acc key cell]
            (let [alive-neighbours (c/alive-neighbours cell world)]
              (cond
                (and (not (:alive cell))
                     (= alive-neighbours 3))
                (assoc! acc key (assoc cell :alive true))

                (or (< alive-neighbours 2)
                    (> alive-neighbours 3))
                (assoc! acc key (assoc cell :alive false))

                :else
                (assoc! acc key cell))))
          (transient {})
          cells))]
    (-> world
        (assoc :cells updated-cells)
        (update :tick inc))))

(defn render [world]
  ;; The following is slower
  ;; (loop [y 0
  ;;        rendering ""]
  ;;   (if (>= y (:height world))
  ;;     rendering
  ;;     (recur (inc y)
  ;;            (loop [x 0
  ;;                   line rendering]
  ;;              (if (>= x (:width world))
  ;;                (str line "\n")
  ;;                (let [cell (cell-at world x y)]
  ;;                  (recur (inc x)
  ;;                         (if cell
  ;;                           (str line (c/to-char cell))
  ;;                           line))))))))

  ;; The following is slower
  ;; (let [chars (loop [y 0
  ;;                    result []]
  ;;               (if (>= y (:height world))
  ;;                 result
  ;;                 (recur (inc y)
  ;;                        (loop [x 0
  ;;                               line result]
  ;;                          (if (>= x (:width world))
  ;;                            (conj line \newline)
  ;;                            (let [cell (cell-at world x y)]
  ;;                              (recur (inc x)
  ;;                                     (if cell
  ;;                                       (conj line (c/to-char cell))
  ;;                                       line))))))))]
  ;;   (apply str chars))

  ;; The following is the fastest
  (let [render-size (+ (* (:width world) (:height world)) (:height world))
        rendering (StringBuilder. (int render-size))]
    (doseq [y (range (:height world))]
      (doseq [x (range (:width world))]
        (let [cell (cell-at world x y)]
          (when cell
            (.append rendering (c/to-char cell)))))
      (.append rendering \newline))
    (.toString rendering)))

(defn- make-key [x y]
  ;; The following is slower
  ;; (format "%d-%d" x y)

  ;; The following is slower
  ;; (str x "-" y)

  ;; The following is the fastest
  (string/join "-" [x y]))

(defn- cell-at [world x y]
  (let [key (make-key x y)]
    (get (:cells world) key)))

(defn- populate-cells [world]
  (reduce (fn [world y]
            (reduce (fn [world x]
                      (let [alive (<= (rand) 0.2)
                            [world _success] (add-cell world x y alive)]
                        world))
                    world
                    (range (:width world))))
          world
          (range (:height world))))

(defn- add-cell
  ([world x y]
   (add-cell world x y false))
  ([world x y alive]
   (let [existing (cell-at world x y)]
     (if existing
       (throw (location-occupied-exception x y))
       (let [key (make-key x y)
             cell (c/new-cell x y alive)]
         [(assoc-in world [:cells key] cell) true])))))

(defn- prepopulate-neighbours [world]
  (reduce-kv
   (fn [world key cell]
     (let [neighbours
           (vec (keep (fn [[rel-x rel-y]]
                        (let [nx (+ (:x cell) rel-x)
                              ny (+ (:y cell) rel-y)]
                          (when-not (or (< nx 0) (< ny 0)) ; Out of bounds
                            (when-not (or (>= nx (:width world)) (>= ny (:height world))) ; Out of bounds
                              (let [neighbour-key (make-key nx ny)]
                                (when (get (:cells world) neighbour-key)
                                  neighbour-key))))))
                      directions))]
       (assoc-in world [:cells key :neighbours] neighbours)))
   world
   (:cells world)))
