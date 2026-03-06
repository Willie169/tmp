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
* Work with **android\_ime\_aware\_terminal.vim** to keep and restore IME language for each buffer separately when leaving/re-entering insert mode or search mode and suggest English to IME when entering normal node, visual mode, or command line mode, in Vim and Neovim.

## Termux Integration

### Dependency Installation

Provide an intent and a button to install and update dependencies of this app on Termux automatically via `com.termux.RUN_COMMAND` intent.

### SSH Daemon

The project will launch a separate SSH daemon instance with configurable default `sshd_config` via `com.termux.RUN_COMMAND` intent to avoid interfering with existing Termux SSH setups.

When the app is closed with no active Termux session running, stop SSH daemon via `com.termux.RUN_COMMAND` intent.

### Configurable Intent Sending

User can configure the app to send specific `com.termux.RUN_COMMAND` intents on certain events.

## App Architecture

### Terminal Renderer

Provide different Terminal mode

### SSH Client

Reuse [ConnectBot](https://github.com/connectbot/connectbot).

### Session Manager

Reuse existing projects such as Termux.

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
* Environmental variable `IME_AWARE_TERMINAL_VERSION` (injected as current IME-Aware Terminal version string on SSH session start by default) is not set.
* Vim variable `g:android_ime_aware_terminal` (set to 1 by the plugin if not exists) is set to 0.
* Intent, Unix socket, and TCP socket are all unavailable.

### Mode Change Event

Use Vim autocmd to detect mode change events and
- Send intent (Termux only) or
- Send to socket (any SSH connection).

### Behavior

* Re-enter insert mode: Restore precious insert mode language.
* Leave insert mode: Keep current insert mode language.
* Re-enter search mode: Restore precious search mode language.
* Leave search mode: Keep current search mode language.
* Enter normal, visual, or command line mode: Suggest English.
