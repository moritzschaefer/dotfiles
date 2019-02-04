(setq exwm-workspace-number 4)

(defvar exwm-terminal-command "urxvt"
  "Terminal command to run.")

(defvar exwm--locking-command "lock"
  "Command to run when locking session")

(defvar exwm-app-launcher--prompt "$ "
  "Prompt for the EXWM application launcher")

(defvar exwm--hide-tiling-modeline nil
  "Whether to hide modeline.")

(exwm-input-set-key (kbd "s-<escape>") 'exwm-reset)

(exwm-input-set-key (kbd "<s-tab>") #'spacemacs/exwm-jump-to-last-exwm)
;; + Bind a key to switch workspace interactively
(exwm-input-set-key (kbd "s-w") 'exwm-workspace-switch)
;; + Set shortcuts to switch to a certain workspace.
(exwm-input-set-key (kbd "s-n")
                    (lambda () (interactive) (exwm-workspace-switch 0)))
(exwm-input-set-key (kbd "s-r")
                    (lambda () (interactive) (exwm-workspace-switch 1)))
(exwm-input-set-key (kbd "s-t")
                    (lambda () (interactive) (exwm-workspace-switch 2)))
(exwm-input-set-key (kbd "s-d")
                    (lambda () (interactive) (exwm-workspace-switch 3)))
(exwm-input-set-key (kbd "s-g")
                    (lambda () (interactive) (exwm-workspace-switch 4)))
(exwm-input-set-key (kbd "s-6")
                    (lambda () (interactive) (exwm-workspace-switch 5)))
(exwm-input-set-key (kbd "s-7")
                    (lambda () (interactive) (exwm-workspace-switch 6)))
(exwm-input-set-key (kbd "s-8")
                    (lambda () (interactive) (exwm-workspace-switch 7)))
(exwm-input-set-key (kbd "s-9")
                    (lambda () (interactive) (exwm-workspace-switch 8)))
(exwm-input-set-key (kbd "s-0")
                    (lambda () (interactive) (exwm-workspace-switch 9)))
;; + Application launcher ('M-&' also works if the output buffer does not
;;   bother you). Note that there is no need for processes to be created by
;;   Emacs.
(exwm-input-set-key (kbd "s-c") #'spacemacs/exwm-app-launcher)

(fancy-battery-mode)

(defun exwm-logout ()
  (interactive)
  (recentf-save-list)
  (save-some-buffers)
  (start-process-shell-command "logout" nil "kill -9 -1"))


;; autostart

(call-process-shell-command "/home/moritz/.spacemacs.d/autostart.sh")

;; media hotkeys
;; Key([], 'XF86AudioRaiseVolume', lazy.spawn('amixer sset Master 5%+')),
;; Key([], 'XF86AudioLowerVolume', lazy.spawn('amixer sset Master 5%-')),
;; Key([], 'XF86AudioMute', lazy.spawn('amixer sset Master toggle')),
;; Key([], 'XF86AudioPlay', lazy.spawn(music_cmd + 'PlayPause')),
;; Key([], 'XF86AudioNext', lazy.function(next_prev('Next'))),
;; Key([], 'XF86AudioPrev', lazy.function(next_prev('Previous'))),
;;; Volume control
(when (require 'pulseaudio-control nil t)
  ;; (exwm-input-set-key (kbd "s-<kp-subtract>") #'pulseaudio-control-decrease-volume)
  ;; (exwm-input-set-key (kbd "s-<kp-add>") #'pulseaudio-control-increase-volume)
  ;; (exwm-input-set-key (kbd "s-<kp-enter>") #'pulseaudio-control-toggle-current-sink-mute)
  (exwm-input-set-key (kbd "<XF86AudioLowerVolume>") #'pulseaudio-control-decrease-volume)
  (exwm-input-set-key (kbd "<XF86AudioRaiseVolume>") #'pulseaudio-control-increase-volume)
  (exwm-input-set-key (kbd "<XF86AudioMute>") #'pulseaudio-control-toggle-current-sink-mute))

;; ;; TODO TEST:
;; ;; (dolist (k '(XF86AudioLowerVolume
;; ;;              XF86AudioRaiseVolume
;; ;;              XF86AudioPlay
;; ;;              XF86AudioStop
;; ;;              XF86AudioPrev
;; ;;              XF86AudioNext))
;; ;;   (pushnew k exwm-input-prefix-keys))

;; TODO i could also use https://melpa.org/#/desktop-environment for all this..
(defun moritzs/exwm-start-screenshot () (interactive) (start-process-shell-command "scrot" nil "scrot -s ~/Screenshots/%F-%T.png -e 'xclip -selection clipboard -t image/png $f'"))

(exwm-input-set-key (kbd "<XF86LaunchB>") #'moritzs/exwm-start-screenshot)


(defun moritzs/exwm-brightness-inc () (interactive) (start-process-shell-command "xbacklight" nil "xbacklight -inc 10" ))
(exwm-input-set-key (kbd "<XF86MonBrightnessUp>") #'moritzs/exwm-brightness-inc)

(defun moritzs/exwm-brightness-dec () (interactive) (start-process-shell-command "xbacklight" nil "xbacklight -dec 10" ))
(exwm-input-set-key (kbd "<XF86MonBrightnessDown>") #'moritzs/exwm-brightness-dec)


(exwm-input-set-key (kbd "s-v") #'moritzs/open-browser)
(exwm-input-set-key (kbd "s-S-v") #'moritzs/open-browser)


(exwm-input-set-key (kbd "s-S-c") #'spacemacs/exwm-app-launcher)
;; (exwm-input-set-key (kbd "<Print>") #'moritzs/exwm-start-screenshot)

(setq browse-url-generic-program "qutebrowser")
;; (setq helm-exwm-emacs-buffers-source (helm-exwm-build-emacs-buffers-source))
;; (setq helm-exwm-source (helm-exwm-build-source))
;; (setq helm-mini-default-sources `(helm-exwm-emacs-buffers-source
;;                                   helm-exwm-source
;;                                   helm-source-recentf)
(setq exwm-layout-show-all-buffers t)
(setq exwm-workspace-show-all-buffers t)
;; (add-to-list 'helm-source-names-using-follow "EXWM buffers")

;; TODO
;; hotkey for opening new window in qutebrowser (with input)
;; hotkey for helm-all browser windows
;; (hotkey for all exwm windows)

;(exwm-input-set-key (kbd "s-v") 'helm-exwm-switch-browser)
; (exwm-input-set-key (kbd "s-v") 'helm-exwm)

;; (exwm-input-set-key exwm-workspace-move-window)

;; TODO symon.el?
