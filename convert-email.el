;;;; convert-email.el -- go through my web tree, and convert mailtos into a reference to a contact details page
;;; Time-stamp: <2005-01-18 19:04:55 jcgs>

;;  This program is free software; you can redistribute it and/or modify it
;;  under the terms of the GNU General Public License as published by the
;;  Free Software Foundation; either version 2 of the License, or (at your
;;  option) any later version.

;;  This program is distributed in the hope that it will be useful, but
;;  WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;  General Public License for more details.

;;  You should have received a copy of the GNU General Public License along
;;  with this program; if not, write to the Free Software Foundation, Inc.,
;;  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

;;;###autoload
(defun convert-email-file (file replacement)
  "In FILE convert all mailtos to a REPLACEMENT contact details file."
  (interactive "fConvert addresses in file: 
sNew address file: ")
  (if nil
      (message "File %s replacement %s" file replacement)
    (let* ((already (get-file-buffer file))
	   (contact-tag (format "<a href=\"%s\">Contact me</a>" replacement))
	   )
      (find-file file)
      (save-excursion
	(goto-char (point-min))
	(while (re-search-forward "<a href=\"mailto:[^\"]+\">[^<]+</a>" (point-max) t)
	  (replace-match contact-tag)))
      (let ((write-file-hooks nil)
	    (local-write-file-hooks nil))
	(basic-save-buffer))
      (if (not already) (kill-buffer nil)))))
    
;;;###autoload
(defun convert-email-directory (dir &optional replacement)
  "In DIR convert contact details."
  (interactive "DDirectory: ")
  (or replacement (setq replacement "contact.html"))
  (let ((files (directory-files dir t nil t))
	(next-replacement (concat "../" replacement)))
    (while files
      (let ((file (car files)))
	(cond
	 ((string-match "\\.html$" file)
	  (convert-email-file file replacement))
	 ((and (file-directory-p file)
	       (not (string-match "\\.$" file)))
	  (convert-email-directory file next-replacement))
	 (t nil)))
      (setq files (cdr files)))))

;;; end of convert-email.el
