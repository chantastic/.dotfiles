;; backups: off
; http://stackoverflow.com/questions/151945/how-do-i-control-how-emacs-makes-backup-files#answer-151946
(setq make-backup-files nil)

;; auto-save: off
(setq auto-save-default nil)

;; set default languange to english
(setenv "DICTIONARY" "en_GB")

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
