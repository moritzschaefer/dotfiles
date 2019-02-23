(define-coding-system-alias 'UTF-8 'utf-8)


(setq org-download-method 'attach)

;; For all programming modes
(add-hook 'prog-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))

(add-hook 'org-capture-mode-hook 'evil-insert-state)

;; only the third line works apparently...
;;(add-hook 'hack-local-variables-hook (lambda () (setq truncate-lines f)))
;;(spacemacs/toggle-truncate-lines-off)
(add-hook 'org-mode-hook #'spacemacs/toggle-truncate-lines-off)

(require 'org-agenda)
(define-key org-agenda-mode-map "i" 'org-agenda-clock-in)
(define-key org-agenda-mode-map "r" 'moritzs/org-process-inbox)
(define-key org-agenda-mode-map "R" 'org-agenda-refile)
(define-key org-agenda-mode-map "c" 'moritzs/org-inbox-capture)

(org-babel-do-load-languages
  'org-babel-load-languages
  '((ipython . t)
    ;; other languages..
    ))
(setq org-confirm-babel-evaluate nil)   ;don't prompt me to confirm everytime I want to evaluate a block

;;; display/update images in the buffer after I evaluate TODO don't know if this is necessary
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)
;; TODO this does not work because org-latex-minted-langs is not set or so..
;; (add-to-list 'org-latex-minted-langs '(ipython "python"))

;; add sketch to org file
(defun moritzs/org-download-sketch ()
  "Draw sketch and download it. Used tool is mypaint"
  (interactive)
  ;; We can use most of the objects from org-download
  (call-process-shell-command (format "rm %s" org-download-screenshot-file)
                              nil "*Shell Command Output*" t)
  (call-process-shell-command (format "/usr/bin/mypaint %s"
                                      org-download-screenshot-file)
                              nil "*Shell Command Output*" t
                              )
  (org-download-image org-download-screenshot-file))

(spacemacs/set-leader-keys
  "feuc" (lambda () (interactive) (find-file "~/.spacemacs.d/user-config.el"))
  )

(spacemacs/set-leader-keys
  "feui" (lambda () (interactive) (find-file "~/.spacemacs.d/user-init.el"))
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
(spacemacs/set-leader-keys-for-major-mode 'org-mode
  "id" 'moritzs/org-download-sketch)

(spacemacs/set-leader-keys-for-major-mode 'org-mode
  "ip" 'moritzs/download-smartphone-photo)

(spacemacs/set-leader-keys-for-major-mode 'org-mode
  "$" 'moritzs/org-archive-done-tasks)

(spacemacs/set-leader-keys
  "aoj" 'org-now
  )

(spacemacs/set-leader-keys-for-major-mode 'org-mode
  "j" 'org-now) ; jetzt

(spacemacs/set-leader-keys-for-major-mode 'org-mode
  "in" 'org-now-link) ; insert->now

;; auto org save buffers after refile.
(advice-add 'org-refile :after
            (lambda (&rest _)
              (org-save-all-org-buffers)))
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

;; refine autocompletion behavior

;; I can use the error keys her
(require 'company)
(define-key company-active-map (kbd "M-n") nil)
(define-key company-active-map (kbd "M-p") nil)
(add-to-list 'company-backends 'company-ob-ipython)

(global-set-key (kbd "M-n") 'hippie-expand)
;; (global-set-key (kbd "M-n") 'yas-expand)


(use-package org
  :config
  (setq org-startup-indented t))
;; clipboard management
(setq x-select-enable-clipboard nil)
(setq x-select-enable-primary t)
(setq mouse-drag-copy-region t)
(define-key evil-insert-state-map  (kbd "C-v") (kbd "+"))
(define-key evil-ex-completion-map (kbd "C-v") (kbd "+"))
(define-key evil-ex-search-keymap  (kbd "C-v") (kbd "+"))

(eval-after-load "ansi-term"
  '(define-key ansi-term-raw-map (kbd "C-v") 'term-paste))

(add-hook 'ess-mode-hook
          (lambda ()
            (ess-toggle-underscore nil)))

  ;; (require 'exec-path-from-shell)
  ;; (exec-path-from-shell-copy-env "SSH_AGENT_PID")
  ;;(exec-path-from-shell-copy-env "SSH_AUTH_SOCK")
  ;; TODO dont add projectile files...
  ;; (with-eval-after-load 'org-agenda
  ;;   (require 'org-projectile)
  ;;   (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
  ;;   )
  (defvar moritzs/new-project-template
    "
    *Project Purpose/Principles*:

    *Project Outcome*:
    "
    "Project template, inserted when a new project is created")

  (defvar moritzs/is-new-project nil
    "Boolean indicating whether it's during the creation of a new project")

  (defun moritzs/refile-new-child-advice (orig-fun parent-target child)
    (let ((res (funcall orig-fun parent-target child)))
      (save-excursion
        (find-file (nth 1 parent-target))
        (goto-char (org-find-exact-headline-in-buffer child))
        (org-add-note)
        )
      res))

  (advice-add 'org-refile-new-child :around #'moritzs/refile-new-child-advice)
  (defun moritzs/set-todo-state-next ()
    "Visit each parent task and change NEXT states to TODO"
    (org-todo "NEXT"))

  (add-hook 'org-clock-in-hook 'moritzs/set-todo-state-next 'append)
(setq org-agenda-block-separator nil)
(setq org-agenda-start-with-log-mode t)
(setq moritzs/org-agenda-todo-view
      `(" " "Agenda"
        ((agenda ""
                ((org-agenda-span 'day)
                  (org-deadline-warning-days 365)))
        (todo "TODO"
              ((org-agenda-overriding-header "To Refile")
                (org-agenda-files '("~/wiki/gtd/inbox.org"))))
        ;; (todo "TODO"
        ;;       ((org-agenda-overriding-header "Emails")
        ;;         (org-agenda-files '("~/wiki/gtd/emails.org")))) TODO add later..
        (todo "NEXT"
              ((org-agenda-overriding-header "In Progress")
                (org-agenda-files '("~/wiki/gtd/someday.org"
                                    "~/wiki/gtd/projects.org"
                                    "~/wiki/gtd/next.org"))
                ;; (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))
                ))
        (todo "TODO"
              ((org-agenda-overriding-header "Projects")
                (org-agenda-files '("~/wiki/gtd/projects.org"))
                (org-agenda-skip-function #'moritzs/org-agenda-skip-all-siblings-but-first)))
        (todo "TODO"
              ((org-agenda-overriding-header "One-off Tasks")
                (org-agenda-files '("~/wiki/gtd/next.org"))
                (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))))
        nil)))

(defun moritzs/org-agenda-skip-all-siblings-but-first ()
  "Skip all but the first non-done entry."
  (let (should-skip-entry)
    (unless (or (org-current-is-todo)
                (not (org-get-scheduled-time (point))))
      (setq should-skip-entry t))
    (save-excursion
      (while (and (not should-skip-entry) (org-goto-sibling t))
        (when (org-current-is-todo)
          (setq should-skip-entry t))))
    (when should-skip-entry
      (or (outline-next-heading)
          (goto-char (point-max))))))

(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))

(defun moritzs/switch-to-agenda ()
  (interactive)
  (org-agenda nil " ")
  (delete-other-windows))

(bind-key "<f1>" 'moritzs/switch-to-agenda)
(setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)")
(setq org-agenda-custom-commands
    `(,moritzs/org-agenda-inbox-view
      ,moritzs/org-agenda-someday-view
      ,moritzs/org-agenda-todo-view
      ))

(defun moritzs/org-capture-hook ()
  (when (equal (buffer-name) "CAPTURE-receipts.org")
    (newline)
    (moritzs/download-smartphone-photo)
    ))

(add-hook 'org-capture-before-finalize-hook 'moritzs/org-capture-hook)

(eval-after-load 'ox '(require 'ox-koma-letter))
(eval-after-load 'ox-latex
  '(add-to-list 'org-latex-packages-alist '("AUTO" "babel" t) t))

(setq reftex-default-bibliography '("~/wiki/papers/references.bib"))

(setq org-ref-notes-directory "~/wiki/papers/notes"
      org-ref-default-bibliography '("~/wiki/papers/references.bib")
      org-ref-pdf-directory "~/wiki/papers/"
      org-ref-bibliography-notes "~/wiki/papers.org")

(setq helm-bibtex-bibliography "~/wiki/papers/references.bib"
      helm-bibtex-library-path "~/wiki/papers/"
      helm-bibtex-notes-path "~/wiki/papers.org")

(setq bibtex-completion-bibliography "~/wiki/papers/references.bib"
      bibtex-completion-library-path "~/wiki/papers/"
      bibtex-completion-notes-path "~/wiki/papers.org")


(setq bibtex-completion-pdf-open-function 'org-open-file)

(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))

(setq org-file-apps
      '(("\\.docx?\\'" . system)
        ("\\.pptx?\\'" . system)
        ("\\.x?html?\\'" . default)
        ("\\.svg\\'" . "inkscape %s")
        ("\\.gan\\'" . "ganttproject %s")
        ("\\.pdf\\'" . default)
        ("\\.png\\'" . system)
        (system . system)
        (auto-mode . emacs)))
(setq openwith-associations '(("\\.svg\\'" "inkscape" (file))))

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


(openwith-mode t)

(require 'org-now)
;; (use-package org-now
;;   :general (:keymaps 'org-mode-map
;;                      :prefix "M-SPC"
;;                      "rl" #'org-now-link
;;                      "rn" #'org-now-refile-to-now
;;                      "rp" #'org-now-refile-to-previous-location))

(setq org-link-abbrev-alist '(("att" . org-attach-expand-link)))

(load "~/.spacemacs.d/lisp/exwm.el")
