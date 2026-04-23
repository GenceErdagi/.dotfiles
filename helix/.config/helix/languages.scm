(require "helix/configuration.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))

;; -----------------------------------------------------------------------------
;; General Language Servers
;; -----------------------------------------------------------------------------

(define-lsp "typescript-language-server"
  (config (hash "preferences"
    (hash "importModuleSpecifier" "non-relative"
          "preferTypeOnly" #t))))

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

;; Simple Completion Language Server (scls) for snippets
(define-lsp "scls"
  (command "simple-completion-language-server"))

;; -----------------------------------------------------------------------------

(define-language "html"
  (language-servers '("vscode-html-language-server" "tailwindcss-ls" "emmet-ls"  "codebook")))

(define-language "typescript"
  (auto-format #t)
  (language-servers '("typescript-language-server" "vscode-eslint-language-server" "tailwindcss-ls" "codebook"))
  (formatter (command "prettier") (args '("--parser" "typescript")))
  (debugger (hash "name" "js-debug" "transport" "stdio" "command" "js-debug-adapter" "templates" '())))

(define-language "javascript"
  (auto-format #t)
  (language-servers '("typescript-language-server" "tailwindcss-ls" "codebook"))
  (formatter (command "prettier") (args '("--parser" "typescript")))
  (debugger (hash "name" "js-debug" "transport" "stdio" "command" "js-debug-adapter" "templates" '())))

(define-language "tsx"
  (auto-format #t)
  (language-servers '("scls" "typescript-language-server" "vscode-eslint-language-server" "emmet-ls" "tailwindcss-ls" "codebook"))
  (formatter (command "prettier") (args '("--parser" "typescript")))
  (debugger (hash "name" "js-debug" "transport" "stdio" "command" "js-debug-adapter" "templates" '())))

(define-language "jsx"
  (auto-format #t)
  (language-servers '("typescript-language-server" "vscode-eslint-language-server" "emmet-ls" "tailwindcss-ls" "codebook"))
  (formatter (command "prettier") (args '("--parser" "typescript")))
  (debugger (hash "name" "js-debug" "transport" "stdio" "command" "js-debug-adapter" "templates" '())))

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
  (language-servers '()))

(define-language "scheme"
  (language-servers '("steel-language-server"))
  (file-types '("scm")))

(define-lsp "clangd"
  (command "clangd")
  (args '("--background-index" "--clang-tidy" "--header-insertion=iwyu")))

(define-language "c"
  (auto-format #t)
  (language-servers '("clangd"))
  (formatter (command "clang-format"))
  (debugger (hash "name" "lldb-dap" "transport" "stdio" "command" "lldb-dap" "templates" '())))

(define-language "cpp"
  (auto-format #t)
  (language-servers '("clangd"))
  (formatter (command "clang-format"))
  (debugger (hash "name" "lldb-dap" "transport" "stdio" "command" "lldb-dap" "templates" '())))
