(setq-default c-basic-offset 4)
;;; Prevent Extraneous Tabs
(setq-default indent-tabs-mode nil)
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
