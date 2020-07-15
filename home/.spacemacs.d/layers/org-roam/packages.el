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
        "arg" 'org-roam-graph)

      (spacemacs/declare-prefix-for-mode 'org-mode "mr" "org-roam")
      (spacemacs/set-leader-keys-for-major-mode 'org-mode
        "rl" 'org-roam
        "rt" 'org-roam-dailies-today
        "rb" 'org-roam-switch-to-buffer
        "rf" 'org-roam-find-file
        "ri" 'org-roam-insert ;; TODO make this faster
        "rg" 'org-roam-graph)
      (setq org-roam-capture-templates
            '(("d" "default" plain #'org-roam-capture--get-point "%?" :file-name "%<%Y%m%d%H%M%S>-${slug}" :head "#+TITLE: ${title}
" :unnarrowed t :immediate-finish t)
             ("D" "default-edit" plain #'org-roam-capture--get-point "%?" :file-name "%<%Y%m%d%H%M%S>-${slug}" :head "#+TITLE: ${title}
" :unnarrowed t)
             ("E" "experiment" plain #'org-roam-capture--get-point "%?" :file-name  "experiment_%<%Y%m%d%H%M%S>-${slug}"  :head "#+TITLE: ${title}
" :unnarrowed t)
             ("p" "person" plain #'org-roam-capture--get-point "%?" :file-name  "person_%<%Y%m%d%H%M%S>-${slug}" :head "#+TITLE: ${title}
" :unnarrowed t :immediate-finish t)
             ("P" "Person" plain #'org-roam-capture--get-point "%?" :file-name  "person_%<%Y%m%d%H%M%S>-${slug}" :head "#+TITLE: ${title}
" :unnarrowed t)
             )
            )

      (setq org-roam-dailies-capture-templates
        '(("d" "daily" plain (function org-roam-capture--get-point)
           ""
           :immediate-finish t
           :file-name "daily_%<%Y-%m-%d>"
           :head "#+TITLE: %<%Y-%m-%d>")))

      )))
