(uiop:define-package :meus-papiros/misc
    (:use #:cl
          #:uiop
          #:cl-scripting
          #:inferior-shell
          #:fare-utils
          #:uuid
          #:cl-launch/dispatch)
  (:export #:tmg-uuid1
           #:tmg-uuid4))

;; (asdf:load-system :meus-papiros)

(in-package #:meus-papiros/misc)

(exporting-definitions
 (defun tmg-uuid1 ()
   (uuid:make-v1-uuid))

 (defun tmg-uuid4 ()
   (uuid:make-v4-uuid)))

(register-commands :meus-papiros/misc)
