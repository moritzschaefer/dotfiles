(defun moritzs/switch-to-agenda ()
  (interactive)
  (exwm-workspace-switch-create 4)
  (org-agenda nil " ")
  ;;(delete-other-windows)
  )

(require 'org-agenda)
(setq moritzs/org-agenda-inbox-view
      `("i" "Inbox" todo ""
        ((org-agenda-files '("~/wiki/gtd/inbox.org" "~/wiki/gtd/orgzly_smartphone/Smartphone.org" )))))
;; (setq moritzs/org-agenda-someday-view
;;       `("s" "Someday" todo ""
;;         ((org-agenda-files '("~/wiki/gtd/someday.org")))))
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-log-state-notes-insert-after-drawers nil)
(setq org-todo-keywords
      '((sequence "BACKLOG(b)" "TODO(t)" "NEXT(n)" "|" "DONE(d)")
        (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c!)")))

(setq org-tag-alist (quote (("ignore" . ?i)
                            ;; ("@errand" . ?e)
                            ("noexport" . ?e)
                            ("@office" . ?o)
                            ;; ("@question" . ?q)
                            ("@home" . ?h)
                            ("leisure" . ?l)
                            ;; ("@school" . ?s)
                            ("delegate" . ?d)
                            (:newline)
                            ("WAITING" . ?w)
                            ("HOLD" . ?H)
                            ("CANCELLED" . ?c))))

(setq org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-refile-targets '(("/home/moritz/wiki/gtd/inbox.org" :level . 0)
                           ("/home/moritz/wiki/gtd/einkaufen.org" :level . 0)
                           ("/home/moritz/wiki/gtd/toread.org" :level . 0)
                           ("/home/moritz/wiki/gtd/someday.org" :level . 0)
                           ("/home/moritz/wiki/gtd/projects.org" :level . 1)
                           ))
;; (defvar moritzs/org-agenda-bulk-process-key ?f
;;   "Default key for bulk processing inbox items.")

(defun moritzs/bulk-process-entries (item-process-function)
  (if (not (null org-agenda-bulk-marked-entries))
      (let ((entries (reverse org-agenda-bulk-marked-entries))
            (processed 0)
            (skipped 0))
        (dolist (e entries)
          (let ((pos (text-property-any (point-min) (point-max) 'org-hd-marker e)))
            (if (not pos)
                (progn (message "Skipping removed entry at %s" e)
                       (cl-incf skipped))
              (goto-char pos)

                                        ; (save-excursion
              ;;   (org-back-to-heading t)
              ;;   (and (let ((case-fold-search nil))
              ;;          (looking-at org-todo-line-regexp))
              ;;        (match-end 2)
              ;;        (match-string 2))))
              ;; (message "%s" (get-text-property (point-at-bol) 'org-marker)) ;; same as org-get-at-bol
              ;; (message "%s" (text-properties-at (point-at-bol))) ;; TODO exploit the text property that shows that this is green==DONE (or CANCELLED)
              (org-agenda-do-context-action)
              (let (org-loop-over-headlines-in-active-region) (funcall item-process-function))
              ;; `post-command-hook' is not run yet.  We make sure any
              ;; pending log note is processed.
              (when (or (memq 'org-add-log-note (default-value 'post-command-hook))
                        (memq 'org-add-log-note post-command-hook))
                (org-add-log-note))
              (cl-incf processed))))
        (org-agenda-redo)
        (unless org-agenda-persistent-marks (org-agenda-bulk-unmark-all))
        (message "Acted on %d entries%s%s"
                 processed
                 (if (= skipped 0)
                     ""
                   (format ", skipped %d (disappeared before their turn)"
                           skipped))
                 (if (not org-agenda-persistent-marks) "" " (kept marked)")))
    ))

;; (define-key org-agenda-mode-map "i" 'org-agenda-clock-in)
;; (define-key org-agenda-mode-map "R" 'org-agenda-refile)
;; (define-key org-agenda-mode-map "c" 'moritzs/org-inbox-capture)

(defun moritzs/mark-as-project ()
  "From https://karl-voit.at/2019/11/03/org-projects/
  This function makes sure that the current heading has
(1) the tag :project:
(2) has property COOKIE_DATA set to \"todo recursive\"
(3) has any TODO keyword
(4) a leading progress indicator and
(5) is refiled to projects
"
  (interactive)
  (org-toggle-tag "project" 'on)
  (org-set-property "COOKIE_DATA" "todo recursive")
  (org-back-to-heading t)
  (let* ((title (nth 4 (org-heading-components)))
         (keyword (nth 2 (org-heading-components))))
    (when (and (bound-and-true-p keyword) (string-prefix-p "[" title))
      (message "TODO keyword and progress indicator found")
      )
    (when (and (not (bound-and-true-p keyword)) (string-prefix-p "[" title))
      (message "no TODO keyword but progress indicator found")
      (forward-whitespace 1)
      (insert "NEXT ")
      )
    (when (and (not (bound-and-true-p keyword)) (not (string-prefix-p "[" title)))
      (message "no TODO keyword and no progress indicator found")
      (forward-whitespace 1)
      (insert "NEXT [/] ")
      )
    (when (and (bound-and-true-p keyword) (not (string-prefix-p "[" title)))
      (message "TODO keyword but no progress indicator found")
      (forward-whitespace 2)
      (insert "[/] ")
      )
    )
  (org-refile nil nil (list "projects.org" "/home/moritz/wiki/gtd/projects.org" nil nil))
  ;; open buffer projects.org
  (find-file "/home/moritz/wiki/gtd/projects.org")
  )

;; (defun moritzs/org-inbox-capture ()
;;   (interactive)
;;   "Capture a task in agenda mode."
;;   (org-capture nil "i"))

(defun moritzs/org-archive-done-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading)))
   "/DONE" 'file)

  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading)))
   "/CANCELLED" 'file)
  )
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
         (todo "NEXT"
               ((org-agenda-overriding-header "In Progress")
                (org-agenda-files '("~/wiki/gtd/projects.org" "~/wiki/gtd/someday.org" "~/wiki/gtd/inbox.org"))
                ;; (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))
                ))
         (todo "TODO"
               ((org-agenda-overriding-header "To Refile")
                (org-agenda-files '("~/wiki/gtd/inbox.org" "~/wiki/gtd/orgzly_smartphone/Smartphone.org"))))
         ;; (todo "TODO"
         ;;       ((org-agenda-overriding-header "Emails")
         ;;         (org-agenda-files '("~/wiki/gtd/emails.org")))) TODO add later..
         (todo "TODO"
               ((org-agenda-overriding-header "Reading")
                (org-agenda-files '("~/wiki/gtd/toread.org"))
                (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))))
         (todo "TODO"
               ((org-agenda-overriding-header "Undated")
                (org-agenda-files '("~/wiki/gtd/projects.org" "~/wiki/gtd/someday.org"))
                (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))
                ))
         nil)))


(setq moritzs/org-agenda-undone-view  ;; TODO needs to get updated
      `("u" "Undone"
        (
         (todo "TODO"
               ((org-agenda-overriding-header "To Refile")
                (org-agenda-files '("~/wiki/gtd/inbox.org" "~/wiki/gtd/someday.org"))))
         ;; (todo "TODO"
         ;;       ((org-agenda-overriding-header "Emails")
         ;;         (org-agenda-files '("~/wiki/gtd/emails.org")))) TODO add later..
         (todo "NEXT"
               ((org-agenda-overriding-header "In Progress")
                (org-agenda-files '("~/wiki/gtd/someday.org" "~/wiki/gtd/projects.org"))
                ;; (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))
                ))
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


(setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)")
(setq org-agenda-custom-commands
      `(,moritzs/org-agenda-inbox-view
        ;; ,moritzs/org-agenda-someday-view
        ,moritzs/org-agenda-todo-view
        ,moritzs/org-agenda-undone-view
        ))

(defun moritzs/org-capture-hook ()
  (when (equal (buffer-name) "CAPTURE-receipts.org")
    (newline)
    (moritzs/download-smartphone-photo)
    ))

(add-hook 'org-capture-before-finalize-hook 'moritzs/org-capture-hook)
