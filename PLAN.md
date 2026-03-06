# PLAN.md for IME-Aware Terminal

## Overview

**IME-Aware Terminal** is an open source, IME-aware, multi-language friendly terminal emulator UI for SSH sessions on Android. The primary design goals of **IME-Aware Terminal** and accompanying Vim plugin **android_ime_aware_terminal.vim** are:
* Provide a **non-Latin language** toggle for terminal session where non-Latin language can be typed directly into terminal when enabled.
* Provide a **keyboard suggestion** toggle for terminal where keyboard suggestion is allowed when enabled.
* Provide a **buffering** toggle for terminal session where inputs are buffered and sent when a send button is clicked and enter is treated as literal newline.
* Support multiple sessions. Each session is a SSH session.
* Run configured commands on SSH session start, such as environmental variables injection.
* Configurable app behavior.
* Automatically initiate SSH server on Termux with `com.termux.RUN_COMMAND` intent.
* Provide intents and socket for user to view IME languages history, suggest IME languages, control session toggles, adjust app configurations, initiate SSH connections etc.
* Work with **android\_ime\_aware\_terminal.vim** to achieve IME language switching similar to [fcitx.vim](https://github.com/lilydjwg/fcitx.vim) in Vim/Neovim.

## Termux Integration

### Dependency Installation

Provide an intent and a button to install and update dependencies of this app on Termux automatically via `com.termux.RUN_COMMAND` intent.

### SSH Daemon

The project will launch a separate SSH daemon instance with configurable default `sshd_config` via `com.termux.RUN_COMMAND` intent to avoid interfering with existing Termux SSH setups.

When the app is closed with no active Termux session running, stop SSH daemon via `com.termux.RUN_COMMAND` intent.

### Configurable Intent Sending

User can configure the app to send specific `com.termux.RUN_COMMAND` intents on certain events.

## App Architecture

### Terminal

Based on Termux `terminal-view` and `terminal-emulator`.

### SSH Client

Based on [ConnectBot](https://github.com/connectbot/connectbot).

User can configure commands to run on SSH session start. By default, the following environmental variables are injected at a SSH session start:
- `IME_AWARE_TERMINAL_VERSION`: Current IME-Aware Terminal app version string.
- `IME_AWARE_TERMINAL_CODE`: Current IME-Aware Terminal app version code.
- `IME_AWARE_TERMINAL_SOCKET`: Listening socket.
- `IME_AWARE_TERMINAL_SESSION_UUID`: The uuid of current session, no changes in the entire session, can be used in intent and socket to specify sessions.
- `IME_AWARE_TERMINAL_SESSION_NUMBER`: The number of current session (1 means first and so on), can change during session, can be used in intent and socket to specify sessions.
- `IME_AWARE_TERMINAL_SESSION_DISTINATION`: The SSH destination of current session.

### IME Controller

Suggest IME language:

```
setImeHintLocales(Locale.forLanguageTags(<language_tag>))
```

Get current IME language:

```
getCurrentInputMethodSubtype().getLanguageTag()
```

Keep IME languages history for external processes to read via intent.

### Intent Receiver

Receive intents from external processes.

### Socket Listener

Listen to external requests to Unix domain socket or TCP socket.

## android\_ime\_aware\_terminal.vim

### Fast Finish

Fast finish if either:
* Environmental variable `IME_AWARE_TERMINAL_VERSION` is not set.
* Vim variable `g:android_ime_aware_terminal` (set to 1 by the plugin if not exists) is set to 0.
* Intent, Unix socket, and TCP socket are all unavailable.

### Mode Change Event

Use Vim autocmd to detect mode change events and
- Send intent (Termux only) or
- Send to TCP socket (any SSH connection).

### Behavior

* First enter insert or search mode: Suggest a default language if set by user, do nothing otherwise.
* Re-enter insert or search mode: Restore previous language.
* Leave insert or search mode: Keep current language.
* Enter normal, visual, or command line mode: Suggest English.
