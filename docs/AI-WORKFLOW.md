# AI Workflow

AI tooling lives in `lisp/personal-ai.el`.

The setup intentionally separates two different AI jobs:

- **gptel** handles chat, region prompts, rewriting, and longer conversations.
- **copilot.el** handles inline ghost-text completions while editing code.

Both are grouped under the `C-c a` prefix.

## gptel with GitHub CopilotChat

`gptel` is configured to use GitHub CopilotChat:

```elisp
(setq gptel-model 'claude-3.7-sonnet
      gptel-backend (gptel-make-gh-copilot "Copilot"))
```

This uses gptel's GitHub Copilot backend rather than an API key stored in this
repository.

### Login

Run this inside Emacs:

```text
M-x gptel-gh-login
```

Bound shortcut:

```text
C-c a l
```

## Copilot inline completion

`copilot.el` is installed with Emacs 31's `use-package :vc` support:

```elisp
(use-package copilot
  :vc (:url "https://github.com/copilot-emacs/copilot.el"
       :rev :newest
       :branch "main"))
```

This avoids adding MELPA only for Copilot.

### First-time setup

Inside Emacs:

```text
M-x copilot-install-server
M-x copilot-login
```

Bound shortcuts:

```text
C-c a i  install the Copilot server
C-c a L  log in to Copilot
C-c a d  diagnose Copilot
```

## Keybindings

| Key | Command | Purpose |
|---|---|---|
| `C-c a g` | `gptel` | Open a gptel chat buffer |
| `C-c a s` | `gptel-send` | Send the active region or current prompt |
| `C-c a m` | `gptel-menu` | Open gptel's transient menu |
| `C-c a l` | `gptel-gh-login` | Authenticate gptel with GitHub Copilot |
| `C-c a c` | `copilot-complete` | Request an inline Copilot suggestion |
| `C-c a L` | `copilot-login` | Authenticate copilot.el |
| `C-c a i` | `copilot-install-server` | Install the Copilot language server |
| `C-c a d` | `copilot-diagnose` | Diagnose Copilot setup |
| `C-c a a` | `copilot-accept-completion` | Accept a visible Copilot suggestion |
| `C-c a w` | `copilot-accept-completion-by-word` | Accept one word from a suggestion |
| `C-c a n` | `copilot-next-completion` | Show the next Copilot suggestion |
| `C-c a p` | `copilot-previous-completion` | Show the previous Copilot suggestion |
| `C-c a q` | `copilot-clear-overlay` | Clear the visible suggestion |

## Why not bind Copilot to TAB?

Corfu already uses `TAB` and `S-TAB` inside its popup completion map. Copilot
suggestions are therefore bound under `C-c a` to avoid ambiguity between:

- completing from a local completion-at-point candidate, and
- accepting AI-generated ghost text.

This is less magical than editor-style TAB acceptance, but it is easier to debug
and keeps ordinary completion predictable.

## Credentials

Do not put Copilot tokens, API keys, or OAuth results in this repository. Let
gptel and copilot.el store authentication through their normal Emacs/package
mechanisms.

