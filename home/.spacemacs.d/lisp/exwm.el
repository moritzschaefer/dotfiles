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
;; (exwm-input-set-key (kbd "s-w") 'exwm-workspace-switch)
;; + Set shortcuts to switch to a certain workspace.
(exwm-input-set-key (kbd "s-n")
                    (lambda () (interactive) (exwm-workspace-switch 0)))
(exwm-input-set-key (kbd "s-r")
                    (lambda () (interactive) (exwm-workspace-switch 1)))
(exwm-input-set-key (kbd "s-s")
                    (lambda () (interactive) (exwm-workspace-switch 2)))
;; (exwm-input-set-key (kbd "s-g")
;;                     (lambda () (interactive) (exwm-workspace-switch 3)))
(exwm-input-set-key (kbd "s-z")
                    (lambda () (interactive) (exwm-workspace-switch 3)))
(exwm-input-set-key (kbd "s-,")
                    (lambda () (interactive) (exwm-workspace-switch 4)))
(exwm-input-set-key (kbd "s-.")
                    (lambda () (interactive) (exwm-workspace-switch 5)))
;; (exwm-input-set-key (kbd "s-.")
;;                     (lambda () (interactive) (exwm-workspace-switch 6)))

;; + Application launcher ('M-&' also works if the output buffer does not
;;   bother you). Note that there is no need for processes to be created by
;;   Emacs.
(exwm-input-set-key (kbd "s-a") #'spacemacs/exwm-app-launcher)

(exwm-input-set-key (kbd "s-c") #'org-capture)

(exwm-input-set-key (kbd "s-x") #'helm-bibtex)

(fancy-battery-mode)

(defun moritzs/exwm-reboot ()
  (interactive)
  (recentf-save-list)
  (save-some-buffers)
  (start-process-shell-command "reboot" nil "systemctl reboot"))

(defun moritzs/exwm-logout ()
  (interactive)
  (recentf-save-list)
  (save-some-buffers)
  (start-process-shell-command "logout" nil "kill -9 -1"))

(exwm-input-set-key (kbd "s-C-q") #'moritzs/exwm-logout)


;; autostart
(start-process-shell-command "autostart" "autostart" "/home/moritz/.spacemacs.d/autostart.sh")

;; (desktop-environment-mode)  (inside config now)


(exwm-input-set-key (kbd "<XF86LaunchB>") #'desktop-environment-screenshot)
(exwm-input-set-key (kbd "S-<XF86LaunchB>") #'desktop-environment-screenshot-part)

(exwm-input-set-key (kbd "s-f") #'desktop-environment-screenshot)
(exwm-input-set-key (kbd "s-F") #'desktop-environment-screenshot-part)

(require 'desktop-environment)

(exwm-input-set-key (kbd "s-w") #'exwm-floating-toggle-floating)
(exwm-input-set-key (kbd "s-d") #'spacemacs/delete-window)
(exwm-input-set-key (kbd "s-v") #'split-window-right)
(exwm-input-set-key (kbd "s-V") #'split-window-right-and-focus)
(exwm-input-set-key (kbd "s-h") #'split-window-below)
(exwm-input-set-key (kbd "s-H") #'split-window-below-and-focus)
(exwm-input-set-key (kbd "s-t") #'evil-window-next) ;; import window

;; (exwm-input-set-key (kbd "s-v") #'moritzs/open-browser) ;; todo open in workspace 2or 3
;; (exwm-input-set-key (kbd "s-V") #'moritzs/open-browser)  ;; todo open in side tab on current workspace
(exwm-input-set-key (kbd "s-i") #'exwm-workspace-switch-to-buffer) ;; import window

;; (exwm-input-set-key (kbd "s-e") #'exwm-workspace-move-window) ;; export window

(setq exwm-input--update-focus-interval 0.2)

;; (setq helm-exwm-emacs-buffers-source (helm-exwm-build-emacs-buffers-source))
;; (setq helm-exwm-source (helm-exwm-build-source))
;; (setq helm-mini-default-sources `(helm-exwm-emacs-buffers-source
;;                                   helm-exwm-source
;;                                   helm-source-recentf)

(setq exwm-layout-show-all-buffers t)  ;; enable switching to other workspaces
(setq exwm-workspace-show-all-buffers nil)
(require 'helm)
(add-to-list 'helm-source-names-using-follow "EXWM buffers")
(setq helm-follow-mode-persistent t)


;; TODO
;; hotkey for opening new window in qutebrowser (with input)
;; hotkey for helm-all browser windows
;; (hotkey for all exwm windows)

;;(exwm-input-set-key (kbd "s-v") 'helm-exwm-switch-browser)
;; (exwm-input-set-key (kbd "s-v") 'helm-exwm)

(exwm-input-set-key (kbd "<XF86AudioPlay>") #'spotify-playpause)
(exwm-input-set-key (kbd "<XF86AudioNext>") #'spotify-next)
(exwm-input-set-key (kbd "<XF86AudioPrev>") #'spotify-previous)

;; (exwm-input-set-key exwm-workspace-move-window)

(defun sarg/run-or-raise (NAME PROGRAM)
  (interactive)
  (let ((buf (cl-find-if
              (lambda (buf) (string= NAME (buffer-name buf)))
              (buffer-list))))

    (if buf (switch-to-buffer buf)
      (start-process NAME nil PROGRAM))))

(defun sarg/with-browser ()
  "Opens browser side-by-side with current window"
  (interactive)
  (delete-other-windows)
  (set-window-buffer (split-window-horizontally) "qutebrowser"))

(exwm-input-set-key (kbd "s-p") 'sarg/with-browser)


;; TODO symon.el?

;; (eval-after-load "ansi-term"
;;   (define-key ansi-term-raw-map (kbd "s-c") (lambda () (interactive) (term-send-raw-string "\C-c")))
;;   (define-key ansi-term-raw-map (kbd "s-d") (lambda () (interactive) (term-send-raw-string "\C-d")))
;;   (define-key ansi-term-raw-map (kbd "s-r") (lambda () (interactive) (term-send-raw-string "\C-r")))
;;   (define-key ansi-term-raw-map (kbd "s-r") nil)
;;   (define-key ansi-term-raw-map (kbd "C-v") 'term-paste)
;;   )

;;;;(setq exwm-randr-workspace-output-plist '(1 "eDP1" 2 "HDMI1")) (start-process-shell-command "xrandr" nil "xrandr --fb 7680x2160 --output HDMI1 --transform none && xrandr --fb 7680x2160 --output eDP1 --gamma 1.0:1.0:1.0 --mode 3840x2160 --pos 0x0 --primary --rate 60.00 --reflect normal --rotate normal --output HDMI1 --gamma 1.0:1.0:1.0 --mode 1920x1080 --pos 3840x0 --rate 60.00 --reflect normal --rotate normal --transform 2.000000,0.000000,0.000000,0.000000,2.000000,0.000000,0.000000,0.000000,1.000000")))

(add-hook 'server-switch-hook
          (lambda nil
            (let ((server-buf (current-buffer)))
              (bury-buffer)
              (exwm-workspace-switch 1)
              (switch-to-buffer server-buf)
              )
            )
          )
(defun exwm-y-or-n-p-wrapper (orig-fun &rest args)
  (let ((is-exwm-mode (derived-mode-p 'exwm-mode))
        (is-fullscreen (exwm-layout--fullscreen-p)))
    (when is-exwm-mode
      (when is-fullscreen
        (exwm-layout-unset-fullscreen))
      (call-interactively #'exwm-input-grab-keyboard))
    (let ((res (apply orig-fun args)))
      (when is-exwm-mode
        (call-interactively #'exwm-input-release-keyboard)
        (when is-fullscreen
          (exwm-layout-set-fullscreen))
        )
      res)))


(advice-add #'y-or-n-p :around #'exwm-y-or-n-p-wrapper)
;; (advice-remove #'y-or-n-p #'exwm-y-or-n-p-wrapper)
(setq epg-pinentry-mode 'loopback)
