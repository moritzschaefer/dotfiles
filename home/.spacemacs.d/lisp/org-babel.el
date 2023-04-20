;; most of it is from here: https://zwild.github.io/posts/ob-ipython-enhancement-completion-eldoc-help/
;; org babel autocompletion


;; (defun run-python-first (&rest args)
;;   "Start a inferior python if there isn't one."
;;   (or (comint-check-proc "*Python*") (run-python)))

;; (advice-add 'org-babel-execute:ipython :after
;;             (lambda (body params)
;;               "Send body to `inferior-python'."
;;               (run-python-first)
;;               (python-shell-send-string body)))
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (setq-local completion-at-point-functions
;;                         '(pcomplete-completions-at-point python-completion-at-point))))
;; (defun ob-ipython-eldoc-function ()
;;   (when (org-babel-where-is-src-block-head)
;;     (python-eldoc-function)))

;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (setq-default eldoc-documentation-function 'ob-ipython-eldoc-function)))
;; (defun ob-ipython-help (symbol)
;;   (interactive (list (read-string "Symbol: " (python-eldoc--get-symbol-at-point))))
;;   (unless (org-babel-where-is-src-block-head)
;;     (error "Symbol is not in src block."))
;;   (unless (ob-ipython--get-kernel-processes)
;;     (error "There is no ob-ipython-kernal running."))
;;   (when-let* ((processes  (ob-ipython--get-kernel-processes))
;;               (session (caar processes))
;;               (ret (ob-ipython--eval
;;                     (ob-ipython--execute-request (format "help(%s)" symbol) session))))
;;     (let ((result (cdr (assoc :result ret)))
;;           (output (cdr (assoc :output ret))))
;;       (let ((buf (get-buffer-create "*ob-ipython-doc*")))
;;         (with-current-buffer buf
;;           (let ((inhibit-read-only t))
;;             (erase-buffer)
;;             (insert output)
;;             (goto-char (point-min))
;;             (read-only-mode t)
;;             (pop-to-buffer buf)))))))

;; (org-babel-do-load-languages
;;   'org-babel-load-languages
;;   '((ipython . t)
;;     ;; other languages..
;;     ))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   ;; (julia . t)
   (shell . t)
   (python . t)
   (jupyter . t)))
(require 'jupyter)
(org-babel-jupyter-override-src-block "python")
(org-babel-jupyter-override-src-block "ipython")
(setq org-confirm-babel-evaluate nil)   ;don't prompt me to confirm everytime I want to evaluate a block

(setq org-babel-default-header-args:jupyter-python '((:async . "no") (:kernel . "python3")))
(setq org-babel-default-header-args:python '((:async . "no") (:kernel . "python3")))

;; doesn't work unfortunately (because jupyter ignores the local default kernel argument)
(defun moritzs/set-custom-kernel ()
  (when-let ((kernel (org-entry-get nil "CUSTOM_KERNEL" t)))
    (setq-local org-babel-default-header-args:python
                `((:async . "no")
                  (:kernel . ,kernel)))
    (setq-local org-babel-default-header-args:jupyter-python
                `((:async . "no")
                  (:kernel . ,kernel)))
    ))

(add-hook 'org-mode-hook #'moritzs/set-custom-kernel)

(with-eval-after-load 'jupyter-kernel-process-manager
  (advice-add 'jupyter-command :override (lambda (&rest args)
      "Run a Jupyter shell command synchronously, return its output.
      The shell command run is

          jupyter ARGS...

      If the command fails or the jupyter shell command doesn't exist,
      return nil."
      (with-temp-buffer
        (when (zerop (apply #'process-file "guided_prot_diff_cmd" nil t nil (cons "jupyter" args)))
          (string-trim-right (buffer-string)))))
              )

  (advice-add 'jupyter-locate-python :override (lambda ()
      "Return the path to a Python executable."
      "guided_prot_diff_repl"
      )
    )

  ;; We can't use `advice-add :override' on generic functions
  (cl-defmethod jupyter-start-kernel ((kernel jupyter-kernel-process) &rest args)
    "Start a KERNEL process with ARGS."
    (let ((name (jupyter-kernel-name kernel)))
      (when jupyter--debug
        (message "jupyter-start-kernel: default-directory = %s" default-directory)
        (message "jupyter-start-kernel: Starting process with args \"%s\""
                (mapconcat #'identity args " ")))
      (oset kernel process
            (apply #'start-file-process
                  (format "jupyter-kernel-%s" name)
                  (generate-new-buffer
                    (format " *jupyter-kernel[%s]*" name))
                  "guided_prot_diff_cmd" args)) ; <-- Change (car args) to guided_prot_diff_cmd
      (set-process-query-on-exit-flag
      (oref kernel process) jupyter--debug)))
)
