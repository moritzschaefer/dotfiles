(setq shell-file-name "/bin/sh")
(setq org-roam-v2-ack t)

;; (require 'cl) ;; fix spacemacs-os issue https://github.com/timor/spacemacsOS/issues/7  cl has been deprecated and should be replaced by cl-lib

;; (require 'xdg)

;; https://emacs.stackexchange.com/questions/2418/moving-the-mode-line-and-minibuffer-to-the-top
;; (setq-default header-line-format mode-line-format) <- doesn't work
(setq org-roam-directory "~/wiki/roam")
(defun moritzs/recent-download-file ()
  "Open a recently downloaded file."
  (interactive)

  (setq downloaded-file (shell-command-to-string "ls -t ~/Downloads | head -n 1 | tr -d '\n'"))

  (find-file-existing (format "~/Downloads/%s" downloaded-file))
  )

(defun moritzs/recent-smartphone-photo ()
  "Open a recently taken smartphone picture."
  (format "~/Kamera/Camera/%s" (shell-command-to-string "ls -t  '~/Kamera/Camera/' | head -n 1 | tr -d '\n'"))
  )

(defun moritzs/open-smartphone-photo ()
  (interactive)
  (find-file (moritzs/recent-smartphone-photo))
  )

;; (erc :server "irc.freenode.net" :port 6697 :nick "moritzschaefer")
;; (setq erc-autojoin-channels-alist
;;       '(("freenode.net" "#spacemacs" "#wiki" "#nethack" "#neo")))
