;;(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

(with-eval-after-load 'org
  (require 'ol) ;; orgit https://github.com/magit/orgit-forge/issues/7
  (require 'forge)
  (require 'treemacs-workspaces)
  (require 'org-capture)
  (require 'org-attach)
  (require 'ox-extra)
  (require 'ox-beamer)
  (require 'org-roam-protocol)
  (require 'oc-csl)

  ;; enable proselint in textual modes:
  (add-hook 'org-mode-hook #'flycheck-mode)

  (define-key org-mode-map (kbd "C-m") nil)

  ;; roam
  (org-roam-db-autosync-mode)  ;; should become part of org-roam layers
  (setq org-roam-db-node-include-function
        (defun moritz/org-roam-include ()
          ;; exclude ATTACH headlines from org-roam (convenience)
          (not (member "ATTACH" (org-get-tags)))))

  (global-page-break-lines-mode 0) ;; temporary fix: https://github.com/org-roam/org-roam/issues/1732#issuecomment-891550040

  (ox-extras-activate '(ignore-headlines))

  ;; (setq org-reveal-root "file:///opt/reveal.js-3.7.0/")
  ;; set specific browser to open links
  (require 'find-lisp)

  ;; agenda


  ;; org-download
  ;; workaround: attachment-links are not exported correctly (/home/moritz/.emacs.d/elpa/27.2/develop/org-x.x.x/ox-odt.el)
  ;; Therefore use "normal" (less elegant) links
  (defun moritzs/org-download-link-format-function-data-path (filename)
    "The default function of `org-download-link-format-function'."
    (format org-download-link-format
            (org-link-escape
              (funcall org-download-abbreviate-filename-function filename))))
  (setq org-download-link-format-function #'moritzs/org-download-link-format-function-data-path)

  ;; (add-hook 'org-capture-mode-hook 'evil-insert-state)

  ;; From: [[id:e86470f9-423b-4022-9995-77047f9ee1df][An Emacs Lisp function to convert attachment: links to file: links for ox-hugo exports - vxlabs]]
  (defun moritzs/convert-attachment-to-file ()
    "Convert [[attachment:..]] to [[file:..][file:..]]"
    (interactive)
    (let ((elem (org-element-context)))
      (if (eq (car elem) 'link)
          (let ((type (org-element-property :type elem)))
            ;; only translate attachment type links
            (when (string= type "attachment")
              ;; translate attachment path to relative filename using org-attach API
              ;; 2020-11-15: org-attach-export-link was removed, so had to rewrite
              (let* ((link-end (org-element-property :end elem))
                    (link-begin (org-element-property :begin elem))
                    ;; :path is everything after attachment:
                    (file (org-element-property :path elem))
                    ;; expand that to the full filename
                    (fullpath (org-attach-expand file))
                    ;; then make it relative to the directory of this org file
                    (current-dir (file-name-directory (or default-directory
                                                          buffer-file-name)))
                    (relpath (file-relative-name fullpath current-dir)))
                ;; delete the existing link
                (delete-region link-begin link-end)
                ;; replace with file: link and file: description
                (insert (format "[[file:%s][file:%s]]" relpath relpath))))))))


  ;; only the third line works apparently...
  ;;(add-hook 'hack-local-variables-hook (lambda () (setq truncate-lines f)))
  ;;(spacemacs/toggle-truncate-lines-off)
  (add-hook 'org-mode-hook #'spacemacs/toggle-truncate-lines-off)


  (defun moritzs/org-set-weekly-id-property ()
    (interactive)
    (let* ((value (read-string "weekly_id:")) ;; TODO could use interactive as well..
           (file_full_path (buffer-file-name(window-buffer (minibuffer-selected-window))))
           (file_relative_path (concat "../roam/" (file-name-nondirectory file_full_path)))
           )

      (org-set-property "CUSTOM_ID" (concat "weekly_id:" value))
      (kill-new (concat "#+INCLUDE: \"" file_relative_path "::#weekly_id:" value "\" :only-contents t"))
        )
    )
  ;; Org protocol handler for DOI adding
  (defun moritzs/add-doi-or-arxiv-to-bibtex (info)
    "Add a doi to bibtex and create an org-roam entry via doiutils."
    (unless (or (plist-get info :doi) (plist-get info :arxiv))
      (user-error "No doi nor arxiv provided"))

    (org-roam-plist-map! (lambda (k v)
                           (org-link-decode
                            (if (equal k :ref)
                                (org-protocol-sanitize-uri v)
                              v))) info)

    (if (plist-get info :doi)
        (doi-utils-add-bibtex-entry-from-doi
         (plist-get info :doi)
         (car org-ref-default-bibliography))
      (arxiv-get-pdf-add-bibtex-entry
       (plist-get info :arxiv)
       (car org-ref-default-bibliography)
       org-ref-pdf-directory
       )
      )
    ;; notes are added automatically (juhuu)
    ;; go to references.bib and get the citekey

    ;; alternative here might be to exploit org-capture-template-context to hide all other templates while in exwm-mode (however what about capturing websites using "gc" in qutebrowser then?)
    (let ((org-roam-capture-templates (list (assoc "r" org-roam-capture-templates))))
      (split-window-right-and-focus)
      (let ((citekey (cdr (assoc "=key=" (car (bibtex-completion-candidates))))))
        (orb-edit-note citekey))
      )
    )

  (defun moritzs/doi-utils-get-json-metadata (doi)
    "Try to get json metadata for DOI.  Open the DOI in a browser if we do not get it."
    (if-let ((data (cdr (assoc doi doi-utils-cache))))
        ;; We have the data already, so we return it.
        data
      (let ((url-request-method "GET")
            (url-mime-accept-string "application/citeproc+json")
            (json-object-type 'plist)
            (json-data)
      (url (concat doi-utils-dx-doi-org-url doi)))
        (with-current-buffer
            (url-retrieve-synchronously
            ;; (concat "http://dx.doi.org/" doi)
      url nil nil 7)
    (setq json-data (buffer-substring url-http-end-of-headers (point-max)))

    (when (or (string-match "<title>Error: DOI Not Found</title>" json-data)
        (string-match "Resource not found" json-data)
        (string-match "Status *406" json-data)
        (string-match "400 Bad Request" json-data))
      ;; (browse-url (concat doi-utils-dx-doi-org-url doi))
      (error "Something went wrong.  We got this response:
  %s

  Opening %s" json-data url))

    (setq data (json-read-from-string json-data))
    (cl-pushnew (cons doi data) doi-utils-cache)
    data))))
  (setq doi-utils-metadata-function 'moritzs/doi-utils-get-json-metadata)

  (defun moritzs/org-roam-node-id-by-title (title)  ;; from https://github.com/org-roam/org-roam/issues/1902
    "Get a node ID by its title, whether original title or alias"
    (caar (org-roam-db-query [:select id
                                      :from [:select [(as node_id id)
                                                      (as alias title)]
                                                     :from aliases
                                                     :union-all
                                                     :select [id title]
                                                     :from nodes]
                                      :where (= title $s1)
                                      :limit 1] title)))

  (push '("doi-to-bibtex"  :protocol "doi-to-bibtex"  :function moritzs/add-doi-or-arxiv-to-bibtex)
        org-protocol-protocol-alist)

  (push '("arxiv-to-bibtex"  :protocol "arxiv-to-bibtex"  :function moritzs/add-doi-or-arxiv-to-bibtex)
        org-protocol-protocol-alist)

  ;; TODO I need to run this only for s-x, but not for s-X
  (require 'helm-bibtex)
  (helm-delete-action-from-source "Insert citation" helm-source-bibtex)
  (helm-add-action-to-source "Insert citation" 'helm-bibtex-insert-citation helm-source-bibtex 0)

  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "S" 'org-download-screenshot)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "sp" 'org-set-property)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "sw" 'moritzs/org-set-weekly-id-property)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "sH" 'helm-org-in-buffer-headings)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "ui" 'org-redisplay-inline-images)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "mu" 'doi-utils-add-bibtex-entry-from-doi)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "br" 'python-shell-send-region)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "bR" 'spacemacs/python-shell-send-region-switch)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "tC" 'org-table-create-or-convert-from-region)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode  ;; refile
    "dr" (lambda () "Schedule and Refile" (interactive) (call-interactively 'org-schedule) (call-interactively 'org-refile)))
  ;; (spacemacs/set-leader-keys-for-major-mode 'org-agenda-mode
  ;;   "dr" (lambda () "Schedule and Refile" (interactive) (call-interactively 'org-agenda-schedule) (org-agenda-refile nil (list "someday.org" "/home/moritz/wiki/gtd/someday.org" nil nil))))
  ;; (spacemacs/set-leader-keys-for-major-mode 'org-agenda-mode
  ;;   "dw" (lambda () "Schedule to weekend" (interactive) (org-agenda-schedule nil "sat") (org-agenda-refile nil (list "someday.org" "/home/moritz/wiki/gtd/someday.org" nil nil)) ))

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
  ;; (advice-add 'org-refile :after
  ;;             (lambda (&rest _)
  ;;               (org-save-all-org-buffers)))

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
  (eval-after-load 'ox '(require 'ox-koma-letter))
  (eval-after-load 'ox-latex
    '(add-to-list 'org-latex-packages-alist '("AUTO" "babel" t) t))

  ;; CITATIONS/BIBTEX

  ;; configure insert link functions. should become unnecessary after some time (included in spacemacs)
  (setq org-ref-insert-link-function 'org-ref-insert-link-hydra/body
        org-ref-insert-cite-function 'org-ref-cite-insert-helm
        org-ref-insert-label-function 'org-ref-insert-label-link
        org-ref-insert-ref-function 'org-ref-insert-ref-link
        org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body)))

  (require 'org-ref-refproc)
  (setq org-export-before-parsing-hook '(org-ref-cite-natmove ;; do this first
					                               org-ref-csl-preprocess-buffer
					                               org-ref-refproc))


  (setq reftex-default-bibliography '("~/wiki/papers/references.bib"))

  (setq gscholar-bibtex-database-file "~/wiki/papers/references.bib")

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
           (csl-file (or csl-file "/home/moritz/wiki/gtd/csbj.csl"))  ;; use csbj.csl for [1] numbers and elsevier-harvard2.csl for years,name
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

  (load "~/.spacemacs.d/lisp/org-babel.el")
  )
