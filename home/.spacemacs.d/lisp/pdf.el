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
  (define-key pdf-view-mode-map (kbd "H") 'image-scroll-down)
  (define-key pdf-view-mode-map (kbd "L") 'image-scroll-up)

  ;; reset keymapping C-c C-c
  (define-key pdf-view-mode-map (kbd "C-c C-c") 'pdf-view-midnight-minor-mode)

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
;; from ~/.emacs.d/elpa/27.1/develop/org-ref-20201002.1514/org-ref-pdf.el
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

;; Sci-hub
(defun sci-hub-pdf-url (doi)
  "Get url to the pdf from SCI-HUB https://emacs.stackexchange.com/questions/58861/using-org-ref-to-download-pdfs-using-sci-hub-as-a-fallback"
  (setq *doi-utils-pdf-url* (concat "https://sci-hub.se/" doi) ;captcha
        *doi-utils-waiting* t
        )
  ;; try to find PDF url (if it exists)
  (url-retrieve (concat "https://sci-hub.se/" doi)
                (lambda (status)
                  (goto-char (point-min))
                  (while (search-forward-regexp "\\(https://\\|//sci-hub.se/downloads\\).+download=true'" nil t)
                    (let ((foundurl (match-string 0)))
                      (message foundurl)
                      (if (string-match "https:" foundurl)
                          (setq *doi-utils-pdf-url* foundurl)
                        (setq *doi-utils-pdf-url* (concat "https:" foundurl))))
                    (setq *doi-utils-waiting* nil))))
  (while *doi-utils-waiting* (sleep-for 0.1))
  *doi-utils-pdf-url*)


(eval-after-load 'doi-utils
  '(defun doi-utils-get-bibtex-entry-pdf (&optional arg)
    "Download pdf for entry at point if the pdf does not already exist locally.
The entry must have a doi. The pdf will be saved to
`org-ref-pdf-directory', by the name %s.pdf where %s is the
bibtex label.  Files will not be overwritten.  The pdf will be
checked to make sure it is a pdf, and not some html failure
page. You must have permission to access the pdf. We open the pdf
at the end if `doi-utils-open-pdf-after-download' is non-nil.

With one prefix ARG, directly get the pdf from a file (through
`read-file-name') instead of looking up a DOI. With a double
prefix ARG, directly get the pdf from an open buffer (through
`read-buffer-to-switch') instead. These two alternative methods
work even if the entry has no DOI, and the pdf file is not
checked."
    (interactive "P")
    (save-excursion
      (bibtex-beginning-of-entry)
      (let ( ;; get doi, removing http://dx.doi.org/ if it is there.
        (doi (replace-regexp-in-string
          "https?://\\(dx.\\)?.doi.org/" ""
          (bibtex-autokey-get-field "doi")))
        (key (cdr (assoc "=key=" (bibtex-parse-entry))))
        (pdf-url)
        (pdf-file))
    (setq pdf-file (concat
            (if org-ref-pdf-directory
                (file-name-as-directory org-ref-pdf-directory)
              (read-directory-name "PDF directory: " "."))
            key ".pdf"))
    ;; now get file if needed.
    (unless (file-exists-p pdf-file)
      (cond
       ((and (not arg)
         doi
         (if (doi-utils-get-pdf-url doi)
             (setq pdf-url (doi-utils-get-pdf-url doi))
           (setq pdf-url "https://www.sciencedirect.com/science/article/")))
        (url-copy-file pdf-url pdf-file)        
        ;; now check if we got a pdf
        (if (org-ref-pdf-p pdf-file)
        (message "%s saved" pdf-file)
          (delete-file pdf-file)
          ;; sci-hub fallback option
          (setq pdf-url (sci-hub-pdf-url doi))
          (url-copy-file pdf-url pdf-file)
          ;; now check if we got a pdf
          (if (org-ref-pdf-p pdf-file)
          (message "%s saved" pdf-file)
        (delete-file pdf-file)
        (message "No pdf was downloaded.") ; SH captcha
        (browse-url pdf-url))))
       ;; End of sci-hub fallback option
       ((equal arg '(4))
        (copy-file (expand-file-name (read-file-name "Pdf file: " nil nil t))
               pdf-file))
       ((equal arg '(16))
        (with-current-buffer (read-buffer-to-switch "Pdf buffer: ")
          (write-file pdf-file)))
       (t
        (message "We don't have a recipe for this journal.")))
      (when (and doi-utils-open-pdf-after-download (file-exists-p pdf-file))
        (org-open-file pdf-file)))))))

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

;; (require 'openwith)
;; (openwith-mode t)
;; (setq openwith-associations '(("\\.pdf\\'" "sioyek" (file))))
(setq openwith-associations nil)
