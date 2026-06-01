# Hermes-Hinata Architecture

## System Overview

Hermes-Hinata is a unified mobile application that combines:

1. **React Native UI** - Cross-platform mobile interface
2. **Termux Core** - Linux container with PTY emulation
3. **Python Bridge** - JSON-RPC server for Hermes communication
4. **Hermes Agent** - AI agent engine for autonomous task execution

## Component Layers

### 1. UI Layer (React Native)

**Location:** `src/`

- **Screens:** Chat, Terminal, Settings, Skills
- **Components:** Message display, input, terminal emulator
- **Services:** Bridge communication, storage, navigation
- **Navigation:** Bottom tabs + stack navigation

### 2. Bridge Layer (Python JSON-RPC)

**Location:** `hermes-bridge/`

Manages:
- Hermes agent lifecycle
- Message streaming
- Tool execution
- Session management

Communication via stdin/stdout (JSON-RPC).

### 3. Agent Layer (Hermes)

**Location:** Installed in Termux via `pip install hermes-agent`

Provides:
- LLM integration
- Tool execution framework
- Skill system
- Memory management
- Autonomous task loop

### 4. Terminal Layer (Termux)

**Location:** Native Termux core

Provides:
- PTY emulation
- Shell environment
- Package management
- Linux utilities

## Data Flow

### User Message → Agent Response

```
┌──────────────────┐
│  React Native UI │
└────────┬─────────┘
         │ User Input
         ↓
┌──────────────────┐
│  Bridge (Python) │ ← JSON-RPC
└────────┬─────────┘
         │ route_message()
         ↓
┌──────────────────┐
│ Hermes Agent     │
└────────┬─────────┘
         │ process_input()
         ↓
┌──────────────────┐
│ Tool Execution   │
│ (Terminal)       │
└────────┬─────────┘
         │ results
         ↓
┌──────────────────┐
│ Hermes Agent     │
│ (generate resp)  │
└────────┬─────────┘
         │ stream_response()
         ↓
┌──────────────────┐
│  Bridge (Python) │ ← emit event
└────────┬─────────┘
         │ JSON event
         ↓
┌──────────────────┐
│  React Native UI │ ← display
└──────────────────┘
```

## Communication Protocol

### JSON-RPC over stdio

**Request (UI → Bridge):**
```json
{
  "jsonrpc": "2.0",
  "method": "agent.send_message",
  "params": {
    "message": "Hello, what can you do?",
    "session_id": "session-123"
  },
  "id": 1
}
```

**Response (Bridge → UI):**
```json
{
  "jsonrpc": "2.0",
  "result": {
    "status": "processing"
  },
  "id": 1
}
```

**Event Stream (Bridge → UI):**
```json
{"event": "message.start", "data": {"id": "msg-1"}}
{"event": "message.delta", "data": {"text": "I can help"}}
{"event": "tool.start", "data": {"name": "web_search"}}
{"event": "tool.complete", "data": {"result": "..."}}
{"event": "message.complete", "data": {"text": "Done"}}
```

## Storage Architecture

### Local Storage (AsyncStorage)

```
~/.hinata/
├── config.json           # App settings
├── conversations/        # Chat history
│   ├── session-1.json
│   └── session-2.json
├── skills/              # Downloaded skills
│   ├── web-search/
│   └── code-exec/
└── cache/               # Temporary data
```

### Termux Storage

```
$HOME/.hermes/          # Hermes agent home
├── config.yaml         # Agent config
├── memory.db           # Agent memory
├── skills/             # Procedural skills
└── sessions/           # Session history
```

## State Management

Using Zustand for React state:

```typescript
// Chat state
const useChatStore = create((set) => ({
  messages: [],
  addMessage: (msg) => set(...),
  clearMessages: () => set(...),
}));

// Agent state
const useAgentStore = create((set) => ({
  status: 'idle',
  currentModel: 'hermes-2',
  tools: [],
  updateStatus: (status) => set(...),
}));

// Terminal state
const useTerminalStore = create((set) => ({
  output: '',
  input: '',
  history: [],
  write: (text) => set(...),
}));
```

## Lifecycle Management

### App Startup

1. React Native app starts
2. Initialize storage (load config, history)
3. Start Termux environment
4. Spawn Python bridge process
5. Initialize Hermes agent in bridge
6. Ready for user input

### Agent Turn

1. User submits message
2. Bridge receives via RPC
3. Agent processes with tools
4. Stream events back to UI
5. Update local storage
6. Display in chat

### Shutdown

1. Close UI
2. Graceful bridge termination
3. Hermes agent saves state
4. Termux cleanup

## Performance Considerations

### Memory
- Python bridge: ~50-100MB
- Hermes agent: ~100-200MB
- UI layer: ~50-100MB
- **Total: ~300-500MB**

### Startup
- App launch: ~2s
- Bridge init: ~1s
- Hermes load: ~2-3s
- **Total: ~5-6s**

### Response Time
- Terminal command: <50ms
- Agent thinking: 1-5s (varies by model)
- Tool execution: 100ms-5s (depends on tool)

## Security Model

### Isolation
- Termux runs in Android sandbox
- Python bridge in separate process
- Tool execution sandboxed
- No privilege escalation

### Data
- All data stored locally
- API keys encrypted at rest
- No telemetry/analytics
- Optional cloud backup

## Extension Points

### Adding Tools

1. Implement in Python: `hermes-bridge/tools/`
2. Register in bridge: `register_tool()`
3. Add UI support in React: `src/components/ToolIndicator.tsx`

### Custom Models

1. Configure in `~/.hinata/config.json`
2. Update bridge provider list
3. Test in Settings → Model Selection

### New Screens

1. Create in `src/screens/`
2. Add route in `src/navigation/`
3. Add tab in bottom navigator
