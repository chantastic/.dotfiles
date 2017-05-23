(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

;; use-package http://www.lunaryorn.com/posts/my-emacs-configuration-with-use-package.html
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t)

(use-package web-mode
  :no-require t
  :init
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.eex?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.slim\\'" . web-mode))
  :config
  (setq web-mode-attr-indent-offset 2)
  (setq web-mode-enable-auto-expanding t))

(use-package evil
  :config
  (evil-mode t))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package magit
  :config
  (global-set-key (kbd "C-x g") 'magit-status))

(use-package dracula-theme
  :init
  (load-theme 'dracula t))

(use-package slim-mode)
(use-package js2-mode)

(use-package markdown-mode
  :commands
  (markdown-mode gfm-mode)
  :mode
  (("README\\.md\\'" . gfm-mode)
   ("\\.md\\'" . markdown-mode)
   ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "multimarkdown"))

(use-package flycheck
  :init (global-flycheck-mode))

;;; not setup into use-package yet
(flycheck-add-mode 'javascript-eslint 'web-mode)
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


(use-package editorconfig
  :init
  (editorconfig-mode 1))

(use-package ag)

(use-package helm
  :bind (
    ("M-x" . helm-M-x)
    ("C-x C-f" . helm-find-files)))

(use-package helm-ag)

(use-package helm-projectile
  :init
  (projectile-global-mode)
  (setq projectile-completion-system 'helm)
  (helm-projectile-on))

(use-package elixir-mode)

(use-package yaml-mode)

(use-package eslint-fix)
;;; not integrated into use-package yet
(eval-after-load 'js-mode
  '(add-hook 'js-mode-hook (lambda () (add-hook 'after-save-hook 'eslint-fix nil t))))
