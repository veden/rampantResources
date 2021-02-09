
(require file/zip)
(require json)

(define modFolder "/mnt/gallery/gameFiles/factorio/mods/")
(define zipModFolder "/data/games/factorio/mods/")
(define configuration (call-with-input-file "info.json"
                        (lambda (port)
                          (string->jsexpr (port->string port)))))
(define packageName (string-append (string-replace (hash-ref configuration 'name) " " "_")
                                   "_"
                                   (hash-ref configuration 'version)))

(define (makeZip folder)
  (let ((packagePath (string->path (string-append folder
                                                  packageName
                                                  ".zip"))))
    (delete-directory/files (string->path (string-append folder
                                                         packageName)))
    (when (file-exists? packagePath)
      (delete-file packagePath)))
  (zip (string-append folder
                      packageName
                      ".zip")
       #:path-prefix packageName
       (string->path "info.json")
       (string->path "control.lua")
       ;; (string->path "data.lua")
       (string->path "thumbnail.png")
       ;; (string->path "data-updates.lua")
       (string->path "data-final-fixes.lua")
       (string->path "changelog.txt")
       (string->path "LICENSE.md")
       (string->path "settings.lua")
       (string->path "README.md")
       (string->path "NOTICE")
       ;; (string->path "libs")
       ;; (string->path "migrations")
       (string->path "locale")
       ;; (string->path "graphics")
       ;; (string->path "prototypes")
       ))

(define (copyFile fileName modFolder)
  (copy-file (string->path fileName)
             (string->path (string-append modFolder
                                          packageName
                                          "/"
                                          fileName))))

(define (copyDirectory directoryName modFolder)
  (copy-directory/files (string->path directoryName)
                        (string->path (string-append modFolder
                                                     packageName
                                                     "/"
                                                     directoryName))))

(define (copyFiles modFolder)
  (let ((packagePath (string->path (string-append modFolder
                                                  packageName))))
    (when (directory-exists? packagePath)
      (delete-directory/files packagePath))
    (sleep 0.1)
    (make-directory packagePath)
    (copyFile "control.lua" modFolder)
    (copyFile "info.json" modFolder)
    ;; (copyFile "data.lua" modFolder)
    (copyFile "data-final-fixes.lua" modFolder)
    ;; (copyFile "data-updates.lua" modFolder)
    (copyFile "LICENSE.md" modFolder)
    (copyFile "thumbnail.png" modFolder)
    (copyFile "changelog.txt" modFolder)
    (copyFile "settings.lua" modFolder)
    (copyFile "NOTICE" modFolder)
    ;; (copyDirectory "libs" modFolder)
    ;; (copyDirectory "migrations" modFolder)
    (copyDirectory "locale" modFolder)
    ;; (copyDirectory "graphics" modFolder)
    ;; (copyDirectory "prototypes" modFolder)
    ))


(define (copy)
  (set! configuration (call-with-input-file "info.json"
                        (lambda (port)
                          (string->jsexpr (port->string port)))))
  (set! packageName (string-append (string-replace (hash-ref configuration 'name) " " "_")
                                   "_"
                                   (hash-ref configuration 'version)))
  (print (string-append "copying " (hash-ref configuration 'name) (hash-ref configuration 'version)))
  (copyFiles modFolder))

(define (zipIt)
  (set! configuration (call-with-input-file "info.json"
                        (lambda (port)
                          (string->jsexpr (port->string port)))))
  (set! packageName (string-append (string-replace (hash-ref configuration 'name) " " "_")
                                   "_"
                                   (hash-ref configuration 'version)))
  (print (string-append "zipping " (hash-ref configuration 'name) (hash-ref configuration 'version)))
  (makeZip modFolder))

(define (runStart)
  ;; (copyFiles modFolder)
  ;;(copyFiles zipModFolder)
  (makeZip modFolder)
  (system*/exit-code "factorio"))
