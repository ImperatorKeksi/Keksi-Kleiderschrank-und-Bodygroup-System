# 🍪 Keks Kleiderschrank - Bodygroup & Skin Management System

> **Ein professionelles Bodygroup-Management System für Garry's Mod mit erweiterten Features und moderner UI**

[![Version](https://img.shields.io/badge/Version-2.1-purple)](https://github.com/imperatorkeksi/keksi-kleiderschrank-und-bodygroup-system)
[![Garry's Mod](https://img.shields.io/badge/Garry's%20Mod-Compatible-blue)](https://store.steampowered.com/app/4000/Garrys_Mod/)
[![DarkRP](https://img.shields.io/badge/DarkRP-Integration-orange)](https://github.com/FPtje/DarkRP)
[![License](https://img.shields.io/badge/License-Free-green)](#lizenz)

---

## � Inhaltsverzeichnis

- [Über das Projekt](#-über-das-projekt)
- [Features](#-features)
- [Datenstruktur](#-datenstruktur)
- [Verwendung](#-verwendung)
- [Konfiguration](#-konfiguration)
- [Über den Entwickler](#-über-den-entwickler)
- [Social Media](#-social-media)
- [Lizenz](#-lizenz)
- [Abschlusstext](#-abschlusstext)

---

## 🚀 Über das Projekt

**Keks Kleiderschrank - Bodygroup & Skin Management System** ist ein hochmodernes Kleiderschrank-System für Garry's Mod Server, das speziell für Roleplay-Umgebungen entwickelt wurde. Mit einem eleganten lila-blauen Design und vollständiger 3D-Vorschau bietet es Spielern eine immersive Erfahrung beim Anpassen ihrer Charaktere.

Das Add-on erweitert das Standard-Bodygroup-System von Garry's Mod durch eine professionelle Vollbild-Oberfläche mit Echtzeit-3D-Vorschau, Set-Management und physischen Dresser-Entities. Es wurde für maximale Benutzerfreundlichkeit und Server-Performance optimiert.

### 🎮 Hauptziele:

- **Immersive Charakter-Anpassung**: Vollbild-UI mit 3D-Vorschau und interaktiver Kamera
- **Flexibles Set-System**: Speichere bis zu 30 verschiedene Outfit-Kombinationen
- **Server-Performance**: Optimiert für hohe Spielerzahlen und sichere Netzwerkkommunikation
- **Einfache Integration**: Funktioniert out-of-the-box auf allen Garry's Mod Servern

---

## ✨ Features

### 🔥 Kern-Features

- **🎨 Vollbild-Benutzeroberfläche** mit modernem lila-blauem Design und responsivem Layout
- **👕 Komplette Bodygroup-Kontrolle** für alle verfügbaren Model-Bodygroups
- **🖌️ Erweiterte Skin-Unterstützung** zum Wechseln zwischen verschiedenen Model-Skins
- **💾 Set-Management System** mit bis zu 30 speicherbaren Outfit-Kombinationen pro Spieler
- **🖼️ 3D Model Preview** mit Echtzeit-Vorschau aller Änderungen
- **🖱️ Interaktive Kamerasteuerung** mit Drag & Drop und automatischer Rotation

### 🛡️ Technische Features

- **🏪 Spawnable Dresser-Entities** als physische Kleiderschrank-Objekte in der Welt
- **🔒 Server-seitige Validierung** mit Anti-Cheat und Sicherheitsprüfungen
- **⚡ Performance-Optimierung** für bis zu 50 gleichzeitige Benutzer
- **🌐 Sichere Netzwerkkommunikation** mit Throttling und Payload-Limits
- **📱 Responsive Design** funktioniert auf allen Bildschirmgrößen
- **� JSON-Persistierung** für sichere Datenspeicherung pro Spieler

### 🌟 UI & Design Features

- **🎭 Drei-Spalten Layout**: Model Preview, Bodygroup Controls, Set Management
- **✨ Smooth Animationen** und Hover-Effekte für beste Benutzererfahrung
- **🎨 Vollständig konfigurierbare Farben** und Schriftarten
- **📊 Echtzeit-Updates** bei allen Änderungen
- **🖱️ Intuitive Maussteuerung** in der 3D-Vorschau

### 🔧 Admin Features

- **🛠️ Vollständig konfigurierbar** über zentrale Config-Datei
- **📝 Erweiterte Berechtigungen** mit Rang-System Integration
- **🗂️ Flexible Dresser-Konfiguration** für Model, Distanz und Verhalten
- **🔍 Debug-System** mit ausführlichem Logging
- **⚙️ Hot-Reload Support** für Konfigurationsänderungen

---

## 🗂️ Datenstruktur

### 📁 Ordnerstruktur

```
keksi-kleiderschrank-und-bodygroup-system/
├── 📄 addon.json                              # Add-on Metadaten
├── 📖 README.md                               # Dokumentation
└── lua/
    ├── autorun/
    │   ├── 📜 client/wardrobe_cl.lua          # Client-UI und Networking
    │   ├── � server/wardrobe_sv.lua          # Server-Logik und Persistierung
    │   └── 📜 shared/wardrobe_shared.lua      # Shared Config Loading
    ├── entities/wardrobe_dresser/
    │   ├── 📜 init.lua                        # Server-seitige Entity
    │   ├── 📜 cl_init.lua                     # Client-seitige Entity
    │   └── 📜 shared.lua                      # Entity-Definition
    ├── wardrobe/
    │   └── 📜 sh_config.lua                   # Hauptkonfiguration
    └── materials/entities/
        └── 🖼️ wardrobe_dresser.vmt            # Entity-Material
```

### 🔧 Skript-Komponenten

#### **Server-Side Funktionen:**

- **Spieler-Daten Management** mit Steam ID basierter JSON-Persistierung
- **Bodygroup-Validierung** gegen verfügbare Model-Bodygroups
- **Set-Speicherung und -Synchronisation** mit Größen- und Anzahl-Limits
- **Anti-Spam Schutz** mit Throttling und Payload-Validierung
- **Dresser-Entity Logic** für Spawn-Menü Integration

#### **Client-Side Funktionen:**

- **Vollbild-GUI Rendering** mit drei-spaltigem Layout
- **3D Model Preview** mit interaktiver Kamerasteuerung
- **Bodygroup-Controls** mit Echtzeit-Updates
- **Set-Management Interface** für Speichern, Laden und Löschen
- **Skin-Selection System** für verfügbare Model-Skins

#### **Shared Components:**

- **Zentrale Konfiguration** mit Farben, Schriftarten und Limits
- **Entity-Definitionen** für Dresser-Spawning
- **Hilfsfunktionen** für Validierung und Utilities

---

## 🎮 Verwendung

### 📥 Installation

1. **Download** das Add-on in deinen Garry's Mod Addons-Ordner:
   ```
   steamapps/common/GarrysMod/garrysmod/addons/keksi-kleiderschrank-und-bodygroup-system/
   ```

2. **Server-Neustart** oder `changelevel` ausführen

3. **Automatische Aktivierung** - Das Add-on lädt sich automatisch und ist sofort einsatzbereit

### 🕹️ Im Spiel verwenden

#### Kleiderschrank öffnen:

1. **Konsolen-Befehl** `keksi_kleiderschrank_open` oder Legacy `wardrobe_open`
2. **Dresser-Entity** spawnen und mit E-Taste interagieren
3. **Automatische UI-Aktivierung** mit Vollbild-Interface

#### Bodygroups anpassen:

- **Mittlere Spalte** zeigt alle verfügbaren Bodygroups des aktuellen Models
- **Dropdown-Menüs** für jede Bodygroup-Option
- **Echtzeit-Vorschau** in der linken 3D-Model-Ansicht

#### Skins wechseln:

- **Skin-Dropdown** oberhalb der Bodygroup-Controls
- **Sofortige Anwendung** auf Spieler und Preview-Model
- **Automatische Validierung** gegen verfügbare Skins

#### Sets verwalten:

- **Rechte Spalte** zeigt alle gespeicherten Sets des Spielers
- **"Set speichern"** Button für aktuelle Bodygroup/Skin-Kombination
- **Set-Buttons** zum sofortigen Anwenden gespeicherter Outfits
- **Rename/Delete** Funktionen für erweiterte Set-Verwaltung

### 🎯 3D-Vorschau Bedienung

- **Automatische Rotation** wenn keine Interaktion stattfindet
- **Linke Maustaste + Ziehen** für manuelle Kamera-Rotation
- **Rechte Maustaste + Ziehen** für Kamera-Bewegung
- **Mausrad** für Zoom (falls implementiert)

### 👨‍💻 Admin-Commands

```bash
# Kleiderschrank öffnen
keksi_kleiderschrank_open

# Legacy-Befehl
wardrobe_open

# Admin: Spieler-Sets löschen (Console only)
wardrobe_clear_sets <steamid>
```

---

## ⚙️ Konfiguration

### 🎛️ Haupt-Einstellungen

Das Add-on kann durch Bearbeitung der `lua/wardrobe/sh_config.lua` angepasst werden:

```lua
-- Set-Management Limits
WardrobeConfig.Save = {
    folder = "keksi_kleiderschrank",    -- DATA-Ordner für Spielerdaten
    max_sets = 30,                      -- Maximale Sets pro Spieler
    max_set_size_kb = 64               -- Maximale JSON-Größe pro Set
}
```

### 🎨 Design-Anpassungen

```lua
-- Farbschema (nur Client-seitig erstellt)
WardrobeConfig.Colors = {
    primary = Color(120, 80, 255, 255),     -- Haupt-Lila-Blau
    secondary = Color(80, 60, 180, 255),    -- Sekundär-Lila
    dark = Color(40, 30, 80, 255),          -- Dunkles Panel
    background = Color(0, 0, 0, 255),       -- Vollbild-Hintergrund
    text = Color(240, 240, 245, 255),       -- Haupttext
    accent = Color(120, 80, 255, 255),      -- Accent-Farbe
    hover = Color(80, 60, 180, 200)         -- Hover-Effekte
}
```

### 📝 UI-Anpassungen

```lua
-- Schriftarten-Definitionen
WardrobeConfig.Fonts = {
    header = {name = "KeksiKleiderschrank.Header", font = "DermaLarge", size = 22, weight = 700},
    normal = {name = "KeksiKleiderschrank.Normal", font = "DermaDefault", size = 14, weight = 500},
    small = {name = "KeksiKleiderschrank.Small", font = "DermaDefaultSmall", size = 12, weight = 400}
}
```

### 🔧 System-Einstellungen

```lua
-- Sicherheit und Performance
WardrobeConfig.Network = {
    max_payload_kb = 64,         -- Maximale Netzwerk-Payload
    throttled_seconds = 0.1      -- Anti-Spam Delay zwischen Requests
}

-- Dresser-Entity Konfiguration
WardrobeConfig.Dresser = {
    enabled = true,              -- Dresser-Interaction aktiviert
    model = "models/props_c17/FurnitureDresser001a.mdl",
    max_distance = 100,          -- Maximale Interaktions-Distanz
    show_hint = true             -- Interaktions-Hinweise anzeigen
}
```

### 💰 Berechtigungen-System

```lua
-- Erweiterte Berechtigungen (optional)
WardrobeConfig.Permissions = {
    allow_all = true,                         -- Alle dürfen verwenden
    allowed_ranks = { "superadmin", "admin" } -- Beschränkte Ränge
}
```

---## �‍💻 Über den Entwickler

**Imperator Keksi** (auch bekannt als Nico, Milky, Brownie, Cookie oder Keksi) ist ein leidenschaftlicher Gamer und Roleplayer, der sich besonders für **Garry's Mod Development** und technische Projekte begeistert.

### 🌟 Entwickler-Profil:

- **🎮 Passion**: Garry's Mod Addon-Entwicklung und Roleplay-Systeme
- **📈 Status**: Erfahrener Entwickler mit Fokus auf Benutzerfreundlichkeit und Performance
- **🤝 Charakter**: Ruhig, hilfsbereit und immer offen für Feedback und neue Ideen
- **💡 Motivation**: Hochwertige, kostenlose Add-ons für die Garry's Mod Community

### 🔄 Entwicklungsphilosophie:

Imperator Keksi entwickelt Add-ons mit **hoher Qualität** und **Liebe zum Detail**. Seine Projekte zeichnen sich durch moderne UI-Designs, robuste Server-Performance und umfangreiche Konfigurationsmöglichkeiten aus.

### � Community-Fokus:

Er freut sich über **jede Art von Feedback**, Verbesserungsvorschläge oder neue Ideen. Die Community kann ihn jederzeit kontaktieren - er ist **immer bereit zu helfen** und **neue Konzepte zu diskutieren**.

> *"Gemeinsam können wir die besten Add-ons für die Garry's Mod Community erschaffen!"*

---

## � Social Media

### 🔗 Offizielle Profile von Imperator Keksi:

**🌐 Hauptprofil:**
- **Website**: [guns.lol/imperatorkeksi](https://guns.lol/imperatorkeksi)

### 📞 Kontakt & Support:

Für **Fragen**, **Feedback** oder **Kollaborationen** kannst du Imperator Keksi über seine offiziellen Kanäle erreichen. Er ist immer interessiert an:

- 💡 **Neuen Ideen** für Add-on Features und Verbesserungen
- 🐛 **Bug Reports** und Verbesserungsvorschläge für bestehende Systeme
- 🤝 **Community Feedback** und Erfahrungen mit seinen Add-ons
- 🚀 **Kollaborationsmöglichkeiten** mit anderen Entwicklern

---

## � Lizenz

### ✅ **ERLAUBT:**

- ✅ **Verwendung auf privaten und öffentlichen Servern**
- ✅ **Kopieren und Weiterverbreitung des Add-ons**
- ✅ **Modifikation und Anpassung an eigene Bedürfnisse**
- ✅ **Integration in Server-Packs oder Collections**

### ❌ **NICHT ERLAUBT:**

- ❌ **Verkauf oder kommerzielle Nutzung des Add-ons**
- ❌ **Weiterverkauf in jeglicher Form**
- ❌ **Ausgeben als eigene Entwicklung**
- ❌ **Entfernen der Urheberrechtshinweise**

### ℹ️ **WICHTIGE BEDINGUNGEN:**

- **🏷️ Urheberschaft**: **Imperator Keksi** muss in jeder Veröffentlichung als **originaler Entwickler** genannt werden
- **📝 Attribution**: Bei Modifikationen muss die Quelle und der originale Autor erwähnt werden
- **🆓 Kostenlos**: Das Add-on ist und bleibt **komplett kostenlos** für die Community

### 📋 **Lizenz-Zusammenfassung:**

```
Keks Kleiderschrank - Bodygroup & Skin Management System v2.1
Copyright (c) 2025 Imperator Keksi

Dieses Add-on ist kostenlose Software für die Garry's Mod Community.
Verwendung, Modifikation und Weitergabe unter Nennung des Originalautors gestattet.
Kommerzielle Nutzung oder Verkauf ist strengstens untersagt.
```

---

## � Abschlusstext

**Danke fürs Nutzen des Add-ons!**

Wenn dir das **Keks Kleiderschrank - Bodygroup & Skin Management System** gefällt, unterstütze die Arbeit von **Imperator Keksi** durch:

- ⭐ **Einen Stern auf GitHub** (falls verfügbar)
- 💬 **Positives Feedback** in der Community
- 🐛 **Bug Reports** für kontinuierliche Verbesserungen
- 💡 **Feature-Vorschläge** für zukünftige Updates
- 🤝 **Weiterempfehlungen** an andere Server-Owner

### 🚀 **Zukunftspläne:**

- 🔄 **Regelmäßige Updates** mit neuen Features basierend auf Community-Feedback
- 🎨 **Zusätzliche Themes** und Design-Varianten für verschiedene Server-Styles
- � **Erweiterte Konfigurationsmöglichkeiten** für Server-Admins
- 🌐 **Multi-Language Support** für internationale Server
- 📱 **Mobile-optimierte Interfaces** für verschiedene Bildschirmgrößen

---

**Version 2.1** – Erstellt mit **💜 Leidenschaft** für die **Garry's Mod Community**

*Ein Projekt von **Imperator Keksi** - Für die Gemeinschaft, mit der Gemeinschaft*

---

[![Made with Love](https://img.shields.io/badge/Made%20with-❤️-red)](https://guns.lol/imperatorkeksi)
[![Garry's Mod](https://img.shields.io/badge/Built%20for-Garry's%20Mod-blue)](https://store.steampowered.com/app/4000/Garrys_Mod/)
[![Community](https://img.shields.io/badge/Community-Driven-green)](https://github.com/imperatorkeksi)

> *"Style dein Character, style dein Roleplay!"* ✨
