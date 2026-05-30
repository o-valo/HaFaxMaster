#NoTrayIcon
; Version: 2.0 - AutoIt Only - Die bewährte Logik vereint
$sourcePath = "C:\look-fax"
$numberFile = "C:\look-fax\current_number.txt"
$archivPath = "C:\look-fax\archiv\"

While 1
    ; 1. Wächter: Suche nach PDF
    $search = FileFindFirstFile($sourcePath & "\*.pdf")
    
    If $search <> -1 Then
        $fileName = FileFindNextFile($search)
        FileClose($search)
        
        ; Nur verarbeiten, wenn eine Datei gefunden wurde
        If Not @error Then
            ; Extrahiere Nummer wie in der PowerShell-Logik
            $faxNumber = StringSplit($fileName, "-")[1]
            FileWrite($numberFile, $faxNumber)
            
            ; Datei öffnen
            ShellExecute($sourcePath & "\" & $fileName)
            
            ; 2. Warten, bis Firefox die PDF anzeigt
            WinWaitActive("[CLASS:MozillaWindowClass]", "", 10)
            
            ; 3. Druck-Dialog öffnen
            Send("^p")
            Sleep(2000) 
            Send("{ENTER}")
            Sleep(4000) 
            
            ; 4. AVM-Fenster bedienen (Die bewährte Logik)
            If WinWaitActive("FRITZ!fax", "", 10) Then
                ; Aktivierungs-Dialog abfangen
                If WinWait("FriSnd32", "", 2) Then
                    WinActivate("FriSnd32")
                    Sleep(500)
                    ControlClick("FriSnd32", "", "[CLASS:Button; INSTANCE:1]")
                    Sleep(2000)
                EndIf
                
                ; Nummer eintragen
                ControlSetText("FRITZ!fax", "", "[CLASS:ComboBox; INSTANCE:1]", $faxNumber)
                Sleep(500)
                
                ; OK-Button drücken
                ControlClick("FRITZ!fax", "", "[CLASS:Button; INSTANCE:7]")
                
                ; 5. Warten & Archivieren
                Sleep(3000)
                FileMove($sourcePath & "\" & $fileName, $archivPath & $fileName, 9)
                
                ; 6. Cleanup
                FileDelete($numberFile)
                WinClose("[CLASS:MozillaWindowClass]")
            EndIf
        EndIf
    EndIf
    
    Sleep(2000) ; Kurze Pause zwischen den Suchläufen
WEnd
#EOF
