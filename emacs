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
