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
(add-hook 'jupyter-repl-mode-hook 'company-mode)
(org-babel-jupyter-override-src-block "python")
(org-babel-jupyter-override-src-block "ipython")
(setq org-confirm-babel-evaluate nil)   ;don't prompt me to confirm everytime I want to evaluate a block

(setq org-babel-default-header-args:jupyter-python '((:async . "no") (:kernel . "python3")))
(setq org-babel-default-header-args:python '((:async . "no") (:kernel . "python3")))

(with-eval-after-load 'org
  (evil-define-key 'normal org-mode-map (kbd "]g") 'org-babel-next-src-block)
  (evil-define-key 'normal org-mode-map (kbd "[g") 'org-babel-previous-src-block)
  )

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

(with-eval-after-load 'jupyter-env
  (advice-add 'jupyter-command :override (
                                          lambda (&rest args)

                                          "Run a Jupyter shell command synchronously, return its output.
The shell command run is

    jupyter ARGS...

If the command fails or the jupyter shell command doesn't exist,
return nil."
                                          (let ((stderr-file (make-temp-file "jupyter"))
                                                (stdout (get-buffer-create " *jupyter-command-stdout*")))
                                            (unwind-protect
                                                (let* ((status (apply #'process-file "mamba_cmd" nil (list stdout stderr-file) nil (cons "jupyter" args)))
                                                       (buffer (find-file-noselect stderr-file)))
                                                  (unwind-protect
                                                      (with-current-buffer buffer
                                                        (unless (eq (point-min) (point-max))
                                                          (message "jupyter-command: Content written to stderr stream")
                                                          (while (not (eq (point) (point-max)))
                                                            (message "    %s" (buffer-substring (line-beginning-position)
                                                                                                (line-end-position)))
                                                            (forward-line))))
                                                    (kill-buffer buffer))
                                                  (when (zerop status)
                                                    (with-current-buffer stdout
                                                      (string-trim-right (buffer-string)))))
                                              (delete-file stderr-file)
                                              (kill-buffer stdout))))
              )
  (advice-add 'jupyter-locate-python :override (lambda ()
                                                 "Return the path to a Python executable."
                                                 "mamba_repl"
                                                 )
              )
  )
(with-eval-after-load 'jupyter-kernelspec
  ;; Add advice after existing
  (defun my-jupyter-kernel-argv-advice (orig-fun &rest args)
    (let ((orig-argv (apply orig-fun args)))
      (cons "mamba_cmd" orig-argv)))

  (advice-add 'jupyter-kernel-argv :around #'my-jupyter-kernel-argv-advice)

  ) ;; TODO make sure this works


;; (with-eval-after-load 'jupyter-kernel-process ;; covered by the one above
;;   (advice-add 'jupyter--start-kernel-process :override (lambda (name kernelspec conn-file)
;;                                                          (let* ((process-name (format "jupyter-kernel-%s" name))
;;                                                                 (buffer-name (format " *jupyter-kernel[%s]*" name))
;;                                                                 (process-environment
;;                                                                  (append (jupyter-process-environment kernelspec)
;;                                                                          process-environment))
;;                                                                 (args (jupyter-kernel-argv kernelspec conn-file))
;;                                                                 (atime (nth 4 (file-attributes conn-file)))
;;                                                                 (process (apply #'start-file-process process-name
;;                                                                                 (generate-new-buffer buffer-name)
;;                                                                                 "mamba_cmd" args))) ; <-- Change (car args) to mamba_cmd
;;                                                                 )
;;               (set-process-query-on-exit-flag process jupyter--debug)
;;               ;; Wait until the connection file has been read before returning.
;;               ;; This is to give the kernel a chance to setup before sending it
;;               ;; messages.
;;               ;;
;;               ;; TODO: Replace with a check of the heartbeat channel.
;;               (jupyter-with-timeout
;;                   ((format "Starting %s kernel process..." name)
;;                    jupyter-long-timeout
;;                    (unless (process-live-p process)
;;                      (error "Kernel process exited:\n%s"
;;                             (with-current-buffer (process-buffer process)
;;                               (ansi-color-apply (buffer-string))))))
;;                 ;; Windows systems may not have good time resolution when retrieving
;;                 ;; the last access time of a file so we don't bother with checking that
;;                 ;; the kernel has read the connection file and leave it to the
;;                 ;; downstream initialization to ensure that we can communicate with a
;;                 ;; kernel.
;;                 (or (memq system-type '(ms-dos windows-nt cygwin))
;;                     (let ((attribs (file-attributes conn-file)))
;;                       ;; `file-attributes' can potentially return nil, in this case
;;                       ;; just assume it has read the connection file so that we can
;;                       ;; know for sure it is not connected if it fails to respond to
;;                       ;; any messages we send it.
;;                       (or (null attribs)
;;                           (not (equal atime (nth 4 attribs)))))))
;;               (jupyter--gc-kernel-processes)
;;               (push (list process conn-file) jupyter--kernel-processes)
;;               process)
;;               )
;;   )
