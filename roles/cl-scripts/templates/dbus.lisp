(uiop:define-package :meus-papiros/dbus
    (:use #:cl
          #:uiop
          #:cl-scripting
          #:inferior-shell
          #:fare-utils
          #:cl-launch/dispatch)
  (:export #:tmg-mp-play-pause
           #:tmg-mp-next
           #:tmg-mp-prev))

;; (asdf:load-system :meus-papiros)

(in-package #:meus-papiros/dbus)

(defun dbus.mplayer/send (target method)
  (let* ((fmt-str (format nil
                          "~{~A~^ ~}"
                          '("dbus-send"
                            "--session"
                            "--dest=org.mpris.MediaPlayer2.~A"
                            "--type=method_call"
                            "--print-reply"
                            "/org/mpris/MediaPlayer2"
                            "org.mpris.MediaPlayer2.Player.~A")))
                 (command (format nil fmt-str target method)))
    (run command)))

(defun dbus.mplayer/play-pause (target)
  (dbus.mplayer/send target "PlayPause"))

(defun dbus.mplayer/next (target)
  (dbus.mplayer/send target "Next"))

(defun dbus.mplayer/previous (target)
  (dbus.mplayer/send target "Previous"))

(exporting-definitions
 (defun tmg-mp-play-pause (target)
   (dbus.mplayer/play-pause target))

 (defun tmg-mp-next (target)
   (dbus.mplayer/next target))

 (defun tmg-mp-prev (target)
   (dbus.mplayer/previous target)))

(register-commands :meus-papiros/dbus)
