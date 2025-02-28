#lang racket
(require "suffix-tree-stream.rkt")
(require "collection.rkt")

(provide (all-defined-out))

;; Vom prelua toate funcțiile din etapele 1-3 (exceptând
;; longest-common-substring, care nu beneficiază de 
;; reprezentarea ca flux întrucât parcurge tot arborele)
;; și le vom adapta la noua reprezentare a unui ST.
;;
;; Pentru că un ST este construit pornind de la o colecție
;; de sufixe și pentru că ne dorim să nu calculăm toate
;; sufixele decât dacă este nevoie, vom modifica toate
;; funcțiile care prelucrau liste de sufixe pentru a
;; prelucra fluxuri de sufixe.
;;
;; Obs: fără această modificare a listelor de sufixe în
;; fluxuri de sufixe, și presupunând că am manipulat
;; arborii de sufixe doar prin interfața definită în
;; fișierul suffix-tree (respectând astfel bariera de 
;; abstractizare), ar trebui să alterăm doar funcția 
;; suffixes->st care este practic un constructor pentru
;; tipul ST.
;; Din cauza transformării listelor de sufixe în fluxuri,
;; avem mult mai multe implementări de modificat.
;; Puteam evita acest lucru? Da, utilizând conceptul de
;; colecție de sufixe de la început (în loc să presupunem
;; că ele vor fi prelucrate ca liste). În loc de cons,
;; car, cdr, map, filter, etc. am fi folosit de fiecare
;; dată collection-cons, collection-first, ... etc. -
;; aceste funcții fiind definite într-o bibliotecă
;; inițială ca fiind echivalentele lor pe liste, și
;; redefinite ulterior în stream-cons, stream-first,
;; ... etc. Operatorii pe colecții de sufixe ar fi 
;; folosit, desigur, doar funcții de tip collection-.
;;
;; Am ales să nu procedăm astfel pentru că ar fi provocat
;; confuzie la momentul respectiv (când chiar operatorii
;; pe liste erau o noutate) și pentru a vă da ocazia să
;; faceți singuri acest "re-design".


; TODO
; Copiați din etapele anterioare implementările funcțiilor
; de mai jos și modificați-le astfel:
; - Toate funcțiile care lucrează cu liste de sufixe vor
;   lucra cu un nou tip de date Collection, ai cărui
;   constructori și operatori vor fi definiți de voi
;   în fișierul collection.rkt.
; - Pentru toate funcțiile, trebuie să vă asigurați că
;   este respectată bariera de abstractizare (atât în 
;   cazul tipului ST cât și în cazul tipului Collection).
; Obs: cu cât mai multe funcții rămân nemodificate, cu atât
; este mai bine (înseamnă că design-ul inițial a fost bun).

(define (longest-common-prefix w1 w2)
  (longest-common-prefix-tail w1 w2 empty-collection))

(define (longest-common-prefix-tail w1 w2 acc)
  (cond
    [(or (collection-empty? w1) (collection-empty? w2)) (list (list->collection (reverse (collection-take-all acc))) w1 w2)]
    [(equal? (collection-first w1) (collection-first w2)) (longest-common-prefix-tail (collection-rest w1) (collection-rest w2) (collection-cons (collection-first w1) acc))]
    [else (list (list->collection (reverse (collection-take-all acc))) w1 w2)]))

; (prefix    , w1 - rest , w2 - rest )
; (collection, collection, collection)

;(equal? (collection-first (list->collection (string->list "when"))) (collection-first (list->collection (string->list "who"))))
;(longest-common-prefix (list->collection (string->list "when")) (list->collection (string->list "who")))
;(collection-take-all (car (longest-common-prefix (list->collection (string->list "when")) (list->collection (string->list "who")))))
;(collection-take-all (cadr (longest-common-prefix (list->collection (string->list "when")) (list->collection (string->list "who")))))
;(collection-take-all (caddr (longest-common-prefix (list->collection (string->list "when")) (list->collection (string->list "who")))))


; am schimbat, în numele funcției, cuvântul list în
; cuvântul collection
(define (longest-common-prefix-of-collection words)
  (if (collection-empty? (collection-rest words))
      (collection-take-all (collection-first words))
      (longest-common-prefix-of-collection (collection-cons (car (longest-common-prefix (collection-first words) (collection-first (collection-rest words))))
                                                            (collection-rest (collection-rest words))))))

