(ns cell)

(defrecord Cell [x y alive neighbours])

(defn new-cell
  ([x y]
   (new-cell x y false))
  ([x y alive]
   (->Cell x y alive [])))

(defn to-char [cell]
  (if (:alive cell) \o \space))

(defn alive-neighbours [cell world]
  (let [cells (:cells world)]
    ;; The following is slower
    ;; (count (filter (fn [key] (:alive (get cells key))) (:neighbours cell)))

    ;; The following is slower
    ;; (loop [neighbours (:neighbours cell)
    ;;        count 0]
    ;;   (if (empty? neighbours)
    ;;     count
    ;;     (recur (rest neighbours)
    ;;            (if (:alive (get cells (first neighbours)))
    ;;              (inc count)
    ;;              count))))

    ;; The following is the fastest
    (reduce (fn [count neighbour-key]
              (if (:alive (get cells neighbour-key))
                (inc count)
                count))
            0
            (:neighbours cell))))
