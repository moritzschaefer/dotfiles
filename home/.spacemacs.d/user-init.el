(setq shell-file-name "/bin/sh") 

;; (require 'cl) ;; fix spacemacs-os issue https://github.com/timor/spacemacsOS/issues/7  cl has been deprecated and should be replaced by cl-lib

;; (require 'xdg)

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





;; (erc :server "irc.freenode.net" :port 6697 :nick "moritzschaefer")
;; (setq erc-autojoin-channels-alist
;;       '(("freenode.net" "#spacemacs" "#wiki" "#nethack" "#neo")))

