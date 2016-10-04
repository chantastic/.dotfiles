;;; Emacs itself

;; package manager
(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

;; custom.el
(setq custom-file "~/.custom.el")
(load custom-file)

;; backups: off
; http://stackoverflow.com/questions/151945/how-do-i-control-how-emacs-makes-backup-files#answer-151946
(setq make-backup-files nil)

;; auto-save: off
(setq auto-save-default nil)

;; whitespace-mode
;; http://stackoverflow.com/questions/6378831/emacs-globally-enable-whitespace-mode
(global-whitespace-mode 1)

;; http://ergoemacs.org/emacs/whitespace-mode.html
;; http://www.gnu.org/software/emacs/manual/html_node/emacs/Useless-Whitespace.html
;; http://ergoemacs.org/emacs/emacs_delete_trailing_whitespace.html
(setq whitespace-style (quote
(face tabs trailing empty)))

;; default tab width: 2
(setq-default indent-tabs-mode nil)
(setq tab-width 2)

;; syntax highlighting: off
(global-font-lock-mode 0)

;; set default font: Hasklig
(set-face-attribute 'default t :font "Hasklig" )

;;; editorconfig
(add-to-list 'load-path "~/.emacs.d/lisp")
(load "editorconfig")
(editorconfig-mode 1)

;;; evil
(require 'evil)
(evil-mode t)

;;; evil-surround
(require 'evil-surround)
(global-evil-surround-mode 1)

;;; helm
(require 'helm)
(require 'helm-config)
(helm-mode 1)

;;; magit
(global-set-key (kbd "C-x g") 'magit-status)

;;; projectile / projectile-helm
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)
