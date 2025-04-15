;; setup-emacs.el --- Automated Emacs Configuration Setup

;; Initialize package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Ensure use-package is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Performance optimizations
(setq gc-cons-threshold (* 100 1024 1024))  ;; Increase GC threshold
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 2 1024 1024))))  ;; Restore after startup

;; Load Catppuccin theme
(use-package catppuccin-theme
  :config
  (setq catppuccin-flavor 'mocha)
  (load-theme 'catppuccin t))

;; Enable relative line numbers
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

;; Set a nicer font with an increased size.
;; The :height value is in 1/10th pt. For example, 130 means 13pt.
(set-face-attribute 'default nil :family "Fira Code" :height 200)


;; Disable menu, tool, and scroll bars for a minimalist UI.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Python Development Setup
(use-package lsp-mode
  :hook (python-mode . lsp)
  :config
  (setq lsp-idle-delay 0.1
        lsp-prefer-flymake nil))

(use-package lsp-pyright
  :after lsp-mode
  :hook (python-mode . (lambda () (require 'lsp-pyright) (lsp))))

(use-package company
  :config
  (global-company-mode)
  (setq company-idle-delay 0.0
        company-minimum-prefix-length 1))

;; C++ Development Setup
(use-package ccls
  :hook ((c-mode c++-mode) . (lambda () (require 'ccls) (lsp))))

;; Conda Integration
(use-package conda
  :init
  (setq conda-anaconda-home (expand-file-name "~/miniconda3"))
  :config
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell))

;; Org Mode Configuration
(use-package org
  :config
  (setq org-startup-indented t
        org-pretty-entities t
        org-hide-emphasis-markers t)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (C . t)
     (shell . t))))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

;; Final message
(message "Emacs setup complete! Enjoy coding!")



(use-package ein
  :config
  (setq ein:jupyter-default-server-command "jupyter"
        ein:jupyter-server-use-subcommand t))



(provide 'init.el)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
