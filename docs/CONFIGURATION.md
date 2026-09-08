# Personal Emacs Configuration

This repository is a personal fork of
[`jamescherti/minimal-emacs.d`](https://github.com/jamescherti/minimal-emacs.d).
The upstream files stay intact, and personal customizations live in small
modules under `lisp/`.

## Startup flow

Emacs loads the upstream minimal-emacs.d files first:

1. `pre-early-init.el` applies local early-startup preferences.
2. `early-init.el` applies upstream startup optimizations.
3. `init.el` applies upstream defaults and package setup.
4. `post-init.el` loads the personal modules.

`post-init.el` is intentionally a thin loader. The actual personal config is
split by responsibility so it is easier to audit and change.

## Module map

| File | Purpose |
|---|---|
| `lisp/personal-core.el` | Foundation settings: compilation, UI, theme, macOS environment sync, recent files, history, save place, autosave, buffer cleanup |
| `lisp/personal-completion.el` | Completion and discoverability: Corfu, Cape, Vertico, Orderless, Marginalia, Embark, Consult, undo/session persistence, tab-line, Markdown support |
| `lisp/personal-workflow.el` | Daily editing workflow: folding, formatting, whitespace cleanup, diff indicators, Org, Eglot, Treemacs, Helpful, buffer file operations, vterm, scrolling, package updates |
| `lisp/personal-ai.el` | AI-assisted workflow: gptel backed by GitHub CopilotChat and Copilot inline ghost-text completions |

## Design principles

- Keep upstream `init.el` and `early-init.el` untouched so upstream updates stay
  easy to merge.
- Keep personal modules named by workflow area, not by package.
- Prefer built-in Emacs features when they satisfy the need, such as
  `tab-line-mode` for editor-style tabs.
- Avoid storing credentials or tokens in the repository.
- Use `C-c a` as the AI prefix so AI commands are easy to find and do not
  collide with normal completion bindings.

## Editor tabs

The config uses built-in `global-tab-line-mode` for VS Code-like editor tabs.
This shows open buffers as tabs at the top of each window without adding another
package dependency.

The existing `vim-tab-bar` configuration is still used for Emacs tab-bar
behavior. In practical terms:

- `tab-line` is for visible buffer tabs, similar to editor tabs.
- `tab-bar` is for workspace-like tabs.

## Completion

The completion setup has two layers:

- Corfu and Cape provide in-buffer completion popups.
- Vertico, Orderless, Marginalia, Embark, and Consult provide minibuffer
  completion, narrowing, search, and action workflows.

Corfu is configured to show choices automatically after a short delay and to
display popup documentation when available.

## Maintenance notes

When adding a new area of configuration, prefer one of these approaches:

1. Add it to the existing module if it clearly belongs there.
2. Create a new `lisp/personal-*.el` module if it represents a new workflow.
3. Add a short section to this document when the new behavior is user-visible or
   changes how the config should be maintained.

