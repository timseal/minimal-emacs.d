;;; personal-core.el --- Foundation settings for my minimal-emacs.d fork -*- lexical-binding: t; no-byte-compile: t; -*-

;; Scope:
;; - startup and compile-time behavior
;; - default UI and theming
;; - environment sync for macOS
;; - file/session buffer defaults
;;
;; This module should stay small and stable. It contains the global foundation
;; that makes the rest of the personal config predictable and easy to maintain.

;;; ---------------------------------------------------------------------------
;;; Startup and package compilation
;;; ---------------------------------------------------------------------------

(use-package compile-angel
  :demand t
  :config
  (setq compile-angel-verbose t)
  (push "/init.el" compile-angel-excluded-files)
  (push "/early-init.el" compile-angel-excluded-files)
  (push "/pre-init.el" compile-angel-excluded-files)
  (push "/post-init.el" compile-angel-excluded-files)
  (push "/pre-early-init.el" compile-angel-excluded-files)
  (push "/post-early-init.el" compile-angel-excluded-files)
  (compile-angel-on-load-mode 1))

;;; ---------------------------------------------------------------------------
;;; UI and theming
;;; ---------------------------------------------------------------------------

(defun my/disable-all-themes ()
  "Disable every active theme before loading the chosen replacement theme."
  (dolist (theme custom-enabled-themes)
    (disable-theme theme)))

(defun my/apply-default-font ()
  "Apply the default editor font used in this personal setup."
  (set-face-attribute 'default nil
                      :height 130
                      :weight 'regular
                      :family "FiraCode Nerd Font Mono"))

(my/apply-default-font)

(use-package leuven-theme
  :config
  (my/disable-all-themes)
  (load-theme 'leuven t))

;;; ---------------------------------------------------------------------------
;;; Environment sync and file/session defaults
;;; ---------------------------------------------------------------------------

(use-package exec-path-from-shell
  :if (and (or (display-graphic-p) (daemonp))
           (eq system-type 'darwin))
  :demand t
  :functions exec-path-from-shell-initialize
  :config
  (dolist (var '("TMPDIR"
                 "SSH_AUTH_SOCK" "SSH_AGENT_PID"
                 "GPG_AGENT_INFO"
                 "LANG" "LC_CTYPE"))
    (add-to-list 'exec-path-from-shell-variables var))
  (exec-path-from-shell-initialize))

(use-package autorevert
  :ensure nil
  :init
  (setq auto-revert-interval 3
        auto-revert-remote-files nil
        auto-revert-use-notify t
        auto-revert-avoid-polling nil)
  (global-auto-revert-mode 1))

(use-package recentf
  :ensure nil
  :init
  (setq recentf-auto-cleanup (if (daemonp) 300 'never))
  (setq recentf-exclude
        (list "\\.tar$" "\\.tbz2$" "\\.tbz$" "\\.tgz$" "\\.bz2$"
              "\\.bz$" "\\.gz$" "\\.gzip$" "\\.xz$" "\\.zip$"
              "\\.7z$" "\\.rar$"
              "COMMIT_EDITMSG\\'"
              "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
              "-autoloads\\.el$" "autoload\\.el$"))
  (recentf-mode 1)
  :config
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90))

(use-package savehist
  :ensure nil
  :init
  (setq history-length 300
        savehist-autosave-interval 600)
  (savehist-mode 1))

(use-package saveplace
  :ensure nil
  :init
  (setq save-place-limit 400)
  (save-place-mode 1))

(setq auto-save-default t
      auto-save-interval 300
      auto-save-timeout 30)

;;; ---------------------------------------------------------------------------
;;; File and buffer defaults
;;; ---------------------------------------------------------------------------

(use-package buffer-terminator
  :init
  (setq buffer-terminator-verbose nil
        buffer-terminator-inactivity-timeout (* 30 60)
        buffer-terminator-interval (* 10 60))
  (buffer-terminator-mode 1))

(provide 'personal-core)
;;; personal-core.el ends here
