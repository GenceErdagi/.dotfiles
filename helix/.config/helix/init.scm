(require (prefix-in helix. "helix/commands.scm"))
(require "languages.scm")
(require "themes/ashen.scm")
(require "helix-remote/helix-remote.scm")

(helix.theme "ashen")

;; Start the TCP server for file opening from yazi/zellij
(start-helix-tcp-server 6666)

