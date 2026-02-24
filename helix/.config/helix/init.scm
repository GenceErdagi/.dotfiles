(require (prefix-in helix. "helix/commands.scm"))
(require "languages.scm")
(require "themes/ashen.scm")
(require "splash.scm")

(helix.theme "ashen")

(when (equal? (command-line) '("hx"))
  (show-splash))

