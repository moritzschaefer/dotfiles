(define-coding-system-alias 'UTF-8 'utf-8)

(require 'forge)
(require 'ox-beamer)
(require 'pdf-misc)


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
(define-key org-mode-map (kbd "C-m") nil)
(define-key evil-motion-state-map (kbd "C-m") 'evil-avy-goto-char-timer)

;; refine autocompletion behavior

;; I can use the error keys her
(require 'company)
(define-key company-active-map (kbd "M-n") nil)
(define-key company-active-map (kbd "M-p") nil)
(add-to-list 'company-backends 'company-ob-ipython)

(global-set-key (kbd "M-n") 'hippie-expand)
;; (global-set-key (kbd "M-n") 'yas-expand)


;; clipboard management
(setq x-select-enable-clipboard nil)
(setq x-select-enable-primary t)
(setq mouse-drag-copy-region t)
(define-key evil-insert-state-map  (kbd "C-v") (kbd "+"))
(define-key evil-ex-completion-map (kbd "C-v") (kbd "+"))
(define-key evil-ex-search-keymap  (kbd "C-v") (kbd "+"))

(with-eval-after-load "ansi-term"
  (define-key term-raw-map (kbd "s-r") nil)
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
(setq keyfreq-excluded-commands
      '(self-insert-command
        abort-recursive-edit
        forward-char
        backward-char
        previous-line
        next-line))
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)


(evil-set-initial-state 'pdf-view-mode 'normal)

(defun moritzs/pdf-misc-print-current-page (filename &optional interactive-p)
  (interactive
   (list (pdf-view-buffer-file-name) t))
  (cl-check-type filename (and string file-readable))
  (let ((programm (pdf-misc-print-programm interactive-p))
        (args (append pdf-misc-print-programm-args (list filename "-o" (format "page-ranges=%s " (image-mode-window-get 'page))))))
    (unless programm
      (error "No print program available"))
    (apply #'start-process "printing" nil programm args)
    (message "Print job started: %s %s"
             programm (mapconcat #'identity args " "))))

(defun moritzs/pdf-misc-print-until-current-page (filename &optional interactive-p)
  (interactive
   (list (pdf-view-buffer-file-name) t))
  (cl-check-type filename (and string file-readable))
  (let ((programm (pdf-misc-print-programm interactive-p))
        (args (append pdf-misc-print-programm-args (list filename "-o" (format "page-ranges=1-%s" (image-mode-window-get 'page))))))
    (unless programm
      (error "No print program available"))
    (apply #'start-process "printing" nil programm args)
    (message "Print job started: %s %s"
             programm (mapconcat #'identity args " "))))

(spacemacs/set-leader-keys-for-major-mode 'pdf-view-mode
  "b" 'org-ref-pdf-to-bibtex)
(spacemacs/set-leader-keys-for-major-mode 'pdf-view-mode
  "c" 'moritzs/pdf-misc-print-current-page)
(spacemacs/set-leader-keys-for-major-mode 'pdf-view-mode
  "u" 'moritzs/pdf-misc-print-until-current-page)

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
;;https://github.com/ch11ng/exwm/issues/611 fix y-or-n blocking issue TODO can be deleted after exwm upgrade!
(define-advice set-transient-map (:around (fun map &optional keep-pred on-exit) exwm-passthrough)
  (setq exwm-input-line-mode-passthrough t)
  (let ((on-exit (lexical-let ((on-exit on-exit))
                   (lambda ()
                     (setq exwm-input-line-mode-passthrough nil)
                     (when on-exit (funcall on-exit))))))
    (funcall fun map keep-pred on-exit)))


(defun moritzs/notebook-name ()
  (interactive)
  (let* ((name (read-string "notebook name: "))
        (path "~/wiki/gtd/quick/")
        (complete-name (expand-file-name (format "%s.org"
                              name) path))
    )
    (find-file complete-name)
    )
  )

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
(add-hook 'org-mode-hook #'flycheck-mode)

;; fix google translate workarround: https://github.com/atykhonov/google-translate/issues/52
(defun google-translate--search-tkk () "Search TKK." (list 433232 899235537))

(load "~/.spacemacs.d/lisp/exwm.el")
(load "~/.spacemacs.d/lisp/org.el")
(load "~/.spacemacs.d/lisp/dna.el")

(load "~/.spacemacs.d/lisp/rebinder.el")

(define-key global-map (kbd "s-e") (rebinder-dynamic-binding "C-x"))
;; (define-key rebinder-mode-map (kbd "C-c") 'backward-char)

(rebinder-hook-to-mode 't 'after-change-major-mode-hook)
