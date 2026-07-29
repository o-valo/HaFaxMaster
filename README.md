HaFaxMaster

HaFaxMaster ist eine Automatisierungslösung, die den Faxversand von einem Linux-System an ein Windows-basiertes Fax-System via AutoIt (HaFaxMaster.au3) ermöglicht.

Die Lösung verbindet die Linux-Umgebung nahtlos mit einem Windows-Faxserver, indem SMB-Freigaben dynamisch geprüft und gemountet werden, während das AutoIt-Skript auf der Windows-Seite den eingehenden Watchfolder überwacht und abarbeitet.
1. Voraussetzungen & Windows-Einrichtung (Fax-Server)

Damit der automatisierte Dateitransfer von Linux auf den Windows-Server reibungslos funktioniert, sind auf der Windows-Seite folgende Schritte zwingend erforderlich:

    Fax-Dienst: Auf dem Windows-System muss ein funktionierendes Fax-System eingerichtet sein (z. B. Windows Fax-Dienst mit Modem oder eine kompatible Fax-Software).

    AutoIt: Installieren Sie AutoIt v3 auf dem Windows-System.

    Watchfolder & Freigabe einrichten:

        Erstellen Sie das Zielverzeichnis (z. B. C:\HaFaxInbox), das von HaFaxMaster.au3 überwacht wird.

        Machen Sie einen Rechtsklick auf den Ordner -> Eigenschaften -> Reiter Freigabe -> Erweiterte Freigabe...

        Aktivieren Sie Diesen Ordner freigeben und vergeben Sie einen Namen (z. B. FaxInbox).

        Klicken Sie auf Berechtigungen und gewähren Sie dem zugreifenden Benutzer (oder der entsprechenden Gruppe) Ändern- und Vollzugriff.

        Wechseln Sie in den Eigenschaften zum Reiter Sicherheit (NTFS-Berechtigungen) und stellen Sie sicher, dass der Netzwerkbenutzer auch hier Schreibrechte besitzt.

    Firewall: Stellen Sie sicher, dass die Windows-Firewall den SMB-Datenverkehr (Port 445) im lokalen Netzwerk bzw. VPN erlaubt.

    AutoIt-Skript konfigurieren: Öffnen Sie HaFaxMaster.au3, passen Sie den Pfad zum Überwachungsordner an und starten bzw. kompilieren Sie das Skript auf dem Windows-System.

2. Einrichtung & Verwendung auf der Linux-Seite

Auf der Linux-Seite wird das mitgelieferte Bash-Skript verwendet, um vor dem Kopiervorgang automatisch zu prüfen, ob die SMB-Freigabe gemountet ist, den Mount bei Bedarf via gio aufzubauen und das PDF sicher zu übertragen.
Konfiguration des Skripts

Öffnen Sie das Skript und passen Sie die Konfigurationsvariablen an:

    TARGET_DIR: Der lokale GVFS-Mountpfad unter Linux (z. B. /run/user/$(id -u)/gvfs/smb-share:server=<IP>,share=<FREIGABE>,user=<USER>).

    MOUNT_COMMAND: Der Befehl zum Verbinden der Freigabe (z. B. gio mount smb://<USER>@<IP>/<SHARENAME>).

Verwendung

    Machen Sie das Skript auf der Kommandozeile ausführbar:
    Bash

    chmod +x send-fax.sh

    Übergeben Sie die zu versendende PDF-Datei als Argument:
    Bash

    ./send-fax.sh /pfad/zu/dokument.pdf

Powerd with AI !
Lizenz

MIT License

