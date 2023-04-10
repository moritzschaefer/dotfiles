;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '("~/.spacemacs.d/layers/")
   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(graphviz
     shell-scripts
     ;; scimax-layer
     ;; eaf
     conda
     systemd
     c-c++
;;     (mu4e :variables mu4e-installation-path "/usr/share/emacs/site-lisp" mu4e-account-alist t)
     dap
     lsp
     ruby
     nginx
     nixos
     (erc :variables
            erc-server-list
            '(("irc.freenode.net"
               :port "6697"
               :ssl t
               :nick "muronglizi")))
               ;; :password "")))
     ;; w3m ; todo
     clojure
     latex
     rust
     (elfeed :variables rmh-elfeed-org-files (list "~/wiki/elfeed.org"))
     (exwm :variables   ;; this is better handled in nixos-config
           exwm-enable-systray t
           exwm-autostart-xdg-applications nil
           exwm-workspace-number 8)

     ;;       exwm-use-autorandr t
     ;;       exwm-autostart-xdg-applications t
     ;;       exwm-locking-command "slock"
     ;;       exwm-randr-workspace-monitor-plist '(0 "eDP1" 1 "eDP1" 2 "HDMI1" 3 "eDP1" 4 "eDP1" 5 "eDP1")
     ;;       exwm-install-logind-lock-handler t ;; dont know..?
     ;;       exwm-terminal-command "urxvt"  ;; unused anyways..
     ;;       exwm-custom-init (lambda() (gpastel-mode)))
     csv
     yaml
     react
     typescript
     javascript
     html
     themes-megapack
     (python :variables
             python-backend 'lsp
             python-lsp-server 'pyright
             ;;python-backend 'anaconda
             python-formatter 'black
             python-format-on-save t
             python-sort-imports-on-save nil)
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     helm
     (auto-completion
      ;; :disabled-for ;; org spacemacs-org
      :variables
                      auto-completion-return-key-behavior 'nil
                      auto-completion-tab-key-behavior 'complete
                      auto-completion-enable-snippets-in-popup t
                      auto-completion-enable-help-tooltip t
                      )
     pdf
     better-defaults
     latex
     emacs-lisp
     git
     ipython-notebook
     ess ;; emacs speaks statistics (R)
     markdown
     syntax-checking
     (org :variables
          org-projectile-file "TODOs.org"
          org-enable-roam-support t
          org-enable-hugo-support t
          org-enable-roam-ui t
          org-src-tab-acts-natively nil
          )
                     ;; org-enable-reveal-js-support t)
     bibtex
     (shell :variables
            ;; shell-default-shell 'vterm
            shell-default-term-shell "/run/current-system/sw/bin/fish"
            shell-default-height 30
            shell-default-position 'bottom)
     spell-checking
     pass
     ;;modefault
     )

   ;; List of additional packages that will be installed without being wrapped
   ;; in a layer (generally the packages are installed only and should still be
   ;; loaded using load/require/use-package in the user-config section below in
   ;; this file). If you need some configuration for these packages, then
   ;; consider creating a layer. You can also put the configuration in
   ;; `dotspacemacs/user-config'. To use a local version of a package, use the
   ;; `:location' property: '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '((ox-ipynb :location (recipe :fetcher github :repo "jkitchin/ox-ipynb" :files ("*.el"))) clipmon (copilot :location (recipe :fetcher github :repo "zerolfx/copilot.el" :files ("*.el" "dist"))) org-drill keytar (lsp-grammarly :ensure t :hook (org-mode . (lambda () (message "im here")(require 'lsp-grammarly) (lsp)))) org-tree-slide theme-changer gscholar-bibtex key-chord git-auto-commit-mode helm-rg helm-org-ql org-ql py-autopep8 (jupyter :hook (jupyter-repl-mode . (lambda () (company-mode)))) org-roam-bibtex org-noter github-clone el-patch telega synosaurus yasnippet-snippets editorconfig org-cliplink synonymous openwith pulseaudio-control pinentry spotify ssh-agency snakemake-mode helm-exwm desktop-environment (matrix-client :location (recipe :fetcher github :repo "alphapapa/matrix-client.el")) (seqel :location (recipe :fetcher github :repo "rnaer/seqel")))

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil then enable support for the portable dumper. You'll need
   ;; to compile Emacs 27 from source following the instructions in file
   ;; EXPERIMENTAL.org at to root of the git repository.
   ;; (default nil)
   dotspacemacs-enable-emacs-pdumper nil

   ;; Name of executable file pointing to emacs 27+. This executable must be
   ;; in your PATH.
   ;; (default "emacs")
   dotspacemacs-emacs-pdumper-executable-file "emacs"

   ;; Name of the Spacemacs dump file. This is the file will be created by the
   ;; portable dumper in the cache directory under dumps sub-directory.
   ;; To load it when starting Emacs add the parameter `--dump-file'
   ;; when invoking Emacs 27.1 executable on the command line, for instance:
   ;;   ./emacs --dump-file=$HOME/.emacs.d/.cache/dumps/spacemacs-27.1.pdmp
   ;; (default (format "spacemacs-%s.pdmp" emacs-version))
   dotspacemacs-emacs-dumper-dump-file (format "spacemacs-%s.pdmp" emacs-version)

   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; Set `read-process-output-max' when startup finishes.
   ;; This defines how much data is read from a foreign process.
   ;; Setting this >= 1 MB should increase performance for lsp servers
   ;; in emacs 27.
   ;; (default (* 1024 1024))
   dotspacemacs-read-process-output-max (* 1024 1024)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. Spacelpa is currently in
   ;; experimental state please use only for testing purposes.
   ;; (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   ;; dotspacemacs-editing-style '(vim)
   dotspacemacs-editing-style '(hybrid :variables
                                       hybrid-style-visual-feedback t
                                       hybrid-style-enable-evilified-state nil
                                       hybrid-style-enable-hjkl-bindings nil
                                       hybrid-style-use-evil-search-module nil
                                       hybrid-style-default-state 'normal)
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; If non-nil, *scratch* buffer will be persistent. Things you write down in
   ;; *scratch* buffer will be saved and restored automatically.
   dotspacemacs-scratch-buffer-persistent nil

   ;; If non-nil, `kill-buffer' on *scratch* buffer
   ;; will bury it instead of killing.
   dotspacemacs-scratch-buffer-unkillable nil

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(spacemacs-light
                         spacemacs-dark)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.5)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font or prioritized list of fonts. The `:size' can be specified as
   ;; a non-negative integer (pixel size), or a floating-point (point size).
   ;; Point size is recommended, because it's device independent. (default 10.0)
   dotspacemacs-default-font '("Source Code Pro"
                               :size 10.0
                               :weight normal
                               :width normal)

   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m" for terminal mode, "<M-return>" for GUI mode).
   ;; Thus M-RET should work as leader key in both GUI and terminal modes.
   ;; C-M-m also should work in terminal mode, but not in GUI mode.
   ;;dotspacemacs-major-mode-emacs-leader-key (if window-system "<M-return>" "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "s-e"

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab t

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' in OSX to obtain
   ;; borderless fullscreen. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but lines are only visual lines are counted. For example, folded lines
   ;; will not be counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers nil

   ;; Code folding method. Possible values are `evil', `origami' and `vimish'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "rg" "pt" "ack" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil

   ;; If non nil activate `clean-aindent-mode' which tries to correct
   ;; virtual indentation of simple modes. This can interfer with mode specific
   ;; indent handling like has been reported for `go-mode'.
   ;; If it does deactivate it here.
   ;; (default t)
   dotspacemacs-use-clean-aindent-mode t

   ;; If non-nil shift your number row to match the entered keyboard layout
   ;; (only in insert state). Currently supported keyboard layouts are:
   ;; `qwerty-us', `qwertz-de' and `querty-ca-fr'.
   ;; New layouts can be added in `spacemacs-editing' layer.
   ;; (default nil)
   dotspacemacs-swap-number-row nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil

   ;; If nil the home buffer shows the full path of agenda items
   ;; and todos. If non nil only the file name is shown.
   dotspacemacs-home-shorten-agenda-source nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."
  (if (file-readable-p "~/.spacemacs.d/user-init.el") (load "~/.spacemacs.d/user-init.el"))
  )

(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
  )

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."
  (if (file-readable-p "~/.spacemacs.d/user-config.el") (load "~/.spacemacs.d/user-config.el"))
  )

(defun moritzs/blog-post-name ()
  (interactive)
  (let ((name (read-string "file short name: "))
        (path "~/Projects/homepage/_posts/"))
    (expand-file-name (format "%s-%s.md"
                              (format-time-string "%Y-%m-%d")
                              name) path)))


;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(avy-all-windows t)
 '(avy-keys
   '(101 110 105 114 116 115 99 103 117 108 98 111 100 109 97 104 228 121 252 122 118 44 46))
 '(avy-timeout-seconds 0.2)
 '(bibtex-completion-additional-search-fields '("journal"))
 '(bibtex-completion-display-formats
   '((article . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
     (t . "${author:36} ${title:*} ${year:4} ${=has-pdf=:1}${=has-note=:1} ${=type=:7}")))
 '(bibtex-completion-format-citation-functions
   '((org-mode . bibtex-completion-format-citation-org-cite)
     (latex-mode . bibtex-completion-format-citation-cite)
     (markdown-mode . bibtex-completion-format-citation-pandoc-citeproc)
     (python-mode . bibtex-completion-format-citation-sphinxcontrib-bibtex)
     (rst-mode . bibtex-completion-format-citation-sphinxcontrib-bibtex)
     (default . bibtex-completion-format-citation-default)))
 '(browse-url-browser-function 'browse-url-default-browser)
 '(browse-url-generic-program "qutebrowser")
 '(conda-anaconda-home "/home/moritz/.conda/")
 '(conda-env-home-directory "/home/moritz/.conda/")
 '(dap-python-debugger 'debugpy)
 '(dap-python-executable "guided_prot_diff_repl")
 '(dap-python-terminal nil)
 '(desktop-environment-brightness-small-decrement "2%-")
 '(desktop-environment-brightness-small-increment "2%+")
 '(desktop-environment-mode t nil (desktop-environment))
 '(desktop-environment-screenshot-command
   "escrotum -e 'xclip -selection clipboard -t image/png -i \\$f' /tmp/screenshot-$(date +%F_%T).png ")
 '(desktop-environment-screenshot-directory "")
 '(desktop-environment-screenshot-partial-command
   "bash -c 'gnome-screenshot -a -c -f  /tmp/last_screenshot.png && cat /tmp/last_screenshot.png  | xclip -i -selection clipboard -target image/png'")
 '(desktop-environment-update-exwm-global-keys nil)
 '(elfeed-search-filter "@6-months-ago +unread -reddit")
 '(epg-pinentry-mode 'loopback)
 '(evil-want-Y-yank-to-eol nil)
 '(eww-search-prefix "https://google.com/search?q=")
 '(exwm-manage-configurations
   '(((equal
       (buffer-name)
       "The PyMOL Molecular Graphics System")
      floating t width 400 height 200 floating-mode-line nil floating-header-line nil char-mode t)
     ((equal exwm-class-name "Rambox")
      workspace 4)
     ((equal exwm-class-name "URxvt")
      workspace 3)
     ((equal exwm-class-name "Spotify")
      workspace 5)
     ((equal exwm-class-name "qutebrowser")
      workspace 2)
     (t char-mode t)))
 '(exwm-workspace-number 8)
 '(gac-debounce-interval 600)
 '(gac-shell-and "&&")
 '(gac-silent-message-p t)
 '(garbage-collection-messages t)
 '(google-translate-default-source-language "en" t)
 '(google-translate-default-target-language "de")
 '(google-translate-enable-ido-completion t t)
 '(google-translate-show-phonetic t t)
 '(helm-ag-ignore-patterns '("*.ipynb" "*.svg" "*.csv"))
 '(helm-ag-use-agignore t)
 '(helm-completion-style 'emacs)
 '(helm-external-programs-associations '(("docx" . "loffice")))
 '(helm-ff-initial-sort-method 'newest)
 '(helm-ff-lynx-style-map t)
 '(helm-google-suggest-actions
   '(("Google Search" . helm-google-suggest-action)
     ("Wikipedia" lambda
      (candidate)
      (helm-search-suggest-perform-additional-action helm-search-suggest-action-wikipedia-url candidate))
     ("Youtube" lambda
      (candidate)
      (helm-search-suggest-perform-additional-action helm-search-suggest-action-youtube-url candidate))
     ("IMDb" lambda
      (candidate)
      (helm-search-suggest-perform-additional-action helm-search-suggest-action-imdb-url candidate))
     ("Google Maps" lambda
      (candidate)
      (helm-search-suggest-perform-additional-action helm-search-suggest-action-google-maps-url candidate))
     ("Google News" lambda
      (candidate)
      (helm-search-suggest-perform-additional-action helm-search-suggest-action-google-news-url candidate))
     ("Stack Snippet" lambda
      (candidate)
      (helm-search-suggest-perform-additional-action "http://www.stacksnippet.com/#gsc.tab=0&gsc.q=%s" candidate))))
 '(helm-kill-ring-actions
   '(("Copy to clipboard" lambda
      (str)
      (gui-set-selection 'CLIPBOARD str))
     ("Yank marked" . helm-kill-ring-action-yank)
     ("Delete marked" . helm-kill-ring-action-delete)))
 '(helm-source-names-using-follow '("Helm Xref" "mark-ring" "Org Directory Files"))
 '(hybrid-style-default-state 'emacs)
 '(hybrid-style-enable-evilified-state nil)
 '(image-dired-thumb-height 512)
 '(image-dired-thumb-size 512)
 '(image-dired-thumb-width 512)
 '(image-use-external-converter t)
 '(jupyter-api-authentication-method 'password)
 '(jupyter-org-resource-directory "~/wiki/.ob-jupyter/")
 '(large-file-warning-threshold 50000000)
 '(lpr-command "gtklp")
 '(lsp-pyright-multi-root nil)
 '(native-comp-deferred-compilation-deny-list '("jupyter" "zmq" ".*jupyter.*"))
 '(orb-preformat-keywords
   '("citekey" "date" "type" "pdf?" "note?" "author" "editor" "file" "author-abbrev" "editor-abbrev" "author-or-editor-abbrev" "url" "author-or-editor" "keywords" "journal" "title"))
 '(org-agenda-file-regexp
   "\\(inbox\\|someday\\|projects\\|toread\\|smartphone\\|einkaufen\\).org$")
 '(org-agenda-files
   '("/home/moritz/wiki/gtd/einkaufen.org" "/home/moritz/wiki/gtd/inbox.org" "/home/moritz/wiki/gtd/projects.org" "/home/moritz/wiki/gtd/smartphone.org" "/home/moritz/wiki/gtd/someday.org" "/home/moritz/wiki/gtd/toread.org"))
 '(org-agenda-follow-indirect t)
 '(org-attach-id-dir "~/wiki/data/")
 '(org-attach-store-link-p 'file)
 '(org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (python . t)
     (R . t)
     (jupyter . t)))
 '(org-capture-templates
   '(("b" "Buy (add to shopping list)
            " entry
            (file "~/wiki/gtd/einkaufen.org")
            "* TODO %?")
     ("i" "inbox" entry
      (file "~/wiki/gtd/inbox.org")
      "* TODO %?")
     ("w" "Weekly Review" entry
      (file+olp+datetree "~/wiki/gtd/reviews.org")
      (file "~/wiki/gtd/templates/weekly_review.org")
      :immediate-finish t :jump-to-captured t)
     ("r" "Receipt" entry
      (file+olp+datetree "~/wiki/receipts.org")
      "* %?")
     ("s" "Snippet" entry
      (file "~/wiki/deft/capture.org"))
     ("f" "Flash card" entry
      (file+headline "~/wiki/flashcards.org" "Miscellaneous")
      "* Flashcard :drill:
%^{Question}
** Back
%^{Answer}
" :immediate-finish t)
     ("p" "Blog post" entry
      (file moritzs/blog-post-name)
      (file "~/Projects/homepage/templates/post.md"))))
 '(org-cite-global-bibliography '("/home/moritz/wiki/papers/references.bib"))
 '(org-directory "~/wiki")
 '(org-download-image-org-width 300)
 '(org-download-method 'attach)
 '(org-download-screenshot-method "gnome-screenshot -a -f %s")
 '(org-edit-src-content-indentation 0)
 '(org-export-with-broken-links t)
 '(org-export-with-tags nil)
 '(org-fast-tag-selection-single-key t)
 '(org-image-actual-width '(400))
 '(org-latex-prefer-user-labels t)
 '(org-noter-kill-frame-at-session-end nil)
 '(org-now-location '("~/wiki/gtd/now.org"))
 '(org-odt-inline-image-rules
   '(("file" . "\\(?:\\.\\(?:gif\\|\\(?:jpe?\\|pn\\|sv\\)g\\)\\)")))
 '(org-odt-preferred-output-format "docx")
 '(org-pomodoro-length 45)
 '(org-priority-faces '((67 . "Yellow3") (66 . "orange") (65 . "Orangered1")))
 '(org-ql-search-directories-files-recursive t)
 '(org-ref-bibliography-notes "~/wiki/papers.org" t)
 '(org-ref-cite-onclick-function 'org-ref-cite-click-helm)
 '(org-ref-clean-bibtex-entry-hook
   '(org-ref-bibtex-format-url-if-doi orcb-key-comma org-ref-replace-nonascii orcb-& orcb-% orcb-clean-year orcb-key orcb-clean-doi orcb-clean-pages orcb-check-journal org-ref-sort-bibtex-entry orcb-fix-spacing orcb-download-pdf))
 '(org-ref-insert-cite-function 'org-ref-helm-insert-cite-link)
 '(org-ref-insert-label-function 'org-ref-helm-insert-label-link)
 '(org-ref-insert-link-function 'org-ref-helm-insert-cite-link)
 '(org-ref-insert-ref-function 'org-ref-helm-insert-ref-link)
 '(org-ref-notes-directory "~/wiki/papers/notes" t)
 '(org-ref-notes-function 'orb-notes-fn t)
 '(org-ref-pdf-directory "~/wiki/papers/" t)
 '(org-ref-pdf-doi-regex "10\\.[0-9]\\{4,9\\}/[-+._()/:A-Z0-9]+")
 '(org-refile-allow-creating-parent-nodes 'confirm)
 '(org-refile-use-outline-path 'file)
 '(org-roam-bibtex-mode t)
 '(org-roam-capture-immediate-template
   '("d" "default" plain #'org-roam-capture--get-point "%?" :file-name "%<%Y%m%d%H%M%S>-${slug}" :head "#+title: ${title}

- tags :: 
" :unnarrowed t :immediate-finish t))
 '(org-roam-capture-templates
   '(("d" "default" plain "%?" :immediate-finish t :unnarrowed t :if-new
      (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+TITLE: ${title}

- tags ::

"))
     ("a" "Analysis" plain "%?" :immediate-finish t :unnarrowed t :if-new
      (file+head "%<%Y%m%d%H%M%S>-analysis_${slug}.org" "#+ROAM_TAGS: Analysis
#+TITLE: ${title}

- tags :: [[id:111eeb88-55d1-4d4f-a2a8-5f8ff7791472][Analysis]]

* Content
#+BEGIN_SRC python :session py :exports results :var ATT_DIR=(org-attach-dir)

#+END_SRC"))
     ("g" "gene" plain "%?" :immediate-finish t :unnarrowed t :if-new
      (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+ROAM_TAGS: Gene
#+title: ${title}

- tags :: [[id:131686dd-7a7e-49ca-8407-1ea72a780e4e][Gene]]


* Mutant upregulation
#+BEGIN_SRC python :session py :exports results :var ATT_DIR=(org-attach-dir)
df = pd.read_csv('/home/moritz/mesc-regulation/output/mrna_data_all.csv', index_col=[0,1], header=[0,1])
df.xs(axis=1, level=1, key='log2FoldChange').reset_index(level=0).loc['${title}']
#+END_SRC

* TPM expression
#+BEGIN_SRC python :session py :exports results :var ATT_DIR=(org-attach-dir)
df.xs(axis=1, level=1, key='tpm_expression').reset_index(level=0, drop=True).loc['${title}'].plot(kind='bar')
#+END_SRC

* Isoform expression
#+BEGIN_SRC python :session py :exports results :var ATT_DIR=(org-attach-dir)
from moritzsphd.integration import gene_transcript_expression
gene_transcript_expression('${title}', plot=True)
#+END_SRC"))
     ("r" "ref" plain
      (file "/home/moritz/wiki/templates/noter_ref.template")
      :immediate-finish t :jump-to-captured t :if-new
      (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}"))
     ("f" "Friday seminar" plain "%?" :immediate-finish t :jump-to-captured t :unnarrowed t :if-new
      (file+head "%<%Y%m%d%H%M%S>-friday_seminar_%<%Y_%m_%d>.org" "#+ROAM_TAGS: Talk
#+title: Friday Seminar %<%Y-%m-%d>

- tags :: [[id:15f006d2-a3b7-4a2c-bfc1-754220b11797][Talk]]

* Content
"))
     ("m" "meeting" plain "%?" :immediate-finish t :unnarrowed t :if-new
      (file+head "%<%Y%m%d%H%M%S>-meeting_${slug}.org" "#+ROAM_TAGS: Meeting
#+title: ${title}

- tags :: [[id:ff7f625d-20bd-41d7-a3fd-ebbe9f40961e][Meeting]]

* Content
"))
     ("t" "talk" plain "%?" :immediate-finish t :unnarrowed t :if-new
      (file+head "%<%Y%m%d%H%M%S>-talk_${slug}.org" "#+ROAM_TAGS: Talk
#+title: ${title}

- tags :: [[id:15f006d2-a3b7-4a2c-bfc1-754220b11797][Talk]]

* Content
"))
     ("p" "person" plain "%?" :immediate-finish t :unnarrowed t :if-new
      (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+ROAM_TAGS: Person
#+title: ${title}

- tags :: [[id:193d3f1c-cfc3-48e8-90bf-23ae33cdc313][Person]]

"))))
 '(org-roam-dailies-capture-templates
   '(("d" "default" entry "* %?" :target
      (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>
* Morning dump
- [/] Daily tasks 
  - [ ] Take pills 1-2 hours after wake up
  - [ ] Check calendar
  - [ ] [[file:../../gtd/toread.org][Read two abstracts, optionally one paper]]
  - [ ] Process inbox
  - [ ] Check Agenda
  - [ ] Check daily routine 
  - [ ] Afternoon Take coffein at 4
  - [ ] Between 17:00 and 19:00 do some sports
  - [ ] [[file:../../gtd/toread.org][Read <leisure> things]]
* Journal
* Gratitude"))))
 '(org-roam-directory "/home/moritz/wiki/roam")
 '(org-src-preserve-indentation nil)
 '(org-src-tab-acts-natively nil)
 '(org-startup-with-inline-images t)
 '(org-tags-exclude-from-inheritance '("project"))
 '(package-selected-packages
   '(ox-ipynb org copilot org-drill persist seqel image-roll evil-exwm-state ox-hugo tomelr keytar lsp-grammarly grammarly org-tree-slide theme-changer gscholar-bibtex eaf git-auto-commit-mode conda helm-rg helm-org-ql org-ql peg org-super-agenda map ts py-autopep8 swiper drag-stuff button-lock matrix-client frame-purpose esxml tracking ov typescript-mode pyvenv org-roam emacsql-sqlite3 pdf-tools key-chord ivy tablist org-category-capture alert log4e gntp magit-popup origami skewer-mode hierarchy json-snatcher json-reformat multiple-cursors js2-mode epc concurrent simple-httpd htmlize password-store helm-bibtex bibtex-completion biblio parsebib biblio-core haml-mode grip-mode gitignore-mode fringe-helper git-gutter+ gh marshal logito pcache ghub closql treepy flyspell-correct magit git-commit transient ctable ess with-editor polymode anaphora websocket lsp-treemacs bui posframe ycmd request-deferred deferred web-completion-data rtags pos-tip company cider sesman queue parseedn clojure-mode parseclj a autothemer lsp-mode dash-functional markdown-mode rust-mode inf-ruby yasnippet auctex anaconda-mode pythonic auto-complete evil-easymotion dired-quick-sort zenburn-theme zen-and-art-theme yasnippet-snippets yapfify yaml-mode xterm-color ws-butler writeroom-mode winum white-sand-theme which-key web-mode web-beautify vterm volatile-highlights vi-tilde-fringe uuidgen use-package unfill undo-tree underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme treemacs-projectile treemacs-persp treemacs-magit treemacs-icons-dired treemacs-evil toxi-theme toml-mode toc-org tide terminal-here telega tao-theme tangotango-theme tango-plus-theme tango-2-theme tagedit systemd synosaurus synonymous symon symbol-overlay sunny-day-theme sublime-themes subatomic256-theme subatomic-theme string-inflection ssh-agency spotify sphinx-doc spaceline-all-the-icons spacegray-theme soothe-theme solarized-theme soft-stone-theme soft-morning-theme soft-charcoal-theme snakemake-mode smyx-theme smeargle slim-mode shell-pop seti-theme seeing-is-believing scss-mode sass-mode rvm ruby-tools ruby-test-mode ruby-refactor ruby-hash-syntax rubocopfmt rubocop rspec-mode ron-mode robe rjsx-mode reverse-theme restart-emacs rebecca-theme rbenv rake rainbow-delimiters railscasts-theme racer pytest pyenv-mode py-isort purple-haze-theme pulseaudio-control pug-mode professional-theme prettier-js popwin planet-theme pippel pipenv pip-requirements pinentry phoenix-dark-pink-theme phoenix-dark-mono-theme password-store-otp password-generator paradox overseer orgit organic-green-theme org-superstar org-roam-bibtex org-rich-yank org-ref org-projectile org-present org-pomodoro org-now org-noter org-mime org-download org-cliplink org-brain openwith open-junk-file omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme nodejs-repl noctilux-theme nix-mode nginx-mode naquadah-theme nameless mwim mustang-theme multi-term move-text monokai-theme monochrome-theme molokai-theme moe-theme modus-vivendi-theme modus-operandi-theme mmm-mode minitest minimal-theme material-theme markdown-toc majapahit-theme magit-svn magit-section magit-gitflow madhat2r-theme macrostep lush-theme lsp-ui lsp-python-ms lsp-pyright lsp-origami lsp-latex lorem-ipsum livid-mode live-py-mode link-hint light-soap-theme kaolin-themes jupyter json-navigator json-mode js2-refactor js-doc jbeans-theme jazz-theme ir-black-theme interleave insert-shebang inkpot-theme indent-guide importmagic impatient-mode hybrid-mode hungry-delete hl-todo highlight-parentheses highlight-numbers highlight-indentation heroku-theme hemisu-theme helm-xref helm-w3m helm-themes helm-swoop helm-rtags helm-pydoc helm-purpose helm-projectile helm-pass helm-org-rifle helm-org helm-nixos-options helm-mode-manager helm-make helm-lsp helm-ls-git helm-gitignore helm-git-grep helm-flx helm-exwm helm-descbinds helm-css-scss helm-company helm-cider helm-c-yasnippet helm-ag hc-zenburn-theme gruvbox-theme gruber-darker-theme grandshell-theme gotham-theme google-translate google-c-style golden-ratio gnuplot gitignore-templates github-search github-clone gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe+ gist gh-md gandalf-theme fuzzy framemove forge font-lock+ flyspell-correct-helm flycheck-ycmd flycheck-rust flycheck-rtags flycheck-pos-tip flycheck-package flycheck-elsa flycheck-bashate flx-ido flatui-theme flatland-theme fish-mode farmhouse-theme fancy-battery eziam-theme eyebrowse expand-region exotica-theme evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-textobj-line evil-surround evil-org evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit evil-lisp-state evil-lion evil-indent-plus evil-iedit-state evil-goggles evil-exchange evil-escape evil-ediff evil-cleverparens evil-args evil-anzu ess-R-data-view espresso-theme eshell-z eshell-prompt-extras esh-help erc-yt erc-view-log erc-social-graph erc-image erc-hl-nicks emr emmet-mode elisp-slime-nav el-patch ein editorconfig dumb-jump dracula-theme dotenv-mode doom-themes django-theme disaster diminish devdocs desktop-environment define-word darktooth-theme darkokai-theme darkmine-theme darkburn-theme dap-mode dakrone-theme cython-mode cyberpunk-theme csv-mode cpp-auto-include company-ycmd company-web company-shell company-rtags company-reftex company-quickhelp company-nixos-options company-c-headers company-auctex company-anaconda column-enforce-mode color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized clues-theme clojure-snippets clipmon clean-aindent-mode cider-eval-sexp-fu chruby chocolate-theme cherry-blossom-theme cfrs centered-cursor-mode ccls cargo busybee-theme bundler bubbleberry-theme browse-at-remote blacken birds-of-paradise-plus-theme badwolf-theme auto-yasnippet auto-highlight-symbol auto-dictionary auto-compile auctex-latexmk apropospriate-theme anti-zenburn-theme ample-zen-theme ample-theme alect-themes aggressive-indent afternoon-theme ace-link ace-jump-helm-line ac-ispell))
 '(paradox-github-token t)
 '(pdf-annot-activate-created-annotations t)
 '(pdf-info-epdfinfo-error-filename "/tmp/epdfinfo.log")
 '(pdf-misc-print-program "/usr/bin/lpr" t)
 '(pdf-misc-print-program-args '("-o media=A4" "-o fitplot"))
 '(pdf-misc-print-program-executable "/run/current-system/sw/bin/gtklp")
 '(projectile-globally-ignored-file-suffixes '("svg" "ipynb"))
 '(python-shell-interpreter "python")
 '(python-shell-interpreter-args "")
 '(python-shell-prompt-block-regexp "\\.\\.\\.:? ")
 '(send-mail-function 'smtpmail-send-it)
 '(tramp-default-method "ssh")
 '(tramp-verbose 3)
 '(undo-tree-auto-save-history nil)
 '(undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
 '(warning-suppress-types '((server) (:warning))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(highlight-parentheses-highlight ((nil (:weight ultra-bold))) t))
)
