(package-initialize)
(require 'package)
(add-to-list 'package-archives
         '("melpa" . "https://melpa.org/packages/"))

;; backup in one place. flat, no file structure
(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))


;; neotree
;; https://github.com/jaypei/emacs-neotree
(add-to-list 'load-path "~/.emacs.d/plugins/neotree")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(custom-set-faces
 '(neo-root-dir-face ((t (:foreground "#8D8D84"))))
 '(neo-dir-link-face ((t (:foreground "#00ffff"))))
 '(neo-file-link-face ((t (:foreground "#dddddd")))))
