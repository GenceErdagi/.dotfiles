(require (prefix-in helix. "helix/commands.scm"))
(require "languages.scm")
(require "lsp-toggler.scm")

;; Register a toggle for markdown: extra LSP is "codebook", base is empty list
(define-lsp-toggle "markdown" #:extra "codebook" #:base ())

(require "helix-server/helix-server.scm")
(require "helix-file-opener/helix-file-opener.scm")
(require "scooter/scooter.scm")
;; Register handlers before starting server
(register-handler "open" open-file-handler)

(helix-server-start)

;; Provide spellcheck command using the generalized toggler
(provide spellcheck)
(define (spellcheck) (toggle-lsp "markdown"))
