;; all this was taken and adapted from online somewhere..

(defvar rna-base-complement-list
  '((?- . ?-) (?n . ?n) (?* . ?*) (?x . ?x) (?: . ?:) ; identity
    (?a . ?u) (?c . ?g) (?g . ?c) (?u . ?a) ; single
    (?m . ?k) (?r . ?y) (?w . ?w) (?s . ?s) (?y . ?r) (?k . ?m) ; double
    (?v . ?b) (?h . ?d) (?d . ?h) (?b . ?v) ; triple
    )
  "*List of bases and their complements.
Bases should be lowercase, as they are upcased when the `vector is made.")

(defvar dna-base-complement-list
  '((?- . ?-) (?n . ?n) (?* . ?*) (?x . ?x) (?: . ?:) ; identity
    (?a . ?t) (?c . ?g) (?g . ?c) (?t . ?a) ; single
    (?m . ?k) (?r . ?y) (?w . ?w) (?s . ?s) (?y . ?r) (?k . ?m) ; double
    (?v . ?b) (?h . ?d) (?d . ?h) (?b . ?v) ; triple
    )
  "*List of bases and their complements.
Bases should be lowercase, as they are upcased when the `vector is made.")

(defvar dna-base-complement-vector
  (let ((c-vec (make-vector 256 nil))
	      (c-list dna-base-complement-list))
    (while c-list
      (aset c-vec (car (car c-list)) (cdr (car c-list)))
      (aset c-vec (upcase (car (car c-list))) (upcase (cdr (car c-list))))
      (setq c-list (cdr c-list)))
    c-vec)
  "A vector of upper and lower case bases and their complements.")

(defvar rna-base-complement-vector
  (let ((c-vec (make-vector 256 nil))
	      (c-list rna-base-complement-list))
    (while c-list
      (aset c-vec (car (car c-list)) (cdr (car c-list)))
      (aset c-vec (upcase (car (car c-list))) (upcase (cdr (car c-list))))
      (setq c-list (cdr c-list)))
    c-vec)
  "A vector of upper and lower case bases and their complements.")

(defun complement-base (base complement-vector)
  "Complement a BASE using a vector based method.
See `dna-complement-base-list' for more info."
  (aref complement-vector base))

;;; reverse and complement
(defun dna-complement-base-list (base)
  "Complement the BASE using a list based method.
Returns the complement of the base.
It can also be used to test if the character is a base,
as all bases should have a complement."
  (cdr (assq base dna-base-complement-list)))

;;;###autoload
(defun dna-reverse-complement-region (r-start r-end)
  "Reverse complement a region of dna from R-START to R-END.
Works by deleting the region and inserting bases reversed
and complemented, while entering non-bases in the order
found."
  (interactive "r")
  (let (r-string r-length r-base r-cbase r-point r-mark r-complement-vector)
    (goto-char r-start)
    (setq r-string (buffer-substring-no-properties r-start r-end))
    (setq r-length (length r-string))
    (setq r-mark (1- r-length))
    (setq r-point 0)
    (setq r-complement-vector (if (string-match-p "u" (downcase r-string)) rna-base-complement-vector dna-base-complement-vector))
    (if (and (string-match-p "u" (downcase r-string)) (string-match-p "t" (downcase r-string)))
      (error "Sequence contains T AND U. I do nothing until you are sure if it's RNA or DNA.")
      )
    ;; goodbye
    (delete-region r-start r-end)

    ;; insert the bases from back to front base by base
    ;; insert non-bases from front to back to preserve spacing
    (while (< r-point r-length)
      (setq r-base (aref r-string r-point))
      (setq r-cbase (complement-base r-base r-complement-vector))
      (if r-cbase
        (progn
          ;; it is a base. find the reverse and complement it
          (while (not (complement-base (aref r-string r-mark) r-complement-vector))
            (setq r-mark (1- r-mark)))
          (insert (complement-base (aref r-string r-mark) r-complement-vector))
          (setq r-mark (1- r-mark)) )
        ;; not a base, no change
        (insert r-base))
      (setq r-point (1+ r-point)))))
