#!/bin/bash
# Skript: send-fax.sh
# Version: 1.0.0
# Zweck: Prüft, ob die SMB-Freigabe gemountet ist, mountet bei Bedarf und kopiert eine PDF-Datei.

# Konfiguration
# Beispiel für Pfad: /run/user/$(id -u)/gvfs/smb-share:server=<IP>,share=<SHARENAME>,user=<USER>
TARGET_DIR="" 
MOUNT_COMMAND="gio mount smb://<USER>@<IP>/<SHARENAME>"

# 1. Prüfen, ob eine Datei übergeben wurde
if [ -z "$1" ]; then
    echo "Fehler: Bitte gib eine Quelldatei als Argument an."
    exit 1
fi

# 2. Logik: Prüfen und mounten
if [ ! -d "$TARGET_DIR" ]; then
    echo "Freigabe nicht aktiv. Versuche Verbindung..."
    $MOUNT_COMMAND
    
    # Wartezeit für den Mount-Prozess
    sleep 3
    
    # Erneute Prüfung
    if [ ! -d "$TARGET_DIR" ]; then
        echo "Fehler: Verbindung konnte nicht hergestellt werden."
        exit 1
    else
        echo "Verbindung erfolgreich hergestellt."
    fi
else
    echo "Freigabe ist bereits aktiv."
fi

# 3. Datei kopieren
cp "$1" "$TARGET_DIR/"

if [ $? -eq 0 ]; then
    echo "Erfolg: '$1' wurde übertragen."
else
    echo "Fehler: Übertragung fehlgeschlagen."
    exit 1
fi

#EOF
