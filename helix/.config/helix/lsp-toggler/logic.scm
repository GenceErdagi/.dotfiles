(require (prefix-in helix. "helix/commands.scm"))
(require "helix/configuration.scm")

(provide *toggle-registry*
         register-lsp-toggle!
         perform-toggle!)

;; Hash of Language -> (extra-lsp-name base-lsp-list is-enabled?)
(define *toggle-registry* (hash))

(define (register-lsp-toggle! lang extra-lsp base-lsps)
  (set! *toggle-registry* 
        (hash-insert *toggle-registry* 
                     lang 
                     (list extra-lsp base-lsps #f))))

(define (perform-toggle! lang)
  (define entry (hash-try-get *toggle-registry* lang))
  (when entry
    (let ([extra-lsp (list-ref entry 0)]
          [base-lsps (list-ref entry 1)]
          [is-enabled? (list-ref entry 2)])
      
      (if is-enabled?
          ;; Disable it
          (begin
            (helix.lsp-stop)
            (update-language-config! lang (hash "language-servers" base-lsps))
            (helix.echo (to-string "LSP " extra-lsp " disabled for " lang))
            ;; Update state to disabled
            (set! *toggle-registry* 
                  (hash-insert *toggle-registry* lang (list extra-lsp base-lsps #f))))
          
          ;; Enable it
          (begin
            (update-language-config! lang (hash "language-servers" (cons extra-lsp base-lsps)))
            (helix.echo (to-string "LSP " extra-lsp " enabled for " lang))
            (helix.lsp-restart)
            ;; Update state to enabled
            (set! *toggle-registry* 
                  (hash-insert *toggle-registry* lang (list extra-lsp base-lsps #t))))))))
