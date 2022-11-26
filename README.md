# Risp
Risp is a lisp interpreter written in Ruby.

# Launch the REPL
`ruby risp.rb`

# Example
```
risp>> (define area (lambda (r) (* 3.141592653 (* r r))))
area
risp>> (area 3)
28.274333877
risp>> (define fact (lambda (n) (if (<= n 1) 1 (* n (fact (- n 1))))))
fact
risp>> (fact 10)
3628800
```
