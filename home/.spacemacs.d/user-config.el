(define-coding-system-alias 'UTF-8 'utf-8)

(require 'forge)
(require 'ox-beamer)


;; For all programming modes
(add-hook 'prog-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))


(spacemacs/set-leader-keys
  "feuc" (lambda () (interactive) (find-file "~/.spacemacs.d/user-config.el"))
  )

(spacemacs/set-leader-keys
  "feui" (lambda () (interactive) (find-file "~/.spacemacs.d/user-init.el"))
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
(global-set-key (kbd "<left>") 'evil-window-left)
(global-set-key (kbd "<right>") 'evil-window-right)
(global-set-key (kbd "<up>") 'evil-window-up)
(global-set-key (kbd "<down>") 'evil-window-down)
(define-key evil-motion-state-map (kbd "<left>") 'evil-window-left)
(define-key evil-motion-state-map (kbd "<right>") 'evil-window-right)
(define-key evil-motion-state-map (kbd "<up>") 'evil-window-up)
(define-key evil-motion-state-map (kbd "<down>") 'evil-window-down)

(define-key evil-ex-completion-map [left] 'evil-backward-char)
(define-key evil-ex-completion-map [right] 'evil-forward-char)
(define-key evil-ex-search-keymap [left] 'evil-backward-char)
(define-key evil-ex-search-keymap [right] 'evil-forward-char)

(define-key minibuffer-local-map [up] 'evil-previous-line)
(define-key minibuffer-local-map [down] 'evil-next-line)
(define-key minibuffer-local-map [left] 'evil-backward-char)
(define-key minibuffer-local-map [right] 'evil-forward-char)

(define-key evil-motion-state-map (kbd "C-f") nil)
(define-key evil-motion-state-map (kbd "C-f") 'evil-avy-goto-char-timer)

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

(defun moritzs/dired-copy-file-path
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
                              (push '(?e . ("enumerate(" . ")")) evil-surround-pairs-alist)))


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
        (args (append pdf-misc-print-programm-args (list filename "-P" (number-to-string(image-mode-window-get 'page))))))
    (unless programm
      (error "No print program available"))
    (apply #'start-process "printing" nil programm args)
    (message "Print job started: %s %s"
             programm (mapconcat #'identity args " "))))

(spacemacs/set-leader-keys-for-major-mode 'pdf-view-mode
  "b" 'org-ref-pdf-to-bibtex)
(spacemacs/set-leader-keys-for-major-mode 'pdf-view-mode
  "c" 'moritzs/pdf-misc-print-current-page)

(load "~/.spacemacs.d/lisp/exwm.el")
(load "~/.spacemacs.d/lisp/org.el")
(load "~/.spacemacs.d/lisp/dna.el")

