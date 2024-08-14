(spacemacs|define-custom-layout "@GuiApp"
  :binding "1"
  :body
  (progn
    ;; Placeholder for GUI application setup
    ))

(spacemacs|define-custom-layout "@MainWork"
  :binding "2"
  :body
  (progn
    ;; Placeholder for main work setup
    ))

(spacemacs|define-custom-layout "@Browser"
  :binding "3"
  :body
  (progn
    ;; google-chrome is assigned via the `exwm-manage-configurations` variable
    ))

(spacemacs|define-custom-layout "@Console"
  :binding "4"
  :body
  (progn
    ;; Placeholder for console setup
    ;; urxvt is assigned via the `exwm-manage-configurations` variable
    ))



(spacemacs|define-custom-layout "@Agenda"
  :binding "5"
  :body
  (progn
    (moritzs/switch-to-agenda)
    (evil-window-left)

    (golden-ratio-mode 1)
    (org-clock-goto)
    ;; Add hook to org-clock-in-hook to automatically switch to this layout and call (org-clock-goto)
    ;; (add-hook 'org-clock-in-hook
    ;;           (lambda ()
    ;;             (exwm-workspace-switch-create 0)
    ;;             (evil-window-left)
    ;;             (org-clock-goto)))
    ))

(spacemacs|define-custom-layout "@LanguageModel"
  :binding "6"
  :body
  (progn
    ;; Placeholder for language model setup
    ;; gptel buffers are opened here, as defined in the gptel layer
    ))

;; alternative is to use spacemacs/select-custom-layout
(add-hook 'exwm-init-hook
          (lambda ()
            (exwm-workspace-switch-create 0)
            (spacemacs/custom-perspective-@Agenda)
            (exwm-workspace-switch-create 1)
            (spacemacs/custom-perspective-@MainWork)
            (exwm-workspace-switch-create 2)
            (spacemacs/custom-perspective-@Browser)
            (exwm-workspace-switch-create 3)
            (spacemacs/custom-perspective-@Console)
            (exwm-workspace-switch-create 4)
            (spacemacs/custom-perspective-@GuiApp)
            (exwm-workspace-switch-create 5)
            (spacemacs/custom-perspective-@LanguageModel)))
