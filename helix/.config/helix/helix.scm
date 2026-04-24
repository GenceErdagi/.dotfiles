(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))
(provide open-helix-scm
         open-init-scm
         sidebar-focus
         terminal-focus)
;;@doc
;; Open the helix.scm file
(define (open-helix-scm)
  (helix.open (helix.static.get-helix-scm-path)))

;;@doc
;; Opens the init.scm file
(define (open-init-scm)
  (helix.open (helix.static.get-init-scm-path)))

;;@doc
;; Focuses on the zellij sidebar
(define (sidebar-focus)
  (helix.run-shell-command "zellij pipe --plugin zjide-manager --name focus-or-toggle-pane -- \"File-Explorer\"" ))


;;@doc
;; Focuses on the zellij sidebar
(define (terminal-focus)
  (helix.run-shell-command "zellij pipe --plugin zjide-manager --name focus-or-toggle-pane -- \"Terminal\"" ))
