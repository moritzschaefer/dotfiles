(define-coding-system-alias 'UTF-8 'utf-8)

(helm-descbinds-mode 0)  ;; disabling, otherwise which-key mode fails

;; delete (after update)
;; (defalias 'dnd-unescape-uri 'dnd--unescape-uri)

;; For all programming modes
(add-hook 'prog-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))


(spacemacs/set-leader-keys
  "feuc" (lambda () (interactive) (find-file "~/.spacemacs.d/user-config.el"))
  )

(spacemacs/set-leader-keys
  "feui" (lambda () (interactive) (find-file "~/.spacemacs.d/user-init.el"))
  )

(spacemacs/set-leader-keys
  "feux" (lambda () (interactive) (find-file "~/.spacemacs.d/lisp/exwm.el"))
  )

(spacemacs/set-leader-keys
  "fes" (lambda () (interactive) (yas-visit-snippet-file))
  )
(apply #'spacemacs/declare-prefix '("fw" "wiki files"))

(apply #'spacemacs/declare-prefix '("fwm" "main.org"))
(spacemacs/set-leader-keys
  "fwm" (lambda () (interactive) (find-file "~/wiki/main.org"))
  )
(apply #'spacemacs/declare-prefix '("fwp" "projects.org"))
(spacemacs/set-leader-keys
  "fwp" (lambda () (interactive) (find-file "~/wiki/gtd/projects.org"))
  )
(apply #'spacemacs/declare-prefix '("fwd" "phd.org"))
(spacemacs/set-leader-keys
  "fwd" (lambda () (interactive) (find-file "~/wiki/gtd/phd.org"))
  )
(apply #'spacemacs/declare-prefix '("fww" "reviews.org"))
(spacemacs/set-leader-keys
  "fww" (lambda () (interactive) (find-file "~/wiki/gtd/reviews.org"))
  )

(spacemacs/set-leader-keys
  "fd" 'moritzs/recent-download-file
  )
(spacemacs/set-leader-keys
  ;; "fp" (lambda () (interactive) (progn (moritzs/recent-download-file) (org-ref-pdf-to-bibtex)))  ;; not using it so much...
  "fp" 'moritzs/open-smartphone-photo
  )
(spacemacs/set-leader-keys
  "fn" (lambda () (interactive) (find-file "~/nixos-config/README.org"))
  )

(global-set-key [s-left] 'evil-window-left)
(global-set-key [s-right] 'evil-window-right)
(global-set-key [s-up] 'evil-window-up)
(global-set-key [s-down] 'evil-window-down)
(define-key evil-motion-state-map [s-left] 'evil-window-left)
(define-key evil-motion-state-map [s-right] 'evil-window-right)
(define-key evil-motion-state-map [s-up] 'evil-window-up)
(define-key evil-motion-state-map [s-down] 'evil-window-down)

;; (define-key evil-ex-completion-map [left] 'evil-backward-char)
;; (define-key evil-ex-completion-map [right] 'evil-forward-char)
;; (define-key evil-ex-search-keymap [left] 'evil-backward-char)
;; (define-key evil-ex-search-keymap [right] 'evil-forward-char)

(define-key minibuffer-local-map [up] 'evil-previous-line)
(define-key minibuffer-local-map [down] 'evil-next-line)
(define-key minibuffer-local-map [left] 'evil-backward-char)
(define-key minibuffer-local-map [right] 'evil-forward-char)

(define-key evil-motion-state-map (kbd "C-m") nil)
(define-key evil-motion-state-map (kbd "C-m") 'evil-avy-goto-char-timer)

;; refine autocompletion behavior
(eval-after-load "company"
  '(add-to-list 'company-backends 'company-anaconda))
(require 'company)

;; I can use the error keys her
(define-key company-active-map (kbd "M-n") nil)
(define-key company-active-map (kbd "M-p") nil)
;; (add-to-list 'company-backends 'company-ob-ipython)

;; helm help
(require 'helm)
(global-set-key [C-f1] 'help-command)
(define-key helm-read-file-map (kbd "C-c t") 'helm-ff-sort-by-newest)
(define-key helm-read-file-map (kbd "C-c s") 'helm-ff-sort-by-size)
(define-key helm-read-file-map (kbd "C-c n") 'helm-ff-sort-alpha)

;; helm-swoop: search in file
(spacemacs/set-leader-keys "ä" 'helm-swoop)

(global-set-key (kbd "M-n") 'hippie-expand)
;; (global-set-key (kbd "M-n") 'yas-expand)

;;display time in powerline
(display-time-mode)

;;display emacs memory usage in pwoerline (https://emacs.stackexchange.com/questions/16735/how-to-add-date-and-time-into-spacemacs-mode-line)
;; (spaceline-define-segment emacs-memory-segment
;;   (shell-command-to-string "echo -n $(ps aux | grep emacs-exwm-load | grep -v grep | awk '{print $4}')")
;;                                     )
;; (spaceline-spacemacs-theme 'emacs-memory-segment)

;; clipboard management
;; (setq x-select-enable-clipboard nil)
;; (setq x-select-enable-primary t)
(setq mouse-drag-copy-region t)

;; (define-key evil-insert-state-map  (kbd "C-v") (kbd ""))
(define-key evil-ex-completion-map (kbd "C-v") (kbd "+"))
(define-key evil-ex-search-keymap  (kbd "C-v") (kbd "+"))

(define-key global-map (kbd "C-v") 'evil-paste-from-register)


;;   (define-key ansi-term-raw-map (kbd "s-c") (lambda () (interactive) (term-send-raw-string "\C-c")))



(with-eval-after-load "ansi-term"
  (define-key term-raw-map (kbd "s-r") nil)
  (define-key term-raw-map (kbd "<prior>") nil)
  (define-key term-raw-map (kbd "<next>") nil)
  (define-key ansi-term-raw-map (kbd "C-v") 'term-paste))

(add-hook 'ess-mode-hook
          (lambda ()
            (ess-toggle-underscore nil)))

  ;; (require 'exec-path-from-shell)
  ;; (exec-path-from-shell-copy-env "SSH_AGENT_PID")
  ;;(exec-path-from-shell-copy-env "SSH_AUTH_SOCK")

(defun moritzs/open-browser ()
  "Prompt user to enter a string, with input history support."
  (interactive)
  (let ((user-input (read-string "Enter qutebrowser term: ")))
    (call-process-shell-command (format "qutebrowser \":open -t %s\""
                                        user-input)
                                nil "*Shell Command Output*" t
                                )
    )
  )

(defun moritzs/dired-copy-file-path ()
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (with-temp-buffer
        (insert filename)
        (clipboard-kill-region (point-min) (point-max)))
      (message filename))))

(define-key dired-mode-map "y" 'moritzs/dired-copy-file-path)

(require 'evil-surround)
(add-hook 'python-mode-hook (lambda ()
                              (push '(?e . ("enumerate(" . ")")) evil-surround-pairs-alist)
                              (push '(?a . ("['" . "']")) evil-surround-pairs-alist)
                              ))

;; projectile search

(defun moritzs/projectile-switch-search ()
  "Switch project and search for file"
  (interactive)
  (let ((projectile-switch-project-action 'spacemacs/helm-project-smart-do-search))
    (projectile-switch-project)
    )
  )

(spacemacs/set-leader-keys
  "ps" 'moritzs/projectile-switch-search
  )

;; TODO run lsyncd automatically on project change if an lsyncd file exists
(defun auto-lsyncd ()
  "Perform some action after switching Projectile projects."
  (message "Project changed...")
  ;; Do something interesting here...
  ;;
  ;; `projectile-current-project-files', and `projectile-current-project-dirs' can be used
  ;; to get access to the new project's files, and directories.
  )

;; (add-hook 'projectile-after-switch-project-hook #'my-switch-project-hook)

;; (load "~/.spacemacs.d/lisp/science.el")

;; keyfreq
;; (setq keyfreq-excluded-commands
;;       '(self-insert-command
;;         abort-recursive-edit
;;         forward-char
;;         backward-char
;;         previous-line
;;         next-line))
;; (keyfreq-mode 1)
;; (keyfreq-autosave-mode 1)

;; apparently there is no evidence that color change shift is good in any way?
;; theme-changer (https://github.com/hadronzoo/theme-changer)
;; (setq calendar-location-name "Vienna, Austria")
;; (setq calendar-latitude 48.21003)
;; (setq calendar-longitude 16.363449)
;; (require 'theme-changer)
;; (change-theme 'spacemacs-light 'spacemacs-dark)  ;; spacemacs-light vs spacemacs-night?



(defun shell-command-on-region-replace (start end command)
  "Run shell-command-on-region interactivly replacing the region in place"
  (interactive (let (string) 
                 (unless (mark)
                   (error "The mark is not set now, so there is no region"))
                 ;; Do this before calling region-beginning
                 ;; and region-end, in case subprocess output
                 ;; relocates them while we are in the minibuffer.
                 ;; call-interactively recognizes region-beginning and
                 ;; region-end specially, leaving them in the history.
                 (setq string (read-from-minibuffer "Shell command on region: "
                                                    nil nil nil
                                                    'shell-command-history))
                 (list (region-beginning) (region-end)
                       string)))
  (shell-command-on-region start end command t t)
  )

(defun ag-on-region-replace (start end regexp)
  "Run shell-command-on-region interactivly replacing the region in place"
  (interactive (let (string) 
                 (unless (mark)
                   (error "The mark is not set now, so there is no region"))
                 ;; Do this before calling region-beginning
                 ;; and region-end, in case subprocess output
                 ;; relocates them while we are in the minibuffer.
                 ;; call-interactively recognizes region-beginning and
                 ;; region-end specially, leaving them in the history.
                 (setq string (read-regexp "regex on region"))
                 (list (region-beginning) (region-end)
                       string)))
  (shell-command-on-region start end (format "ag -o \"%s\"" regexp) t t)
  )


(defun moritzs/copy-current-kill-to-clipboard ()
  (interactive)
  (gui-set-selection 'CLIPBOARD (current-kill 0)))

(spacemacs/set-leader-keys "rc" 'moritzs/copy-current-kill-to-clipboard)


;;https://github.com/ch11ng/exwm/issues/611 fix y-or-n blocking issue TODO can be deleted after exwm upgrade!
;; (define-advice set-transient-map (:around (fun map &optional keep-pred on-exit) exwm-passthrough)
;;   (setq exwm-input-line-mode-passthrough t)
;;   (let ((on-exit (lexical-let ((on-exit on-exit))
;;                    (lambda ()
;;                      (setq exwm-input-line-mode-passthrough nil)
;;                      (when on-exit (funcall on-exit))))))
;;     (funcall fun map keep-pred on-exit)))


(defun moritzs/reverse-characters-region (beg end)
  "Reverse characters between BEG and END."
  (interactive "r")
  (let ((region (buffer-substring beg end)))
    (delete-region beg end)
    (insert (nreverse region))))

;; enable proselint in textual modes:
(add-hook 'markdown-mode-hook #'flycheck-mode)
(add-hook 'text-mode-hook #'flycheck-mode)
(add-hook 'message-mode-hook #'flycheck-mode)

;; fix google translate workarround: https://github.com/atykhonov/google-translate/issues/52
(defun google-translate--search-tkk () "Search TKK." (list 433232 899235537))

;; towards emacs mode: unmap remap C-z it to undo-tree-undo
(define-key evil-emacs-state-map (kbd "C-z") nil)
(define-key evil-motion-state-map (kbd "C-z") nil)

(define-key undo-tree-map (kbd "C-r") nil)  ;; TODO not working yet
(define-key evil-motion-state-map (kbd "C-r") 'isearch-backward)  ;; TODO not working yet

(define-key global-map (kbd "C-z") 'undo-tree-undo)
(define-key global-map (kbd "C-S-z") 'undo-tree-redo)
(define-key global-map (kbd "<redo>") 'undo-tree-redo)

;; copilot

(with-eval-after-load 'company
  ;; disable inline previews
  (delq 'company-preview-if-just-one-frontend company-frontends))

(with-eval-after-load 'copilot
  (define-key copilot-completion-map (kbd "M-<left>") 'copilot-accept-completion)
  (define-key copilot-completion-map (kbd "<down>") 'copilot-accept-completion)
  (define-key copilot-completion-map (kbd "<left>") 'copilot-accept-completion-by-word)
  ;; (define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

  (add-hook 'prog-mode-hook 'copilot-mode)

  (define-key copilot-completion-map (kbd "M-<right>") 'copilot-accept-completion-by-word)  ;; before C-
  ;; (define-key copilot-completion-map (kbd "M-TAB") 'copilot-accept-completion-by-word)
  )



;; magit
(require 'magit)
(define-key magit-hunk-section-map (kbd "M-RET") 'magit-diff-visit-file-other-window)
(define-key magit-file-section-map (kbd "M-RET") 'magit-diff-visit-file-other-window)

;;
(define-key global-map (kbd "C-p") nil)

(require 'key-chord)
(key-chord-define-global "dm" 'evil-avy-goto-char-timer)  ;; dm because it's fast to type
(key-chord-mode +1)


;; duplicate lines (https://www.emacswiki.org/emacs/CopyingWholeLines)
(defun duplicate-current-line (&optional n)
  "duplicate current line, make more than 1 copy given a numeric argument"
  (interactive "p")
  (save-excursion
    (let ((nb (or n 1))
          (current-line (thing-at-point 'line)))
      ;; when on last line, insert a newline first
      (when (or (= 1 (forward-line 1)) (eq (point) (point-max)))
        (insert "\n"))
      
      ;; now insert as many time as requested
      (while (> n 0)
        (insert current-line)
        (decf n)))))

(define-key global-map (kbd "C-d") 'duplicate-current-line)


(defun sudo-shell-command (buffer password command)
  (let ((proc (start-process-shell-command
               "*sudo*"
               buffer
               (concat "sudo bash -c "
                       (shell-quote-argument command)))))
    (process-send-string proc password)
    (process-send-string proc "\r")
    (process-send-eof proc)))

(defun sudo-nixos-rebuild ()
  (interactive)
  (let ((password (read-passwd "Sudo password for nixos-rebuild switch: ")))

    (find-file  "/home/moritz/nixos-config/README.org")
    (org-babel-tangle)
    (sudo-shell-command
     "*nixos-rebuild*"
     password
     "nixos-rebuild switch")
    (clear-string password))
  (switch-to-buffer "*nixos-rebuild*")
  )
(define-key global-map (kbd "s-M-c") 'sudo-nixos-rebuild)
(define-key global-map (kbd "s-C-c") 'sudo-nixos-rebuild)

;; https://stackoverflow.com/questions/9656311/conflict-resolution-with-emacs-ediff-how-can-i-take-the-changes-of-both-version/29757750#29757750
(defun ediff-copy-both-to-C ()
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))
(defun add-d-to-ediff-mode-map () (define-key 'ediff-mode-map "c" 'ediff-copy-both-to-C))
(add-hook 'ediff-keymap-setup-hook 'add-d-to-ediff-mode-map)


;; https://www.reddit.com/r/emacs/comments/c6m4db/grepping_recent_files_is_underrated/
(defun my-grep-recent-files (filepattern pattern)
  (interactive "sFiles regexp: \nsSearch regexp: ")
  (let ((files (if filepattern
                   (cl-remove-if-not (lambda (item) (string-match filepattern item))
                                     recentf-list)
                 recentf-list))
        (limit 50)
        (grep-use-null-device nil))
    (if (> (length files) limit)
        (subseq files 0 limit))

    (let* ((tempfile (make-temp-file "emacs"))
           (orig compilation-finish-functions))
      (add-to-list 'compilation-finish-functions
                   (lambda (buf result)
                     (setq font-lock-keywords-case-fold-search t)
                     (highlight-regexp pattern 'hi-yellow)
                     (delete-file tempfile) 
                     (setq compilation-finish-functions orig)))

      (write-region  (mapconcat 'identity files (char-to-string 0))
                     nil tempfile)

      (grep (format "%s %s | xargs -0 grep -n -i \"%s\" "
                    (if (eq system-type 'windows-nt)
                        "type"
                      "cat")

                    (if (eq system-type 'windows-nt)
                        (replace-regexp-in-string "/" "\\\\" tempfile)
                      tempfile)

                    pattern)))))

;; monitor the system clipboard and add any changes to the kill ring
;; (clipmon-mode-start)  ;; <- might freeze emacs...
;; (clipmon-mode 1) ;; TODO observe whether this fixes it

(with-eval-after-load 'dap-ui  ;; TODO dap-ui is only loaded after first DAP run :/
  (message "NOW dap-ui loaded")

  ;; Use
  (defun moritzs/dap-python-conda-env-advice (orig-fun &rest args)
    "Advice to set up Python executable for dap-python with conda environment."
    (let* ((conf (first args))
           (original-dap-python-executable dap-python-executable)
           (conda-env (or (plist-get conf :condaEnv) "base"))
           (starter-file (format "/tmp/emacs_dap_python_conda_%s_starter" conda-env)))
      ;; Create the starter script if it doesn't exist
      (unless (file-exists-p starter-file)
        (with-temp-file starter-file
          (insert "#!/usr/bin/env conda-shell\n\n")
          (insert (format "conda activate %s\n" conda-env))
          (insert "python \"$@\"\n"))
        (chmod starter-file #o755))
      ;; Set the dap-python-executable to the starter script
      (setq dap-python-executable starter-file)
      ;; Call the original function
      (prog1
          (apply orig-fun args)
        ;; Reset dap-python-executable to its original value
        (setq dap-python-executable original-dap-python-executable))))

  (advice-add 'dap-python--populate-start-file-args :around #'moritzs/dap-python-conda-env-advice)


  (dap-register-debug-template
   "Python :: Attach running debug process"
   (list :name "Python :: Attach running debug process"
         :type "python"
         :args ""
         :cwd "${workspaceFolder}"
         :port 5678
         :host "localhost"
         :module nil
         :program nil
         :request "attach"))

  (dap-register-debug-template
   "Python :: Attach running remote debug process"
   (list :name "Python :: Attach running remote debug process"
         :type "python"
         :args ""
         :cwd "${workspaceFolder}"
         :port 5679
         :host "localhost"
         :module nil
         :program nil
         :request "attach"))

  (defvar dap-exception-breakpoints nil)

  ;; Eval/Inspect (real inspect is not implemented apparently)
  (defun moritzs/dap-eval-region-or-thing-at-point ()
    "Evaluate the selected region or the thing at point with DAP."
    (interactive)
    (if (use-region-p)
        (dap-eval-region (region-beginning) (region-end))
      (dap-eval-thing-at-point)))
  (defun moritzs/dap-eval-WORD-at-point ()
    "Evaluate the WORD under the cursor with DAP."
    (interactive)
    (let ((pos (point))
          (bounds (bounds-of-thing-at-point 'symbol)))
      (if bounds
          (progn
            (evil-backward-WORD-begin)
            (setq start (point))
            (evil-inner-WORD)
            (setq end (point))
            (dap-eval-region start end)
            (goto-char pos))
        (message "No WORD at point."))))
  (define-key dap-mode-map (kbd "M-I") #'moritzs/dap-eval-WORD-at-point)
  (define-key dap-mode-map (kbd "M-i") #'moritzs/dap-eval-region-or-thing-at-point)

  (add-hook 'dap-stopped-hook (lambda (arg) (exwm-workspace-switch 1)))  ;; an improved version would identify the workspace where dap-ui-controls-mode is active (the dap-frame and and dap-workspace fields are useless)
  (advice-add 'dap-ui--show-many-windows :before #'(lambda (&rest args) (exwm-workspace-switch 1)))

  ;; Navigation
  (define-key dap-mode-map (kbd "S-<right>") 'dap-next)
  (define-key dap-mode-map (kbd "S-<left>") 'dap-continue)
  (define-key dap-mode-map (kbd "S-<up>") 'dap-step-out)
  (define-key dap-mode-map (kbd "S-<down>") 'dap-step-in)
  (define-key dap-mode-map (kbd "M-<up>") 'dap-up-stack-frame)
  (define-key dap-mode-map (kbd "M-<down>") 'dap-down-stack-frame)

  )

;; add gitignore to lsp-ignore
;; https://github.com/emacs-lsp/lsp-mode/issues/713 (the stuff below can be deleted once the issue is closed )
(defun ++git-ignore-p (path)
  (let* (; trailing / breaks git check-ignore if path is a symlink:
         (path (directory-file-name path))
         (default-directory (file-name-directory path))
         (relpath (file-name-nondirectory path))
         (cmd (format "git check-ignore '%s'" relpath))
         (status (call-process-shell-command cmd)))
    (eq status 0)))

(defun ++lsp--path-is-watchable-directory-a
    (fn path dir ignored-directories)
  (and (not (++git-ignore-p (f-join dir path)))
       (funcall fn path dir ignored-directories)))

(advice-add 'lsp--path-is-watchable-directory
            :around #'++lsp--path-is-watchable-directory-a)

;; Prevent importmagicserver to lock my PC upon boot
(defun renice-importmagicserver ()
  "Renice the importmagicserver.py process."
  (let ((command "pgrep -f importmagicserver.py | xargs -r renice -n 11 >/dev/null 2>&1"))
    (shell-command command)))


;; Whisper
(exwm-input-set-key (kbd "C-s-g") #'whisper-run)
(remove-hook 'whisper-pre-process-hook 'whisper--check-buffer-read-only-p)
;; Add a hook that kills the output of whisper (which is the 'current buffer')
(add-hook 'whisper-post-process-hook
          (lambda ()
            (kill-ring-save (point-min) (point-max))
            (let ((major-mode (with-current-buffer whisper--point-buffer
                                major-mode)))

              (when (derived-mode-p 'exwm-mode)
                (start-process-shell-command "slock" nil "sleep 0.05; echo key ctrl+v | dotool")
                )
              ))
          )

(add-hook 'importmagic-mode-hook 'renice-importmagicserver)

;; TODO automatically import everything in lisp/

(load "~/.spacemacs.d/lisp/org.el")
(load "~/.spacemacs.d/lisp/exwm.el")
(load "~/.spacemacs.d/lisp/layouts.el")
(load "~/.spacemacs.d/lisp/dna.el")
(load "~/.spacemacs.d/lisp/pdf.el")
(load "~/.spacemacs.d/lisp/isearch.el")

;; (load "~/.spacemacs.d/lisp/eaf.el")
;; (load "~/.spacemacs.d/lisp/feedly.el")
;; (load "~/.spacemacs.d/secrets/feedly.el")


;;(load "~/.spacemacs.d/lisp/mu4e.el")

;; TODO map C-e to C-x doesn't work anymore...
;; (load "~/.spacemacs.d/lisp/rebinder.el")

;; (define-key global-map (kbd "C-e") (rebinder-dynamic-binding "C-x"))
;; (define-key global-map (kbd "C-n") (rebinder-dynamic-binding "C-c"))
;; (define-key rebinder-mode-map (kbd "C-c") 'backward-char)

;; (rebinder-hook-to-mode 't 'after-change-major-mode-hook)

