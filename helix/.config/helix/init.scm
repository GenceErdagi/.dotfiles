(require (prefix-in helix. "helix/commands.scm"))
(require "languages.scm")
(require "themes/ashen.scm")
(require "helix-server/helix-server.scm")
(require "helix-file-opener/helix-file-opener.scm")
(require "scooter/scooter.scm")

(helix.theme "ashen")

;; Register handlers before starting server
(register-handler "open" open-file-handler)

(helix-server-start)
