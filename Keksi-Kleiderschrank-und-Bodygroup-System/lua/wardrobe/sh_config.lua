--[[
    Keksi Kleiderschrank - Shared Configuration
    ==========================================
    
    Diese Datei enthält alle wichtigen Konfigurationseinstellungen für das Keksi Kleiderschrank System.
    Hier können Farben, Schriftarten, Limits und Verhalten angepasst werden.
    
    Diese Datei wird sowohl auf Client als auch auf Server geladen (shared).
    
    Entwickelt von: Imperator Keksi
    https://guns.lol/imperatorkeksi
--]]
-- Hauptkonfigurationstabelle erstellen (falls noch nicht vorhanden)
WardrobeConfig = WardrobeConfig or {}

-- Anzeigename des Addons
WardrobeConfig.PrintName = "Keksi Kleiderschrank"

--[[
    Schriftarten-Definitionen
    =========================
    Diese Schriftarten werden client-seitig beim Laden erstellt.
    Hier können Größe, Gewicht und Basis-Font angepasst werden.
--]]
WardrobeConfig.Fonts = {
    header = {name = "KeksiKleiderschrank.Header", font = "DermaLarge", size = 22, weight = 700},    -- Große Überschrift
    normal = {name = "KeksiKleiderschrank.Normal", font = "DermaDefault", size = 14, weight = 500}, -- Standard Text
    small = {name = "KeksiKleiderschrank.Small", font = "DermaDefaultSmall", size = 12, weight = 400} -- Kleiner Text
}

--[[
    Farbschema
    ==========
    Vollständiges Lila-Blau Farbschema für das UI.
    Farbobjekte werden nur client-seitig erstellt, um Server-Performance zu schonen.
--]]
WardrobeConfig.Colors = {}
if CLIENT then
    WardrobeConfig.Colors = {
        -- Haupt-Farbschema (Default)
        primary = Color(120, 80, 255, 255),        -- Helles Lila-Blau
        secondary = Color(80, 60, 180, 255),       -- Dunkleres Lila-Blau
        dark = Color(40, 30, 80, 255),             -- Sehr dunkles Lila-Blau
        background = Color(0, 0, 0, 255),          -- Komplett schwarz
        
        -- Glow und Effekte
        glow = Color(120, 80, 255, 100),           -- Lila-Blau Glow (mit Alpha)
        warning = Color(255, 102, 102, 255),       -- Rot (bleibt für Warnungen)
        danger = Color(255, 102, 102, 255),        -- Rot (bleibt für Fehler/kritisch)
        success = Color(100, 200, 255, 255),       -- Helles Blau (Heilung/voll)
        
        -- Textfarben
        text = Color(240, 240, 245, 255),          -- Haupttext (hell)
        text_health = Color(60, 40, 120, 255),     -- Dunkles Lila für Text
        text_armor = Color(80, 60, 180, 255),      -- Sekundärtext Lila-Blau
        text_enemy = Color(255, 102, 102, 255),    -- Rot (bleibt für Gegner)
        text_ally = Color(100, 150, 255, 255),     -- Helles Blau (Verbündete)
        
        -- Status-Indikatoren
        stabilized = Color(120, 80, 255, 255),     -- Lila-Blau
        bleeding = Color(255, 153, 153, 255),      -- Rot (bleibt für Blutung)
        neutral = Color(85, 85, 85, 255),          -- Grau (neutral)
        
        -- UI-spezifische Farben (basierend auf Hauptschema)
        panel = Color(40, 30, 80, 240),            -- dark mit Alpha
        accent = Color(120, 80, 255, 255),         -- primary
        hover = Color(80, 60, 180, 200),           -- secondary mit Alpha
        text_muted = Color(100, 80, 160, 255),     -- gedämpfte Variante
        
        -- Assault Variante (intensiver) - als Alternative verfügbar
        assault = {
            primary = Color(140, 100, 255, 255),
            secondary = Color(100, 80, 200, 255),
            dark = Color(50, 40, 100, 255),
            background = Color(0, 0, 0, 255),
            success = Color(120, 220, 255, 255),
            text_health = Color(70, 50, 140, 255),
            text_armor = Color(100, 80, 200, 255),
            text_ally = Color(120, 170, 255, 255)
        },
        
        -- Support Variante (sanfter) - als Alternative verfügbar  
        support = {
            primary = Color(100, 60, 220, 255),
            secondary = Color(70, 50, 160, 255),
            dark = Color(35, 25, 70, 255),
            background = Color(0, 0, 0, 255),
            success = Color(80, 180, 255, 255),
            text_health = Color(50, 30, 100, 255),
            text_armor = Color(70, 50, 160, 255),
            text_ally = Color(80, 130, 255, 255)
        }
    }
