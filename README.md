# 🍪 Keksi Kleiderschrank - Bodygroup System für Garry's Mod

![Garry's Mod](https://img.shields.io/badge/Garry's%20Mod-Addon-blue)
![Version](https://img.shields.io/badge/Version-2.1-green)
![License](https://img.shields.io/badge/License-Custom-yellow)
![Developer](https://img.shields.io/badge/Developer-Imperator%20Keksi-purple)

**Keksi Kleiderschrank** ist ein fortschrittliches Bodygroup- und Skin-Management-System für Garry's Mod, das Spielern ermöglicht, ihre Charakteranpassungen einfach zu speichern, zu verwalten und anzuwenden.

---

## 📖 Inhaltsverzeichnis

- [Über das Projekt](#-über-das-projekt)
- [Features](#-features)
- [Installation](#-installation)
- [Verwendung](#-verwendung)
- [Dateistruktur](#-dateistruktur)
- [Konfiguration](#-konfiguration)
- [Technische Details](#-technische-details)
- [Entwickler](#-entwickler)
- [Lizenz](#-lizenz)
- [Support & Community](#-support--community)

---

## 🎯 Über das Projekt

Das **Keksi Kleiderschrank System** wurde von **Imperator Keksi** entwickelt und bietet eine vollständige Lösung für die Verwaltung von Bodygroups und Skins in Garry's Mod. Es ermöglicht Spielern:

- 🎨 **Vollständige Bodygroup-Kontrolle** - Ändere alle verfügbaren Bodygroups deines Charaktermodels
- 👕 **Skin-Management** - Wechsle zwischen verschiedenen Skins des Models
- 💾 **Set-Speicherung** - Speichere deine Lieblings-Outfits als Sets
- 🖥️ **Intuitive UI** - Moderne, vollbildschirmfähige Benutzeroberfläche
- 🏪 **Dresser Entity** - Physische Kleiderschrank-Objekte zum Spawnen
- 🔒 **Sicherheit** - Server-seitige Validierung und sichere Netzwerkkommunikation

---

## ✨ Features

### Hauptfunktionen
- **3D Model Preview** - Sehe deine Änderungen in Echtzeit mit automatischer Kamerarotation
- **Drag & Drop Kamera** - Interaktive Kamerasteuerung in der Vorschau
- **Set Management** - Speichere bis zu 30 verschiedene Outfit-Sets
- **Fullscreen UI** - Moderne, responsive Benutzeroberfläche
- **Entity Interaction** - Spawne Kleiderschrank-Objekte in der Welt
- **Multi-Language Support** - Deutsche Lokalisierung
- **Admin Tools** - Erweiterte Verwaltungsfunktionen

### Technische Features
- **JSON Persistierung** - Sichere Datenspeicherung pro Spieler
- **Network Throttling** - Schutz vor Spam und Missbrauch
- **Payload Validation** - Server-seitige Sicherheitsprüfungen
- **Performance Optimiert** - Effiziente Client-Server Kommunikation
- **Error Handling** - Robuste Fehlerbehandlung

---## 🚀 Installation

1. **Download** - Lade das Addon herunter
2. **Installation** - Kopiere den Ordner `keksi-kleiderschrank-und-bodygroup-system` nach `garrysmod/addons/`
3. **Server Neustart** - Starte den Server neu (bei Server-Installation)
4. **Fertig** - Das Addon ist einsatzbereit!

### Dateistruktur nach Installation:
```
garrysmod/addons/keksi-kleiderschrank-und-bodygroup-system/
├── addon.json
├── README.md
└── lua/
    ├── autorun/
    │   ├── client/wardrobe_cl.lua
    │   ├── server/wardrobe_sv.lua
    │   └── shared/wardrobe_shared.lua
    ├── entities/wardrobe_dresser/
    │   ├── init.lua
    │   ├── cl_init.lua
    │   └── shared.lua
    └── wardrobe/sh_config.lua
```

---

## 🎮 Verwendung

### Als Spieler

**Kleiderschrank öffnen:**
- Konsole: `keksi_kleiderschrank_open`
- Legacy: `wardrobe_open`
- **E-Taste** am Dresser-Entity

**Set Management:**
1. **Bodygroups ändern** - Mittlere Spalte: Wähle verschiedene Bodygroup-Optionen
2. **Skins ändern** - Wechsle zwischen verfügbaren Model-Skins
3. **Sets speichern** - Rechte Spalte: Speichere aktuelle Konfiguration als Set
4. **Sets anwenden** - Lade gespeicherte Sets mit einem Klick
5. **3D Vorschau** - Linke Spalte: Sehe Änderungen in Echtzeit

### Als Server-Besitzer

**Dresser spawnen:**
- Öffne das Spawn-Menü → Entities → Keksi Tools → Keksi Kleiderschrank

**Konfiguration anpassen:**
- Editiere `lua/wardrobe/sh_config.lua` für:
  - Farbschema
  - Set-Limits
  - Berechtigungen
  - Netzwerk-Einstellungen

---

## ⚙️ Konfiguration

Die Hauptkonfiguration erfolgt über `lua/wardrobe/sh_config.lua`:

```lua
-- Beispiel-Konfiguration
WardrobeConfig.Save.max_sets = 30              -- Max. Sets pro Spieler
WardrobeConfig.Network.throttled_seconds = 0.1  -- Anti-Spam Schutz
WardrobeConfig.Permissions.allow_all = true     -- Jeder darf verwenden
WardrobeConfig.Colors.primary = Color(120, 80, 255, 255) -- Hauptfarbe
```

### Wichtige Einstellungen:
- **max_sets** - Maximale Anzahl Sets pro Spieler
- **max_payload_kb** - Maximale Netzwerk-Payload Größe
- **throttled_seconds** - Mindestabstand zwischen Anfragen
- **Colors** - Vollständiges Farbschema anpassbar
- **Fonts** - Schriftarten und -größen

---

## 🔧 Technische Details

### Architektur
- **Client-Server Model** - Saubere Trennung von UI und Logik
- **JSON Persistierung** - Spielerdaten in `DATA/keksi_kleiderschrank/`
- **Network Strings** - Effiziente Kommunikation
- **Entity System** - Spawnable Dresser-Objekte

### Sicherheit
- **Server-seitige Validierung** - Alle Bodygroup-Änderungen werden validiert
- **Payload Limits** - Schutz vor überdimensionierten Anfragen
- **Throttling** - Schutz vor Spam-Anfragen
- **Admin Commands** - Erweiterte Verwaltungsfunktionen

### Performance
- **Optimierte UI** - Minimale FPS-Auswirkung
- **Caching** - Intelligente Datenhaltung
- **Network Efficiency** - Minimaler Netzwerk-Traffic

---

## 👨‍💻 Entwickler

**Imperator Keksi**
- 🌐 **Profil:** [https://guns.lol/imperatorkeksi](https://guns.lol/imperatorkeksi)
- 🎮 **Discord Community:** Keks Familie
- 🛠️ **Spezialisierung:** Garry's Mod Addons, Lua Development

### Über den Entwickler
Imperator Keksi ist ein erfahrener Garry's Mod Entwickler mit Fokus auf benutzerfreundliche und technisch ausgereifte Addons. Das Keksi Kleiderschrank System spiegelt jahrelange Erfahrung in der GMod-Entwicklung wider.

---

## 📜 Lizenz

### ✅ **ERLAUBT:**
- ✓ Verwendung auf privaten und öffentlichen Servern
- ✓ Weiterentwicklung und Modifikation (mit Quellenangabe)
- ✓ Integration in andere Projekte (Credits erforderlich)
- ✓ Anpassung für spezielle Server-Bedürfnisse

### ❌ **NICHT ERLAUBT:**
- ✗ Kommerzieller Verkauf oder Monetarisierung
- ✗ Entfernung der Entwickler-Credits
- ✗ Behauptung eigener Urheberschaft
- ✗ Weiterverteilung ohne Credits

### 📋 **Bedingungen:**
- **Credits erforderlich:** Bei jeder Verwendung oder Modifikation muss „Entwickelt von Imperator Keksi" erwähnt werden
- **Nicht-kommerziell:** Das Addon darf nicht verkauft oder monetarisiert werden
- **Weiterentwicklung erlaubt:** Modifikationen sind ausdrücklich erwünscht, solange die Credits bleiben

**Rechtlicher Hinweis:** Dieses Addon ist geistiges Eigentum von Imperator Keksi. Bei Fragen zur kommerziellen Nutzung kontaktiere den Entwickler direkt.

---

## 🍪 Support & Community

### **Die Keks Familie**
Werde Teil unserer aktiven Gaming-Community!

**Was wir bieten:**
- 🎮 Gaming-Sessions & Community-Events
- 🎲 Casino Nights & Roleplay-Gruppen
- 🛠️ Addon-Support & Hilfestellung
- 📺 Streams & Updates
- 🌟 Star Wars RP & weitere Projekte

### **Support erhalten:**
- 💬 **Discord:** Keks Familie Community
- 🐛 **Bug Reports:** GitHub Issues
- 💡 **Feature Requests:** Discord oder GitHub
- 📖 **Dokumentation:** Diese README

### **Links:**
- 🌐 **Entwickler Profil:** [https://guns.lol/imperatorkeksi](https://guns.lol/imperatorkeksi)
- 🎮 **Community Discord:** Über das Entwickler-Profil erreichbar

---

## 🔄 Changelog

### Version 2.1 (Aktuell)
- ✨ Vollständige Skin-Unterstützung hinzugefügt
- 🎨 Verbessertes UI mit 3D Model Preview
- 🔒 Erweiterte Sicherheitsvalidierung
- 🖱️ Interaktive Kamerasteuerung
- 📱 Fullscreen-responsive Design
- 🐛 Diverse Bugfixes und Optimierungen

---

## 🙏 Credits

**Hauptentwickler:** Imperator Keksi  
**Community:** Die Keks Familie  
**Engine:** Garry's Mod / Lua  
**Inspiration:** Community-Feedback und Requests  

---

<div align="center">

**Made with ❤️ by Imperator Keksi**

*"Bringing style to Garry's Mod, one outfit at a time!"*

---

![Keks Familie](https://img.shields.io/badge/Community-Keks%20Familie-orange)
![Made for GMod](https://img.shields.io/badge/Made%20for-Garry's%20Mod-blue)
![Open Source](https://img.shields.io/badge/License-Custom%20Open%20Source-green)

</div>
