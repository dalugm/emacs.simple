;;; init-vc.el --- version control -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Version control system.
;;

;;; Code:

(use-package magit
  :bind (("C-x g"   . magit-status)
         ("C-c v g" . magit-status)
         ("C-x M-g" . magit-dispatch)
         ("C-c v d" . magit-dispatch)
         ("C-c M-g" . magit-file-dispatch)
         ("C-c v f" . magit-file-dispatch))
  :config
  ;; add module section into the status buffer
  (magit-add-section-hook 'magit-status-sections-hook
                          #'magit-insert-modules
                          #'magit-insert-stashes #'append))

(use-package diff-hl
  :hook ((after-init . global-diff-hl-mode)
         (dired-mode . diff-hl-dired-mode))
  :config
  ;; highlight on-the-fly
  (diff-hl-flydiff-mode +1)

  (setq diff-hl-margin-symbols-alist
        '((insert . "+") (delete . "-") (change . "=")
          (unknown . "?") (ignored . "!")))

  (unless (display-graphic-p)
    ;; fall back to margin since fringe is unavailable in terminal
    (diff-hl-margin-mode +1)
    ;; avoid restoring `diff-hl-margin-mode' when using `desktop.el'
    (with-eval-after-load 'desktop
      (add-to-list 'desktop-minor-mode-table
                   '(diff-hl-margin-mode nil))))

  ;; integration with `magit'
  (with-eval-after-load 'magit
    (add-hook 'magit-pre-refresh-hook #'diff-hl-magit-pre-refresh)
    (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)))

(use-package git-modes
  :mode ("/\\.dockerignore\\'" . gitignore-mode))

(use-package git-link
  :init
  ;; make the following lambda work without initialize.
  (setq git-link-use-commit nil)
  :bind (("C-c v l l" . git-link)
         ("C-c v l c" . git-link-commit)
         ("C-c v l h" . git-link-homepage)
         ("C-c v l t" . (lambda ()
                          "Toggle `git-link-use-commit'."
                          (interactive)
                          (setq git-link-use-commit
                                (not git-link-use-commit))))))

(use-package git-timemachine
  :bind ("C-c v t" . git-timemachine))

(provide 'init-vc)

;;; init-vc.el ends here