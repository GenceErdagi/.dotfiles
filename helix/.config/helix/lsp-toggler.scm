(require "lsp-toggler/logic.scm")

(provide register-lsp-toggle!
         toggle-lsp
         define-lsp-toggle)

;; High-level command for Helix
(define (toggle-lsp lang)
  (perform-toggle! lang))

;; Convenience macro
(define-syntax define-lsp-toggle
  (syntax-rules ()
    [(_ lang #:extra extra-lsp #:base (base-lsps ...))
     (register-lsp-toggle! lang extra-lsp (list base-lsps ...))]))
