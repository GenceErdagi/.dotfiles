(require (prefix-in helix. "helix/commands.scm"))
(require "helix/configuration.scm")
(require-builtin helix/core/keymaps as km.)

(provide open-from-yazi-chooser
         register-yazi-picker!)

;;@doc
;; Open every file listed in Yazi's chooser file
(define (open-from-yazi-chooser)
  (let ((chooser-file "/tmp/unique-file"))
    (call-with-input-file chooser-file
      (lambda (port)
        (let loop ((line (read-line port)))
          (when (not (eof-object? line))
            (helix.open line)
            (loop (read-line port))))))))

;;@doc
;; Bind `space <key>` to the yazi file picker in normal and select modes.
;;
;; The blocking yazi step runs as a native command sequence, mirroring the old
;; config.toml binding. This keeps the shell out of the steel engine context so
;; the steel interrupt-handler thread cannot steal terminal input from yazi.
(define (register-yazi-picker! [key "e"])
  (let* ([global-bindings (get-keybindings)]
         [yazi-sequence
          (list
           ":sh rm -f /tmp/unique-file"
           ":insert-output yazi \"%{buffer_name}\" --chooser-file=/tmp/unique-file"
           ":sh printf \"\\x1b[?1049h\\x1b[?2004h\" > /dev/tty"
           ":open-from-yazi-chooser"
           ":redraw")]
         [keymap (hash "normal" (hash "space" (hash key yazi-sequence))
                       "select" (hash "space" (hash key yazi-sequence)))])
    (km.helix-merge-keybindings
     global-bindings
     (~> keymap (value->jsexpr-string) (km.helix-string->keymap)))
    (keybindings global-bindings)))

(register-yazi-picker!)
