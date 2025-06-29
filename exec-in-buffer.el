;;; exec-in-buffer.el --- Choose programs to execute on buffers in projects

;; Copyright (C) 2025 Arteen Abrishami

;; Author: Arteen Abrishami <arteen@ucla.edu>
;; Maintainer: Arteen Abrishami <arteen@ucla.edu>
;; URL: https://github.com/arteen1000/exec-in-buffer
;; Version: 0.0.1
;; Package-Requires ((emacs "24.1"))
;; Keywords: tools, c, c++, formatting, projects

;; This file is not a part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; In conjunction, the interfaces of this package,
;; allow the user to adjust `exec-in-buffer' to their needs.
;; `exec-in-buffer' permits executing programs and reverting the buffer
;; on-save for both remote and local files.
;; See the README for more details.

;;; Code:

(defgroup exec-in-buffer nil
  "Exec program/args in buffer for remote/local files with on-save hook."
  :group 'tools)

(defcustom exec-in-buffer-config-filename nil
  "Local config file name."
  :group 'exec-in-buffer
  :type '(choice (const nil) string))

(defcustom exec-in-buffer-config nil
  "Determines programs to run for files matching regexp."
  :group 'exec-in-buffer
  :type '(choice (const nil) (repeat (cons string (repeat string)))))

(defun exec-in-buffer-execute ()
  "Execute regexp matching programs for file and reverts buffer."
  (let ((full-path (buffer-file-name)))
    (when full-path
      (let ((filename (file-relative-name full-path)))
        (dolist (mp exec-in-buffer-config)
          (if (string-match-p (car mp) filename)
              (let* ((cmd-list (cdr mp))
                     (prog (car cmd-list))
                     (args (mapcar
                            (lambda (a)
                              (if (eq a 'filename)
                                  full-path
                                a)) (cdr cmd-list))))
                (apply #'process-file prog nil nil nil args))))
        (revert-buffer t t)))))

(defun exec-in-buffer ()
  "Locate local config if applicable and apply program/args if file matches."
  (interactive)
  (let ((global-conf exec-in-buffer-config))
    (if exec-in-buffer-config-filename
        (if-let ((dir (locate-dominating-file "." exec-in-buffer-config-filename)))
            (load-file (expand-file-name exec-in-buffer-config-filename dir))))
    (exec-in-buffer-execute)
    (setq exec-in-buffer-config global-conf)))

(defun exec-in-buffer-save-hook ()
  "Hook to run `exec-in-buffer-on-disk' on-save, works for local/remote files."
  (add-hook 'after-save-hook
            #'exec-in-buffer -99 t))

(provide 'exec-in-buffer)
;;; exec-in-buffer.el ends here
