;; more can be found here: [[file:~/.spacemacs.d.old/layers/exwm/packages.el::(eval-after-load 'persp-mode]]

(defvar exwm--hide-tiling-modeline nil
  "Whether to hide modeline.")

;; clipboard

(clipmon-mode-start)

(defun moritzs/exwm-helm-yank-pop ()
  "Same as `helm-show-kill-ring' and paste into exwm buffer."
  (interactive)
  (let ((inhibit-read-only t)
        ;; Make sure we send selected yank-pop candidate to
        ;; clipboard: 
        (yank-pop-change-selection t))
    (call-interactively #'helm-show-kill-ring))
  (when (derived-mode-p 'exwm-mode)
    ;; https://github.com/ch11ng/exwm/issues/413#issuecomment-386858496
    (exwm-input--set-focus (exwm--buffer->id (window-buffer (selected-window))))
    (exwm-input--fake-key ?\C-v)))

(exwm-input-set-key (kbd "M-y") #'moritzs/exwm-helm-yank-pop)


(defun exwm-rename-buffer ()
  (interactive)
  (exwm-workspace-rename-buffer
   (concat exwm-class-name ":"
           (if (<= (length exwm-title) 50) exwm-title
             (concat (substring exwm-title 0 49) "...")))))

;; Add these hooks in a suitable place (e.g., as done in exwm-config-default)
(add-hook 'exwm-update-class-hook 'exwm-rename-buffer)
(add-hook 'exwm-update-title-hook 'exwm-rename-buffer)


(exwm-input-set-key (kbd "s-<escape>") 'exwm-reset)


;; TODO rebind s-enter
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

;; Shortcuts to move buffer to a certain workspace
(exwm-input-set-key (kbd "s-C-n") #'buffer-to-window-1)  ;; # TODO use move-buffer-window-no-follow to not focus to the new window?
(exwm-input-set-key (kbd "s-C-r") #'buffer-to-window-2)
(exwm-input-set-key (kbd "s-C-s") #'buffer-to-window-3)
(exwm-input-set-key (kbd "s-C-z") #'buffer-to-window-4)
(exwm-input-set-key (kbd "s-C-,") #'buffer-to-window-5)
(exwm-input-set-key (kbd "s-C-.") #'buffer-to-window-6)

(defun buffer-to-window-split (window)
   "move buffer to a certain workspace as vertical split"
   (interactive "P")
   (let (
         (buffer (current-buffer)))
     (exwm-workspace-switch window)
     (split-window-right-and-focus)
     (switch-to-buffer buffer)
     )
   )

;;(exwm-input-set-key (kbd "s-S-.") (lambda () (interactive) (message "36")))

;; TODO (kbd "s-<kp-1>") can be used!!!

;; s-S cannot be combined
(exwm-input-set-key (kbd "s-N") (lambda () (interactive) (buffer-to-window-split 0)))
(exwm-input-set-key (kbd "s-R") (lambda () (interactive) (buffer-to-window-split 1)))
(exwm-input-set-key (kbd "s-S") (lambda () (interactive) (buffer-to-window-split 2)))
(exwm-input-set-key (kbd "s-Z") (lambda () (interactive) (buffer-to-window-split 3)))
;; (exwm-input-set-key (kbd "s-–") (lambda () (interactive) (buffer-to-window-split 4)))  ;; TODO does not work
;; (exwm-input-set-key (kbd "s-•") (lambda () (interactive) (buffer-to-window-split 5)))  ;; TODO does not work

;; (exwm-input-set-key (kbd "s-.")
;;                     (lambda () (interactive) (exwm-workspace-switch 6)))

;; + Application launcher ('M-&' also works if the output buffer does not
;;   bother you). Note that there is no need for processes to be created by
;;   Emacs.
(exwm-input-set-key (kbd "s-a") #'helm-run-external-command) ;; exwm/app-launcher)

(exwm-input-set-key (kbd "s-c") #'org-capture)

(exwm-input-set-key (kbd "s-x") #'helm-bibtex)
(exwm-input-set-key (kbd "s-o") #'moritzs/switch-to-agenda)

(fancy-battery-mode)

(defun moritzs/exwm-shutdown ()
  (interactive)
  (recentf-save-list)
  (save-some-buffers)
  (start-process-shell-command "shutdown" nil "systemctl poweroff"))

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
(exwm-input-set-key (kbd "s-C-s") #'moritzs/exwm-shutdown) ;; TODO hotkeys are in use..
(exwm-input-set-key (kbd "s-C-r") #'moritzs/exwm-reboot)


;; autostart
(start-process-shell-command "autostart" "autostart" "/home/moritz/.spacemacs.d/autostart.sh")

(desktop-environment-mode)  ;; (not in config anymore)
;; (setq desktop-environment-brightness-small-decrement "2%-")
;; (setq desktop-environment-brightness-small-increment "2%+")
;; (setq desktop-environment-mode t nil (desktop-environment))
;; (setq desktop-environment-screenshot-command "escrotum /tmp/screenshot-$(date +%F_%T).png -C")
;; (setq desktop-environment-screenshot-directory "")
;; (setq desktop-environment-screenshot-partial-command "escrotum -s /tmp/screenshot-$(date +%F_%T).png -C")

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

(exwm-input-set-key (kbd "s-t") #'spacemacs/alternate-window)
;; (exwm-input-set-key (kbd "<s-tab>") #'spacemacs/exwm-jump-to-last-exwm)
(exwm-input-set-key (kbd "<s-tab>") #'spacemacs/alternate-buffer)

;; (exwm-input-set-key (kbd "s-v") #'moritzs/open-browser) ;; todo open in workspace 2or 3
;; (exwm-input-set-key (kbd "s-V") #'moritzs/open-browser)  ;; todo open in side tab on current workspace
(exwm-input-set-key (kbd "s-i") #'exwm-workspace-switch-to-buffer) ;; import window
(exwm-input-set-key (kbd "s-b") #'lazy-helm/helm-mini) ;; import buffer
(exwm-input-set-key (kbd "s-m") #'spacemacs/toggle-maximize-buffer) ;; import buffer


(evil-define-key 'normal exwm-mode-map (kbd "i") 'exwm/enter-insert-state)
(dolist (k '("<down-mouse-1>" "<down-mouse-2>" "<down-mouse-3>"))
  (evil-define-key 'normal exwm-mode-map (kbd k) 'exwm/enter-insert-state))

;; Define super-space as default leader key.
(exwm-input-set-key (kbd "s-SPC") spacemacs-default-map)
;; Don't have to lift finger from s-key for M-x behavior:
(if (configuration-layer/layer-used-p 'helm)
    (spacemacs/set-leader-keys "s-SPC" 'helm-M-x)
  (spacemacs/set-leader-keys "s-SPC" 'execute-extended-command))

;; EXWM does not bypass exwm-mode-map keybindings in line-mode, so the
;; default bindings are still mapped to C-c.  We remap that to C-s-c.

(define-key exwm-mode-map (kbd "C-s-c") (lookup-key exwm-mode-map (kbd "C-c")))
(define-key exwm-mode-map (kbd "C-c") nil)

;; User s-q to close buffers
(exwm-input-set-key (kbd "s-q") 'spacemacs/kill-this-buffer)

;; Don't override any keybindings in line-mode
(setq exwm-input-prefix-keys '())

;; Undo window configurations
(exwm-input-set-key (kbd "s-u") #'winner-undo)
(exwm-input-set-key (kbd "s-U") #'winner-redo)

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

;; (exwm-input-set-key (kbd "s-p") 'sarg/with-browser)


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
              (exwm-workspace-switch 5)
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

(exwm-input--update-global-prefix-keys)
(setq epg-pinentry-mode 'loopback)
