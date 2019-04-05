(uiop:define-package :meus-papiros/misc
    (:use #:cl
          #:uiop
          #:cl-scripting
          #:inferior-shell
          #:fare-utils
          #:uuid
          #:cl-ppcre
          #:cl-launch/dispatch)
  (:export #:tmg-uuid1
           #:tmg-uuid4
           #:tmg-mp3))

;; (asdf:load-system :meus-papiros)

(in-package #:meus-papiros/misc)

(exporting-definitions
 (defun tmg-uuid1 ()
   (uuid:make-v1-uuid))

 (defun tmg-uuid4 ()
   (uuid:make-v4-uuid))

 (defun tmg-mp3 (input-file)
   (let* ((input-file (truename input-file))
          (base-file (first (cl-ppcre:split "\\.[^.]*$" (namestring input-file))))
          (out-file (concatenate 'string base-file ".mp3")))
     (run/i `(and (ffmpeg -i ,input-file -vn ,out-file) (rm ,input-file)) :on-error t)
     (success))))

(register-commands :meus-papiros/misc)
