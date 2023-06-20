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

(defun tts-upload-global (conn path)
  (tts-send-obj
   conn
   `((messageID . 1)
     (scriptStates
      .
      [
       ((name . "Global")
        (guid . "-1")
        (script . ,(tts-file-to-string path)))
       ]))))

(defun tts-do-upload ()
  (interactive)
  (tts-upload-global (tts-connect) "global.lua"))

;;
(provide 'tts)
