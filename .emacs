(package-initialize)
(require 'package)
(add-to-list 'package-archives
         '("melpa" . "https://melpa.org/packages/"))

;; backup in one place. flat, no file structure
(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))

(global-font-lock-mode 1)
(setq font-lock-maximum-decoration t)
pax
;; neotree
;; https://github.com/jaypei/emacs-neotree
(add-to-list 'load-path "~/.emacs.d/plugins/neotree")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(setq-default neo-show-hidden-files t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(neo-dir-link-face ((t (:foreground "#00ffff"))))
 '(neo-file-link-face ((t (:foreground "#dddddd"))))
 '(neo-root-dir-face ((t (:foreground "#8D8D84")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(## projectile)))
