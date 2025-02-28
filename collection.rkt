#lang racket

(provide (all-defined-out))

;; În acest fișier vă definiți constructorii și
;; operatorii tipului Collection.
;; În etapele anterioare, colecțiile erau de fapt
;; liste.
;; În definițiile de mai jos, veți considera că
;; o colecție este implementată ca flux.

; Întrucât stream-cons nu este o funcție obișnuită, 
; ci este definită ca o sintaxă specială, astfel
; încât ea să nu își evalueze argumentele înainte 
; de apel (comportament pe care ni-l dorim și pentru 
; collection-cons), nu putem folosi o definiție
; de tipul
;    (define collection-cons stream-cons)
; (genul acesta de definiție generează o eroare).
; Nici varianta
;    (define (collection-cons x xs) (stream-cons x xs))
; nu este o soluție, întrucât funcțiile definite de noi
; în Racket sunt funcții stricte, iar x și xs vor fi
; evaluate înainte de a intra în corpul funcției
; collection-cons și a descoperi că ele vor fi
; argumentele unui stream-cons.
; Modul de a defini collection-cons pentru a reproduce
; întocmai comportamentul lui stream-cons este:
(define-syntax-rule (collection-cons x xs) (stream-cons x xs))
; Obs: puteți schimba numele funcției, dacă nu vă
; place "collection-cons". Este o funcție folosită doar
; de voi în fișierul etapa4.rkt, nu de checker.


; TODO
; Scrieți în continuare restul definițiilor
; (care nu necesită o sintaxă specială).
(define empty-collection empty-stream)

; Functii de baza
(define collection-first stream-first)
(define collection-rest stream-rest)
(define collection-empty? stream-empty?)
(define collection-map stream-map)
(define collection-filter stream-filter)

; Functii auxiliare
(define (collection-take s n)
  (cond ((zero? n) '())
        ((collection-empty? s) '())
        (else (cons (collection-first s)
                    (collection-take (collection-rest s) (- n 1))))))

(define (collection-take-all s)
  (if (collection-empty? s)
      `()
      (cons (collection-first s) (collection-take-all (collection-rest s)))))

(define (collection-check-length s n)
  (cond ((zero? n) #t)
        ((collection-empty? s) #f)
        (else (collection-check-length (collection-rest s) (sub1 n)))))

(define (list->collection L)
  (if (null? L)
      empty-collection
      (collection-cons (car L) (list->collection (cdr L)))))

(define (collection-zip-with f s1 s2)
  (if (or (collection-empty? s1) (collection-empty? s2))
      empty-collection
      (collection-cons (f (collection-first s1) (collection-first s2)) (collection-zip-with f (collection-rest s1) (collection-rest s2)))))

;(collection-take-all (list->collection `(1 2 3 4 5 6 7 8 4)))
;(collection-take (collection-zip-with + (list->collection `(1 2 3 4 5)) (list->collection `(5 4 3 2 1))) 4)