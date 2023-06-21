(defvar tts-guid "")

(defun tts-connect ()
  (open-network-stream "tcp-connection" nil "localhost" 39999))

(defun tts-file-to-string (path)
  (with-temp-buffer
    (insert-file-contents path)
    (buffer-string)))

(defun tts-send-obj (conn obj)
  (process-send-string conn (json-encode obj))
  (process-send-eof conn)
  (while (process-live-p conn)
    (accept-process-output conn)))

(defun tts-upload-scripts (conn path)
  (tts-send-obj
   conn
   `((messageID . 1)
     (scriptStates
      .
      [
       ((name . "OPR-TTS-FTW")
        (guid . ,tts-guid)
        (script . ,(tts-file-to-string path)))
       ]))))

(defun tts-set-guid (guid)
  (interactive "sGUID: ")
  (setq tts-guid guid))

(defun tts-do-upload ()
  (interactive)
  (tts-upload-scripts (tts-connect) "core.lua"))

;;
(provide 'tts)
