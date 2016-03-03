;;; init.el --- emacs configuration

;;;; Commentary:

;; Emacs configuration

;;;; Code:

;;;
;;; Packages
;;;

(setq
 load-prefer-newer t
 package-archives '(
  ("melpa" . "https://melpa.org/packages/")
  ;; ("melpa-stable" . "https://stable.melpa.org/packages/")
  ("gnu" . "https://elpa.gnu.org/packages/")))

(require 'package)
(package-initialize)

(defmacro after (feature &rest body)
  "After FEATURE is loaded, evaluate BODY."
  (declare (indent defun))
  `(eval-after-load ,feature
    '(progn ,@body)))


;;;
;;; General
;;;

(fset 'yes-or-no-p 'y-or-n-p)
(modify-syntax-entry ?_ "w")
(setq tls-checktrust 'ask)

;; Backup and autosave files
(setq
 auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-saves/\\1" t))
 backup-directory-alist '((".*" . "~/.emacs.d/backups/"))
 make-backup-files nil)

;; Resist agitprop
(global-set-key (kbd "C-h g") nil)
(global-set-key (kbd "C-h C-c") nil)
(global-set-key (kbd "C-h C-m") nil)
(global-set-key (kbd "C-h C-o") nil)
(global-set-key (kbd "C-h C-w") nil)

;; Disable Command-Q on OSX
(global-set-key (kbd "s-q") nil)


;;;
;;; Visual appearance
;;;

;; TODO: highlight FIXME/TODO/XXX in comment strings

(show-paren-mode t)
(setq text-scale-mode-step 1.05)

;; Reduce clutter
(setq
 frame-resize-pixelwise t
 inhibit-startup-screen t
 initial-scratch-message nil)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(toggle-frame-maximized)
(tool-bar-mode -1)

;; Theme
(setq solarized-use-less-bold t)
(load-theme 'solarized-dark t)
(defvar my-active-theme 'solarized-dark "The currently active theme.")
(defun toggle-dark-light-theme ()
  "Toggle between a dark and light theme."
  (interactive)
  (if (eq my-active-theme 'solarized-light)
      (setq my-active-theme 'solarized-dark)
    (setq my-active-theme 'solarized-light))
  (load-theme my-active-theme t))

;; Cursor
(blink-cursor-mode 0)
(setq
   evil-normal-state-cursor   '("#859900" box)     ; green
   evil-visual-state-cursor   '("#cb4b16" box)     ; orange
   evil-insert-state-cursor   '("#268bd2" bar)     ; blue
   evil-replace-state-cursor  '("#dc322f" bar)     ; red
   evil-operator-state-cursor '("#dc322f" hollow)  ; red
)

;; Font faces
(defun my-remove-bold-underline-from-all-faces ()
  "Remove unwanted attributes from all font faces."
  (mapc
   (lambda (face) (set-face-attribute face nil :weight 'normal :underline nil))
   (face-list)))
(my-remove-bold-underline-from-all-faces)

;; Mode line
(require 'smart-mode-line)
(setq rm-blacklist '(
  " ARev"
  " FlyC"
  " Undo-Tree"
  " hl-p"
  " hl-s"
  " ivy"
  " s-/"
))
(sml/setup)
(setq
 sml/col-number-format "%c"
 sml/line-number-format "%l")

;; Line numbering
(require 'relative-line-numbers)
(defun my-relative-line-numbers-format (offset)
  "Format relative line number for OFFSET."
  (number-to-string (abs (if (= offset 0) (line-number-at-pos) offset))))
(setq relative-line-numbers-format 'my-relative-line-numbers-format)


;;;
;;; Whitespace
;;;

(setq
 require-final-newline 'visit-save
 sentence-end-double-space nil)
(setq-default
 indent-tabs-mode nil
 show-trailing-whitespace t
 tab-width 4)
(defun my-hide-trailing-whitespace ()
  "Helper to hide trailing whitespace, intended for mode hooks."
  (setq show-trailing-whitespace nil))
(add-hook 'buffer-menu-mode-hook 'my-hide-trailing-whitespace)


;;;
;;; Scrolling
;;;

(setq
 scroll-conservatively 101
 scroll-margin 5)


;;;
;;; Completion
;;;

;; ivy, counsel
(setq magit-completing-read-function 'ivy-completing-read)
(ivy-mode 1)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key [remap find-file] 'counsel-find-file)
(global-set-key [remap switch-to-buffer] 'ivy-switch-buffer)
(global-set-key [remap describe-function] 'counsel-describe-function)
(global-set-key [remap describe-variable] 'counsel-describe-variable)


;;;
;;; Evil
;;;

(setq
 evil-want-C-u-scroll t
 evil-vsplit-window-right t
 evil-cross-lines t)

(require 'evil)
(require 'evil-args)
(require 'evil-commentary)
(require 'evil-god-state)
(require 'evil-indent-plus)
(require 'evil-magit)
(require 'evil-numbers)
(require 'evil-surround)
(require 'god-mode)

(evil-mode)
(evil-commentary-mode)
(global-evil-surround-mode)

;; Text objects
(define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
(define-key evil-outer-text-objects-map "a" 'evil-outer-arg)
(evil-indent-plus-default-bindings)

;; Movement
(evil-define-key 'motion global-map
  (kbd "C-j") 'evil-next-visual-line
  (kbd "C-k") 'evil-previous-visual-line)

;; Quick window selection of vertical splits
(evil-define-key 'motion global-map
  (kbd "C-w 1") 'evil-window-top-left
  (kbd "C-w 2") (lambda () (interactive) (evil-window-top-left) (evil-window-next 2))
  (kbd "C-w 3") (lambda () (interactive) (evil-window-top-left) (evil-window-next 3))
  (kbd "C-w 4") (lambda () (interactive) (evil-window-top-left) (evil-window-next 4)))

;; Shortcuts using a "leader key" as a prefix
(defvar my-leader-map
  (make-sparse-keymap)
  "Keymap for 'leader key' shortcuts.")
(evil-define-key 'motion global-map "," my-leader-map)
(define-key my-leader-map " " 'whitespace-cleanup)
(define-key my-leader-map "f" 'counsel-find-file)
(define-key my-leader-map "F" (lambda()
  "Show buffer menu with open files"
  (interactive) (buffer-menu t)))
(define-key my-leader-map "b" 'ivy-switch-buffer)
(define-key my-leader-map "B" 'buffer-menu)
(define-key my-leader-map "k" (lambda () (interactive) (kill-buffer nil)))
(define-key my-leader-map "q" 'kill-buffer-and-window)
(define-key my-leader-map "r" 'ivy-resume)
(define-key my-leader-map "w" 'save-buffer)
(define-key my-leader-map "W" 'save-some-buffers)
(define-key my-leader-map "u" 'universal-argument)
(define-key my-leader-map "x" 'counsel-M-x)
(define-key my-leader-map "+" 'evil-numbers/inc-at-pt)
(define-key my-leader-map "-" 'evil-numbers/dec-at-pt)

;; Toggles
(defvar my-toggle-map
  (make-sparse-keymap)
  "Keymap for various toggles.")
(define-key my-leader-map "t" my-toggle-map)
(define-key my-toggle-map "b" 'toggle-dark-light-theme)
(define-key my-toggle-map "c" 'fci-mode)
(define-key my-toggle-map "f" 'auto-fill-mode)
(define-key my-toggle-map "l" 'hl-line-mode)
(define-key my-toggle-map "m" 'toggle-frame-fullscreen)
(define-key my-toggle-map "M" 'toggle-frame-maximized)
(define-key my-toggle-map "n"
  (lambda () (interactive)
    (relative-line-numbers-mode -1)
    (linum-mode 'toggle)))
(define-key my-toggle-map "r"
  (lambda () (interactive)
    (linum-mode -1)
    (relative-line-numbers-mode 'toggle)))
(define-key my-toggle-map "t" 'toggle-truncate-lines)
(define-key my-toggle-map "v" 'visual-line-mode)
(define-key my-toggle-map "w" 'whitespace-mode)

;; Zooming / text size
(defvar my-zoom-map
  (make-sparse-keymap)
  "Keymap for zooming shortcuts.")
(define-key my-leader-map "z" my-zoom-map)
(define-key my-zoom-map "i" 'text-scale-increase)
(define-key my-zoom-map "o" 'text-scale-decrease)
(define-key my-zoom-map "z" 'text-scale-adjust)
(define-key my-zoom-map "0" 'text-scale-adjust)

;; Directory navigation (inspired by vim vinagre)
(evil-define-key 'motion global-map "-" 'dired-jump)
(define-key dired-mode-map "-" 'dired-jump)

;; Previous/next thing (inspired by vim unimpaired)
(evil-define-key 'motion global-map
  (kbd "[ SPC") (lambda () (interactive)
    (evil-insert-newline-above)
    (evil-line 2))
  (kbd "] SPC") (lambda () (interactive)
    (evil-insert-newline-below)
    (evil-line 0))
  "[b" 'evil-prev-buffer
  "]b" 'evil-next-buffer
  "[c" 'flycheck-previous-error
  "]c" 'flycheck-next-error
  "[C" (lambda () (interactive)
    (goto-char (point-min))
    (flycheck-next-error))
  "]C" (lambda () (interactive)
    (goto-char (point-max))
    (flycheck-previous-error))
  "[e" 'previous-error
  "]e" 'next-error
  "[E" 'first-error
  "]E" (lambda () (interactive)
    (goto-char (point-max))
    (previous-error))
  "[m" 'move-text-up
  "]m" 'move-text-down
  "[s" 'highlight-symbol-prev
  "]s" 'highlight-symbol-next
  "[w" 'evil-window-prev
  "]w" 'evil-window-next
)

;; Single key prefix key for god-mode integration
(evil-define-key 'motion global-map ";" 'evil-execute-in-god-state)
(evil-define-key 'god global-map [escape] 'evil-god-state-bail)

;; Misc
(evil-define-key 'insert global-map
  (kbd "RET") 'evil-ret-and-indent
  (kbd "C-a") 'evil-first-non-blank
  (kbd "C-l") 'end-of-line)
(defun my-evil-fill-paragraph ()
  "Dwim helper to fill the current paragraph"
  (interactive)
  ;; Move point after comment marker; useful for multi-line comments.
  (end-of-line)
  (fill-paragraph)
  (evil-first-non-blank))
(evil-define-key 'motion global-map
  "Q" 'my-evil-fill-paragraph
  (kbd "M-j") 'move-text-down
  (kbd "M-k") 'move-text-up)


;;;
;;; Version control
;;;

(require 'magit)
(setq
 auto-revert-check-vc-info t
 magit-process-popup-time 10)

;; Pop-ups sometimes contain trailing whitespace.
(add-hook 'magit-popup-mode-hook 'my-hide-trailing-whitespace)

;; Magit shortcuts
(defvar my-git-map
  (make-sparse-keymap)
  "Keymap for git shortcuts.")
(define-key my-leader-map "g" my-git-map)
(define-key my-git-map "!" 'magit-git-command)
(define-key my-git-map "b" 'magit-blame)
(define-key my-git-map "c" 'magit-commit)
(define-key my-git-map "d" 'magit-diff)
(define-key my-git-map "f" 'counsel-git)
(define-key my-git-map "g" 'vc-git-grep)
(define-key my-git-map "l" 'magit-log)
(define-key my-git-map "o" (lambda ()
  "Open git status for another repository."
  (interactive)
  (setq current-prefix-arg t)
  (call-interactively 'magit-status)))
(define-key my-git-map "p" 'magit-dispatch-popup)
(define-key my-git-map "r" 'magit-rebase)
(define-key my-git-map "s" 'magit-status)
(define-key my-git-map "w" (lambda ()
  "Browse repository on the web; invokes hub."
  (interactive)
  (shell-command "hub browse")))
(define-key my-git-map "W" (lambda ()
  "Compare repository on the web; invokes hub."
  (interactive)
  (shell-command "hub compare")))


;;;
;;; Search
;;;

;; Swiper
(global-set-key [remap isearch-forward ] 'swiper)
(evil-define-key 'motion global-map
  "/" 'swiper
  "?" 'swiper
  "g/" 'evil-search-forward
  "g?" 'evil-search-backward)
(evil-define-key 'normal global-map
  "g?" 'evil-search-backward)

;; Ag, the silver searcher
(setq ag-reuse-buffers t)
(defvar my-ag-map
  (make-sparse-keymap)
  "Keymap for ag shortcuts.")
(define-key my-leader-map "a" my-ag-map)
(define-key my-ag-map "f" 'ag-project-files)
(define-key my-ag-map "F" 'ag-files)
(define-key my-ag-map "g" 'ag-project)
(define-key my-ag-map "G" 'ag)
(define-key my-ag-map "r" 'ag-project-regexp)
(define-key my-ag-map "R" 'ag-regexp)
(add-hook 'ag-mode-hook (lambda ()
  (toggle-truncate-lines t)))

;; Highlight
(evil-define-key 'motion global-map
  (kbd "SPC") 'highlight-symbol
  (kbd ", SPC") 'highlight-symbol-remove-all)
(evil-define-key 'visual global-map
  (kbd "SPC") (lambda (start end) (interactive "r")
    (highlight-symbol-add-symbol (buffer-substring start end))))


;;;
;;; Programming
;;;

(setq highlight-symbol-idle-delay 1.0)
(evil-define-key 'insert prog-mode-map
  (kbd "RET") 'comment-indent-new-line)

;; Flycheck
(setq flycheck-display-errors-delay 1.0)
(global-flycheck-mode)

;; Language-agnostic mode hook
(defun my-prog-mode-hook ()
  (column-number-mode)
  (highlight-symbol-mode))
(add-hook 'prog-mode-hook 'my-prog-mode-hook)

;; JSON
(setq json-reformat:indent-width 2)
(add-hook 'json-mode-hook (lambda ()
  (setq
   tab-width json-reformat:indent-width
   evil-shift-width tab-width)))

;; Python
(defun my-python-mode-hook ()
  (setq
   fill-column 72
   python-fill-docstring-style 'symmetric))
(add-hook 'python-mode-hook 'my-python-mode-hook)

;; Yaml
(defun my-yaml-mode-hook ()
  (setq evil-shift-width yaml-indent-offset))
(add-hook 'yaml-mode-hook 'my-yaml-mode-hook)


(provide 'init)
;;; init.el ends here
