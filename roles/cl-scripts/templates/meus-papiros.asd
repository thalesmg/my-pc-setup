#-asdf3.1 (error "ASDF 3.1 or bust!")

(defsystem "meus-papiros"
  :version "0.0.1"
  :description "Scripts em Common Lisp"
  :license "GPL3"
  :author "Thales Macedo Garitezi"
  :class :package-inferred-system
  :depends-on ((:version "cl-scripting" "0.1")
               (:version "inferior-shell" "2.0.3.3")
               (:version "fare-utils" "1.0.0.5")
               (:version "uuid" "2012.12.26")
               (:version "cl-ppcre" "2.0.11")
{{ papiros | map('regex_replace', '^(.+)$', '"meus-papiros/\\1"') | join('\n') | indent(width=15, indentfirst=True) }}))
