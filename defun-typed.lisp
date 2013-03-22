;;;; defun-typed.lisp
;; (c) 2013 Matt Novenstern <fisxoj@gmail.com>

(in-package #:defun-typed)

(defmacro defun-typed ((name return-type &optional inline &rest optimization-list) lambda-list &body body)
  "Automatically creates type declarations for the function and it's arguments.

name: function's name

return-type: return type of the function

inline: generalized boolean, if nil, function is not declaimed inline.  If true, function will be declared inline.

optimization-list: optimization keywords, eg. speed, (safety 2), etc. These should not be enclosed in a list.

lambda-list: a list of the parameters in (name type) form, eg. ((n fixnum) (a double-float))"
  (let ((parameter-types
	 (loop for (nil type) in lambda-list collect type))
	(parameter-names
	 (loop for (name nil) in lambda-list collect name)))
    `(progn
       (declaim (ftype (function ,parameter-types ,return-type) ,name)
		,(when inline `(inline ,name)))
       (defun ,name ,parameter-names
	 (declare
		
		,@(loop for parameter in lambda-list
		     when (= (length parameter) 2)
		     ;; Providing a type isn't necessary, so don't do anything
		     ;; special if a type isn't provided
		     collect (list 'type
				   (second parameter)
				   (if (consp (first parameter))
				       ;; If first value is a cons, then the
				       ;; first value of that cons is the name
				       ;; and the second is the default value
				       (first (first parameter))
				       (first parameter)))
		     into declarations
		     finally (prog2 (when optimization-list
				      (push (append '(optimize) optimization-list) declarations))
				 (return declarations))))
	 ,@body))))
