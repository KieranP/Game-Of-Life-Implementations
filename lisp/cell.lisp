(defclass Cell ()
  ((x
    :initarg :x
    :reader x)
   (y
    :initarg :y
    :reader y)
   (alive
    :initarg :alive
    :initform nil
    :accessor alive)
   (next-state
    :initform nil
    :accessor next-state)
   (neighbours
    :initform nil
    :accessor neighbours)))

(defmethod to-char ((cell Cell))
  (if (alive cell) #\o #\Space))

(defmethod alive-neighbours ((cell Cell))
  ;; The following is slower
  ;; (count-if #'alive (neighbours cell))

  ;; The following is the fastest
  (let ((alive-neighbours 0))
    (loop for neighbour across (neighbours cell) do
      (when (alive neighbour)
        (incf alive-neighbours)))
    alive-neighbours)

  ;; The following is slower
  ;; (let ((alive-neighbours 0)
  ;;       (count (length (neighbours cell))))
  ;;   (loop for i from 0 below count do
  ;;     (let ((neighbour (svref (neighbours cell) i)))
  ;;       (when (alive neighbour)
  ;;         (incf alive-neighbours))))
  ;;   alive-neighbours)
  )
