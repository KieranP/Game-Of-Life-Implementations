(load "world.lisp")

(defparameter WORLD-WIDTH 150)
(defparameter WORLD-HEIGHT 40)

(defparameter CLEAR-SCREEN (format nil "~c[?2026h~c[H~c[2J" #\Escape #\Escape #\Escape))
(defparameter SHOW-SCREEN (format nil "~c[?2026l" #\Escape))

(defun _f (value)
  ;; internal time units -> milliseconds
  (/ (* value 1000) (float internal-time-units-per-second 0d0)))

(defun run ()
  (let ((world (make-instance 'World
                              :width WORLD-WIDTH
                              :height WORLD-HEIGHT))
        (minimal (equal (sb-ext:posix-getenv "MINIMAL") "1"))
        (total-tick 0)
        (lowest-tick sb-ext:double-float-positive-infinity)
        (total-render 0)
        (lowest-render sb-ext:double-float-positive-infinity))

    (unless minimal
      (format t "~a~%" (render world)))

    (loop
      (let* ((tick-start (get-internal-real-time))
             (tick-finish (progn (dotick world) (get-internal-real-time)))
             (tick-time (- tick-finish tick-start)))
        (incf total-tick tick-time)
        (setf lowest-tick (min lowest-tick tick-time))
        (let ((avg-tick (/ total-tick (tick world))))

          (let* ((render-start (get-internal-real-time))
                 (rendered (render world))
                 (render-finish (get-internal-real-time))
                 (render-time (- render-finish render-start)))
            (incf total-render render-time)
            (setf lowest-render (min lowest-render render-time))
            (let ((avg-render (/ total-render (tick world))))

              (unless minimal
                (format t "~a" CLEAR-SCREEN))

              (format t "#~d - World Tick (L: ~,3f; A: ~,3f) - Rendering (L: ~,3f; A: ~,3f)~%"
                      (tick world)
                      (_f lowest-tick)
                      (_f avg-tick)
                      (_f lowest-render)
                      (_f avg-render))

              (unless minimal
                (format t "~a~a~%" rendered SHOW-SCREEN)))))))))

(run)
