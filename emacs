;;; Emacs itself

;; package manager
(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

;; Bootstrap `use-package'
;; http://www.lunaryorn.com/posts/my-emacs-configuration-with-use-package.html
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; custom.el
(setq custom-file "~/.custom.el")
(load custom-file)

;; web-mode.el
;;; http://web-mode.org
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.slim\\'" . web-mode))
(setq web-mode-attr-indent-offset 2)
(eval-after-load "web-mode"
  '(setq web-mode-enable-auto-expanding t))

;; auto-complete
(ac-config-default)

;; ac-emmet
(require 'ac-emmet)
(add-hook 'sgml-mode-hook 'ac-emmet-html-setup)
(add-hook 'css-mode-hook 'ac-emmet-css-setup)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; flycheck
(flycheck-add-mode 'javascript-eslint 'web-mode)
(setq-default flycheck-temp-prefix ".flycheck")
;; use local eslint from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

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

;; set default font: Fira Code
(set-face-attribute 'default nil :font "Fira Code" :height 160 )

;;; Fira Code Ligatures hack
(when (window-system)
  (set-default-font "Fira Code"))
(let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
               (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
               (36 . ".\\(?:>\\)")
               (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
               (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
               (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
               (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
               (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
               (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
               (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
               (48 . ".\\(?:x[a-zA-Z]\\)")
               (58 . ".\\(?:::\\|[:=]\\)")
               (59 . ".\\(?:;;\\|;\\)")
               (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
               (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
               (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
               (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
               (91 . ".\\(?:]\\)")
               (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
               (94 . ".\\(?:=\\)")
               (119 . ".\\(?:ww\\)")
               (123 . ".\\(?:-\\)")
               (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
               (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
               )
             ))
  (dolist (char-regexp alist)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))

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
