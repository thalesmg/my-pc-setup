;; -*- mode: lisp -*-
(ql:quickload :swank)
(ql:quickload :clx-truetype)

(in-package :stumpwm)

(load-module :cpu)
(load-module :mem)
(load-module :ttf-fonts)
(load-module :battery-portable)

;; use super-q
(set-prefix-key (kbd "s-q"))

(define-key *top-map* (kbd "s-j") "next-in-frame")
(define-key *top-map* (kbd "s-k") "prev-in-frame")

;; aliases
(setf *window-format* "%m%n%s%20c")
(setf *time-modeline-string* "%a %Y-%m-%d %H:%M:%S")
(setf *mode-line-timeout* 2)
(setf *mode-line-border-width* 0)

(setf *screen-mode-line-format*
      (list "%g %W ^> %C | %M | %B | " '(:eval (run-shell-command "date +'%a %Y-%m-%d %H:%M:%S'" t))))
(enable-mode-line (current-screen) (current-head) t)

;; commands
(defcommand tmg_runcmd () ()
  "exec a command"
  (run-shell-command "bash -l -c 'rofi -show run'"))
(define-key *top-map* (kbd "s-p") "tmg_runcmd")

(defcommand tmg_editor () ()
  "run or raise emacs"
  (run-or-raise "emacs" '(:class "Emacs")))

(define-key *top-map* (kbd "s-e") "tmg_editor")
(define-key *root-map* (kbd "e") "tmg_editor")
(undefine-key *root-map* (kbd "C-e"))

(defcommand tmg_terminal () ()
  "run or raise terminal"
  (run-or-raise "terminator" '(:class "Terminator")))
(define-key *top-map* (kbd "s-t") "tmg_terminal")
(define-key *root-map* (kbd "c") "tmg_terminal")
(undefine-key *root-map* (kbd "C-c"))

(defcommand tmg_firefox () ()
  "run or raise firefox"
  (run-or-raise "firefox" '(:class "Firefox")))
(define-key *top-map* (kbd "s-b") "tmg_firefox")

(defcommand tmg_passmenu () ()
  "run passmenu"
  (run-shell-command "bash -l -c passmenu"))
(define-key *top-map* (kbd "s-P") "tmg_passmenu")

;; defaults

(xft:cache-fonts)
;; (set-font
;;  (make-instance 'xft:font :family "Iosevka SS07" :subfamily "Regular" :size 11))
;; (setf *startup-message* nil)
;; (setq *ignore-wm-inc-hints* t)

(setq *window-border-style* :thin)
(setf *mouse-focus-policy* :sloppy)

;; swank server
(funcall (intern "CREATE-SERVER" :swank) :port 19876 :dont-close t)
