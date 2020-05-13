(setq moritzs/bibtex-pdf-inbox (format "%s/inbox" bibtex-completion-library-path))
(require 'filenotify)
(require 'org-ref-pdf)

(defun moritzs/bibtex-inbox-event (event)
  (message "Event %S" event)
  (cond
   ((equal (nth 1 event) 'created)
    (moritzs/bibtex-new-pdf-event((nth 2 event))
     )))
  )

(defun moritzs/bibtex-new-pdf-event (filename)


  )

(defun moritzs/mv-inbox-pdf (source target))

(file-notify-add-watch moritzs/bibtex-pdf-inbox '(change attribute-change) )
