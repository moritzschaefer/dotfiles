(require 'pdf-misc)
(use-package pdf-tools
  :config
  (pdf-tools-install t t nil nil)  ;; installing system packages requires root. I don't want to type in my password on every start. maybe it's a bad idea..
  (evil-set-initial-state 'pdf-view-mode 'normal)

  (add-hook 'pdf-view-mode-hook (lambda () (cua-mode 0)))

  ;; http://pragmaticemacs.com/emacs/more-pdf-tools-tweaks/ :
  ;; more fine-grained zooming
  (setq pdf-view-resize-factor 1.15)
  ;; turn off cua so copy works
  ; (add-hook 'pdf-view-mode-hook (lambda () (cua-mode 0)))

  (define-key pdf-view-mode-map (kbd "h") 'pdf-annot-add-highlight-markup-annotation)
  (define-key pdf-view-mode-map (kbd "t") 'pdf-annot-add-text-annotation)
  (define-key pdf-view-mode-map (kbd "D") 'pdf-annot-delete)
  )

;; org-noter (https://github.com/weirdNox/org-noter/issues/57)
(use-package org-noter
  :config
  (setq org-noter-always-create-frame nil
        org-noter-insert-note-no-questions t
        org-noter-separate-notes-from-heading t
        org-noter-auto-save-last-location t)

  (defun org-noter-init-pdf-view ()
    (pdf-view-fit-page-to-window)
    (pdf-view-auto-slice-minor-mode)
    (run-at-time "0.5 sec" nil #'org-noter))

  (add-hook 'pdf-view-mode-hook 'org-noter-init-pdf-view))


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
