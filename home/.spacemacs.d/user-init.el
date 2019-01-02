;;(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

(setq shell-file-name "/bin/bash") 
(setq org-reveal-root "file:///opt/reveal.js-3.7.0/")
;; set specific browser to open links
(setq browse-url-browser-function 'browse-url-firefox)
(require 'find-lisp)
(setq moritzs/org-agenda-directory "~/wiki/gtd/")
(setq org-agenda-files
      (find-lisp-find-files moritzs/org-agenda-directory "\.org$"))
(require 'org-agenda)
(setq moritzs/org-agenda-inbox-view
      `("i" "Inbox" todo ""
        ((org-agenda-files '("~/wiki/gtd/inbox.org")))))
(setq moritzs/org-agenda-someday-view
      `("s" "Someday" todo ""
        ((org-agenda-files '("~/wiki/gtd/someday.org")))))
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-log-state-notes-insert-after-drawers nil)
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
        (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))

(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-log-state-notes-insert-after-drawers nil)
(setq org-tag-alist (quote (("@errand" . ?e)
                            ("@office" . ?o)
                            ("@question" . ?q)
                            ("@home" . ?h)
                            ("@school" . ?s)
                            (:newline)
                            ("WAITING" . ?w)
                            ("HOLD" . ?H)
                            ("CANCELLED" . ?c))))

(setq org-fast-tag-selection-single-key nil)
(setq org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-refile-targets '(("next.org" :level . 0)
                            ("einkaufen.org" :level . 0)
                            ("someday.org" :level . 0)
                            ("projects.org" :maxlevel . 1)))
(defvar moritzs/org-agenda-bulk-process-key ?f
  "Default key for bulk processing inbox items.")

(defun moritzs/compute-paper-template ()
  (let (tmp url title abstract)
    (setq url (shell-command-to-string "xsel -b"))
    (setq title
      (with-current-buffer (url-retrieve-synchronously url)
        (goto-char (point-min))
        (re-search-forward "<title>\\([^<]*\\)</title>" nil t 1)
        (setq tmp (match-string 1))
        (goto-char (point-min))
        (re-search-forward "charset=\\([-0-9a-zA-Z]*\\)" nil t 1)
        (decode-coding-string tmp (intern (match-string 1)))))
    (setq abstract (shell-command-to-string (format "python -c \"import eutils; c=eutils.Client(); a=c.efetch('pubmed', c.esearch('pubmed', '%s').ids[0]); print(next(iter(a)).abstract, end='')\" 2> /dev/null" title )))

    ;; maybe add[[file:%s][PDF]]
    (format "TODO %s
[[%s][Article]], 
** Abstract
%s
** Notes
- %%?" title url abstract)
    )
  )


(defun moritzs/org-process-inbox ()
  "Called in org-agenda-mode, processes all inbox items."
  (interactive)
  (org-agenda-bulk-mark-regexp "inbox:")
  (moritzs/bulk-process-entries))

(defun moritzs/org-agenda-process-inbox-item ()
  "Process a single item in the org-agenda."
  (org-with-wide-buffer
  (org-agenda-set-tags)
  (org-agenda-priority)
  (org-agenda-set-effort)
  (org-agenda-refile nil nil t)))

(defun moritzs/bulk-process-entries ()
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
              (let (org-loop-over-headlines-in-active-region) (funcall 'moritzs/org-agenda-process-inbox-item))
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



(defun moritzs/org-inbox-capture ()
  (interactive)
  "Capture a task in agenda mode."
  (org-capture nil "i"))

(setq org-agenda-bulk-custom-functions `((,moritzs/org-agenda-bulk-process-key jethro/org-agenda-process-inbox-item)))

(defun moritzs/recent-download-file ()
  "Open a recently downloaded file."
  (interactive)

  (setq downloaded-file (shell-command-to-string "ls -t /home/moritz/Downloads | head -n 1 | tr -d '\n'"))

  (find-file-existing (format "/home/moritz/Downloads/%s" downloaded-file))
  )

(defun moritzs/recent-smartphone-photo ()
  "Open a recently taken smartphone picture."
  (format "/home/moritz/Seafile/Main/My Photos/Camera/%s" (shell-command-to-string "ls -t  '/home/moritz/Seafile/Main/My Photos/Camera/' | head -n 1 | tr -d '\n'"))
  )


(defun moritzs/download-smartphone-photo ()
  (interactive)
  (org-download-image (moritzs/recent-smartphone-photo))
  )

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

(setq org-odt-preferred-output-format "docx")

(setq org-src-tab-acts-natively t)

(add-hook 'python-mode-hook (lambda ()
                           (push '(?e . ("enumerate(" . ")")) evil-surround-pairs-alist)))
