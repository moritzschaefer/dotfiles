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

  ;; (add-hook 'pdf-view-mode-hook 'org-noter-init-pdf-view)
  )
;; from /home/moritz/.emacs.d/elpa/27.1/develop/org-ref-20201002.1514/org-ref-pdf.el
(defun moritzs/org-ref-pdf-to-bibtex ()
  "Add pdf of current buffer to bib file and save pdf to
`org-ref-default-bibliography'. The pdf should be open in Emacs
using the `pdf-tools' package."
  (interactive)
  (when (not (f-ext? (downcase (buffer-file-name)) "pdf"))
    (error "Buffer is not a pdf file"))
  ;; Get doi from pdf of current buffer
  (let* ((dois (org-ref-extract-doi-from-pdf (buffer-file-name)))
         (doi-utils-download-pdf nil)
         (doi (if (= 1 (length dois))
                  (car dois)
                (completing-read "Select DOI: " dois))))
    ;; Add bib entry from doi:
    (doi-utils-add-bibtex-entry-from-doi doi (car org-ref-default-bibliography)) ;; only modification is that I added bibliography here
    ;; Copy pdf to `org-ref-pdf-directory':
    (let ((key (org-ref-bibtex-key-from-doi doi)))
      (funcall org-ref-pdf-to-bibtex-function
	             (buffer-file-name)
               (expand-file-name (format "%s.pdf" key)
                                 org-ref-pdf-directory)))))

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
