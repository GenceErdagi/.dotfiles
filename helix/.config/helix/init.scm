(require (prefix-in helix. "helix/commands.scm"))
(require "languages.scm")
(require "themes/ashen.scm")
(require "splash.scm")
(require "tcp_server.scm")

(helix.theme "ashen")

(when (equal? (command-line) '("hx"))
  (show-splash))

;; Start the TCP server for file opening from yazi/zellij
(start-helix-tcp-server 6666)

