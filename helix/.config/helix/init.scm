(require (prefix-in helix. "helix/commands.scm"))
(require "languages.scm")
(require "library/lsp-toggler.scm")

(require "helix-server/helix-server.scm")
(require "helix-file-opener/helix-file-opener.scm")
;; Register handlers before starting server
(register-handler "open" open-file-handler)

(helix-server-start)

