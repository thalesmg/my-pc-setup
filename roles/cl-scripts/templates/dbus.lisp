(uiop:define-package :meus-papiros/dbus
    (:use #:cl
          #:uiop
          #:cl-scripting
          #:inferior-shell
          #:fare-utils
          #:cl-launch/dispatch)
  (:export #:tmg-mp-play-pause
           #:tmg-mp-next
           #:tmg-mp-prev
           #:tmg-mp-fwd
           #:tmg-mp-bwd))

;; (asdf:load-system :meus-papiros)

(in-package #:meus-papiros/dbus)

(defun dbus.mplayer/send (target method &rest args)
  (let* ((fmt-str (format nil
                          "~{~A~^ ~}"
                          (concatenate
                           'list
                           '("dbus-send"
                             "--session"
                             "--dest=org.mpris.MediaPlayer2.~A"
                             "--type=method_call"
                             "--print-reply"
                             "/org/mpris/MediaPlayer2"
                             "org.mpris.MediaPlayer2.Player.~A")
                           args)))
         (command (format nil fmt-str target method)))
    (run command)))

(defun dbus.mplayer/play-pause (target)
  (dbus.mplayer/send target "PlayPause"))

(defun dbus.mplayer/next (target)
  (dbus.mplayer/send target "Next"))

(defun dbus.mplayer/previous (target)
  (dbus.mplayer/send target "Previous"))

(defun dbus.mplayer/forward (target)
  (dbus.mplayer/send target "Seek" "int64:10000000"))

(defun dbus.mplayer/backward (target)
  (dbus.mplayer/send target "Seek" "int64:-10000000"))

(exporting-definitions
 (defun tmg-mp-play-pause (target)
   (dbus.mplayer/play-pause target))

 (defun tmg-mp-next (target)
   (dbus.mplayer/next target))

 (defun tmg-mp-prev (target)
   (dbus.mplayer/previous target))

 (defun tmg-mp-fwd (target)
   (dbus.mplayer/forward target))

 (defun tmg-mp-bwd (target)
   (dbus.mplayer/backward target)))

(register-commands :meus-papiros/dbus)
