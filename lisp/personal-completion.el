;;; personal-completion.el --- Completion and minibuffer workflow -*- lexical-binding: t; no-byte-compile: t; -*-

;; Scope:
;; - in-buffer completion and minibuffer navigation
;; - command discovery and search
;; - undo/session persistence and tab management
;; - Markdown support and note-taking conveniences
;;
;; This module is intentionally focused on the interactive, "discoverability"
;; layer of Emacs. Keep it opinionated and compact.

;;; ---------------------------------------------------------------------------
;;; Completion stack
;;; ---------------------------------------------------------------------------

(use-package corfu
  :bind (:map corfu-map
              ("TAB" . corfu-next)
              ([tab] . corfu-next)
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous)
              ("RET" . corfu-insert))
  :init
  (setq text-mode-ispell-word-completion nil
        read-extended-command-predicate #'command-completion-default-include-p
        tab-always-indent 'complete
        corfu-auto t
        corfu-auto-delay 0.2
        corfu-auto-prefix 2
        corfu-cycle t
        corfu-on-exact-match nil
        corfu-preselect 'prompt
        corfu-quit-no-match 'separator
        corfu-popupinfo-delay '(0.5 . 0.2))
  (global-corfu-mode 1)
  :config
  (corfu-popupinfo-mode 1))

(use-package cape
  :commands (cape-dabbrev cape-file cape-elisp-block)
  :bind ("C-c p" . cape-prefix-map)
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

(use-package vertico
  :init
  (vertico-mode 1))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-overrides '((file (styles partial-completion)))
        completion-pcm-leading-wildcard t))

(use-package marginalia
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode 1))

(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult)

(use-package consult
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x t b" . consult-buffer-other-tab)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ("M-y" . consult-yank-pop)
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ("M-s d" . consult-find)
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))
  :init
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5
        xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<"))

;;; ---------------------------------------------------------------------------
;;; Undo, session, and tabs
;;; ---------------------------------------------------------------------------

(use-package undo-fu
  :commands (undo-fu-only-undo
             undo-fu-only-redo
             undo-fu-only-redo-all
             undo-fu-disable-checkpoint)
  :init
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") #'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") #'undo-fu-only-redo))

(use-package undo-fu-session
  :init
  (undo-fu-session-global-mode 1))

(use-package vim-tab-bar
  :init
  (vim-tab-bar-mode 1))

(use-package tab-line
  :ensure nil
  :init
  (setq tab-line-close-button-show t
        tab-line-new-button-show nil
        tab-line-separator " "
        tab-line-switch-cycling t)
  (global-tab-line-mode 1))

(use-package easysession
  :demand t
  :config
  (setq easysession-save-interval (* 10 60)
        easysession-switch-to-save-session t
        easysession-switch-to-exclude-current nil
        easysession-setup-load-session t)
  (easysession-setup))

;;; ---------------------------------------------------------------------------
;;; Markdown support
;;; ---------------------------------------------------------------------------

(use-package markdown-mode
  :commands (gfm-mode
             gfm-view-mode
             markdown-mode
             markdown-view-mode)
  :mode (("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode))
  :bind (:map markdown-mode-map
              ("C-c C-e" . markdown-do)))

(use-package markdown-toc
  :init
  (setq markdown-toc-header-toc-title "**Table of Contents**"))

(provide 'personal-completion)
;;; personal-completion.el ends here
