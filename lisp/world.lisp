(load "cell.lisp")

(define-condition LocationOccupied (error)
  ((x :initarg :x)
   (y :initarg :y))
  (:report (lambda (condition stream)
             (with-slots (x y) condition
               (format stream "LocationOccupied(~d-~d)" x y)))))

(defparameter DIRECTIONS
  '((-1 1)  (0 1)  (1 1)    ; above
    (-1 0)         (1 0)    ; sides
    (-1 -1) (0 -1) (1 -1))) ; below

(defclass World ()
  ((tick
    :initform 0
    :accessor tick)
   (width
    :initarg :width
    :reader width)
   (height
    :initarg :height
    :reader height)
   (cells
    :initform (make-hash-table :test #'equal)
    :reader cells)))

(defmethod initialize-instance :after ((world World) &key)
  (populate-cells world)
  (prepopulate-neighbours world))

(defmethod dotick ((world World))
  ;; First determine the action for all cells
  (loop for cell being the hash-values of (cells world) do
    (let ((alive-neighbours (alive-neighbours cell)))
      (cond
        ((and (not (alive cell)) (= alive-neighbours 3))
         (setf (next-state cell) t))
        ((or (< alive-neighbours 2) (> alive-neighbours 3))
         (setf (next-state cell) nil))
        (t
         (setf (next-state cell) (alive cell))))))

  ;; Then execute the determined action for all cells
  (loop for cell being the hash-values of (cells world) do
    (setf (alive cell) (next-state cell)))

  (incf (tick world)))

(defmethod render ((world World))
  ;; The following is slower
  ;; (let ((rendering ""))
  ;;   (loop for y from 0 below (height world) do
  ;;     (loop for x from 0 below (width world) do
  ;;       (let ((cell (cell-at world x y)))
  ;;         (when cell
  ;;           (setf rendering (concatenate 'string rendering (string (to-char cell)))))))
  ;;     (setf rendering (concatenate 'string rendering (string #\Newline))))
  ;;   rendering)

  ;; The following is slower
  ;; (let ((rendering '()))
  ;;   (loop for y from 0 below (height world) do
  ;;     (loop for x from 0 below (width world) do
  ;;       (let ((cell (cell-at world x y)))
  ;;         (when cell
  ;;           (push (to-char cell) rendering))))
  ;;     (push #\Newline rendering))
  ;;   (coerce (nreverse rendering) 'string))

  ;; The following is slower
  ;; (with-output-to-string (rendering)
  ;;   (loop for y from 0 below (height world) do
  ;;     (loop for x from 0 below (width world) do
  ;;       (let ((cell (cell-at world x y)))
  ;;         (when cell
  ;;           (write-char (to-char cell) rendering))))
  ;;     (write-char #\Newline rendering)))

  ;; The following is the fastest
  (let* ((render-size (+ (* (width world) (height world)) (height world)))
         (rendering (make-string render-size))
         (idx 0))
    (loop for y from 0 below (height world) do
      (loop for x from 0 below (width world) do
        (let ((cell (cell-at world x y)))
          (when cell
            (setf (char rendering idx) (to-char cell))
            (incf idx))))
      (setf (char rendering idx) #\Newline)
      (incf idx))
    rendering))

(defmethod make-key ((world World) x y)
  ;; The following is the fastest
  (format nil "~d-~d" x y)

  ;; The following is slower
  ;; (concatenate 'string (write-to-string x) "-" (write-to-string y))

  ;; The following is slower
  ;; (with-output-to-string (key)
  ;;   (princ x key)
  ;;   (write-char #\- key)
  ;;   (princ y key))
  )

(defmethod cell-at ((world World) x y)
  (let ((key (make-key world x y)))
    (gethash key (cells world))))

(defmethod populate-cells ((world World))
  (setf *random-state* (make-random-state t))
  (loop for y from 0 below (height world) do
    (loop for x from 0 below (width world) do
      (let ((alive (<= (random 1.0d0) 0.2d0)))
        (add-cell world x y alive)))))

(defmethod add-cell ((world World) x y &optional (alive nil))
  (let ((existing (cell-at world x y)))
    (when existing
      (error 'LocationOccupied :x x :y y)))

  (let ((key (make-key world x y))
        (cell (make-instance 'Cell :x x :y y :alive alive)))
    (setf (gethash key (cells world)) cell)
    t))

(defmethod prepopulate-neighbours ((world World))
  (loop for cell being the hash-values of (cells world) do
    (let ((x (x cell))
          (y (y cell))
          (neighbours '()))
      (dolist (set DIRECTIONS)
        (let* ((rel-x (first set))
               (rel-y (second set))
               (nx (+ x rel-x))
               (ny (+ y rel-y)))
          (unless (or (< nx 0) (< ny 0)) ; Out of bounds
            (unless (or (>= nx (width world)) (>= ny (height world))) ; Out of bounds
              (let ((neighbour (cell-at world nx ny)))
                (when neighbour
                  (push neighbour neighbours)))))))
      (setf (neighbours cell) (coerce (nreverse neighbours) 'simple-vector)))))
