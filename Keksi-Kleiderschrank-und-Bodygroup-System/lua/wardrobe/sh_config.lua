-- shared configuration for Keksi Kleiderschrank
-- Change values here to customize fonts, colors, limits and behaviour.
WardrobeConfig = WardrobeConfig or {}

WardrobeConfig.PrintName = "Keksi Kleiderschrank"

-- Fonts: created on client side during load using these definitions
WardrobeConfig.Fonts = {
    header = {name = "KeksiKleiderschrank.Header", font = "DermaLarge", size = 22, weight = 700},
    normal = {name = "KeksiKleiderschrank.Normal", font = "DermaDefault", size = 14, weight = 500},
    small = {name = "KeksiKleiderschrank.Small", font = "DermaDefaultSmall", size = 12, weight = 400}
}

-- UI colors (RGBA) - only create Color objects on client
-- Vollständiges Lila-Blau Farbschema
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

-- UI layout values
WardrobeConfig.UI = {
    frame_w = 0, -- wird zu ScrW() gesetzt (Fullscreen)
    frame_h = 0, -- wird zu ScrH() gesetzt (Fullscreen)
    padding = 12,
    spacing = 8,
    border_radius = 0, -- Kein Radius für Fullscreen
    animation_time = 0.12 -- seconds for simple transitions (purely cosmetic)
}

-- Persistence limits and paths
WardrobeConfig.Save = {
    folder = "keksi_kleiderschrank", -- DATA/<folder>/
    max_sets = 30, -- max number of saved sets per player
    max_set_size_kb = 64 -- limit JSON size per set to prevent abuse
}

-- Security & Networking
WardrobeConfig.Network = {
    max_payload_kb = 64, -- maximum payload size accepted from clients
    throttled_seconds = 0.1 -- minimal delay between apply requests per player (reduziert)
}

-- Dresser interaction settings
WardrobeConfig.Dresser = {
    enabled = true, -- Enable dresser interaction
    model = "models/props_c17/FurnitureDresser001a.mdl", -- Dresser model to interact with
    max_distance = 100, -- Maximum interaction distance
    show_hint = true -- Show interaction hint to players
}

-- Permissions (can be extended to integrate with third-party rank addons)
WardrobeConfig.Permissions = {
    allow_all = true, -- if false, only ranks in `allowed_ranks` can change certain restricted items
    allowed_ranks = { "superadmin", "admin" } -- example strings - integrators can adapt to their rank system
}

-- Optional restrictions per bodygroup name (by model) -> example structure
-- WardrobeConfig.Restrictions = {
--    ["models/player/kleiner.mdl"] = {
--        ["hat"] = {roles = {"vip", "admin"}, allow = true},
--    }
-- }
WardrobeConfig.Restrictions = WardrobeConfig.Restrictions or {}

if CLIENT then
    -- create fonts based on config
    for k, v in pairs(WardrobeConfig.Fonts) do
        surface.CreateFont(v.name, { font = v.font, size = v.size, weight = v.weight, antialias = true })
    end
end

-- small utility function to clamp numbers
function WardrobeConfig.ClampInt(v, low, high)
    v = tonumber(v) or 0
    if v < low then v = low end
    if v > high then v = high end
    return math.floor(v)
end

-- Export the table
return WardrobeConfig
