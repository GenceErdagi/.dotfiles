(require "helix/configuration.scm")

;; -----------------------------------------------------------------------------
;; General Language Servers
;; -----------------------------------------------------------------------------

(define-lsp "scls"
  (command "simple-completion-language-server")
  (config (hash "feature_words" #f
                "feature_snippets" #t
                "snippets_first" #t
                "snippets_inline_by_word_tail" #f
                "feature_unicode_input" #f
                "feature_paths" #f
                "feature_citations" #f)))

(define-lsp "typescript-language-server"
  (config (hash "preferences" (hash "importModuleSpecifier" "non-relative"))))

(define-lsp "stylelint"
  (command "stylelint-lsp")
  (args '("--stdio"))
  (config (hash "stylelintplus" (hash "autoFixOnFormat" #t "autoFixOnSave" #t))))

(define-lsp "emmet-ls"
  (command "emmet-ls")
  (args '("--stdio")))

(define-lsp "tailwindcss-ls"
  (command "tailwindcss-language-server")
  (args '("--stdio")))

(define-lsp "codebook"
  (command "codebook-lsp")
  (args '("serve")))

;; Steel LSP Configuration (from previous step)
(define-lsp "steel-language-server" (command "steel-language-server") (args '()))

;; -----------------------------------------------------------------------------
;; Language Definitions
;; -----------------------------------------------------------------------------

(define-language "html"
  (language-servers '("vscode-html-language-server" "tailwindcss-ls" "emmet-ls" "scls" "codebook")))

(define-language "typescript"
  (auto-format #t)
  (language-servers '("typescript-language-server" "vscode-eslint-language-server" "graphql-language-service" "tailwindcss-ls" "codebook"))
  (formatter (command "prettier") (args '("--parser" "typescript"))))

(define-language "javascript"
  (auto-format #t)
  (language-servers '("typescript-language-server" "tailwindcss-ls" "codebook"))
  (formatter (command "prettier") (args '("--parser" "typescript"))))

(define-language "tsx"
  (auto-format #t)
  (language-servers '("typescript-language-server" "vscode-eslint-language-server" "emmet-ls" "tailwindcss-ls" "codebook"))
  (formatter (command "prettier") (args '("--parser" "typescript"))))

(define-language "jsx"
  (auto-format #t)
  (language-servers '("typescript-language-server" "vscode-eslint-language-server" "emmet-ls" "tailwindcss-ls" "codebook"))
  (formatter (command "prettier") (args '("--parser" "typescript"))))

(define-language "json"
  (language-servers '("codebook"))
  (formatter (command "prettier") (args '("--parser" "json"))))

(define-language "css"
  (auto-format #t)
  (language-servers '("stylelint" "vscode-css-language-server" "tailwindcss-ls" "codebook"))
  (formatter (command "prettier") (args '("--parser" "css"))))

(define-language "scss"
  (file-types '("scss"))
  (auto-format #t)
  ;; Note: partial config for vscode-css-language-server (only-features) is not directly supported in simple string list
  (language-servers '("stylelint" "vscode-css-language-server" "codebook"))
  (formatter (command "bash") (args '("-c" "npx stylelint --fix 2>&1 | prettier --parser css "))))

(define-language "markdown"
  (language-servers '("codebook")))

(define-language "scheme"
                 (language-servers '("steel-language-server")))

;; (define-lsp "clangd"
;;   (command "clangd")
;;   (args '("--background-index" "--clang-tidy" "--header-insertion=iwyu")))
;;
;; (define-language "c"
;;   (auto-format #t)
;;   (language-servers '("clangd"))
;;   (formatter (command "clang-format"))
;;   (debugger (hash "name" "lldb-dap" "transport" "stdio" "command" "lldb-dap" "templates" '())))
;;
;; (define-language "cpp"
;;   (auto-format #t)
;;   (language-servers '("clangd"))
;;   (formatter (command "clang-format"))
;;   (debugger (hash "name" "lldb-dap" "transport" "stdio" "command" "lldb-dap" "templates" '())))
