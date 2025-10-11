Keksi Kleiderschrank - Bodygroup Management System
https://img.shields.io/badge/Garry's%2520Mod-Add--on-blue
https://img.shields.io/badge/Version-1.0-green
https://img.shields.io/badge/License-Custom-yellow

📖 Über das Projekt
Keksi Kleiderschrank ist ein umfangreiches Bodygroup-Management-System für Garry's Mod, entwickelt von Imperator Keksi. Dieses Addon ermöglicht Spielern das einfache Speichern, Verwalten und Anwenden von Bodygroup-Kombinationen durch eine intuitive Benutzeroberfläche.

✨ Hauptfeatures
🎨 Vollständige Bodygroup-Kontrolle - Ändere alle Bodygroups deines Models

💾 Set-Management - Speichere und verwalte unbegrenzt viele Outfits

🖱️ Interaktive 3D-Vorschau - Sieh deine Änderungen in Echtzeit

🏪 Dresser-Entity - Physikalische Kleiderschrank-Entity für RP-Server

🎨 Anpassbares Design - Vollständig konfigurierbare Farben und Fonts

🔒 Sicherheitssystem - Geschützte Netzwerkkommunikation und Validierung

🚀 Installation
Hauptaddon-Ordner in garrysmod/addons/ kopieren

Server neustarten (wenn auf Server-Seite)

Fertig! - Das Addon ist einsatzbereit

🎮 Verwendung
👤 Als Spieler
Kleiderschrank öffnen:

Benutze die Konsole: keksi_kleiderschrank_open

Oder: wardrobe_open (Legacy Command)

Oder: Interagiere mit dem Dresser-Entity (E drücken)

Sets verwalten:

Bodygroups in der mittleren Spalte ändern

Sets in der rechten Spalte speichern und anwenden

3D-Vorschau in der linken Spalte betrachten

🛠️ Als Server-Besitzer
Dresser spawnen:

Entity-Menü → "Keksi Kleiderschrank"

In der Welt platzieren

Konfiguration anpassen:

Datei: lua/wardrobe/sh_config.lua

Farben, Limits, Berechtigungen anpassen

⚙️ Konfiguration
Die sh_config.lua ermöglicht umfangreiche Anpassungen:
-- Farbdesign anpassen
WardrobeConfig.Colors.primary = Color(120, 80, 255, 255)

-- Limits setzen
WardrobeConfig.Save.max_sets = 30

-- Berechtigungen konfigurieren
WardrobeConfig.Permissions.allow_all = true

🔧 Technische Details
📊 Netzwerk-System
Throttling: 0.1s zwischen Apply-Requests

Payload-Limit: 64KB pro Request

Validierung: Server-seitige Bodygroup-Validierung

💾 Datenspeicherung
Format: JSON in Dateisystem

Pfad: DATA/keksi_kleiderschrank/

Pro Spieler: Individuelle Set-Speicherung

🎨 UI-System
Vollbild: Responsive Fullscreen-Interface

3D-Vorschau: Interaktive Model-Darstellung

Drag & Drop: Kamera-Steuerung per Maus

👨‍💻 Entwickler-Information
📝 Über den Entwickler
Imperator Keksi

🔫 Social Media: guns.lol/imperatorkeksi

🎮 Discord: Keks Familie

🍪 Die Keks Familie Community
Willkommen in der Keks Familie - einer lebendigen Gaming-Community! Bei uns findest du:

🎮 Was bei uns abgeht:

Gaming-Sessions - Gemeinsam zocken und Spaß haben

Casino Nights - Spannende Casino-Abende

Star Wars RP - Intensive Rollenspiel-Erfahrungen

Stream-Ankündigungen - Verpasse keine Livestreams

Hilfe & Support - Bei Problemen helfen wir gerne

Community-Events - Regelmäßige Events und Aktivitäten

💫 Unsere Angebote:

Verschiedene Gaming-Bereiche für jeden Geschmack

Aktive Community mit netten Mitgliedern

Professionelle Organisation und Moderation

Regelmäßige Updates und Neuigkeiten

🎯 Für wen sind wir?

Für alle, die gerne in Gesellschaft zocken

Für Rollenspiel-Enthusiasten

Für Casino- und Spiele-Fans

Für alle, die eine nette Community suchen

Schau vorbei und mach dich selbst ein Bild! Wir freuen uns auf dich! ✨

📜 Lizenzbedingungen
✅ ERLAUBT:

Weiterentwicklung und Modifikation

Testing auf öffentlichen und privaten Servern

Private und öffentliche Nutzung

Einbindung in andere Projekte (mit Credit)

❌ NICHT ERLAUBT:

Kommerzieller Verkauf oder Vermarktung

Behauptung der eigenen Urheberschaft

Entfernen der Credits und Entwickler-Hinweise

Nutzung für betrügerische oder schädliche Zwecke

📝 Rechtlicher Hinweis:
Dieses Addon ist geistiges Eigentum von Imperator Keksi. Die vollständigen Lizenzbestimmungen können im Discord eingesehen werden. Bei Fragen zur kommerziellen Nutzung kontaktieren Sie bitte den Entwickler.

📞 Support
Discord: https://discord.gg/BTtC6b3XAY

Fragen: Im Discord-Channel stellen

Updates: Folge auf guns.lol für Neuigkeiten

Made with ❤️ by Imperator Keksi
"Bringing style to Garry's Mod, one outfit at a time!"