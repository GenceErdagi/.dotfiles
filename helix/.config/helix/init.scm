(require (prefix-in helix. "helix/commands.scm"))
(require "languages.scm")
(require "helix-server/helix-server.scm")
(require "helix-file-opener/helix-file-opener.scm")
(require "scooter/scooter.scm")
(require "splash-hx/splash.scm")
;; Register handlers before starting server
(register-handler "open" open-file-handler)

(helix-server-start)
(require "splash-hx/splash.scm")

;; Add this to your init.scm
(when (equal? (command-line) '("hx"))
  (show-splash))
