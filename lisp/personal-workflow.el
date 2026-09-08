;;; personal-workflow.el --- Daily editing, navigation, and terminal workflow -*- lexical-binding: t; no-byte-compile: t; -*-

;; Scope:
;; - code folding and editing aids
;; - source-control and whitespace feedback
;; - project navigation and help tools
;; - terminal emulation and scrolling behavior
;; - package maintenance and final polish
;;
;; This is the largest module because it covers the day-to-day coding workflow.
;; Keep the individual sections intentionally grouped around activity, not by
;; package name alone.

(eval-when-compile
  (require 'use-package))

;;; ---------------------------------------------------------------------------
;;; Folding and code navigation
;;; ---------------------------------------------------------------------------

(use-package kirigami
  :commands (kirigami-open-fold
             kirigami-open-fold-rec
             kirigami-close-fold
             kirigami-toggle-fold
             kirigami-open-folds
             kirigami-close-folds-except-current
             kirigami-close-folds)
  :bind
  (("C-c z o" . kirigami-open-fold)
   ("C-c z O" . kirigami-open-fold-rec)
   ("C-c z r" . kirigami-open-folds)
   ("C-c z c" . kirigami-close-fold)
   ("C-c z m" . kirigami-close-folds)
   ("C-c z a" . kirigami-toggle-fold))
  :custom
  (kirigami-show-menu-bar t)
  (kirigami-show-context-menu t)
  :init
  (kirigami-global-mode 1))

(use-package outline
  :ensure nil
  :commands outline-minor-mode
  :hook (((outline-minor-mode)
          .
          (lambda ()
            (let* ((display-table (or buffer-display-table (make-display-table)))
                   (face-offset (* (face-id 'shadow) (ash 1 22)))
                   (value (vconcat (mapcar (lambda (c) (+ face-offset c)) " ▼"))))
              (set-display-table-slot display-table 'selective-display value)
              (setq buffer-display-table display-table)))))
  :config
  (add-hook 'emacs-lisp-mode-hook #'outline-minor-mode)
  (add-hook 'lisp-mode-hook #'outline-minor-mode)
  (add-hook 'conf-mode-hook #'outline-minor-mode)
  (add-hook 'markdown-mode-hook #'outline-minor-mode)
  (add-hook 'diff-mode-hook #'outline-minor-mode)
  (add-hook 'c-mode-hook #'hs-minor-mode)
  (add-hook 'c++-mode-hook #'hs-minor-mode)
  (add-hook 'java-mode-hook #'hs-minor-mode)
  (add-hook 'sh-mode-hook #'hs-minor-mode)
  (add-hook 'html-mode-hook #'hs-minor-mode))

(use-package outline-indent
  :commands outline-indent-minor-mode
  :init
  (setq outline-indent-ellipsis " ▼")
  :config
  (add-hook 'python-mode-hook #'outline-indent-minor-mode)
  (add-hook 'python-ts-mode-hook #'outline-indent-minor-mode)
  (add-hook 'yaml-mode-hook #'outline-indent-minor-mode)
  (add-hook 'yaml-ts-mode-hook #'outline-indent-minor-mode)
  (add-hook 'haskell-mode-hook #'outline-indent-minor-mode))

(use-package treesit-fold
  :commands (treesit-fold-close
             treesit-fold-close-all
             treesit-fold-open
             treesit-fold-toggle
             treesit-fold-open-all
             treesit-fold-mode
             global-treesit-fold-mode
             treesit-fold-open-recursively
             treesit-fold-line-comment-mode)
  :init
  (setq treesit-fold-line-count-show t
        treesit-fold-line-count-format " ▼")
  :config
  (set-face-attribute 'treesit-fold-replacement-face nil
                      :foreground "#808080"
                      :box nil
                      :weight 'bold)
  (add-hook 'c-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'c++-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'php-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'css-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'html-ts-mode-hook #'treesit-fold-mode)
  (add-hook 'bash-ts-mode-hook #'treesit-fold-mode))

;;; ---------------------------------------------------------------------------
;;; Formatting and whitespace cleanup
;;; ---------------------------------------------------------------------------

(use-package apheleia
  :commands (apheleia-mode apheleia-global-mode)
  :hook ((prog-mode . apheleia-mode)))

(use-package stripspace
  :commands stripspace-local-mode
  :hook ((prog-mode . stripspace-local-mode)
         (text-mode . stripspace-local-mode)
         (conf-mode . stripspace-local-mode))
  :init
  (setq stripspace-only-if-initially-clean nil
        stripspace-restore-column t))

;;; ---------------------------------------------------------------------------
;;; Source-control and editing feedback
;;; ---------------------------------------------------------------------------

(use-package diff-hl
  :commands (diff-hl-mode global-diff-hl-mode)
  :hook (prog-mode . diff-hl-mode)
  :init
  (setq diff-hl-flydiff-delay 0.4
        diff-hl-show-staged-changes nil
        diff-hl-update-async t
        diff-hl-global-modes '(not pdf-view-mode image-mode)))

;;; ---------------------------------------------------------------------------
;;; Org and LSP
;;; ---------------------------------------------------------------------------

(use-package org
  :commands (org-mode org-version)
  :mode ("\\.org\\'" . org-mode)
  :init
  (setq org-hide-leading-stars t
        org-startup-indented t
        org-adapt-indentation nil
        org-edit-src-content-indentation 0
        org-startup-truncated t))

(use-package org-appear
  :commands org-appear-mode
  :hook (org-mode . org-appear-mode))

(use-package eglot
  :ensure nil
  :commands (eglot-ensure eglot-rename eglot-format-buffer))

;;; ---------------------------------------------------------------------------
;;; Project structure and file tools
;;; ---------------------------------------------------------------------------

(use-package treemacs
  :commands (treemacs
             treemacs-select-window
             treemacs-delete-other-windows
             treemacs-select-directory
             treemacs-bookmark
             treemacs-find-file
             treemacs-find-tag)
  :bind
  (:map global-map
        ("M-0" . treemacs-select-window)
        ("C-x t 1" . treemacs-delete-other-windows)
        ("C-x t t" . treemacs)
        ("C-x t d" . treemacs-select-directory)
        ("C-x t B" . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag))
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (setq treemacs-collapse-dirs (if treemacs-python-executable 3 0)
        treemacs-deferred-git-apply-delay 0.5
        treemacs-directory-name-transformer #'identity
        treemacs-display-in-side-window t
        treemacs-eldoc-display 'simple
        treemacs-file-event-delay 2000
        treemacs-file-extension-regex treemacs-last-period-regex-value
        treemacs-file-follow-delay 0.2
        treemacs-file-name-transformer #'identity
        treemacs-follow-after-init t
        treemacs-expand-after-init t
        treemacs-find-workspace-method 'find-for-file-or-pick-first
        treemacs-git-command-pipe ""
        treemacs-goto-tag-strategy 'refetch-index
        treemacs-header-scroll-indicators '(nil . "^^^^^^")
        treemacs-hide-dot-git-directory t
        treemacs-indentation 2
        treemacs-indentation-string " "
        treemacs-is-never-other-window nil
        treemacs-max-git-entries 5000
        treemacs-missing-project-action 'ask
        treemacs-move-files-by-mouse-dragging t
        treemacs-move-forward-on-expand nil
        treemacs-no-png-images nil
        treemacs-no-delete-other-windows t
        treemacs-project-follow-cleanup nil
        treemacs-persist-file (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
        treemacs-position 'left
        treemacs-read-string-input 'from-child-frame
        treemacs-recenter-distance 0.1
        treemacs-recenter-after-file-follow nil
        treemacs-recenter-after-tag-follow nil
        treemacs-recenter-after-project-jump 'always
        treemacs-recenter-after-project-expand 'on-distance
        treemacs-litter-directories '("/node_modules" "/.venv" "/.cask")
        treemacs-project-follow-into-home nil
        treemacs-show-cursor nil
        treemacs-show-hidden-files t
        treemacs-silent-filewatch nil
        treemacs-silent-refresh nil
        treemacs-sorting 'alphabetic-asc
        treemacs-select-when-already-in-treemacs 'move-back
        treemacs-space-between-root-nodes t
        treemacs-tag-follow-cleanup t
        treemacs-tag-follow-delay 1.5
        treemacs-text-scale nil
        treemacs-user-mode-line-format nil
        treemacs-user-header-line-format nil
        treemacs-wide-toggle-width 70
        treemacs-width 35
        treemacs-width-increment 1
        treemacs-width-is-initially-locked t
        treemacs-workspace-switch-cleanup nil)
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always)
  (pcase (cons (not (null (executable-find "git")))
               (not (null treemacs-python-executable)))
    (`(t . t)
     (treemacs-git-mode 'deferred))
    (`(t . _)
     (treemacs-git-mode 'simple)))
  (treemacs-hide-gitignored-files-mode nil))

(use-package helpful
  :commands (helpful-callable
             helpful-variable
             helpful-key
             helpful-command
             helpful-at-point
             helpful-function)
  :bind
  ([remap describe-command] . helpful-command)
  ([remap describe-function] . helpful-callable)
  ([remap describe-key] . helpful-key)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  :init
  (setq helpful-max-buffers 7))

(use-package bufferfile
  :commands (bufferfile-copy
             bufferfile-rename
             bufferfile-delete)
  :init
  (setq bufferfile-verbose nil
        bufferfile-use-vc nil
        bufferfile-delete-switch-to 'parent-directory))

(use-package persist-text-scale
  :init
  (setq text-scale-mode-step 1.07)
  (persist-text-scale-mode 1))

;;; ---------------------------------------------------------------------------
;;; Terminal and scrolling
;;; ---------------------------------------------------------------------------

(use-package vterm
  :if (bound-and-true-p module-file-suffix)
  :commands (vterm
             vterm-send-string
             vterm-send-return
             vterm-send-key
             vterm-module-compile)
  :preface
  (when noninteractive
    (advice-add #'vterm-module-compile :override #'ignore))
  (defun my-vterm--setup ()
    (setq mode-line-format nil
          hscroll-margin 0
          confirm-kill-processes nil))
  :init
  (add-hook 'vterm-mode-hook #'my-vterm--setup)
  (setq vterm-timer-delay 0.05
        vterm-kill-buffer-on-exit t
        vterm-max-scrollback 5000))

(unless (and (eq window-system 'mac)
             (bound-and-true-p mac-carbon-version-string))
  (setq pixel-scroll-precision-use-momentum nil)
  (pixel-scroll-precision-mode 1))

;;; ---------------------------------------------------------------------------
;;; Package maintenance and final polish
;;; ---------------------------------------------------------------------------

(use-package auto-package-update
  :ensure t
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-hide-results t)
  (auto-package-update-delete-old-versions t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "10:00"))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package rainbow-delimiters)

(provide 'personal-workflow)
;;; personal-workflow.el ends here
