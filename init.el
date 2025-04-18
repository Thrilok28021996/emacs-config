;;; init.el ---Emacs setup using straight.el -*- lexical-binding: t; -*-

;;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;; Integrate straight.el with use-package
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;; Early Performance Optimizations
;; Increase the garbage collection threshold to speed up startup.
(setq gc-cons-threshold (* 100 1024 1024))
;; Optionally, disable file-name handlers during startup.
(let ((old-file-name-handler (default-value 'file-name-handler-alist)))
  (setq file-name-handler-alist nil)
  (add-hook 'emacs-startup-hook
            (lambda ()
              (setq gc-cons-threshold (* 2 1024 1024))
              (setq file-name-handler-alist old-file-name-handler))))

;;; Disable automatic package initialization (handled by straight.el)
(setq package-enable-at-startup nil)

;;; Basic UI Tweaks
;; Disable UI elements early to reduce startup overhead.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Set default font
(set-face-attribute 'default nil :family "Fira Code" :height 200)

;; Enable relative line numbers globally.
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

;;; Theme Configuration
(use-package catppuccin-theme
  ;;;:defer t
  :init (setq catppuccin-flavor 'mocha)
  :config (load-theme 'catppuccin t))

;;; Python Development Setup
(use-package lsp-mode
  :hook (python-mode . lsp)
  :commands lsp
  :config
  (setq lsp-idle-delay 0.1
        lsp-prefer-flymake nil))

(use-package lsp-pyright
  :after lsp-mode
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp)))
  :commands lsp)

(use-package company
  :defer t
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.0
        company-minimum-prefix-length 1))

;;; C++ Development Setup
(use-package ccls
  :defer t
  :hook ((c-mode c++-mode) . (lambda ()
                               (require 'ccls)
                               (lsp))))

;;; Conda Integration
(use-package conda
  :defer t
  :init (setq conda-anaconda-home (expand-file-name "~/miniconda3"))
  :config
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell))

;;; Org Mode Configuration
(use-package org
  :defer t
  :init (progn
          (setq org-startup-indented t
                org-pretty-entities t
                org-hide-emphasis-markers t))
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (C . t)
     (shell . t))))

(use-package org-bullets
  :defer t
  :hook (org-mode . org-bullets-mode))

;;; Jupyter Notebook Integration
(use-package ein
  :defer t
  :config
  (setq ein:jupyter-default-server-command "jupyter"
        ein:jupyter-server-use-subcommand t))

;;; Modeline Configuration
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)
           (doom-modeline-bar-width 3)))


;;; Additional Performance & Usability Enhancements
;; Uncomment the following lines if you have Emacs 28+ and want to enable native compilation.
(when (and (fboundp 'native-comp-available-p) (native-comp-available-p))
         (setq comp-deferred-compilation t
         comp-deferred-compilation-black-list nil))

;; Disable the startup splash screen for a cleaner launch.
(setq inhibit-startup-screen t)


(use-package which-key
  :defer 0.5
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3))


;;; Final Message After Startup
;; (add-hook 'emacs-startup-hook
;;           (lambda ()
;;             (message "Emacs setup complete! Enjoy coding!")))

(use-package magit
  :defer t
  :commands (magit-status magit-get-current-branch)
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))


(add-hook 'emacs-startup-hook
  (lambda ()
    (let ((buffer (get-buffer-create "*Welcome*")))
      (with-current-buffer buffer
        (insert "Welcome to Emacs!\n\n")
        (insert (format-time-string "Today is: %A, %B %d, %Y\n\n"))
        (insert "Here are some useful commands to get started:\n")
        (insert "  - Open a file: C-x C-f\n")
        (insert "  - Save a file: C-x C-s\n")
	(insert "  - Quit the Emacs: C-x C-c\n")
      (switch-to-buffer buffer)))))


(provide 'init)
;;; init.el ends here

