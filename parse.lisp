(in-package :cl-kanren)

(defparameter exfb '(
                     (ATOM NODE 6) 
                     (PROPERTY-ORIGIN 6 (72 12)) 
                     (RELATION-IS-INITIAL-FOR-LINE 6 5) 
                     (RELATION-NEXT-ITEM 6 7) 
                     
                     (ATOM NODE 7) 
                     (PROPERTY-ORIGIN 7 (156 12)) 
                     (RELATION-IS-FINAL-FOR-LINE 7 5) 
                     
                     (ATOM POLYLINE 5) 
                     
                     (ATOM SHEET 0) 
                     (PROPERTY-MODE 0 (BASE)) 
                     )
)

;; helper for readability
;; Does the slot already exist in the hash table?
(defun hash-entry-already-exists (rel htable)
  (multiple-value-bind (v success) (gethash rel htable)
    (declare (ignore v))
    success))      
             
;; helper for readability
;; add a new hash table entry by pushing it onto the already-existing (list) slot in the hash table
(defun push-hash (new-relation htable)
  (setf (gethash (first new-relation) htable)
        (cons new-relation (gethash (first new-relation) htable))))

;; helper for readability
;; create a new hash table slot and fill it with the (list of the) relation
(defun create-new-hash-slot (rel htable)
  (setf (gethash (first rel) htable)
        (list rel)))

;; helper for readability
;; create a new hashtable, all slots empty
(defun new-hash-table ()
  (make-hash-table :test 'eq))

;; optimize the factbase (fb) by creating a hash table base on the relationships, 
;; e..g all 'atom facts are congregated into a single list indexed by the 'atom hash table slot, 
;; it is possible to optimize even further by creating more hash tables based on the OBJECT's in the relationships
(defun optimize-fb (fb)
  (let ((result-hash (new-hash-table)))
    (mapcar #'(lambda (rel)
               (if (hash-entry-already-exists (first rel) result-hash)
                   (push-hash rel result-hash)
                 (create-new-hash-slot rel result-hash)))
            fb)
  result-hash))

                                                  
(defun find-lines (hashed-fb)
  (let ((result-list nil))
    (maphash #'(lambda (key rel)
                 (when (eq 'atom key)
                   (mapcar #'(lambda (atom-rel)
                               (when (eq 'polyline (second atom-rel))
                                 (push (third atom-rel) result-list)))
                           rel)))
             hashed-fb)
    result-list))
  

(defun main ()
  (find-lines (optimize-fb exfb)))
