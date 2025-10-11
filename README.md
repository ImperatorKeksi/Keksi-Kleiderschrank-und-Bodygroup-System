# 🍪 Keksi Kleiderschrank — Bodygroup Management System for Garry's Mod

![Garry's Mod](https://img.shields.io/badge/Garry's%20Mod-Add--on-blue)
![Version](https://img.shields.io/badge/Version-1.0-green)
![License](https://img.shields.io/badge/License-Custom-yellow)

**Keksi Kleiderschrank** ist ein umfangreiches Bodygroup-Management-System für Garry's Mod, entwickelt von **Imperator Keksi**.  
Dieses Addon ermöglicht Spielern das einfache Speichern, Verwalten und Anwenden von Bodygroup-Kombinationen durch eine intuitive Benutzeroberfläche.


## ✨ Hauptfeatures

- 🎨 **Vollständige Bodygroup-Kontrolle** – Ändere alle Bodygroups deines Models  
- 💾 **Set-Management** – Speichere und verwalte unbegrenzt viele Outfits  
- 🖱️ **Interaktive 3D-Vorschau** – Sieh deine Änderungen in Echtzeit  
- 🏪 **Dresser-Entity** – Physikalische Kleiderschrank-Entity für RP-Server  
- 🎨 **Anpassbares Design** – Vollständig konfigurierbare Farben und Fonts  
- 🔒 **Sicherheitssystem** – Geschützte Netzwerkkommunikation und Validierung  


## 🚀 Installation

1. **Hauptaddon-Ordner** in `garrysmod/addons/` kopieren  
2. **Server neustarten** (falls auf Server-Seite)  
3. **Fertig!** – Das Addon ist einsatzbereit  



## 🎮 Verwendung

### 👤 Als Spieler

**Kleiderschrank öffnen:**
- Konsole: `keksi_kleiderschrank_open`  
- Legacy Command: `wardrobe_open`  
- Oder: **Interagiere mit dem Dresser-Entity** (Taste **E**)  

**Sets verwalten:**
- Bodygroups in der mittleren Spalte ändern  
- Sets in der rechten Spalte speichern und anwenden  
- 3D-Vorschau in der linken Spalte betrachten  


### 🛠️ Als Server-Besitzer

**Dresser spawnen:**
- Entity-Menü → *Keksi Kleiderschrank*  
- In der Welt platzieren  

**Konfiguration anpassen:**
- Datei: `lua/wardrobe/sh_config.lua`  
- Farben, Limits, Berechtigungen anpassen  


## ⚙️ Konfiguration

Die `sh_config.lua` ermöglicht umfangreiche Anpassungen:

```lua
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

Format: JSON im Dateisystem

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

Willkommen in der Keks Familie – einer lebendigen Gaming-Community!

🎮 Was bei uns abgeht:

Gaming-Sessions & gemeinsame Spiele

Casino Nights & Community-Events

Star Wars RP & andere RP-Formate

Stream-Ankündigungen & Support

💫 Unsere Angebote:

Verschiedene Gaming-Bereiche

Aktive & freundliche Community

Professionelle Organisation

Regelmäßige Updates & Events

🎯 Für wen sind wir?

Für alle, die gerne zocken

Für RP- & Casino-Fans

Für alle, die eine coole Community suchen

➡️ Schau vorbei: Discord beitreten

📜 Lizenzbedingungen

✅ ERLAUBT:

Weiterentwicklung & Modifikation

Testing auf öffentlichen & privaten Servern

Private & öffentliche Nutzung

Integration in andere Projekte (mit Credit)

❌ NICHT ERLAUBT:

Kommerzieller Verkauf oder Vermarktung

Entfernen von Credits & Entwickler-Hinweisen

Falsche Urheberangabe

Nutzung für schädliche Zwecke

📝 Rechtlicher Hinweis:
Dieses Addon ist geistiges Eigentum von Imperator Keksi.
Die vollständigen Lizenzbestimmungen sind im Discord einsehbar.
Für kommerzielle Nutzung bitte Kontakt aufnehmen.

📞 Support

💬 Discord: https://discord.gg/BTtC6b3XAY

❓ Fragen: Im Support-Channel stellen

📰 Updates: Folge auf guns.lol

Made with ❤️ by Imperator Keksi
"Bringing style to Garry's Mod, one outfit at a time!"