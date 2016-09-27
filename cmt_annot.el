(require 'caml)
(require 'caml-types)

(defvar caml-types-cmt-annot-path (executable-find "cmt_annot")
  "path to the cmt_annot tool")

(defun caml-types-get-cmt-annot-path ()
  caml-types-cmt-annot-path)

(defun caml-types-run-cmt-annot (kind filename line1 col1 line2 col2)
  (let* ((s (format "%s -%s %s %d %d" (caml-types-get-cmt-annot-path) kind filename line1 col1 line2 col2))
         ;; (_ (message "cmt_annot invocation: %s" s))
         (out (car (read-from-string (shell-command-to-string s)))))
         ;; (_ (message "cmt_annot result:\n%s" out)))
    out))

(defun caml-types-pos-of-line-column (line col)
  (save-excursion
    (goto-char (point-min))
    (forward-line (1- line))
    (move-to-column col)
    (point)))

(defun caml-types-show-type-cmt (arg)
  (interactive "p")
  (let* ((target-buf (current-buffer))
         (target-buf-name (buffer-file-name))
         (target-file (concat (file-name-directory target-buf-name) (concat (file-name-base target-buf-name) ".cmt")))
         (target-line (count-lines (point-min) (point)))
         (target-col (current-column)))
    ;; (message "%d %d" target-line target-col)
    (setq caml-types-buffer (get-buffer-create caml-types-buffer-name))
    (let* ((res (caml-types-run-cmt-annot "type" target-file target-line target-col target-line target-col))
          (_ (prin1 res)))
      (if res
          (pcase res
            (`(,l1 ,c1 ,l2 ,c2 ,type)
             ;; (message "%d %d %d %d %s" result-line1 result-col1 result-line2 result-col2 type)
             (let ((left (caml-types-pos-of-line-column l1 c1))
                   (right (caml-types-pos-of-line-column l2 c2)))
               (move-overlay caml-types-expr-ovl left right target-buf)
               (with-current-buffer caml-types-buffer
                 (erase-buffer)
                 (insert type)
                 (message (format "type: %s" type))))))
        (progn
          (delete-overlay caml-types-expr-ovl)
          (message "Point is not within a typechecked expression or pattern"))))
    (if (and (= arg 4)
             (not (window-live-p (get-buffer-window caml-types-buffer))))
        (display-buffer caml-types-buffer))
    (unwind-protect
        (caml-sit-for 60)
      (delete-overlay caml-types-expr-ovl))))

(defun caml-types-show-ident-cmt (arg)
  (interactive "p")
  (let* ((target-buf (current-buffer))
         (target-buf-name (buffer-file-name))
         (target-file (concat (file-name-directory target-buf-name) (concat (file-name-base target-buf-name) ".cmt")))
         (target-line (count-lines (point-min) (point)))
         (target-col (current-column)))
    ;; (message "%d %d" target-line target-col)
    (setq caml-types-buffer (get-buffer-create caml-types-buffer-name))
    (let ((res (caml-types-run-cmt-annot "ident" target-file target-line target-col target-line target-col)))
      ;; (print res)
      (if res
          (pcase res
            (`(,l1 ,c1 ,l2 ,c2 ,var-name . ,kind)
             ;; (message "%s %i %i %i %i" kind result-line1 result-col1 result-line2 result-col2)
             (let ((left (caml-types-pos-of-line-column l1 c1))
                   (right (caml-types-pos-of-line-column l2 c2)))
               (move-overlay caml-types-expr-ovl left right target-buf)
               (pcase kind
                 (`(external) (message "external ident: %s" var-name))
                 (`(internal ,l1 ,c1 ,l2 ,c2)
                  (let ((left (caml-types-pos-of-line-column l1 c1))
                        (right (caml-types-pos-of-line-column l2 c2)))
                    (move-overlay caml-types-def-ovl left right target-buf)
                    (message "%s is bound at line %d char %d" var-name l1 c1)))
                 (`(local-variable ,l1 ,c1 ,l2 ,c2)
                  (let ((left (caml-types-pos-of-line-column l1 c1))
                        (right (caml-types-pos-of-line-column l2 c2)))
                    (message "local variable %s is bound here" var-name)
                    (move-overlay caml-types-scope-ovl left right target-buf)))
                 (`(global-variable ,l1 ,c1 ,_ ,_)
                  (let ((left (caml-types-pos-of-line-column l1 c1))
                        (right (buffer-size target-buf)))
                    (message "global variable %s is bound here" var-name)
                    (move-overlay caml-types-scope-ovl left right target-buf)))))))
        (progn
          (delete-overlay caml-types-expr-ovl)
          (message "Point is not within an identifier.")))
      (if (and (= arg 4)
               (not (window-live-p (get-buffer-window caml-types-buffer))))
          (display-buffer caml-types-buffer))
      (unwind-protect
          (caml-sit-for 60)
        (delete-overlay caml-types-expr-ovl)
        (delete-overlay caml-types-def-ovl)
        (delete-overlay caml-types-scope-ovl)))))

(define-key caml-mode-map [?\C-c?\C-t] 'caml-types-show-type-cmt)  ; "type"
(define-key caml-mode-map [?\C-c?\C-l] 'caml-types-show-ident-cmt) ; "let"

(provide 'cmt_annot)