end

--[[
    UI Layout Einstellungen
    =======================
    Grundlegende Werte für das Benutzeroberflächen-Layout.
--]]
WardrobeConfig.UI = {
    frame_w = 0,             -- Wird zu ScrW() gesetzt (Vollbild-Breite)
    frame_h = 0,             -- Wird zu ScrH() gesetzt (Vollbild-Höhe)
    padding = 12,            -- Innenabstand für UI-Elemente
    spacing = 8,             -- Abstand zwischen UI-Elementen
    border_radius = 0,       -- Kein Radius für Vollbild-Design
    animation_time = 0.12    -- Sekunden für UI-Übergänge (rein kosmetisch)
}

--[[
    Datenspeicherung und Limits
    ===========================
    Einstellungen für die Persistierung von Spielerdaten.
--]]
WardrobeConfig.Save = {
    folder = "keksi_kleiderschrank", -- Ordner unter DATA/ für Spielerdaten
    max_sets = 30,                   -- Maximale Anzahl Sets pro Spieler
    max_set_size_kb = 64            -- Maximale JSON-Größe pro Set (Anti-Missbrauch)
}

--[[
    Sicherheit und Netzwerk
    =======================
    Einstellungen zum Schutz vor Missbrauch und zur Performance-Optimierung.
--]]
WardrobeConfig.Network = {
    max_payload_kb = 64,      -- Maximale Paketgröße von Clients (KB)
    throttled_seconds = 0.1   -- Mindestabstand zwischen Apply-Requests pro Spieler
}

--[[
    Dresser Entity Einstellungen
    ============================
    Konfiguration für die physischen Kleiderschrank-Objekte.
--]]
WardrobeConfig.Dresser = {
    enabled = true,          -- Dresser-Interaktion aktivieren
    model = "models/props_c17/FurnitureDresser001a.mdl", -- 3D-Model des Kleiderschranks
    max_distance = 100,                                 -- Maximale Interaktions-Entfernung
    show_hint = true                                   -- Interaktions-Hinweis anzeigen
}

--[[
    Berechtigungen
    ==============
    Kann erweitert werden, um mit Rang-Addons von Dritten zu integrieren.
--]]
WardrobeConfig.Permissions = {
    allow_all = true,                         -- Falls false, können nur Ränge in `allowed_ranks` bestimmte Sachen ändern
    allowed_ranks = { "superadmin", "admin" } -- Beispiel-Ränge - kann an das jeweilige Rang-System angepasst werden
}

--[[
    Erweiterte Beschränkungen (Optional)
    ===================================
    Hier können spezielle Beschränkungen pro Bodygroup und Model definiert werden.
    Beispiel-Struktur:
    WardrobeConfig.Restrictions = {
       ["models/player/kleiner.mdl"] = {
           ["hat"] = {roles = {"vip", "admin"}, allow = true},
       }
    }
--]]
WardrobeConfig.Restrictions = WardrobeConfig.Restrictions or {}

--[[
    Client-seitige Initialisierung
    ==============================
    Erstelle Schriftarten basierend auf der Konfiguration.
--]]
if CLIENT then
    -- Schriftarten basierend auf Konfiguration erstellen
    for k, v in pairs(WardrobeConfig.Fonts) do
        surface.CreateFont(v.name, { 
            font = v.font, 
            size = v.size, 
            weight = v.weight, 
            antialias = true 
        })
    end
end

--[[
    Hilfsfunktionen
    ===============
--]]

-- Kleine Hilfsfunktion zum Begrenzen von Zahlen
function WardrobeConfig.ClampInt(v, low, high)
    v = tonumber(v) or 0
    if v < low then v = low end
    if v > high then v = high end
    return math.floor(v)
end

-- Konfigurationstabelle exportieren
return WardrobeConfig
