;; heavily inspired by  http://cachestocaches.com/2017/3/complete-guide-email-emacs-using-mu-and-/

(setq mu4e-account-alist
      '(("ethz"
         (mu4e-sent-messages-behavior sent)
         (mu4e-sent-folder "/ethz/Sent Items")
         (mu4e-drafts-folder "/ethz/Drafts")
         (user-mail-address "moritz.schaefer@biol.ethz.ch")
         (user-full-name "Moritz Schaefer")
         )
        ("gmail"
         (mu4e-sent-messages-behavior sent)
         (mu4e-sent-folder "/gmail/[Gmail]/.Sent Mail")
         (mu4e-drafts-folder "/gmail/[Gmail]/.Drafts")
         (user-mail-address "mollitz@gmail.com")
         (user-full-name "Moritz Schaefer"))))


;;; Set up some common mu4e variables
(setq mu4e-maildir "~/mail"
      mu4e-trash-folder "/Trash"
      mu4e-refile-folder "/Archive"
      mu4e-get-mail-command "mbsync -a"
      mu4e-update-interval nil
      mu4e-compose-signature-auto-include nil
      mu4e-view-show-images t
      mu4e-view-show-addresses t)

;;; Mail directory shortcuts
(setq mu4e-maildir-shortcuts
      '(("/gmail/INBOX" . ?g)
        ("/college/INBOX" . ?c)))

;;; Bookmarks
(setq mu4e-bookmarks
      `(("flag:unread AND NOT flag:trashed" "Unread messages" ?u)
        ("date:today..now" "Today's messages" ?t)
        ("date:7d..now" "Last 7 days" ?w)
        ("mime:image/*" "Messages with images" ?p)
        (,(mapconcat 'identity
                     (mapcar
                      (lambda (maildir)
                        (concat "maildir:" (car maildir)))
                      mu4e-maildir-shortcuts) " OR ")
         "All inboxes" ?i)))
(setq mu4e-enable-notifications t)

(setq mu4e-enable-mode-line t)

;;; SMTP
;; I have my "default" parameters from Gmail
(setq mu4e-sent-folder "/sent"
      ;; mu4e-sent-messages-behavior 'delete ;; Unsure how this should be configured
      mu4e-drafts-folder "/drafts"
      user-mail-address "moritz.schaefer@biol.ethz.ch"
      smtpmail-default-smtp-server "mail.ethz.ch"
      smtpmail-smtp-server "mail.ethz.ch"
      smtpmail-smtp-service 587)

;; Now I set a list of 
(defvar my-mu4e-account-alist
  '(("ethz"
     (mu4e-sent-folder "/ETHZ/sent")
     (user-mail-address "moritz.schaefer@biol.ethz.ch")
     (smtpmail-smtp-user "d\schamori")
     (smtpmail-local-domain "mail.ethz.ch")
     (smtpmail-default-smtp-server "mail.ethz.ch")
     (smtpmail-smtp-server "mail.ethz.ch")
     (smtpmail-smtp-service 587)
     )
    ("moritzs"
     (mu4e-sent-folder "/MORITZS/sent")
     (user-mail-address "mail@moritzs.de")
     (smtpmail-smtp-user "mollitz@gmail.com")
     (smtpmail-local-domain "gmail.com")
     (smtpmail-default-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-service 587)
     )
    ("gmail"
     (mu4e-sent-folder "/GMAIL/sent")
     (user-mail-address "mollitz@gmail.com")
     (smtpmail-smtp-user "mollitz@gmail.com")
     (smtpmail-local-domain "gmail.com")
     (smtpmail-default-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-service 587)
    )))

(defun my-mu4e-set-account ()
  "Set the account for composing a message.
   This function is taken from: 
     https://www.djcbsoftware.nl/code/mu/mu4e/Multiple-accounts.html"
  (let* ((account
    (if mu4e-compose-parent-message
        (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
    (string-match "/\\(.*?\\)/" maildir)
    (match-string 1 maildir))
      (completing-read (format "Compose with account: (%s) "
             (mapconcat #'(lambda (var) (car var))
            my-mu4e-account-alist "/"))
           (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
           nil t nil nil (caar my-mu4e-account-alist))))
   (account-vars (cdr (assoc account my-mu4e-account-alist))))
    (if account-vars
  (mapc #'(lambda (var)
      (set (car var) (cadr var)))
        account-vars)
      (error "No email account found"))))
(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)
