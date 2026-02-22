(require (prefix-in helix. "helix/commands.scm"))
(require "languages.scm")
(require "themes/ashen.scm")

(provide hello-steel)
(define (hello-steel)
  (helix.echo "Steel is correctly installed and running!"))
(helix.theme "ashen")
