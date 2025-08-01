;; this was added to fix nixos configuration changes (somehow the loadScript there does not work a previously anymore)
(require 'exwm)
;; most of it is now in .spacemacs.d/lisp/exwm.el
(setq exwm-workspace-number 8)
(require 'exwm-systemtray)
(require 'exwm-randr)
;; (setq exwm-randr-workspace-monitor-plist '(0 "eDP1" 1 "HDMI1" 2 "DP2" 3 "eDP1" 4 "HDMI1" 5 "DP2"))
;; (setq exwm-randr-workspace-monitor-plist '(0 "eDP1" 1 "eDP1" 2 "HDMI1" 3 "eDP1" 4 "eDP1" 5 "eDP1"))
;; (exwm-randr-enable)  ;; for the old EXWM 0.28 version
(exwm-systemtray-mode)
(exwm-enable)
(exwm-randr-mode)  ;; I think this would be for the new version








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
  (format "~/Pictures/Camera/Camera/%s" (shell-command-to-string "ls -t  '/home/moritz/Pictures/Camera/Camera' | head -n 1 | tr -d '\n'"))
  )

(defun moritzs/open-smartphone-photo ()
  (interactive)
  (find-file (moritzs/recent-smartphone-photo))
  )

;; (erc :server "irc.freenode.net" :port 6697 :nick "moritzschaefer")
;; (setq erc-autojoin-channels-alist
;;       '(("freenode.net" "#spacemacs" "#wiki" "#nethack" "#neo")))

(shell-command-to-string "ls -t  '/home/moritz/Pictures/Camera/Camera' | head -n 1 | tr -d '\n'")
