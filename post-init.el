;;; post-init.el --- Personal config entry point for my minimal-emacs.d fork -*- no-byte-compile: t; lexical-binding: t; -*-

;;; Commentary:

;; This file intentionally stays small: it contains only the bootstrap that
;; loads the personal modules for the Emacs workflow.
;;
;; Design:
;; - keep upstream minimal-emacs.d files untouched
;; - keep personal modules under ~/.emacs.d/lisp/
;; - load modules explicitly so startup order is obvious
;; - keep generated or machine-local files out of git
;;
;; See docs/CONFIGURATION.md for the full module map and docs/AI-WORKFLOW.md
;; for the gptel/Copilot setup.

;;; Code:

(defconst my/personal-config-dir
  (expand-file-name "lisp/" user-emacs-directory)
  "Directory containing the personal Emacs Lisp modules.")

(defun my/load-personal-module (relative-path)
  "Load a personal configuration file from `my/personal-config-dir'."
  (load (expand-file-name relative-path my/personal-config-dir) nil t))

(my/load-personal-module "personal-core.el")
(my/load-personal-module "personal-completion.el")
(my/load-personal-module "personal-workflow.el")
(my/load-personal-module "personal-ai.el")

(provide 'post-init)
;;; post-init.el ends here
