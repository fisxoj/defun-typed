# defun-typed

Defun-typed comes with a single macro whch is only useful for generating functions with type information automatically added.

```lisp

(defun-typed (fib fixnum t speed (safety 0))
    ((n fixnum))
  (if (< n 2)
      1
      (+ (fib (- n 1)) (fib (- n 2)))))
```

This expands to

```lisp
(PROGN
 (DECLAIM (FTYPE (FUNCTION (FIXNUM) FIXNUM) FIB)
          (INLINE FIB))
 (DEFUN FIB (N)
   (DECLARE (OPTIMIZE SPEED (SAFETY 0))
            (TYPE FIXNUM N))
   (IF (< N 2)
       1
       (+ (FIB (- N 1)) (FIB (- N 2))))))
```
.

This is primarily useful for performance-critical code, like numerical simulations, where giving your lisp the greatest possible type information is desirable.  The lambda-list of defun-typed is as follows:

```lisp
((name return-type &optional inline &rest optimization-list) lambda-list &body body)
```
name: function's name

return-type: return type of the function

inline: generalized boolean, if nil, function is not declaimed inline.  If true, function will be declared inline.

optimization-list: optimization keywords, eg. speed, (safety 2), etc. These should not be enclosed in a list.

lambda-list: a list of the parameters in (name type) form, eg. ((n fixnum) (a double-float))