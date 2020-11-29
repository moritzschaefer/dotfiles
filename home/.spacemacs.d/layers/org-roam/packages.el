(defconst org-roam-packages
  '(org-roam org-roam-bibtex))

(defun org-roam/init-org-roam ()
  (use-package org-roam
    :hook
    (after-init . org-roam-mode)
    :custom
    (org-roam-directory "/home/moritz/wiki/roam")
    :init
    (progn
      (spacemacs/declare-prefix "ar" "org-roam")
      (spacemacs/set-leader-keys
        "arl" 'org-roam
        "art" 'org-roam-dailies-today
        "arf" 'org-roam-find-file
        "aro" 'org-roam-dailies-tomorrow
        "arg" 'org-roam-graph)
      
      (spacemacs/declare-prefix-for-mode 'org-mode "mr" "org-roam")
      (spacemacs/set-leader-keys-for-major-mode 'org-mode
        "ro" 'org-roam-dailies-tomorrow
        "rl" 'org-roam
        "rt" 'org-roam-dailies-today
        "rb" 'org-roam-switch-to-buffer
        "rf" 'org-roam-find-file
        "ri" 'org-roam-insert 
        "rg" 'org-roam-graph)
        (setq org-roam-capture-templates
          '(
            ("d" "default" plain #'org-roam-capture--get-point "%?" :file-name "%<%Y%m%d%H%M%S>-${slug}" :head "#+TITLE: ${title}

- tags ::


" :unnarrowed t :immediate-finish t)
;;                 ("D" "default-edit" plain #'org-roam-capture--get-point "%?" :file-name "%<%Y%m%d%H%M%S>-${slug}" :head "#+TITLE: ${title}

;; - tags :: %?


;; "  :unnarrowed t)
;;               ("E" "experiment" plain #'org-roam-capture--get-point "%?" :file-name  "experiment_%<%Y%m%d%H%M%S>-${slug}"  :head default-template :unnarrowed t)
;;               ("p" "person" plain #'org-roam-capture--get-point "%?" :file-name  "person_%<%Y%m%d%H%M%S>-${slug}" :head default-template :unnarrowed t :immediate-finish t)
;;               ("P" "Person" plain #'org-roam-capture--get-point "%?" :file-name  "person_%<%Y%m%d%H%M%S>-${slug}" :head default-template :unnarrowed t)
            )
          )

      ;; org-protocol
      (require 'org-roam-protocol)

      ;; org-roam-babel TODO, this didn't work (orb-preformat-keywords and orb-templates. why)
      (setq orb-preformat-keywords
            '(("citekey" . "=key=") "title" "url" "file" "author-or-editor" "keywords"))
      ;; I substituted %(orb-process-file-field \"${citekey}\") with the hard path to my papers. The function didn't work because the file wasn't there at the right moment..
      (setq orb-templates
            '(("r" "ref" plain (function org-roam-capture--get-point)
               ""
               :file-name "${citekey}"
               :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}

- tags ::
- keywords :: ${keywords}

* ${title}
:PROPERTIES:
:Custom_ID: ${citekey}
:URL: ${url}
:AUTHOR: ${author-or-editor}
:NOTER_DOCUMENT: /home/moritz/wiki/papers/${citekey}.pdf
:NOTER_PAGE:
:END:" :immediate-finish t)))

      (setq org-roam-dailies-capture-templates
        '(("d" "daily" plain (function org-roam-capture--get-point)
           ""
           :immediate-finish t
           :file-name "daily_%<%Y-%m-%d>"
           :head "#+TITLE: %<%Y-%m-%d>")))

      )))

(defun org-roam/init-org-roam-bibtex ()
  (use-package org-roam-bibtex
    :after org-roam
    :hook (org-roam-mode . org-roam-bibtex-mode)
    :bind (:map org-mode-map
                (("C-c n a" . orb-note-actions)))))
