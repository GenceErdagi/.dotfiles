Lessons from discord-rpc-lsp
LSP Architecture:
- Uses github.com/tliron/glsp for LSP server implementation
- Server runs via stdio: server.RunStdio()
- Handler implements protocol methods (Initialize, TextDocumentDidOpen/DidChange/DidClose)
Editor State Tracking:
- Monitors file open/change/close events
- Tracks workspace, language, editor name
- Idle/view timers for different activity states
- Timestamp tracking for elapsed time
Configuration Pattern:
- TOML config in ~/.discord-rpc-lsp/
- Configurable activities with placeholders ({filename}, {workspace}, {editor}, {language})
- Per-language mappings via remote JSON
Git Integration:
- Uses github.com/go-git/go-git/v5
- Extracts remote URL and branch name
- Handles file:// URI prefixes
Throttling:
- Custom throttler to prevent spam (5s default)
- Important for rate-limited APIs
Handler Structure:
type LSPHandler struct {
    Name, Version string
    Handler *protocol.Handler
    CurrentLang string
    IdleTimer, ViewTimer *time.Timer
    Client *client.Client
    Config *client.Config
    Mutex sync.Mutex
}
Key takeaway: Use similar LSP structure but add workspace/executeCommand support for bidirectional control instead of Discord RPC.
