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

📁 Dateistruktur
text
garrysmod/addons/keksi_kleiderschrank/
├── lua/
│   ├── autorun/
│   │   ├── wardrobe_cl.lua      # Client-Seite UI & Networking
│   │   ├── wardrobe_sv.lua      # Server-Seite Logik & Persistenz
│   │   └── wardrobe_shared.lua  # Shared Konfiguration
│   ├── entities/
│   │   └── wardrobe_dresser/
│   │       ├── cl_init.lua      # Client Entity
│   │       ├── init.lua         # Server Entity  
│   │       └── shared.lua       # Shared Entity
│   └── wardrobe/
│       └── sh_config.lua        # Hauptkonfiguration
└── materials/
    └── entities/
        └── wardrobe_dresser.png # Entity Icon (optional)
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

lua
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

🍪 Die Keks Familie - Wo das Backen heiß hergeht! 🎉
Willkommen in der Keks Familie - der süßesten Community auf Discord! Bei uns ist immer Backtag:

🍪 Was bei uns abgeht:

🎮 Gaming-Sessions - Mit Keks-Pausen natürlich!

💻 Development-Help - Wir helfen beim Code-Backen

🏗️ Building-Tipps - Wie baue ich die perfekte Keksfabrik?

😂 Keks-Witze - "Warum ging der Keks zum Arzt? Er fühlte sich krümelig!"

🔥 Ofen-Witze - "Treffen sich zwei Backbleche. Sagt das eine: 'Du siehst aber heiß aus heute!'"

🎉 Unsere Spezialitäten:

Community-Events - Unser Backofen läuft rund um die Uhr!

Custom Content - Hier backen wir die besten Addons!

Hilfe & Support - Wenn mal was anbrennt, löschen wir gemeinsam!

👨‍🍳 Warum zur Keks Familie?
Weil bei uns jeder willkommen ist - ob Großbäcker oder Back-Anfänger! Wir teilen Rezepte, helfen bei Problemen und haben immer ein offenes Ohr. Also: Komm in die Keksdose, wir haben Plätzchen! 🍪

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

🐛 Bug Reports & Feature Requests
Bei Problemen oder Verbesserungsvorschlägen bitte auf Discord melden!

🤝 Beitragen
Du möchtest zum Projekt beitragen?
Willkommen in der Keks-Familie!
Tritt unserem Discord bei und werde Teil der Community.

📞 Support
Discord: https://discord.gg/BTtC6b3XAY - Komm in die Keksdose! 🍪

Fragen: Im Discord-Channel stellen - Wir helfen gerne!

Updates: Folge mir auf guns.lol für Neuigkeiten

Made with ❤️ by Imperator Keksi
"Bringing style to Garry's Mod, one outfit at a time!"