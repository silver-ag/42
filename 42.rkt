#lang racket

;; 42 - any turing-complete language in which a program consists of a number and the number 42 is a self-interpreter
;; here's one that works by repeatedly reducing and taking the number mod 9 to get a string of digits 0-9,
;; which are mapped onto brainfuck + an eval() such that 42 is ,e

(define (run code [tape '(0 end)] #:debug? [debug? #f] #:debug-level [debug-level 0])
  ;; run some 42 code, returning the value in the current cell at the end
  ;; if #:debug? is #t, displays debugging info
  (display (if (and debug? (not (equal? code 0)))
               (format "~a~a: ~a [~a]\n"
                       (build-string debug-level (λ (n) #\space))
                       (string-ref "+-<>e.,[]" (inexact->exact (abs (remainder code 9))))
                       tape
                       code)
               ""))
  (if (equal? code 0)
      (first tape)
      (case (inexact->exact (abs (remainder code 9)))
        [(0) (run (quotient code 9) (cons (+ (first tape) 1) (rest tape)) #:debug? debug? #:debug-level debug-level)] ;; +
        [(1) (run (quotient code 9) (cons (- (first tape) 1) (rest tape)) #:debug? debug? #:debug-level debug-level)] ;; -
        [(2) (run (quotient code 9) (if (equal? (last tape) 'end)
                                        (cons 0 tape)
                                        (cons (last tape) (take tape (- (length tape) 1)))) #:debug? debug? #:debug-level debug-level)] ;; <
        [(3) (run (quotient code 9) (append (if (equal? (second tape) 'end)
                                                (cons 0 (rest tape))
                                                (rest tape)) (list (first tape))) #:debug? debug? #:debug-level debug-level)] ;; >
        [(4) (run (quotient code 9) (cons (run (first tape) #:debug? debug? #:debug-level (+ debug-level 1)) (rest tape)) #:debug? debug? #:debug-level debug-level)] ;; e - read the current cell and execute that value in a new context
        [(5) (display (format "~a\n" (first tape))) ;; .
             (run (quotient code 9) tape #:debug? debug? #:debug-level debug-level)]
        [(6) (run (quotient code 9) (cons (string->number (read-line)) (rest tape)) #:debug? debug? #:debug-level debug-level)] ;; ,
        [(7) (let ([match (to-matching-bracket (quotient code 9))]) ;; [
               (if (equal? 0 (first tape))
                   (run (inexact->exact (floor (/ code (expt 9 (ceiling (log (+ match 1) 9)))))) tape #:debug? debug? #:debug-level debug-level)
                   (run (inexact->exact (+ match (* (expt 9 (ceiling (log (+ match 1) 9))) code))) tape #:debug? debug? #:debug-level debug-level)))]
        [(8) (run (quotient code 9) tape #:debug? debug? #:debug-level debug-level)]))) ;; ]

(define (to-matching-bracket code [count 1])
  ;; given a number which has an implicit base-9 7 at the start,
  ;; find the corresponding 8 where 7 is [ and 8 is ], and return
  ;; the number up to that point
  ;(display (format "~a: ~a\n" count code))
  (if (equal? count 0)
      0
      (if (equal? (inexact->exact code) 0)
          (error "mismatched brackets")
          (+ (remainder code 9)
             (* 9 (case (remainder code 9)
                     [(7) (to-matching-bracket (quotient code 9) (+ count 1))]
                     [(8) (to-matching-bracket (quotient code 9) (- count 1))]
                     [else (to-matching-bracket (quotient code 9) count)]))))))

(run (string->number (read-line)))