(define (match-pattern-with-label st pattern)
        (if (get-ch-branch st (car pattern))
            (let ([prefix (longest-common-prefix (get-branch-label (get-ch-branch st (car pattern))) pattern)])
              (cond
                [(null? (collection-take-all (car (cdr (cdr prefix))))) #t]
                [(null? (collection-take-all (car (cdr prefix))))
                 (list (collection-take-all (car prefix))
                       (car (cdr (cdr prefix)))
                       (cdr (get-ch-branch st (car pattern))))]
                [else (list #f (car (cdr (cdr prefix))))]))
        `(#f ())))

(define (st-has-pattern? st pattern)
  (if (equal? (match-pattern-with-label st pattern) #t)
      #t
      (if (equal? (car (match-pattern-with-label st pattern)) #f)
          #f
          (st-has-pattern? (car (cdr (cdr (match-pattern-with-label st pattern)))) (car (cdr (match-pattern-with-label st pattern)))))))


(define (get-suffixes text)
  (list->collection (get-suffixes-aux text `())))

(define (get-suffixes-aux text acc)
  (if (null? text)
      acc
      (get-suffixes-aux (cdr text) (append acc (list text)))))

(define (get-ch-words words ch)
  (collection-filter (λ (x)
            (if (collection-empty? x)
                empty-collection
                (equal? ch (car x)))) words))

(define (ast-func suffixes)
  (cond
    [(null? (collection-take-all suffixes)) empty-st]
    [(or (equal? (car (collection-take-all suffixes)) `(#\$)) (equal? (collection-take-all suffixes) `(#\$)))
      (cons `(#\$) empty-st)]
    [else (cons (list (car (collection-first suffixes))) (collection-map (λ (x) (cdr x)) suffixes))]))

(define (take-rest-n text n)
  (if (equal? n 0)
      text
      (take-rest-n (cdr text) (- n 1))))

(define (cst-func suffixes)
  (let ([prefix (longest-common-prefix-of-collection suffixes)]
         [prefix-len (length (longest-common-prefix-of-collection suffixes))])
    (cons prefix (collection-map (λ (x) (take-rest-n x prefix-len)) suffixes))))


; considerați că și parametrul alphabet este un flux
; (desigur, și suffixes este un flux, fiind o colecție
; de sufixe)
(define (check-nulls L)
  (cond
    [(collection-empty? L) empty-st]
    [(null? (collection-take-all (collection-first L))) (check-nulls (collection-rest L))]
    [else (collection-cons (collection-first L) (check-nulls (collection-rest L)))]))

(define (suffixes->st labeling-func suffixes alphabet)
  (cond
    [(st-empty? suffixes) empty-st]
    [else
      (collection-map (λ (branch)
         (let ([labeled (labeling-func branch)])
           (cons (get-branch-label labeled) (suffixes->st labeling-func (get-branch-subtree labeled) alphabet)))) 
             (check-nulls (collection-map (λ (x)
                           (collection-filter (λ (L)
                                     (if (null? L)
                                         #f
                                         (equal? (car L) x))) suffixes)) alphabet)))]))

; nu uitați să convertiți alfabetul într-un flux
(define (text->st func)
  (λ (L)
    (suffixes->st func (get-suffixes (append L `(#\$)))  (list->collection (sort (append `(#\$) (remove-duplicates L)) char<?)))))


(define text->ast
  (text->st ast-func))


(define text->cst
  (text->st cst-func))


; dacă ați respectat bariera de abstractizare,
; această funcție va rămâne nemodificată.
(define (substring? text pattern)
  'your-code-here)

  ;(if (st-has-pattern? (text->cst text) pattern) #t #f))

; dacă ați respectat bariera de abstractizare,
; această funcție va rămâne nemodificată.
(define (repeated-substring-of-given-length text len)
  'your-code-here)

(match-pattern-with-label (text->cst (string->list "banana")) (string->list "ana"))
(st-has-pattern? (text->cst (string->list "banana")) (string->list "bananana"))