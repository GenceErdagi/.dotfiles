(require (prefix-in helix. "helix/commands.scm"))
(require "languages.scm")
(require "themes/ashen.scm")
(require "helix-remote/helix-remote.scm")

(helix.theme "ashen")

;; Start the TCP server for file opening from yazi/zellij
;; Pass -1 to derive port from ZELLIJ_SESSION_NAME
(start-helix-tcp-server -1)
