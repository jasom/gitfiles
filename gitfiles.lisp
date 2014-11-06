(in-package :gitfiles)

(defun build-obj-ht ()
    (let ((objlist (uiop:run-program '("git" "rev-list" "--all" "--objects") :output :string))
	  (ht (make-hash-table :test #'equal)))
      (with-input-from-string (v objlist)
	(loop for line = (read-line v nil nil)
	   while line
	   when (> (length line) 41)
	   do (setf (gethash (subseq line 0 40) ht)
		    (subseq line 41))))
      ht))

(defun find-objs ()
  (let* ((packfiles
	  (split-sequence:split-sequence #\Newline
					 (uiop:run-program '("find" ".git/objects/pack" "-iname" "pack-*.idx") :output :string)
					 :remove-empty-subseqs t))
	 (objects (uiop:run-program `("git" "verify-pack" "-v" ,@packfiles) :output :string)))
    (with-input-from-string (v objects)
      (loop for line = (read-line v nil nil)
	 while line
	 when (> (length line) 45)
	 when (let ((line
		     (split-sequence:split-sequence-if
		      (lambda (x) (member x '(#\Space #\Tab)))
		      line
		      :remove-empty-subseqs t)))
		(when (equal (second line) "blob")
		  (list (first line) (parse-integer (third line)) (parse-integer (fourth line)))))
	 collect it))))

(defun show-files ()
  (let ((oht (build-obj-ht))
	(obj (find-objs)))
    (setf obj (sort obj #'< :key #'third))
    (loop for item in obj
       do (print (list
		  (third item)
		  (second item)
		  (gethash (first item) oht))))))

(defun main (&rest r)
  (declare (ignore r))
  (uiop/image:setup-command-line-arguments)
  ;;(print uiop:*command-line-arguments*)
  ;;(print (uiop:raw-command-line-arguments))
  ;;(terpri)
  (uiop:chdir (second (uiop:raw-command-line-arguments)))
  (show-files))

(defun make (&optional (output-path (asdf:system-relative-pathname :gitfiles "gitfiles")))
  #+sbcl(sb-ext:save-lisp-and-die output-path
				  :toplevel #'main :executable t
				  :save-runtime-options t)
  #+ccl(ccl:save-application output-path
			     :toplevel-function #'main
			     :prepend-kernel t)
  #+ecl(let ((pn
	      (asdf:make-build :gitfiles :type :program :epilogue-code '(main))))
	 (uiop:rename-file-overwriting-target (car pn) output-path)
	 (ext:quit))
  )
