;;; post-init.el --- Personal config entry point for my minimal-emacs.d fork -*- no-byte-compile: t; lexical-binding: t; -*-

;; This file intentionally stays small: it contains only the bootstrap that loads
;; the personal modules for the Emacs workflow. The upstream project files remain
;; untouched, while the custom logic is organized into separate, easier-to-manage
;; files under ~/.emacs.d/lisp/.

(defconst my/personal-config-dir
  (expand-file-name "lisp/" user-emacs-directory)
  "Directory containing the personal Emacs Lisp modules.")

(defun my/load-personal-module (relative-path)
  "Load a personal configuration file from `my/personal-config-dir'."
  (load (expand-file-name relative-path my/personal-config-dir) nil t))

(my/load-personal-module "personal-core.el")
(my/load-personal-module "personal-completion.el")
(my/load-personal-module "personal-workflow.el")

(provide 'post-init)
;;; post-init.el ends here
