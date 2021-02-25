;;; ess-init.el --- A minimal init file with ESS customization.
;;
;; Copyleft, 2021.
;; Author: Frédéric Santos
;; URL: https://github.com/ess-intro/presentation-ess-customization
;;
;;; Commentary:
;; Provides possible inspiration for customizing ESS (without any warranty).
;; Should be adapted according to your own setup, in particular for yasnippet (l. 115).
;;
;;; Code:

;; Make sure that use-package is installed:
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; Load use-package:
(eval-when-compile
  (require 'use-package))

;; Code visibility:
(setq ess-eval-visibly 'nowait)

;; Font lock keywords for syntactic highlighting:
(setq ess-R-font-lock-keywords
      '((ess-R-fl-keyword:keywords . t)
	(ess-R-fl-keyword:constants . t)
	(ess-R-fl-keyword:modifiers . t)
	(ess-R-fl-keyword:fun-defs . t)
	(ess-R-fl-keyword:assign-ops . t)
	(ess-R-fl-keyword:%op% . t)
	(ess-fl-keyword:fun-calls . t)
	(ess-fl-keyword:numbers . t)
	(ess-fl-keyword:operators)
	(ess-fl-keyword:delimiters)
	(ess-fl-keyword:=)
	(ess-R-fl-keyword:F&T . t))))

;; Activate global mode for parenthesis matching:
(show-paren-mode)

;; Remove Flymake support:
(setq ess-use-flymake nil)
;; Replace it (globally) by Flycheck:
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

;; Open Rdired buffer with F9:
(add-hook 'ess-r-mode-hook
	  '(lambda ()
	     (local-set-key (kbd "<f9>") #'ess-rdired)))
;; Close Rdired buffer with F9 as well:
(add-hook 'ess-rdired-mode-hook
	  '(lambda ()
	     (local-set-key (kbd "<f9>") #'kill-buffer-and-window)))

;; An example of window configuration:
(setq display-buffer-alist
      '(("*R Dired"
	 (display-buffer-reuse-window display-buffer-at-bottom)
	 (window-width . 0.5)
	 (window-height . 0.25)
	 (reusable-frames . nil))
	("*R"
	 (display-buffer-reuse-window display-buffer-in-side-window)
	 (side . right)
	 (slot . -1)
	 (window-width . 0.5)
	 (reusable-frames . nil))
	("*Help"
	 (display-buffer-reuse-window display-buffer-in-side-window)
	 (side . right)
	 (slot . 1)
	 (window-width . 0.5)
	 (reusable-frames . nil))))

(use-package company
  :ensure t
  :config
  ;; Turn on company-mode globally:
  (add-hook 'after-init-hook 'global-company-mode)
  ;; Only activate company in R scripts, not in R console:
  (setq ess-use-company 'script-only))

;; Use F12 to trigger manually completion on R function args:
(add-hook 'ess-r-mode-hook
	  '(lambda ()
	     (local-set-key (kbd "<f12>") #'company-R-args)))

;; More customization options for company:
(setq company-selection-wrap-around t
      ;; Align annotations to the right tooltip border:
      company-tooltip-align-annotations t
      ;; Idle delay in seconds until completion starts automatically:
      company-idle-delay 0.45
      ;; Completion will start after typing two letters:
      company-minimum-prefix-length 2
      ;; Maximum number of candidates in the tooltip:
      company-tooltip-limit 10)

(use-package company-quickhelp
  :ensure t
  :config
  ;; Load company-quickhelp globally:
  (company-quickhelp-mode)
  ;; Time before display of documentation popup:
  (setq company-quickhelp-delay 0.3))

(use-package yasnippet
  :ensure t
  :config
  ;; Indicate the directory containing your snippets:
  ;; (setq yas-snippet-dirs '("path/to/your/snippets"))
  ;; Load your snippets on startup:
  (yas-reload-all)
  ;; Turn on yasnippet (minor) mode when editing R files:
  (add-hook 'ess-r-mode-hook #'yas-minor-mode))
