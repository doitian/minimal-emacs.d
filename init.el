(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-splash-screen t)
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;; Customization
(custom-set-variables
 '(current-language-environment "UTF-8")
 '(default-major-mode (quote text-mode) t)
 '(user-full-name "Ian Yang")
 '(user-mail-address "me@iany.me")

 '(enable-recursive-minibuffers t)
 '(minibuffer-depth-indicate-mode t)

 '(delete-by-moving-to-trash t)

 '(mouse-yank-at-point t)
 '(x-select-enable-clipboard t)
 '(tramp-default-method-alist (quote (("\\`localhost\\'" "\\`root\\'" "sudo"))))

 '(tab-width 2)
 '(indent-tabs-mode nil)
 '(show-paren-mode t)
 '(fill-column 78)

 '(set-mark-command-repeat-pop t)

 '(projectile-keymap-prefix (kbd "M-s p")))

(setq hippie-expand-try-functions-list
      '(
        try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name-partially
        try-complete-file-name
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol
        try-expand-list))

(fset 'yes-or-no-p 'y-or-n-p)

(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file t t))

;;; Functions

(defun iy-dash ()
  (interactive)
  (insert "-"))
(defun iy-underscore ()
  (interactive)
  (insert "_"))

(defun back-to-indentation-or-beginning ()
  (interactive)
  (if (= (point) (save-excursion (back-to-indentation) (point)))
      (beginning-of-line)
    (back-to-indentation)))

(defun iy-zap-back-to-char (arg char)
  (interactive "p\ncZap back to char: ")
  (zap-to-char (- arg) char))
(defun iy-zap-back-up-to-char (arg char)
  (interactive "p\ncZap back up to char: ")
  (zap-up-to-char (- arg) char))

;;; bindings

(defvar iy-map (make-sparse-keymap))
(define-minor-mode iy-minor-mode nil t nil
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-s") iy-map)
    map))

(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "M-u") 'iy-underscore)
(global-set-key (kbd "M-l") 'iy-dash)
(global-set-key (kbd "C-a") 'back-to-indentation-or-beginning)
(global-set-key (kbd "M-m") 'iy-go-to-char)
(global-set-key (kbd "M-M") 'iy-go-to-char-backward)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-,") ctl-x-r-map)
(global-set-key (kbd "C-3") 'mc/mark-all-like-this)
(global-set-key (kbd "C-2") 'er/expand-region)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key [(meta ?@)] 'mark-word)
(global-set-key [(control meta ? )] 'mark-sexp)
(global-set-key [(control meta shift ?u)] 'mark-enclosing-sexp)
(global-set-key (kbd "M-SPC") 'thing-actions-mark-thing)
(define-key ctl-x-r-map (kbd "C-r") 'mc/edit-lines)
(define-key ctl-x-r-map (kbd ",") 'mc/edit-lines)
(define-key ctl-x-r-map (kbd "C-,") 'mc/edit-lines)
(define-key ctl-x-r-map (kbd "a") 'mc/mark-all-like-this)
(define-key ctl-x-r-map (kbd "C-n") 'mc/mark-next-like-this)
(define-key ctl-x-r-map (kbd "M-f") 'mc/mark-next-word-like-this)
(define-key ctl-x-r-map (kbd "M-F") 'mc/mark-next-symbol-like-this)
(define-key ctl-x-r-map (kbd "C-p") 'mc/mark-previous-like-this)
(define-key ctl-x-r-map (kbd "M-b") 'mc/mark-previous-word-like-this)
(define-key ctl-x-r-map (kbd "M-B") 'mc/mark-previous-symbol-like-this)
(define-key ctl-x-r-map (kbd "C-a") 'mc/edit-beginnings-of-lines)
(define-key ctl-x-r-map (kbd "C-e") 'mc/edit-ends-of-lines)
(define-key ctl-x-r-map (kbd "C-SPC") 'mc/mark-all-in-region)
(define-key ctl-x-r-map (kbd "C-f") 'mc/mark-sgml-tag-pair)
(define-key iy-map (kbd "d") 'zap-to-char)
(define-key iy-map (kbd "D") 'iy-zap-back-to-char)
(global-set-key (kbd "M-z") 'zap-up-to-char)
(define-key key-translation-map [?\C-h] [?\C-?])
(define-key key-translation-map [?\M-r] [?\C-\M-?])
(global-set-key (kbd "<f12>") 'magit-status)

;;; Modes
;; @purcell https://github.com/purcell/emacs.d/blob/master/init-elpa.el
(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (package-install package)
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))

(package-initialize)

(setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")))
(require-package 'iy-go-to-char)
(require-package 'smex)
(require-package 'ido-hacks)
(require-package 'ido-complete-space-or-hyphen)
(require-package 'multiple-cursors)
(require-package 'expand-region)
(require-package 'projectile)
(require-package 'magit)

(add-to-list 'load-path user-emacs-directory)
(require 'thing-actions nil t)

(show-paren-mode +1)
(ido-mode +1)
(global-auto-revert-mode +1)

(ido-complete-space-or-hyphen-enable)

(projectile-global-mode)
