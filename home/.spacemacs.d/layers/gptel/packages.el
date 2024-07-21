;;; packages.el --- gptel layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2022 Sylvain Benner & Contributors
;;
;; Author:  <moritz@mopad>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `gptel-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `gptel/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `gptel/pre-init-PACKAGE' and/or
;;   `gptel/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst gptel-packages
  '(gptel))

(defun gptel/init-gptel ()
  (use-package gptel
    :init
    (progn

      ;; TODO this still sucks unfortunately!!
      ;; (add-hook 'spacemacs-post-user-config-hook (lambda () (setq gptel-api-key (password-store-get "openai.com/meduni_my_api_key"))))

      ;; async version of the above
      ;; (add-hook 'spacemacs-post-user-config-hook
      ;;     (lambda ()
      ;;       (let ((my-load-path load-path))  ;; need to pass the load-path into the async process
      ;;         (async-start
      ;;          ;; What to do in the child process
      ;;          `(lambda ()
      ;;             (setq load-path ',my-load-path)
      ;;             (require 'password-store)
      ;;             (password-store-get "openai.com/meduni_my_api_key"))
      ;;          ;; What to do when it finishes
      ;;          (lambda (result)
      ;;            (setq gptel-api-key result))))))

      (exwm-input-set-key (kbd "s-j") #'gptel-menu)  ;; normally we should use gptel-send with a prefix argument
      (exwm-input-set-key (kbd "M-s-j") #'moritzs/exwm-llm-question)
      (exwm-input-set-key (kbd "s-<prior>") #'moritzs/within-context-llm)
      (exwm-input-set-key (kbd "C-s-j") #'gptel-abort)
      (exwm-input-set-key (kbd "s-J")
                          (lambda ()
                            (interactive)
                            (let ((current-prefix-arg nil)
                                  (selected-region (and (use-region-p)
                                                        (buffer-substring (region-beginning)
                                                                          (region-end)))))
                              (exwm-workspace-switch 5) ; Switch to workspace 5
                              ;; (call-interactively 'gptel)
                              (let ((buffer (gptel "test" nil selected-region)))
                                (switch-to-buffer buffer)
                                )
                              )))

      (with-eval-after-load 'gptel
        (define-key gptel-mode-map (kbd "C-<return>") #'gptel-send)
        )
      (setq gptel-mode-hook nil)
      (add-hook 'gptel-mode-hook #'moritzs/gptel-write-buffer)
      ;; save buffer after each response using native emacs elisp funciton
      (add-hook 'gptel-post-response-hook #'save-buffer)
      )))


(defun moritzs/gptel-write-buffer ()
  "Save buffer to disk when starting gptel https://github.com/karthink/gptel/issues/128"
  (unless (buffer-file-name (current-buffer))
    (let ((suffix (format-time-string "%Y%m%dT%H%M" (current-time)))
          (chat-dir "~/chatgpt-log"))
      (unless (file-directory-p chat-dir)
        (make-directory chat-dir :parents))
      (write-file (expand-file-name (concat "gptel-" suffix ".txt") chat-dir))
      (gptel-mode 1)  ;; storing as .txt goes txt txt-mode
      ;;(evil-insert-state) ;; pasting of region fails with this
      )))


(defun moritzs/screenshot-and-ocr ()
  (let* ((screenshot-file (make-temp-file "screenshot" nil ".png"))
         (text-file-base (make-temp-file "screenshot"))
         (text-file (concat text-file-base ".txt"))
         (scrot-command (format "escrotum %s" screenshot-file))
         (tesseract-command (format "tesseract %s %s" screenshot-file text-file-base)))
    (shell-command scrot-command)
    (shell-command tesseract-command)
    (with-temp-buffer
      (insert-file-contents text-file)
      (buffer-string))))

(defun moritzs/exwm-llm-question (user-input)
  (interactive "sYour request: ")
  (let* ((screenshot-text (moritzs/screenshot-and-ocr))
         (prompt-intro "You are a helpful assistant and should help me on my day to day work on my computer tasks, based on the current setting on my screen (provided in an unstructured manner using OCR of a screenshot). Don't be verbose in your answer, only providing the piece of text that I requested, without additional explanations. If you return code, don't wrap it in backticks.")  ;; TODO could be improved by first letting it reason and then extract the last bit of the response
         (prompt (concat prompt-intro
                         "Active window title: " exwm-title "\n"
                         "Text on my screen currently: " screenshot-text "\n"
                         "My request: " user-input)))
    (gptel-request
     prompt
     :callback
     (lambda (response info) ; Step 4
       (if (not response)
           (message "GPTel response failed with: %s" (plist-get info :status))
         (kill-new response)
         (message "Response copied to clipboard: %s" response))))))

;; prompt: Write a function `moritzs/within-context-llm` that queries the user for a user-input and runs a gptel request with the following contents: 1. The buffer content, trimmed to a maximum of 3000 characters before and 1000 characters after the cursor. The position of the cursor within emacs should be indicated with the string <<<CURSOR>>> within the passed buffer content. 2. A static prompt, describing the task to the LLM (in brief: you are given context, your task is to fill in text at the indicated position <<<CURSOR>>>, according to the user-request. Don't repeat any provided text but only return the text to be input at the <<<CURSOR>>> position). 3. The user-request (queried via (interactive ...)))
(defun moritzs/within-context-llm (user-input)
  (interactive "sYour request: ")
  (let* ((buffer-content (buffer-substring-no-properties (max (point-min) (- (point) 3000)) (min (point-max) (+ (point) 1000))))
         (buffer-content-with-cursor (concat (substring buffer-content 0 (- (point) (max (point-min) (- (point) 3000))))
                                             "<<<CURSOR>>>"
                                             (substring buffer-content (- (point) (max (point-min) (- (point) 3000))))))
         (prompt "You are given the content of the file I am currently editing, including the position of my cursor, indicated with the text \"<<<CURSOR>>>\". Your task is to fill in text at the cursor position, according to the user-request provided below. Don't repeat any of the provided file content and make sure that you only generate content that fits the user request.")
         )
    (gptel-request
     (concat prompt "\n" "User request: " user-input "\n\n" "Buffer content: " buffer-content-with-cursor)  ;; TODO might need to add again an short version of the text *before* <<<CURSOR>>>
     :callback
     (lambda (response info)
       (if (not response)
           (message "GPTel response failed with: %s" (plist-get info :status))
         (kill-new response)
         (message "Response copied to clipboard: %s" response))))))
