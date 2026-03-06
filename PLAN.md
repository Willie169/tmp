# PLAN for IME-Aware Terminal

## Overview

The **IME-Aware Terminal** is an open source, IME-aware, multi-language friendly terminal emulator UI for SSH sessions on Android. The primary design goals are:

* Allow typing non-English language directly into terminal.
* Allow multiple SSH sessions.
* Automatically initiate SSH server on Termux with `com.termux.RUN_COMMAND` intent.
* Provide intent and socket for user to store and suggest IME languages, control terminal behavior, adjust app configurations, initiate SSH connections etc.
* With official Vim plugin **android\_ime.vim**, keep and restore IME language for each buffer separately when leaving/re-entering insert mode or search mode and suggest English to IME when entering normal node, visual mode, or command line mode for Vim and Neovim.

---

## Termux Integration

### Dedicated SSH Server

The project will launch a **separate SSH daemon instance** to avoid interfering with existing Termux SSH setups.

Configuration file:

```
~/.ime_aware_terminal/sshd_config
```

Key properties:

```
Port 8021 # customizable in app config
ListenAddress 127.0.0.1

PasswordAuthentication no
PubkeyAuthentication yes

AllowTcpForwarding no
AllowAgentForwarding no
X11Forwarding no

PermitTTY yes
```

### com.termux.RUN\_COMMAND Intent

Automatically start and stop server via `com.termux.RUN_COMMAND` intent.

---

## App Architecture

### Terminal Renderer

Reuse existing projects but with better support for non-Enlgish language.

### SSH Client

Use **sshj** library.

### Session Manager

Reuse existing projects. Each session is a SSH connection.

### IME Controller

Suggest IME language:

```
setImeHintLocales(Locale.forLanguageTags(<language_tag>))
```

Get current IME language:

```
getCurrentInputMethodSubtype().getLanguageTag()
```

Keep locale memory for external processes to read.

Only work with keyboard that respect these API, such as Gboard.

### Intent Receiver and Socket Listener

Receives signals from external processes to store and suggest IME languages, control terminal behavior, adjust app configurations, initiate SSH connections etc.

---

## ime\_android.vim Vim Plugin

### Mode Detection

Vim autocmd.

### Mode Change Event

Send intent (Termux only) or to socket (any SSH connection.

### Behavior

* Re-enter insert mode: Restore precious insert mode language.
* Leave insert mode: Keep current insert mode language.
* Re-enter search mode: Restore precious search mode language.
* Leave search mode: Keep current search mode language.
* Enter normal, visual, or command line mode: Suggest English.
