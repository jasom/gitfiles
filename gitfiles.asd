;;;; gitfiles.asd

(asdf:defsystem #:gitfiles
  :serial t
  :description "Describe gitfiles here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:uiop
               #:split-sequence
	       #:asdf)
  :components ((:file "package")
               (:file "gitfiles")))

