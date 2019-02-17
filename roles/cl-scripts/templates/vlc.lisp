(uiop:define-package :meus-papiros/vlc
    (:use #:cl
          #:uiop
          #:cl-scripting
          #:inferior-shell
          #:fare-utils
          #:cl-launch/dispatch)
  (:export #:tmg-vlc))

;; (asdf:load-system :meus-papiros)

(in-package #:meus-papiros/vlc)

(defvar *vlc-host*
  "localhost")

(defvar *vlc-port*
  "4212")

(defun get-pass ()
  (string-trim '(#\Newline) (run/s `(pass local/vlc/password))))

(defun call-vlc (command)
  (let* ((auth (get-pass))
         (curl-comm (format nil "curl -H 'content-type: text/xml' -XGET -u':~A' '~A:~A/requests/status.xml?command=~A'" auth *vlc-host* *vlc-port* command)))
    (run/nil curl-comm)))

(exporting-definitions
  (defun tmg-vlc (&optional command)
    (cond
      ((equal command "next") (call-vlc "pl_next"))
      ((equal command "previous") (call-vlc "pl_previous"))
      ((equal command "pause-resume") (call-vlc "pl_pause"))
      ('t (progn
            (run `(echo "comandos possíveis: next, previous, pause-resume"))
            (failure))))))

(register-commands :meus-papiros/vlc)
