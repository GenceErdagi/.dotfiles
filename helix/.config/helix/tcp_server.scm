(require-builtin steel/tcp)
(require "steel/sync")
(require-builtin helix/core/typable as hx-typable.)
(require "helix/ext.scm")

(provide start-helix-tcp-server)

(define (start-helix-tcp-server port)
  (spawn-native-thread
    (lambda ()
      (let ([listener (tcp-listen (string-append "127.0.0.1:" (int->string port)))])
        (let loop ()
          (let* ([stream (tcp-accept listener)]
                 [reader (tcp-stream-buffered-reader stream)])
            (let ([line (read-line reader)])
              (when (not (eof-object? line))
                (let ([path (trim line)])
                  (when (not (equal? path ""))
                    (hx.block-on-task (lambda () 
                      (hx-typable.open (list path))))))))
            (tcp-shutdown! stream))
          (loop))))))
