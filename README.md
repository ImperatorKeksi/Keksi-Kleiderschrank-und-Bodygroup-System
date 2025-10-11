Hier ist die **komplette** `README.md`-Datei — du kannst den gesamten Inhalt direkt in eine `README.md` kopieren und ins Repo pushen:

## 🍪 Keksi Kleiderschrank — Bodygroup Management System for Garry's Mod

![Garry's Mod](https://img.shields.io/badge/Garry's%20Mod-Add--on-blue)
![Version](https://img.shields.io/badge/Version-1.0-green)
![License](https://img.shields.io/badge/License-Custom-yellow)

**Keksi Kleiderschrank** ist ein umfangreiches Bodygroup-Management-System für Garry's Mod, entwickelt von **Imperator Keksi**.  
Dieses Addon ermöglicht Spielern das einfache Speichern, Verwalten und Anwenden von Bodygroup-Kombinationen durch eine intuitive Benutzeroberfläche.

---

## 📖 Inhaltsverzeichnis

- [Über das Projekt](#-über-das-projekt)
- [Hauptfeatures](#-hauptfeatures)
- [Installation](#-installation)
- [Dateistruktur](#-dateistruktur)
- [Verwendung](#-verwendung)
  - [Als Spieler](#-als-spieler)
  - [Als Server-Besitzer](#-als-server-besitzer)
- [Konfiguration](#-konfiguration)
- [Technische Details](#-technische-details)
  - [Netzwerk-System](#-netzwerk-system)
  - [Datenspeicherung](#-datenspeicherung)
  - [UI-System](#-ui-system)
- [Entwickler-Information](#-entwickler-information)
- [Die Keks Familie Community](#-die-keks-familie-community)
- [Lizenzbedingungen](#-lizenzbedingungen)
- [Support](#-support)
- [Changelog](#-changelog)
- [Credits](#-credits)

---

## 📖 Über das Projekt

**Keksi Kleiderschrank** ist ein Bodygroup-Management-Addon für Garry's Mod. Es erlaubt Spieler:innen, Bodygroup-Kombinationen als Sets zu speichern, diese Sets zu verwalten und per UI oder Dresser-Entity schnell anzuwenden. Entwickelt für RP-Server und Singleplayer-Einsatz mit Fokus auf Sicherheit, Performance und einfache Bedienung.

---

## ✨ Hauptfeatures

- 🎨 **Vollständige Bodygroup-Kontrolle** — Ändere alle Bodygroups deines Models  
- 💾 **Set-Management** — Speichere und verwalte viele Outfits (konfigurierbar)  
- 🖱️ **Interaktive 3D-Vorschau** — Änderungen in Echtzeit sehen  
- 🏪 **Dresser-Entity** — Physische Kleiderschrank-Entity zum Spawnen und Interagieren  
- 🎨 **Anpassbares Design** — Konfigurierbare Farben, Fonts und UI-Optionen  
- 🔒 **Sicherheitssystem** — Server-seitige Validierung & sichere Netzwerkkommunikation

---

## 🚀 Installation

1. Ordner `keksi_kleiderschrank` nach `garrysmod/addons/` kopieren  
2. Falls auf einem Server: Server neustarten  
3. Addon ist einsatzbereit

**Hinweis:** Bei Problemen die Garry's Mod Konsole prüfen (`~`) und Logs kontrollieren.

---


## 🎮 Verwendung

### 👤 Als Spieler

**Kleiderschrank öffnen:**
- Konsole: `keksi_kleiderschrank_open`  
- Legacy Command: `wardrobe_open`  
- Oder: Interagiere mit dem Dresser-Entity (Taste **E**)

**Sets verwalten:**
- Bodygroups in der mittleren Spalte ändern  
- Sets in der rechten Spalte speichern, umbenennen, löschen oder anwenden  
- 3D-Vorschau in der linken Spalte zeigt Model und aktuelle Änderungen  
- Drag & Drop der Kamera in der 3D-Vorschau (Maussteuerung)

**Kurzbefehle (Beispiel):**
```txt
keksi_kleiderschrank_open   -- UI öffnen
wardrobe_save <name>       -- Set speichern (wenn verfügbar)
wardrobe_apply <name>      -- Set anwenden (Serverberechtigung vorausgesetzt)
````

---

### 🛠️ Als Server-Besitzer

**Dresser spawnen:**

* Öffne das Entity-Menü → wähle *Keksi Kleiderschrank* → Dresser platzieren

**Admin-Optionen:**

* Begrenzung der Sets pro Spieler setzen
* Berechtigungen für Anwenden/Speichern steuern
* Logging aktivieren

**Konfiguration anpassen:**

* Datei: `lua/wardrobe/sh_config.lua`
* Farben, Limits, Berechtigungen und Speicherpfad anpassen

---

## ⚙️ Konfiguration

`lua/wardrobe/sh_config.lua` (Beispielausschnitt):

```lua
-- Beispiel: sh_config.lua
WardrobeConfig = WardrobeConfig or {}

-- Farbdesign anpassen
WardrobeConfig.Colors = WardrobeConfig.Colors or {}
WardrobeConfig.Colors.primary = Color(120, 80, 255, 255)
WardrobeConfig.Colors.background = Color(20, 20, 20, 240)

-- Limits setzen
WardrobeConfig.Save = WardrobeConfig.Save or {}
WardrobeConfig.Save.max_sets = 30
WardrobeConfig.Save.max_bodygroups_per_set = 64

-- Berechtigungen konfigurieren
WardrobeConfig.Permissions = WardrobeConfig.Permissions or {}
WardrobeConfig.Permissions.allow_all = true
WardrobeConfig.Permissions.admin_only_apply = false

-- Netzwerk / Sicherheit
WardrobeConfig.Network = WardrobeConfig.Network or {}
WardrobeConfig.Network.throttle = 0.1   -- Sekunden zwischen Apply-Requests
WardrobeConfig.Network.payload_limit = 64 * 1024 -- 64 KB
```

---

## 🔧 Technische Details

### 📊 Netzwerk-System

* **Throttling:** Standardmäßig 0.1s zwischen Apply-Requests, um Spam zu vermeiden
* **Payload-Limit:** 64 KB pro Request (konfigurierbar)
* **Validierung:** Server-seitige Bodygroup-Validierung (Whitelist-basiert)

### 💾 Datenspeicherung

* **Format:** JSON
* **Speicherort:** `DATA/keksi_kleiderschrank/`
* **Organisation:** Pro Spieler eigene JSON-Datei (`<steamid64>.json`)
* **Backups:** Optionale automatische Backups (konfigurierbar)

### 🎨 UI-System

* **Fullscreen-responsive** Interface
* **3D-Preview:** Interaktive Model-Darstellung mit Maus-Kamerasteuerung
* **Drag & Drop:** Kamera/Objekt-Steuerung per Maus (links/rechts/schieben)
* **Themes:** Farben und Fonts über `sh_config.lua` anpassbar

---

## 👨‍💻 Entwickler-Information

### 📝 Über den Entwickler

**Imperator Keksi**

* 🔫 Social: [https://guns.lol/imperatorkeksi](https://guns.lol/imperatorkeksi)
* 🎮 Discord: [https://discord.gg/BTtC6b3XAY](https://discord.gg/BTtC6b3XAY)

### 🧩 Entwicklung & Contribution

* Forke das Repo, erstelle einen Branch und öffne PRs für Bugfixes/Features
* Bitte halte Änderungen modular (Netzwerk, UI, Entity getrennt)
* Tests lokal in Singleplayer durchführen bevor auf Server pushed wird

---

## 🍪 Die Keks Familie Community

Willkommen in der **Keks Familie** — eine aktive Gaming-Community.

**Was wir bieten:**

* Gaming-Sessions & Community-Events
* Casino Nights & RP-Gruppen (z. B. Star Wars RP)
* Support und Hilfestellung zu Addons
* Regelmäßige Updates & Streams

**Tritt bei:** [https://discord.gg/BTtC6b3XAY](https://discord.gg/BTtC6b3XAY)

---

## 📜 Lizenzbedingungen

**✅ ERLAUBT:**

* Weiterentwicklung und Modifikation (mit Credit)
* Testen auf privaten und öffentlichen Servern
* Einbindung in andere Projekte (sofern Credits bleiben)

**❌ NICHT ERLAUBT:**

* Kommerzieller Verkauf oder Monetarisierung des Addons
* Behauptung fremder Urheberschaft
* Entfernen von Credits / Entwickler-Hinweisen
* Nutzung für betrügerische oder schädliche Zwecke

**Rechtlicher Hinweis:** Dieses Addon ist geistiges Eigentum von **Imperator Keksi**. Die vollständigen Lizenzbedingungen werden im Discord gepflegt — kontaktiere den Entwickler für kommerzielle Anfragen.

---

## 📞 Support

* **Discord:** [https://discord.gg/BTtC6b3XAY](https://discord.gg/BTtC6b3XAY)
* **Fragen & Issues:** Öffne ein Issue im GitHub-Repo oder poste im Discord-Support-Channel
* **Updates & News:** Folge dem Entwickler auf guns.lol

---

**Made with ❤️ by Imperator Keksi**
*"Bringing style to Garry's Mod, one outfit at a time!"*
