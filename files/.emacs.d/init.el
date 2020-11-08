;; Add repositories
(require 'package)
(setq package-enable-at-startup nil)

(setq package-archives '(("ELPA"  . "http://tromey.com/elpa/")
			 ("gnu"   . "http://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")
			 ("org"   . "https://orgmode.org/elpa/")))
(package-initialize)

;; Bootstrapping use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; This is the actual config file. It is omitted if it doesn't exist so emacs won't refuse to launch.
(let ((config-file (expand-file-name "config.org" user-emacs-directory)))
  (when (file-readable-p config-file)
    (org-babel-load-file config-file)))
