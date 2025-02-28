#lang racket
(require "suffix-tree.rkt")
(require "etapa1.rkt")
(require "etapa2.rkt")

(provide (all-defined-out))

;; Această etapă este dedicată aplicațiilor 
;; arborelui de sufixe:
;; - găsirea unui șablon într-un text
;; - cel mai lung subșir comun a două texte
;; - găsirea unui subșir de lungime dată care se
;;   repetă în text
;; Conform convenției din etapele anterioare, un text
;; este întotdeauna reprezentat ca listă de caractere.
;; Rezultatele funcțiilor de mai jos sunt de asemenea
;; reprezentate ca liste de caractere.


; TODO 1
; Implementați funcția substring? care primește un text și
; un șablon nevid și întoarce true dacă șablonul apare în 
; text, respectiv false în caz contrar.
; Observație: ați implementat deja logica principală a
; acestei căutări în etapa 1, în funcția st-has-pattern?,
; care este un operator al tipului ST. Acum aveți toate
; uneltele necesare implementării operatorului corespunzător
; pentru tipul text (pentru că în etapa 2 ați implementat
; construcția arborelui de sufixe asociat unui text).
(define (substring? text pattern)
  (if (st-has-pattern? (text->ast text) pattern) #t #f))

; TODO 2
; Implementați funcția longest-common-substring care primește
; două texte și determină cel mai lung subșir comun al
; acestora, folosind algoritmul următor:
; 1. Construiește arborele de sufixe ST1 pentru primul text.
; 2. Pentru fiecare sufix din al doilea text (de la cel mai
;    lung la cel mai scurt), găsește cea mai lungă potrivire 
;    cu sufixele din primul text, urmând căile relevante în ST1.
; 3. Rezultatul final este cel mai lung rezultat identificat
;    la pasul 2 (în caz de egalitate a lungimii, păstrăm
;    primul șir găsit).
; Folosiți named let pentru a parcurge sufixele.
; Observație: pentru sufixele din al doilea text nu dorim 
; marcajul de final $ pentru a nu crește artificial lungimea 
; șirului comun cu acest caracter.
; Hint: Revizitați funcția match-pattern-with-label (etapa 1).

;(get-suffixes (string->list "babxabxaaxxaba"))


(define stree-1
  '(((#\$))
    ((#\a) ((#\$))
           ((#\n #\a) ((#\$))
                      ((#\n #\a #\$))))
    ((#\b #\a #\n #\a #\n #\a #\$))
    ((#\n #\a) ((#\$))
               ((#\n #\a #\$)))))


(define (longest-common-substring text1 text2)
  (foldl (λ (word acc)
           (if (>= (length word) (length acc))
               word
               acc))
         `() (foldl (λ (x acc)
                      ;(display "x = ")
                      ;(print x)
                      ;(display "\n")
                      (let iter ([tree (text->ast text1)] [suffix x] [result `()])
                        (let* ([match (match-pattern-with-label tree suffix)])
                          ;(display "tree = ")
                          ;(print tree)
                          ;(display "\nsuffix = ")
                          ;(print suffix)
                          ;(display "\n")
                          ;(print match)
                          ;(display "\n")
                          (if (not (list? match))
                              (if match
                                  (append (list (append result suffix)) acc)
                                  (append (list result) acc))
                              (if (not (car match))
                                  (append (list result) acc)
                                  (iter (caddr match) (cadr match) (append result (car match)))))))) `() (get-suffixes text2))))


(define (longest-common-substring2 text1 text2)
  (foldl (λ (x acc)
           ;(display "x = ")
           ;(print x)
           ;(display "\n")
           (let iter ([tree (text->ast text1)] [suffix x] [result `()])
             (let* ([match (match-pattern-with-label tree suffix)])
               ;(display "tree = ")
               ;(print tree)
               ;(display "\nsuffix = ")
               ;(print suffix)
               ;(display "\n")
               ;(print match)
               ;(display "\n")
               (if (not (list? match))
                   (if match
                       (append (list (append result suffix)) acc)
                       (append (list result) acc))
                   (if (not (car match))
                       (append (list result) acc)
                       (iter (caddr match) (cadr match) (append result (car match)))))))) `() (get-suffixes text2)))

; TODO 3
; Implementați funcția repeated-substring-of-given-length
; care primește un text și un număr natural len și
; parcurge arborele de sufixe al textului până găsește un
; subșir de lungime len care se repetă în text.
; Dacă acest subșir nu există, funcția întoarce false.
; Obs: din felul în care este construit arborele de sufixe
; (pe baza alfabetului sortat), rezultatul va fi primul 
; asemenea subșir din punct de vedere alfabetic.
; Ideea este următoarea: orice cale în arborele de sufixe
; compact care se termină cu un nod intern (un nod care 
; are copii, nu este o frunză) reprezintă un subșir care
; se repetă, pentru că orice asemenea cale reprezintă un
; prefix comun pentru două sau mai multe sufixe ale textului.
; Folosiți interfața definită în fișierul suffix-tree
; atunci când manipulați arborele.
(define (flatten L)
  (cond
    ((not L) #f)
    ((null? L) '())
    ((not (pair? L)) (list L))
    (else (append (flatten (car L)) (flatten (cdr L))))))

(define (repeated-substring-of-given-length text len)
      (let ([tree (text->cst text)])
        (let ([res (flatten (let iter ([branch (first-branch tree)] [other (other-branches tree)] [current-len `0] [result `()])
                              (print current-len)
                              (display "\n")
                              (if (>= current-len len)
                                  result
                                  (if (and (not (null? (get-branch-subtree branch))) (list? (get-branch-subtree branch)))
                                      (let [(res-branch (iter (first-branch (get-branch-subtree branch)) (other-branches branch) (+ current-len (length (get-branch-label branch))) (cons result (get-branch-label branch))))]
                                        (if res-branch
                                            res-branch
                                            (if (null? other)
                                                #f
                                                (iter (first-branch other) (other-branches other) current-len result))))
                                      (if (and (equal? `0 current-len) (not (null? other)))
                                          (iter (first-branch other) (other-branches other) current-len result)
                                          #f)))))]) (if res
                                                        (take res len)
                                                        #f))))
          


(define long-text (string->list "In computer science, functional programming is a programming paradigm where programs are constructed by applying and composing functions. It is a declarative programming paradigm in which function definitions are trees of expressions that map values to other values, rather than a sequence of imperative statements which update the running state of the program.

In functional programming, functions are treated as first-class citizens, meaning that they can be bound to names (including local identifiers), passed as arguments, and returned from other functions, just as any other data type can. This allows programs to be written in a declarative and composable style, where small functions are combined in a modular manner.

Functional programming is sometimes treated as synonymous with purely functional programming, a subset of functional programming which treats all functions as deterministic mathematical functions, or pure functions. When a pure function is called with some given arguments, it will always return the same result, and cannot be affected by any mutable state or other side effects. This is in contrast with impure procedures, common in imperative programming, which can have side effects (such as modifying the program's state or taking input from a user). Proponents of purely functional programming claim that by restricting side effects, programs can have fewer bugs, be easier to debug and test, and be more suited to formal verification.[1][2]

Functional programming has its roots in academia, evolving from the lambda calculus, a formal system of computation based only on functions. Functional programming has historically been less popular than imperative programming, but many functional languages are seeing use today in industry and education, including Common Lisp, Scheme,[3][4][5][6] Clojure, Wolfram Language,[7][8] Racket,[9] Erlang,[10][11][12] Elixir,[13] OCaml,[14][15] Haskell,[16][17] and F#.[18][19] Functional programming is also key to some languages that have found success in specific domains, like JavaScript in the Web,[20] R in statistics,[21][22] J, K and Q in financial analysis, and XQuery/XSLT for XML.[23][24] Domain-specific declarative languages like SQL and Lex/Yacc use some elements of functional programming, such as not allowing mutable values.[25] In addition, many other programming languages support programming in a functional style or have implemented features from functional programming, such as C++11, C#,[26] Kotlin,[27] Perl,[28] PHP,[29] Python,[30] Go,[31] Rust,[32] Raku,[33] Scala,[34] and Java (since Java 8).[35]"))

;(get-suffixes long-text)
(text->cst long-text)
