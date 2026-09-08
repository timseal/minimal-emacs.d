;;; personal-ai.el --- AI-assisted editing and chat workflow -*- lexical-binding: t; no-byte-compile: t; -*-

;;; Commentary:
;;
;; This module configures AI-assisted editing while keeping AI behavior isolated
;; from the regular completion and coding workflow modules.
;;
;; Scope:
;; - gptel chat and region commands backed by GitHub CopilotChat
;; - Copilot inline ghost-text completions for programming buffers
;; - keybindings that avoid conflicting with Corfu's popup completion keys
;;
;; Use `C-c a' as the shared AI prefix:
;; - `C-c a g' opens a gptel chat buffer
;; - `C-c a s' sends the active region or current prompt with gptel
;; - `C-c a m' opens gptel's transient menu
;; - `C-c a l' logs in to gptel's GitHub Copilot backend
;; - `C-c a c' requests an inline Copilot completion at point
;;
;; See docs/AI-WORKFLOW.md for setup, authentication, and command usage.

;;; Code:

;;; ---------------------------------------------------------------------------
;;; Chat and region prompts
;;; ---------------------------------------------------------------------------

(use-package gptel
  :ensure t
  :commands (gptel
             gptel-send
             gptel-menu
             gptel-gh-login)
  :functions gptel-make-gh-copilot
  :bind (("C-c a g" . gptel)
         ("C-c a s" . gptel-send)
         ("C-c a m" . gptel-menu)
         ("C-c a l" . gptel-gh-login))
  :config
  (setq gptel-model 'claude-3.7-sonnet
        gptel-backend (gptel-make-gh-copilot "Copilot")))

;;; ---------------------------------------------------------------------------
;;; Inline code suggestions
;;; ---------------------------------------------------------------------------

(use-package copilot
  :vc (:url "https://github.com/copilot-emacs/copilot.el"
       :rev :newest
       :branch "main")
  :commands (copilot-mode
             copilot-complete
             copilot-login
             copilot-diagnose
             copilot-install-server)
  :hook (prog-mode . copilot-mode)
  :bind (("C-c a c" . copilot-complete)
         ("C-c a L" . copilot-login)
         ("C-c a d" . copilot-diagnose)
         ("C-c a i" . copilot-install-server)
         :map copilot-completion-map
         ("C-c a a" . copilot-accept-completion)
         ("C-c a w" . copilot-accept-completion-by-word)
         ("C-c a n" . copilot-next-completion)
         ("C-c a p" . copilot-previous-completion)
         ("C-c a q" . copilot-clear-overlay)))

(provide 'personal-ai)
;;; personal-ai.el ends here
