# PLAN.md

## IME-Aware Terminal Frontend for Termux

## 1. Project Overview

This project builds a **custom Android terminal application** designed specifically for **modal editors (Vim/Neovim)** and **multilingual input workflows**.

The terminal app will function as a **frontend UI** while delegating all command execution to the existing **Termux environment**.

Execution is performed by connecting to a **dedicated local SSH server running inside Termux**, ensuring:

* no modification of Termux
* full compatibility with existing Termux packages
* complete control over the terminal UI and Android IME behavior

The primary goal is to enable **IME-aware editing workflows**, allowing the terminal to automatically suggest keyboard language changes depending on Vim mode.

Example:

| Vim Mode | Suggested Keyboard     |
| -------- | ---------------------- |
| Insert   | User’s native language |
| Normal   | English                |
| Command  | English                |

---

# 2. Design Goals

## Functional Goals

* Provide a **modern terminal emulator UI on Android**
* Seamlessly use the **Termux runtime**
* Support **Vim/Neovim modal editing workflows**
* Provide **automatic IME language suggestions**
* Enable **external signaling from Vim plugins**
* Allow **multiple terminal sessions**

## Non-Functional Goals

* No modification of Termux core
* Secure by default
* Low latency
* Modular architecture
* Easily extensible

---

# 3. System Architecture

```
+------------------------------------+
| Android Terminal App               |
|------------------------------------|
| Terminal Renderer                  |
| IME Controller                     |
| Session Manager                    |
| SSH Client                         |
| Intent Receiver                    |
| Plugin API                         |
+------------------+-----------------+
                   |
                   | SSH (127.0.0.1)
                   |
+------------------v-----------------+
| Termux Runtime                      |
|------------------------------------|
| Dedicated sshd instance             |
| PTY                                |
| bash/zsh                           |
| vim / neovim                       |
| packages                           |
+------------------------------------+
```

---

# 4. Execution Model

Execution occurs entirely inside Termux.

The frontend app connects via SSH:

```
Terminal UI
    ↓
SSH channel
    ↓
Termux sshd
    ↓
PTY
    ↓
Shell
```

This avoids:

* Android sandbox restrictions
* shared UID hacks
* filesystem permission issues

---

# 5. Termux Integration

## Dedicated SSH Server

The project will launch a **separate SSH daemon instance** to avoid interfering with existing Termux SSH setups.

Example configuration:

```
~/.termuxvim/sshd_config
```

Key properties:

| Setting                | Value     |
| ---------------------- | --------- |
| Port                   | 8023      |
| ListenAddress          | 127.0.0.1 |
| PasswordAuthentication | no        |
| PubkeyAuthentication   | yes       |

Example config:

```
Port 8023
ListenAddress 127.0.0.1

HostKey ~/.ssh/ssh_host_ed25519_key

PasswordAuthentication no
PubkeyAuthentication yes

AllowTcpForwarding no
AllowAgentForwarding no
X11Forwarding no

PermitTTY yes
```

---

## SSH Key Setup

A dedicated keypair will be used for authentication.

```
~/.termuxvim/app_key
~/.termuxvim/app_key.pub
```

The public key is added to:

```
~/.ssh/authorized_keys
```

---

# 6. Android Terminal App Architecture

## Core Modules

### Terminal Renderer

Responsible for:

* ANSI/VT100 parsing
* screen buffer
* scrollback
* cursor state
* rendering

Implementation options:

* reuse **Termux TerminalView**
* integrate **libvterm**
* build custom renderer

---

### SSH Client

Handles:

* SSH handshake
* channel creation
* PTY allocation
* data streaming

Recommended library:

* **sshj**

---

### Session Manager

Responsible for:

* managing multiple terminal sessions
* session lifecycle
* reconnect logic
* session persistence

---

### IME Controller

Manages keyboard behavior.

Primary API:

```
setImeHintLocales()
```

Responsibilities:

* update keyboard language hints
* remember previous IME locale
* restore locale when entering insert mode

---

### Intent Receiver

Receives signals from external processes.

Example intent:

```
dev.termuxvim.IME_MODE
```

Payload example:

```
mode=insert
mode=normal
mode=command
```

---

### Plugin API

Allows external programs to control terminal behavior.

Communication methods:

* Android intents
* Unix socket
* HTTP localhost
* Neovim RPC

---

# 7. Vim / Neovim Integration

## Basic Mode Detection

Vim autocmd example:

```
autocmd InsertEnter * call system("vim-ime insert")
autocmd InsertLeave * call system("vim-ime normal")
```

Helper script:

```
vim-ime insert
```

Broadcasts:

```
am broadcast -a dev.termuxvim.IME_MODE --es mode insert
```

---

## Mode Behavior

| Mode             | Action               |
| ---------------- | -------------------- |
| InsertEnter      | restore previous IME |
| InsertLeave      | suggest English      |
| CommandLineEnter | suggest English      |

---

## Neovim RPC Integration (Future)

Neovim exposes a socket:

```
nvim --listen /tmp/nvim
```

The terminal can subscribe to:

* `mode_change`
* `cursor_move`
* `buffer_enter`

This allows real-time IME control.

---

# 8. IME Language Memory

The terminal will track:

```
previous_insert_locale
current_locale
```

Example flow:

```
InsertEnter
    restore previous locale

InsertLeave
    store current locale
    suggest English
```

---

# 9. Security Design

Security measures include:

* localhost-only SSH server
* key-only authentication
* dedicated port
* disabled forwarding

Optional hardening:

```
AllowUsers <termux-user>
MaxAuthTries 2
LoginGraceTime 10
```

---

# 10. Performance

Local SSH latency is minimal.

Expected overhead:

| Component       | Latency  |
| --------------- | -------- |
| SSH transport   | <1 ms    |
| Terminal render | dominant |

Optimizations:

* persistent SSH connection
* efficient screen diff rendering

---

# 11. Development Phases

## Phase 1 — Prototype

* basic Android terminal UI
* SSH connection to Termux
* single session
* simple rendering

---

## Phase 2 — Stable Terminal

* full ANSI support
* scrollback buffer
* copy/paste
* resizing

---

## Phase 3 — IME Integration

* keyboard locale hints
* Vim mode switching
* locale memory

---

## Phase 4 — Plugin Ecosystem

* intent API
* CLI helper tools
* Vim plugin

---

## Phase 5 — Advanced Features

* Neovim RPC integration
* multi-session manager
* gesture navigation
* improved CJK input

---

# 12. Future Enhancements

Potential improvements:

* IME composition-aware rendering
* inline candidate window support
* syntax-aware keyboard hints
* collaborative terminals
* remote SSH support

---

# 13. Expected Outcome

The project will deliver:

* a **high-quality Android terminal optimized for Vim**
* seamless integration with Termux
* significantly improved multilingual editing experience

This addresses long-standing issues with **IME handling in terminal environments on mobile devices**.

---

# 14. Summary

This architecture combines:

* Termux runtime stability
* SSH protocol reliability
* custom terminal UI flexibility

to produce a **modern, IME-aware terminal environment for Android modal editing workflows**.

The design is secure, extensible, and avoids modification of existing infrastructure.
