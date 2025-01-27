;;; python-coverage-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "python-coverage" "python-coverage.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from python-coverage.el

(autoload 'python-coverage-select-coverage-file "python-coverage" "\
Explicitly set the COVERAGE-FILE-NAME to use for the current buffer.

This is only needed if autodetection does not work.

\(fn &optional COVERAGE-FILE-NAME)" t nil)

(autoload 'python-coverage-overlay-mode "python-coverage" "\
Minor mode to show Python coverage results as overlays.

This is a minor mode.  If called interactively, toggle the
`Python-Coverage-Overlay mode' mode.  If the prefix argument is
positive, enable the mode, and if it is zero or negative, disable
the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `python-coverage-overlay-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'python-coverage-overlay-refresh "python-coverage" "\
Refresh the overlays." t nil)

(autoload 'python-coverage-overlay-remove-all "python-coverage" "\
Remove all overlays." t nil)

(autoload 'python-coverage-overlay-jump-next "python-coverage" "\
Jump to the next overlay." t nil)

(autoload 'python-coverage-overlay-jump-previous "python-coverage" "\
Jump to the previous overlay." t nil)

(autoload 'python-coverage-overlay-jump-first "python-coverage" "\
Jump to the first overlay." t nil)

(register-definition-prefixes "python-coverage" '("python-coverage-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; python-coverage-autoloads.el ends here
