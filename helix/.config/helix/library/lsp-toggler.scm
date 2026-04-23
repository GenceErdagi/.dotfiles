(require (prefix-in helix. "helix/commands.scm"))
(require "helix/configuration.scm")
(require (prefix-in helix-cmd. "helix/commands.scm"))

(provide register-lsp-toggle!
         toggle-lsp
         define-lsp-toggle
         spellcheck)

;; Hash of Language -> (extra-lsp base-lsps enabled?)
(define *toggle-states* (hash))

(define (register-lsp-toggle! lang extra-lsp base-lsps)
  (set! *toggle-states* 
        (hash-insert *toggle-states* 
                     lang 
                     (list extra-lsp base-lsps #f))))

;; Convenience macro
(define-syntax define-lsp-toggle
  (syntax-rules ()
    [(_ lang #:extra extra-lsp #:base (base-lsps ...))
     (register-lsp-toggle! lang extra-lsp (list base-lsps ...))]))

(define (perform-toggle! lang)
  (define entry (hash-get *toggle-states* lang))
  (when entry
    (let* ([extra-lsp (list-ref entry 0)]
           [base-lsps (list-ref entry 1)]
           [is-enabled? (list-ref entry 2)])
      
      (if is-enabled?
          ;; Disable it
          (begin
            (helix-cmd.lsp-stop extra-lsp)
            (update-language-config! lang (hash "name" lang "language-servers" base-lsps))
            (set! *toggle-states* 
                  (hash-insert *toggle-states* lang (list extra-lsp base-lsps #f)))
            (helix-cmd.echo (string-append "Disabled " (string-append extra-lsp " for " lang))))
          
          ;; Enable it
          (begin
            (update-language-config! lang (hash "name" lang "language-servers" (cons extra-lsp base-lsps)))
            (set! *toggle-states* 
                  (hash-insert *toggle-states* lang (list extra-lsp base-lsps #t)))
            (helix-cmd.echo (string-append "Enabled " (string-append extra-lsp " for " lang)))
            (helix-cmd.lsp-restart extra-lsp))))))

;; High-level command for Helix
(define (toggle-lsp lang)
  (perform-toggle! lang))

;; Register a toggle for markdown: extra LSP is "codebook", base is empty list
(define-lsp-toggle "markdown" #:extra "codebook" #:base ())

;; Provide spellcheck command using the generalized toggler
(define (spellcheck) (toggle-lsp "markdown"))
