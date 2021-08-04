;;(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
(with-eval-after-load 'org
  (require 'org-capture)
  (require 'org-attach)
  (require 'ox-extra)
  ;; (setq org-roam-v2-ack t)
  ;; (org-roam-setup)
  (require 'org-roam-protocol)

  (ox-extras-activate '(ignore-headlines))

  (setq org-reveal-root "file:///opt/reveal.js-3.7.0/")
  ;; set specific browser to open links
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
        '((sequence "BACKLOG(b)" "TODO(t)" "NEXT(n)" "|" "DONE(d)")
          (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))

  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-log-state-notes-insert-after-drawers nil)
  (setq org-tag-alist (quote (("ignore" . ?i)
                              ("@errand" . ?e)
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

  (setq org-download-method 'attach)
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

  (defun moritzs/org-set-weekly-id-property ()
    (interactive)
      (let ((value (read-string "weekly_id:")))  ;; TODO could use interactive as well..
        (org-set-property "CUSTOM_ID" (concat "weekly_id:" value))
        (kill-new (concat "#+INCLUDE: \"./phd.org::#weekly_id:" value "\" :only-contents t"))
        )
    )



  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "sp" 'org-set-property)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "sw" 'moritzs/org-set-weekly-id-property)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "sH" 'helm-org-in-buffer-headings)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "ld" 'doi-utils-add-bibtex-entry-from-doi)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "br" 'python-shell-send-region)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "bR" 'spacemacs/python-shell-send-region-switch)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "tC" 'org-table-create-or-convert-from-region)


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

  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "id" 'moritzs/org-download-sketch)

  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "ip" 'moritzs/download-smartphone-photo)

  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "$" 'moritzs/org-archive-done-tasks)

  ;; (spacemacs/set-leader-keys
  ;;   "aoj" 'org-now
  ;;   )

  ;; (spacemacs/set-leader-keys-for-major-mode 'org-mode
  ;;   "j" 'org-now) ; jetzt

  ;; (spacemacs/set-leader-keys-for-major-mode 'org-mode
  ;;   "in" 'org-now-link) ; insert->now

  ;; (require 'org-now)
  ;; (use-package org-now
  ;;   :general (:keymaps 'org-mode-map
  ;;                      :prefix "M-SPC"
  ;;                      "rl" #'org-now-link
  ;;                      "rn" #'org-now-refile-to-now
  ;;                      "rp" #'org-now-refile-to-previous-location))

  (add-hook 'dired-mode-hook
            (lambda ()
              (define-key dired-mode-map
                (kbd "C-c C-x a")
                #'org-attach-dired-to-subtree)))
  ;; https://emacs.stackexchange.com/questions/18404/can-i-display-org-mode-attachments-as-inline-images-in-my-document
  ;; (setq org-link-abbrev-alist '(("attachment" . org-attach-expand) ("att" . org-attach-expand)))

  ;; auto org save buffers after refile.
  (advice-add 'org-refile :after
              (lambda (&rest _)
                (org-save-all-org-buffers)))

  (use-package org
    :config
    (setq org-startup-indented t))

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
          ("\\.odt?\\'" . system)
          ("\\.odp?\\'" . system)
          ("\\.pptx?\\'" . system)
          ("\\.x?html?\\'" . default)
          ("\\.svg\\'" . "inkscape %s")
          ("\\.gan\\'" . "ganttproject %s")
          ("\\.pdf\\'" . default)
          ("\\.png\\'" . system)
          (system . system)
          (auto-mode . emacs)))

  (defun moritzs/org-ref-bibtex-assoc-pdf-with-entry (&optional prefix)
    "Adapted from org-ref"
    (interactive "P")
    (save-excursion
      (let* (
      (bibtex-expand-strings t)
            (key (helm-bibtex))
            (pdf (concat org-ref-pdf-directory (concat key ".pdf")))
      (file-move-func (org-ref-bibtex-get-file-move-func prefix)))
        (if (file-exists-p pdf)
      (message (format "A file named %s already exists" pdf))
    (progn
      (funcall file-move-func buffer-file-name pdf)
      (message (format "Created file %s" pdf)))))))


  (defun moritzs/hack-export (texfile &optional csl-file)
    "docstring"
    (let* ((basename (file-name-sans-extension texfile))
           (tmpname (format "%s.mod.tex" basename))
           (csl-file (or csl-file "/home/moritz/wiki/gtd/elsevier-harvard2.csl"))  ;; use csbj.csl for [1] numbers and elsevier-harvard2.csl for years,name
          (reference-doc
           (if (file-exists-p (format "%s_template.docx" basename) )
               (format "%s_template.docx" basename)
               "/home/moritz/wiki/template.docx"
               ))
          )
      (call-process-shell-command (format "~/bin/format-tex.py %s %s" texfile tmpname)
                                  nil "*Shell Command Output*" t)

      (call-process-shell-command (format "pandoc -f latex -t docx --reference-doc=%s --bibliography=/home/moritz/wiki/papers/references.bib --csl %s -i %s -o %s.docx" reference-doc csl-file tmpname basename)
                                  nil "*Shell Command Output*" t)
      )
    )

  ;;;###autoload
  (defun moritzs/org-export-docx
    (&optional async subtreep visible-only body-only ext-plist)
    "Export current buffer to LaTeX then process through to PDF.

  If narrowing is active in the current buffer, only export its
  narrowed part.

  If a region is active, export that region.

  A non-nil optional argument ASYNC means the process should happen
  asynchronously.  The resulting file should be accessible through
  the `org-export-stack' interface.

  When optional argument SUBTREEP is non-nil, export the sub-tree
  at point, extracting information from the headline properties
  first.

  When optional argument VISIBLE-ONLY is non-nil, don't export
  contents of hidden elements.

  When optional argument BODY-ONLY is non-nil, only write code
  between \"\\begin{document}\" and \"\\end{document}\".

  EXT-PLIST, when provided, is a property list with external
  parameters overriding Org default settings, but still inferior to
  file-local settings.

  Return PDF file's name."
    (interactive)
    (let ((outfile (org-export-output-file-name ".tex" subtreep)))
      (org-export-to-file 'latex outfile
        async subtreep visible-only body-only ext-plist
        (lambda (file) (moritzs/hack-export file)))))

  ;; patch org-tangle

  (require 'el-patch)

  ;; org-babel fixes to tangle ALL matching sections
  (defun rasen/map-regex (regex fn)
    "Map the REGEX over the BUFFER executing FN.

  FN is called with the match-data of the regex.

  Returns the results of the FN as a list."
    (save-excursion
      (goto-char (point-min))
      (let (res)
        (save-match-data
          (while (re-search-forward regex nil t)
            (let ((f (match-data)))
              (setq res
                    (append res
                            (list
                            (save-match-data
                              (funcall fn f))))))))
        res)))

  (el-patch-feature ob-core)
  (el-patch-defun org-babel-expand-noweb-references (&optional info parent-buffer)
    "Expand Noweb references in the body of the current source code block.

  For example the following reference would be replaced with the
  body of the source-code block named `example-block'.

  <<example-block>>

  Note that any text preceding the <<foo>> construct on a line will
  be interposed between the lines of the replacement text.  So for
  example if <<foo>> is placed behind a comment, then the entire
  replacement text will also be commented.

  This function must be called from inside of the buffer containing
  the source-code block which holds BODY.

  In addition the following syntax can be used to insert the
  results of evaluating the source-code block named `example-block'.

  <<example-block()>>

  Any optional arguments can be passed to example-block by placing
  the arguments inside the parenthesis following the convention
  defined by `org-babel-lob'.  For example

  <<example-block(a=9)>>

  would set the value of argument \"a\" equal to \"9\".  Note that
  these arguments are not evaluated in the current source-code
  block but are passed literally to the \"example-block\"."
    (let* ((parent-buffer (or parent-buffer (current-buffer)))
          (info (or info (org-babel-get-src-block-info 'light)))
          (lang (nth 0 info))
          (body (nth 1 info))
          (ob-nww-start org-babel-noweb-wrap-start)
          (ob-nww-end org-babel-noweb-wrap-end)
          (new-body "")
          (nb-add (lambda (text) (setq new-body (concat new-body text))))
          index source-name evaluate prefix)
      (with-temp-buffer
        (setq-local org-babel-noweb-wrap-start ob-nww-start)
        (setq-local org-babel-noweb-wrap-end ob-nww-end)
        (insert body) (goto-char (point-min))
        (setq index (point))
        (while (and (re-search-forward (org-babel-noweb-wrap) nil t))
          (save-match-data (setf source-name (match-string 1)))
          (save-match-data (setq evaluate (string-match "(.*)" source-name)))
          (save-match-data
            (setq prefix
                  (buffer-substring (match-beginning 0)
                                    (save-excursion
                                      (beginning-of-line 1) (point)))))
          ;; add interval to new-body (removing noweb reference)
          (goto-char (match-beginning 0))
          (funcall nb-add (buffer-substring index (point)))
          (goto-char (match-end 0))
          (setq index (point))
          (funcall
          nb-add
          (with-current-buffer parent-buffer
            (save-restriction
              (widen)
              (mapconcat ;; Interpose PREFIX between every line.
                #'identity
                (split-string
                (if evaluate
                    (let ((raw (org-babel-ref-resolve source-name)))
                      (if (stringp raw) raw (format "%S" raw)))
                  (or
                    ;; Retrieve from the Library of Babel.
                    (nth 2 (assoc-string source-name org-babel-library-of-babel))
                    ;; Return the contents of headlines literally.
                    (save-excursion
                      (when (org-babel-ref-goto-headline-id source-name)
                        (org-babel-ref-headline-body)))
                    ;; Find the expansion of reference in this buffer.
                    (save-excursion
                      (goto-char (point-min))
                      (let* ((name-regexp
                              (org-babel-named-src-block-regexp-for-name
                              source-name))
                            (comment
                              (string= "noweb"
                                      (cdr (assq :comments (nth 2 info)))))
                            (c-wrap
                              (lambda (s)
                                ;; Comment, according to LANG mode,
                                ;; string S.  Return new string.
                                (with-temp-buffer
                                  (funcall (org-src-get-lang-mode lang))
                                  (comment-region (point)
                                                  (progn (insert s) (point)))
                                  (org-trim (buffer-string)))))
                            (expand-body
                              (lambda (i)
                                ;; Expand body of code blocked
                                ;; represented by block info I.
                                (let ((b (if (org-babel-noweb-p (nth 2 i) :eval)
                                            (org-babel-expand-noweb-references i)
                                          (nth 1 i))))
                                  (if (not comment) b
                                    (let ((cs (org-babel-tangle-comment-links i)))
                                      (concat (funcall c-wrap (car cs)) "\n"
                                              b "\n"
                                              (funcall c-wrap (cadr cs)))))))))
                        (if (and (re-search-forward name-regexp nil t)
                                (not (org-in-commented-heading-p)))
                            (el-patch-swap
                              (funcall expand-body
                                      (org-babel-get-src-block-info 'light))
                              ;; Found a source block named SOURCE-NAME.
                              ;; Assume it is unique; do not look after
                              ;; `:noweb-ref' header argument.
                              (mapconcat
                              #'identity
                              (rasen/map-regex name-regexp
                                                (lambda (md)
                                                  (funcall expand-body
                                                          (org-babel-get-src-block-info 'light))))
                              "\n"))
                          ;; Though luck.  We go into the long process
                          ;; of checking each source block and expand
                          ;; those with a matching Noweb reference.
                          (let ((expansion nil))
                            (org-babel-map-src-blocks nil
                              (unless (org-in-commented-heading-p)
                                (let* ((info (org-babel-get-src-block-info 'light))
                                      (parameters (nth 2 info)))
                                  (when (equal source-name
                                              (cdr (assq :noweb-ref parameters)))
                                    (push (funcall expand-body info) expansion)
                                    (push (or (cdr (assq :noweb-sep parameters))
                                              "\n")
                                          expansion)))))
                            (when expansion
                              (mapconcat #'identity
                                        (nreverse (cdr expansion))
                                        ""))))))
                    ;; Possibly raise an error if named block doesn't exist.
                    (if (or org-babel-noweb-error-all-langs
                            (member lang org-babel-noweb-error-langs))
                        (error "%s could not be resolved (see \
  `org-babel-noweb-error-langs')"
                              (org-babel-noweb-wrap source-name))
                      "")))
                "[\n\r]")
                (concat "\n" prefix))))))
        (funcall nb-add (buffer-substring index (point-max))))
      new-body))

  )
