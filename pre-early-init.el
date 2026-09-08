;;; pre-early-init.el --- Personal startup tweaks for my minimal-emacs.d fork -*- no-byte-compile: t; lexical-binding: t; -*-

;; Keep debug mode off during normal startup and only enable it when Emacs is
;; launched with --debug-init. This preserves a quiet startup while still making
;; configuration problems easy to diagnose when needed.
(setq debug-on-error init-file-debug)

;; Follow the minimal-emacs.d recommendation to enable the menu bar, dialogs,
;; contextual menu, and tooltips while keeping the rest of the base defaults.
;; See: https://github.com/jamescherti/minimal-emacs.d#how-to-enable-the-menu-bar-the-tool-bar-dialogs-the-contextual-menu-and-tooltips
(setq minimal-emacs-ui-features '(context-menu menu-bar dialogs tooltips))
