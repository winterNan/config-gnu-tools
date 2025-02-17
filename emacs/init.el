;; Load CEDET.
;; See cedet/common/cedet.info for configuration details.
;; IMPORTANT: Tou must place this *before* any CEDET component
;; gets activated by another package (Gnus, auth-source, ...).

;; Add further minor-modes to be enabled by semantic-mode.
;; See doc-string of `semantic-default-submodes' for other things
;; you can use here.

(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode t)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode t)
(add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode t)

(define-key key-translation-map [dead-grave] "`")
(define-key key-translation-map [dead-acute] "'")
(define-key key-translation-map [dead-circumflex] "^")
(define-key key-translation-map [dead-diaeresis] "\"")
(define-key key-translation-map [dead-tilde] "~")

;; Enable Semantic
(require 'cc-mode)
(require 'semantic)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)

(semantic-mode 1)
(global-semantic-idle-summary-mode 1)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)

(add-to-list 'load-path "~/.emacs.d/elpa/stickyfunc-enhance-20150429.1814")
(require 'stickyfunc-enhance)
(setq-local eldoc-documentation-function #'ggtags-eldoc-function)
;; Enable EDE (Project Management) features
(global-ede-mode 1)

(require 'package)

(add-to-list 'load-path "~/.emacs.d/elpa/async-20221228.1315")
(require 'async)
(add-to-list 'load-path "~/.emacs.d/elpa/helm-3.8.5")
(require 'helm)

(add-to-list 'package-archives
         '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(add-to-list 'load-path "~/.emacs.d/custom")

;(package-initialize)
(require 'setup-general)
(require 'setup-ivy-counsel)
(require 'helm)
(require 'setup-helm)
(require 'setup-helm-gtags)
(require 'setup-ggtags)
(require 'setup-cedet)
(require 'setup-editing)

(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))

(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)

(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
)

(require 'helm-gtags)
;; Enable helm-gtags-mode
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-,") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-.") 'helm-gtags-next-history)
(add-hook 'helm-gtags-dwim #'balance-windows)

(setq-local imenu-create-index-function #'ggtags-build-imenu-index)

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

(setq company-backends (delete 'company-semantic company-backends))
(define-key c-mode-map  [(tab)] 'company-complete)
(define-key c++-mode-map  [(tab)] 'company-complete)

(add-to-list 'company-backends 'company-c-headers)

(use-package magit
  :config
  (global-set-key (kbd "C-c m") 'magit-status))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'manoj-dark)

(setq lazy-highlight-cleanup nil)
(setq lazy-highlight-max-at-a-time nil)
(setq lazy-highlight-initial-delay 0)
(setq column-number-mode t)

(put 'dired-find-alternate-file 'disabled nil)

(setq confirm-kill-emacs #'y-or-n-p)

(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
            '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

(require 'dired-x)
(nyan-mode 1)
(nyan-start-animation)
(nyan-toggle-wavy-trail)
(window-numbering-mode)

(c-add-style "m5"
     '((c-basic-offset . 4)
       (indent-tabs-mode . nil)
       (c-offsets-alist . ((substatement-open . 0)
			   (inline-open . 0)
			   (block-open . -4)
			   (case-label . 2)
			   (label . 2)
			   (statement-case-intro . 2)
			   (statement-case-open . 2)
			   (access-label . -2)
			   (innamespace . 0)))))

(use-package dashboard
  :ensure t
  :defer t
  :init
  (dashboard-setup-startup-hook)
  :config
)

(setq dashboard-items '((recents  . 50)
                        (bookmarks . 50)
                        (projects . 50)
                        (agenda . 50)
                        (registers . 50)))
(setq dashboard-startup-banner 'logo)

(use-package sr-speedbar
  :ensure t
  :defer t
  :init
  (setq sr-speedbar-right-side nil)
  (setq speedbar-show-unknown-files t)
  (setq sr-speedbar-width 35)
  (setq sr-speedbar-max-width 35)
  (setq speedbar-use-images t)
  (define-key speedbar-mode-map "\M-p" nil)
  (setq sr-speedbar-auto-refresh t)
  (sr-speedbar-open)
  :config
  (with-current-buffer sr-speedbar-buffer-name
    (setq window-size-fixed 'width))
)

(setq diredp-hide-details-initially-flag nil)
(setq diredp-bind-problematic-terminal-keys nil)
(require 'dired+)

(require 'ecb)

(add-to-list 'load-path "~/.emacs.d/custom/elpy")
(load "elpy")
(load "elpy-rpc")
(load "elpy-shell")
(load "elpy-profile")
(load "elpy-refactor")
(load "elpy-django")

(setq python-shell-interpreter "python")
(setq py-python-command "python")
(setq python-python-command "python")

(use-package elpy
  :ensure t
  :config
  (elpy-enable))

(setq elpy-rpc-backend "jedi")
(setq elpy-rpc-python-command "python")

;;;;;;; Standard Jedi.el setting
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook 'jedi:ac-setup)
(setq jedi:setup-keys t)                      ; optional
(setq jedi:complete-on-dot t)                 ; optional
(add-hook 'elpy-mode-hook (lambda () (highlight-indentation-mode -1)))

(require 'flymake)
(defun flymake-get-tex-args (file-name)
(list "pdflatex"
(list "-file-line-error" "-draftmode" "-interaction=nonstopmode" file-name)))

(add-hook 'LaTeX-mode-hook 'flymake-mode)
(flyspell-mode)

(pdf-tools-install)
(pdf-loader-install)

(server-start)
(setq TeX-view-program-selection '((output-pdf "PDF Tools")))
(setq TeX-source-correlate-mode t)

(global-set-key (kbd "M-n") (kbd "C-u 1 C-v"))
(global-set-key (kbd "M-p") (kbd "C-u 1 M-v"))

(global-undo-tree-mode 1)
(global-set-key (kbd "C-/") 'undo)
(global-set-key (kbd "M-/") 'redo)
(global-set-key (kbd "C-c ;") 'comment-line)

(setq dired-listing-switches "-laGh1v --group-directories-first")

(global-set-key (kbd "C-<up>") (lambda() (interactive) (call-interactively #'elpy-nav-backward-block) (call-interactively #'recenter)))
(global-set-key (kbd "C-<down>") (lambda() (interactive) (call-interactively #'elpy-nav-forward-block) (call-interactively #'recenter)))

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
(require 'mu4e)

;; for sending mails
(require 'smtpmail)

;; we installed this outside emacs 
(setq mu4e-mu-binary (executable-find "mu"))

;; this is the directory we created before:
(setq mu4e-maildir "~/.maildir")

;; this command is called to sync imap servers:
(setq mu4e-get-mail-command (concat (executable-find "mbsync") " -a"))
;; how often to call it in seconds:
(setq mu4e-update-interval 300)

;; save attachment to desktop by default
;; or another choice of yours:
(setq mu4e-attachment-dir "~/Downloads")

;; rename files when moving - needed for mbsync:
(setq mu4e-change-filenames-when-moving t)

;; list of your email adresses:
(setq mu4e-user-mail-address-list '("your_email@aa.bb.cc"))

(setq mu4e-maildir-shortcuts
        '(("/your_email@aa.bb.cc/Inbox" . ?i)
          ("/your_email@aa.bb.cc/Sent" . ?s)
          ("/your_email@aa.bb.cc/Drafts" . ?d)
          ("/your_email@aa.bb.cc/gem5-dev" . ?g)
          ("/your_email@aa.bb.cc/gem5-users" . ?G)
          ("/your_email@aa.bb.cc/Utkast" . ?U)
          ("/your_email@aa.bb.cc/Skr&AOQ-ppost" . ?t)))

(setq mu4e-contexts
      `(,(make-mu4e-context
          :name "uu"
          :enter-func
          (lambda () (mu4e-message "Enter your_email@aa.bb.cc context"))
          :leave-func
          (lambda () (mu4e-message "Leave your_email@aa.bb.cc context"))
          :match-func
          (lambda (msg)
            (when msg
              (mu4e-message-contact-field-matches msg
                                                  :to "your_email@aa.bb.cc")))
          :vars '((user-mail-address  . "your_email@aa.bb.cc" )
                  (user-full-name     . "Your Name")
                  (mu4e-drafts-folder . "/your_email@aa.bb.cc/Drafts")
                  (mu4e-refile-folder . "/your_email@aa.bb.cc/Archives")
                  (mu4e-sent-folder   . "/your_email@aa.bb.cc/Sent")
                  (mu4e-trash-folder  . "/your_email@aa.bb.cc/Trash")))))

(setq mu4e-context-policy 'pick-first) ;; start with the first (default) context;
(setq mu4e-compose-context-policy 'ask) ;; ask for context if no context matches;

;; gpg encryptiom & decryption:
;; this can be left alone
(require 'epa-file)
; (epa-file-enable)
(setq epa-pinentry-mode 'loopback)
(auth-source-forget-all-cached)

;; don't keep message compose buffers around after sending:
(setq message-kill-buffer-on-exit t)

;; send function:
(setq send-mail-function 'sendmail-send-it
      message-send-mail-function 'sendmail-send-it)

;; send program:
;; this is exeranal. remember we installed it before.
(setq sendmail-program (executable-find "msmtp"))

;; select the right sender email from the context.
(setq message-sendmail-envelope-from 'header)

;; chose from account before sending
;; this is a custom function that works for me.
;; well I stole it somewhere long ago.
;dd-hook 'prog-mode-hook 'highlight-indent-guides-mode); I suggest using it to make matters easy
;; of course adjust the email adresses and account descriptions
(defun timu/set-msmtp-account ()
  (if (message-mail-p)
      (save-excursion
        (let*
            ((from (save-restriction
                     (message-narrow-to-headers)
                     (message-fetch-field "from")))
             (account
              (cond
               ((string-match "your_email@aa.bb.cc" from) "your_email@aa.bb.cc"))))
          (setq message-sendmail-extra-arguments (list '"-a" account))))))

(add-hook 'message-send-mail-hook 'timu/set-msmtp-account)

;; mu4e cc & bcc
;; this is custom as well
(add-hook 'mu4e-compose-mode-hook
          (defun timu/add-cc-and-bcc ()
            "My Function to automatically add Cc & Bcc: headers.
    This is in the mu4e compose mode."
            (save-excursion (message-add-header "Cc:\n"))
            (save-excursion (message-add-header "Bcc:\n"))))

;; mu4e address completion
(add-hook 'mu4e-compose-mode-hook 'company-mode)

;; store link to message if in header view, not to header query:
(setq org-mu4e-link-query-in-headers-mode nil)
;; don't have to confirm when quitting:
(setq mu4e-confirm-quit nil)
;; number of visible headers in horizontal split view:
(setq mu4e-headers-visible-lines 20)
;; don't show threading by default:
(setq mu4e-headers-show-threads nil)
;; hide annoying "mu4e Retrieving mail..." msg in mini buffer:
(setq mu4e-hide-index-messages t)
;; customize the reply-quote-string:
(setq message-citation-line-format "%N @ %Y-%m-%d %H:%M :\n")
;; M-x find-function RET message-citation-line-format for docs:
(setq message-citation-line-function 'message-insert-formatted-citation-line)

(setq mu4e-headers-fields
    '( (:date          .  12)    ;; alternatively, use :human-date
       (:flags         .  9)
       (:from          .  22)
       (:subject       .  nil))) ;; alternatively, use :thread-subject

(defun mu4e~headers-line-apply-flag-face (msg line)
  line)

(add-to-list 'load-path "~/.emacs.d/custom/mu4e-column-faces")
(use-package mu4e-column-faces
  :after mu4e
  :config (mu4e-column-faces-mode))

(setq org-agenda-include-diary t)
(setq org-agenda-files (list "~/.emacs.d/org-agenda/todo.org"))

;; weather from wttr.in
(use-package wttrin
  :init
  (setq wttrin-default-cities          '("Stockholm" "Uppsala")))
(put 'scroll-left 'disabled nil)

(setq gdb-many-windows t)

(add-to-list 'load-path "~/.emacs.d/custom/Emacs-langtool")
(setq langtool-language-tool-jar "~/LanguageTool-5.7/languagetool-commandline.jar")
(setq langtool-language-tool-server-jar "~/LanguageTool-5.7/languagetool-server.jar")
(require 'langtool)

(kill-buffer "*scratch*")

(setq auto-mode-alist
      (append '((".*\\.sm\\'" . c-mode))
              auto-mode-alist))
(setq split-height-threshold nil
      split-width-threshold nil)

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(set-face-attribute 'default nil :height 120)

(require 'ansi-color)
(defun display-ansi-colors ()
  (interactive)
  (ansi-color-apply-on-region (point-min) (point-max)))

(defun find-overlays-specifying (prop pos)
  (let ((overlays (overlays-at pos))
        found)
    (while overlays
      (let ((overlay (car overlays)))
        (if (overlay-get overlay prop)
            (setq found (cons overlay found))))
      (setq overlays (cdr overlays)))
    found))

(defun highlight-or-dehighlight-line ()
  (interactive)
  (if (find-overlays-specifying
       'line-highlight-overlay-marker
       (line-beginning-position))
      (remove-overlays (line-beginning-position) (+ 1 (line-end-position)))
    (let ((overlay-highlight (make-overlay
                              (line-beginning-position)
                              (+ 1 (line-end-position)))))
        (overlay-put overlay-highlight 'face '(:background "#333333"))
        (overlay-put overlay-highlight 'line-highlight-overlay-marker t))))


(global-set-key [f8] 'highlight-or-dehighlight-line)

(require 'bm)
(global-set-key (kbd "<f9>") 'bm-toggle)
(global-set-key (kbd "<f7>") (lambda() (interactive) (call-interactively #'bm-next) (call-interactively #'recenter)))
(global-set-key (kbd "<f8>") (lambda() (interactive) (call-interactively #'bm-previous) (call-interactively #'recenter)))
(global-set-key (kbd "<f6>") 'bm-show-all)

(global-set-key (kbd "<mouse-9>") 'bm-previous)
(global-set-key (kbd "<s-tab>") 'recenter-top-bottom)
(global-set-key (kbd "<mouse-8>") 'bm-next)

(set-face-attribute 'bm-face nil :background "RoyalBlue4" :foreground 'unspecified)
;; (global-hl-line-mode 1)

(require 'hlinum)
(hlinum-activate)
(global-display-line-numbers-mode 1)

(require 'highlight-parentheses)

(define-globalized-minor-mode global-highlight-parentheses-mode highlight-parentheses-mode
  (lambda nil (highlight-parentheses-mode t)))

(global-highlight-parentheses-mode t)
(scroll-bar-mode -1)
(global-set-key (kbd "M-<return>") 'balance-windows)
(global-set-key (kbd "C-<return>") 'recenter-top-bottom)

(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

;; recentf stuff
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 50)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(require 'lsp-mode)
(add-hook 'c++-mode-hook 'lsp-mode)
(add-hook 'c-mode-hook 'lsp-mode)
(add-hook 'objc-mode-hook 'lsp-mode)

(use-package lsp-mode
  :hook
  ((python-mode . lsp)))

(use-package lsp-ui
  :commands lsp-ui-mode)

(put 'lsp-ui-doc--handle-mouse-movement 'isearch-scroll t)
(setq isearch-allow-scroll t)
(setq lsp-signature-auto-activate nil)
(setq lsp-signature-render-documentation nil)

;(ac-config-default)
(global-set-key (kbd "C-c C-f") 'ff-find-other-file)

(require 'google-translate)
(require 'google-translate-default-ui)
(global-set-key "\C-ct" 'google-translate-at-point)
(global-set-key "\C-cT" 'google-translate-query-translate)

(use-package vterm
    :ensure t)

(defvar blink-cursor-colors (list  "#92c48f" "#6785c5" "#be369c" "#d9ca65")
  "On each blink the cursor will cycle to the next color in this list.")

(setq blink-cursor-count 0)
(defun blink-cursor-timer-function ()
  "Zarza wrote this cyberpunk variant of timer `blink-cursor-timer'. 
Warning: overwrites original version in `frame.el'.

This one changes the cursor color on each blink. Define colors in `blink-cursor-colors'."
  (when (not (internal-show-cursor-p))
    (when (>= blink-cursor-count (length blink-cursor-colors))
      (setq blink-cursor-count 0))
    (set-cursor-color (nth blink-cursor-count blink-cursor-colors))
    (setq blink-cursor-count (+ 1 blink-cursor-count))
    )
  (internal-show-cursor nil (not (internal-show-cursor-p)))
  )

(add-hook 'pdf-view-mode-hook (lambda() (linum-mode -1)))

(mu4e-alert-set-default-style 'libnotify)
(add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
(add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)

(add-to-list 'load-path "~/.emacs.d/custom/emacs-powerline")
(require 'powerline)
(powerline-default-theme)

;; Load elfeed-org
(require 'elfeed-org)

;; Initialize elfeed-org
;; This hooks up elfeed-org to read the configuration when elfeed
;; is started with =M-x elfeed=
(elfeed-org)

;; Optionally specify a number of files containing elfeed
;; configuration. If not set then the location below is used.
;; Note: The customize interface is also supported.
(setq rmh-elfeed-org-files (list "~/.emacs.d/elfeed.org"))

(setq-default c-basic-offset 4)

(defun zpcat-signature ()
  (interactive)
  (save-excursion
    (goto-char (point-max))
    (insert "--")
    (insert "\n")
    (insert "Best regards,\n")
    (insert "Your Name\n"))
  ;; if you want to tell a joke too
  ;; (fortune-cowsay)
  )
;; add fortune-cowsay to message-mode-hook
(add-hook 'message-mode-hook 'zpcat-signature)

(add-to-list 'org-emphasis-alist
             '("/" (:foreground "red"))
)

(add-to-list 'org-emphasis-alist
             '("*" (:foreground "green"))
)

(add-to-list 'org-emphasis-alist
             '("_" (:foreground "orange"))
)

(require 'header2)
(autoload 'auto-make-header "header2")
(add-hook 'emacs-lisp-mode-hook 'auto-make-header)
(add-hook 'c-mode-common-hook   'auto-make-header)

(add-hook 'isearch-mode-end-hook 'recenter)
(defadvice
  isearch-repeat-forward
  (after isearch-repeat-forward-recenter activate)
  (recenter))

(defadvice
  isearch-repeat-backward
  (after isearch-repeat-backward-recenter activate)
  (recenter))

(ad-activate 'isearch-repeat-forward)
(ad-activate 'isearch-repeat-backward)

(xterm-mouse-mode 1)
(global-flycheck-mode -1)
(flycheck-mode -1)
(hl-line-mode 1)

(add-hook 'elpy-mode-hook (lambda () (flycheck-mode -1)))
(add-hook 'Python-mode-hook (lambda () (flycheck-mode -1)))
(add-hook 'c++-mode-hook (lambda () (flycheck-mode -1)))

(setq x-select-enable-clipboard t)
(setq lsp-vhdl-server-path "vhdl-tool")

(use-package lsp-mode
         :config
         (add-hook 'vhdl-mode-hook 'lsp))

(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-scroll-amount '(5))
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq vhdl-basic-offset 4)

(use-package fzf
  :config
  (setq fzf/args "-x --color bw --print-query --margin=1,0 --no-hscroll"
        fzf/executable "fzf"
        fzf/git-grep-args "-i --line-number %s"
        ;; command used for `fzf-grep-*` functions
        ;; example usage for ripgrep:
        ;; fzf/grep-command "rg --no-heading -nH"
        fzf/grep-command "grep -nrH"
        ;; If nil, the fzf buffer will appear at the top of the window
        fzf/position-bottom t
        fzf/window-height 15))

(defun fzf-find-file (&optional directory)
  (interactive)
  (let ((d (fzf/resolve-directory directory)))
    (fzf
    (lambda (x)
        (let ((f (expand-file-name x d)))
        (when (file-exists-p f)
            (find-file f))))
    d)))

(require 'gpt)

(setq gpt-openai-key "sk-your_api_key_from_openai")
(setq gpt-openai-engine "gpt-4")
(setq gpt-openai-org "org-5p...Y")
(setq gpt-openai-max-tokens "2000")
(setq gpt-openai-temperature "0")
(global-set-key (kbd "M-C-p") 'gpt-dwim)

(setq tramp-verbose 6)

(require 'man)
(set-face-attribute 'Man-overstrike nil :inherit font-lock-type-face :bold t)
(set-face-attribute 'Man-underline nil :inherit font-lock-keyword-face :underline t)

(require 'xcscope)
(cscope-setup)

(use-package avy
    :bind ("C-x f" . avy-goto-word-1)
)
