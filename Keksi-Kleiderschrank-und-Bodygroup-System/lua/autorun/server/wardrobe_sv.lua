--[[
    Keksi Kleiderschrank - Server Logic
    ===================================
    
    Diese Datei enthält die gesamte Server-seitige Logik des Kleiderschrank-Systems.
    Sie behandelt:
    - Datenpersistierung (Speicherung der Spieler-Sets)
    - Validierung von Bodygroup-Änderungen
    - Sichere Netzwerkkommunikation
    - Anti-Spam und Sicherheitsmaßnahmen
    
    Entwickelt von: Imperator Keksi
    https://guns.lol/imperatorkeksi
--]]

-- Nur auf Server ausführen
if not SERVER then return end

-- Konfiguration für Clients verfügbar machen
AddCSLuaFile("wardrobe/sh_config.lua")

-- Konfiguration laden
local cfg = include("wardrobe/sh_config.lua") or WardrobeConfig
if not cfg then
    error("[Keksi Kleiderschrank] Fehler beim Laden der Konfigurationsdatei")
end

--[[
    Netzwerk-Strings registrieren
    =============================
    Alle Nachrichten zwischen Client und Server werden hier definiert.
--]]
util.AddNetworkString("Wardrobe_RequestSets")  -- Client fragt nach seinen Sets
util.AddNetworkString("Wardrobe_SyncSets")     -- Server sendet Sets an Client
util.AddNetworkString("Wardrobe_ApplySet")     -- Client möchte Set anwenden
util.AddNetworkString("Wardrobe_SaveSet")      -- Client möchte Set speichern
util.AddNetworkString("Wardrobe_Notify")       -- Server sendet Benachrichtigung an Client
util.AddNetworkString("Wardrobe_ChangeSkin")   -- Client möchte Skin ändern

--[[
    Hilfsfunktionen für Datenpfade und Validierung
    ==============================================
--]]

-- Erstellt den Dateipfad für Spielerdaten basierend auf SteamID64
local function playerDataPath(ply)
    local id = ply:SteamID64() or tostring(ply:SteamID())
    return string.format("%s/%s.txt", cfg.Save.folder, id)
end

-- Validiert einen einzelnen Bodygroup-Eintrag gegen das Spieler-Model
local function validateBodygroupEntry(ply, bg)
    -- bg sollte eine Tabelle sein: {name = "", index = 0, value = 0}
    if not istable(bg) then return false end
    local name = tostring(bg.name or "")
    local index = tonumber(bg.index)
    local value = tonumber(bg.value)
    if not name or index == nil or value == nil then return false end

    -- Verfügbare Bodygroups des Spielers abrufen
    local bgs = ply:GetBodyGroups() or {}
    local found = false
    for _, descriptor in ipairs(bgs) do
        if descriptor.name == name and descriptor.id == index then
            found = true
            -- Wert auf erlaubten Bereich begrenzen (Anti-Cheat)
            value = math.Clamp(math.floor(value), 0, descriptor.num - 1)
            break
        end
    end
    return found, index, value
end

-- Lädt gespeicherte Sets für einen Spieler von der Festplatte
local function loadSets(ply)
    local path = playerDataPath(ply)
    if not file.Exists(path, "DATA") then return {} end
    local raw = file.Read(path, "DATA")
    if not raw or raw == "" then return {} end
    -- Sichere JSON-Dekodierung mit Fehlerbehandlung
    local ok, t = pcall(util.JSONToTable, raw)
    if not ok or not istable(t) then return {} end
    return t
end

-- Speichert Sets für einen Spieler auf die Festplatte
local function saveSets(ply, sets)
    if not istable(sets) then return false end
    -- Maximale Anzahl Sets durchsetzen (älteste entfernen falls zu viele)
    while #sets > cfg.Save.max_sets do
        table.remove(sets, 1)
    end
    -- JSON kodieren und Größe prüfen (Anti-Spam Schutz)
    local raw = util.TableToJSON(sets)
    if string.len(raw) > cfg.Save.max_set_size_kb * 1024 then return false end
    -- Datei schreiben
    local path = playerDataPath(ply)
    file.CreateDir(cfg.Save.folder)
    file.Write(path, raw)
    return true
end

--[[
    Netzwerk-Empfänger (Network Receivers)
    ======================================
    Hier werden alle eingehenden Client-Nachrichten verarbeitet.
--]]

-- Client fragt nach seinen gespeicherten Sets
net.Receive("Wardrobe_RequestSets", function(len, ply)
    -- Sets vom Spieler laden und zurücksenden
    local sets = loadSets(ply)
    net.Start("Wardrobe_SyncSets")
        net.WriteTable(sets)
    net.Send(ply)
end)

-- Client möchte ein Set speichern
net.Receive("Wardrobe_SaveSet", function(len, ply)
    if not IsValid(ply) then return end
    -- security: cap read size
    if len > cfg.Network.max_payload_kb * 1024 then
        net.Start("Wardrobe_Notify") net.WriteString("Payload too large") net.Send(ply)
        return
    end

    local ok, data = pcall(net.ReadTable)
    if not ok or not istable(data) then
        net.Start("Wardrobe_Notify") net.WriteString("Ungültige Daten") net.Send(ply)
        return
    end

    -- Check if this is a "replace all sets" action (for deleting)
    if data.action == "replace_all" and data.sets then
        -- Validate all sets in the list
        local validatedSets = {}
        for _, set in ipairs(data.sets) do
            if istable(set) and set.bodygroups then
                local name = tostring(set.name or "")
                local safe = {}
                for _, bg in ipairs(set.bodygroups or {}) do
                    local found, idx, val = validateBodygroupEntry(ply, bg)
                    if found then
                        table.insert(safe, {name = bg.name, index = idx, value = val})
                    end
                end
                table.insert(validatedSets, { name = name, bodygroups = safe, time = set.time or os.time() })
            end
        end
        
        -- Save the complete list (replaces existing)
        if saveSets(ply, validatedSets) then
            -- Keine Chat-Nachricht beim Löschen - wird client-seitig behandelt
        else
            net.Start("Wardrobe_Notify") net.WriteString("Fehler beim Löschen des Sets") net.Send(ply)
        end
        return
    end

    -- Normal single set save (legacy behavior)
    local name = tostring(data.name or "")
    local bodygroups = data.bodygroups or {}
    local safe = {}
    for _, bg in ipairs(bodygroups) do
        local found, idx, val = validateBodygroupEntry(ply, bg)
        if found then
            table.insert(safe, {name = bg.name, index = idx, value = val})
        end
    end

    -- Skin-Validierung hinzufügen
    local skinValue = 0
    if data.skin and isnumber(data.skin) then
        local maxSkins = ply:SkinCount() or 1
        if data.skin >= 0 and data.skin < maxSkins then
            skinValue = data.skin
        end
    end

    -- Load existing and append (mit Skin-Support)
    local sets = loadSets(ply)
    table.insert(sets, { 
        name = name, 
        bodygroups = safe, 
        skin = skinValue,  -- Skin hinzufügen!
        time = os.time() 
    })
    
    if not saveSets(ply, sets) then
        net.Start("Wardrobe_Notify") net.WriteString("Speichern fehlgeschlagen (Größe/Limit)") net.Send(ply)
        return
    end

    net.Start("Wardrobe_Notify") net.WriteString('Du hast dein Set "' .. name .. '" gespeichert (mit Skin)') net.Send(ply)
end)

-- Apply a set requested by client
local lastApply = {}
net.Receive("Wardrobe_ApplySet", function(len, ply)
    if not IsValid(ply) then return end
    local now = CurTime()
    if lastApply[ply] and now - lastApply[ply] < cfg.Network.throttled_seconds then
        -- Stummes Throttling - keine Chat-Nachricht
        return
    end
    lastApply[ply] = now

    if len > cfg.Network.max_payload_kb * 1024 then
        -- Stumme Payload-Verweigerung
        return
    end

    local ok, set = pcall(net.ReadTable)
    if not ok or not istable(set) then
        net.Start("Wardrobe_Notify") net.WriteString("Ungültiges Set") net.Send(ply)
        return
    end

    -- Validate und apply Bodygroups
    local applied = 0
    for _, bg in ipairs(set.bodygroups or {}) do
        local found, idx, val = validateBodygroupEntry(ply, bg)
        if found then
            ply:SetBodygroup(idx, val)
            applied = applied + 1
        end
    end
    
    -- Validate und apply Skin (falls vorhanden)
    if set.skin and isnumber(set.skin) then
        local maxSkins = ply:SkinCount() or 1
        if set.skin >= 0 and set.skin < maxSkins then
            ply:SetSkin(set.skin)
            applied = applied + 1
        end
    end

    -- Chat-Nachricht bei gespeicherten Sets
    local setName = set.name
    if setName and setName ~= "" and string.len(setName) > 0 then
        net.Start("Wardrobe_Notify") 
        net.WriteString('Du hast dich umgezogen und benutzt jetzt dein Set "' .. setName .. '" (Bodygroups + Skin)') 
        net.Send(ply)
    end
    -- Stumm bei einzelnen Bodygroup-Änderungen (haben keinen Namen)
end)

-- Utility console command for admins to clear a player's sets (example of secure server-only action)
concommand.Add("wardrobe_clear_sets", function(admin, cmd, args)
    if not IsValid(admin) or not admin:IsAdmin() then
        return
    end
    local target = args[1]
    if not target then return end
    local ply = player.GetBySteamID(target) or player.GetBySteamID64(target)
    if not IsValid(ply) then
        print("Spieler nicht gefunden")
        return
    end
    local path = playerDataPath(ply)
    if file.Exists(path, "DATA") then
        file.Delete(path)
        print("Sets gelöscht für", ply:Nick())
    end
end)

-- Dresser interaction system - Network strings für Entity
util.AddNetworkString("Wardrobe_OpenFromDresser")

-- ====================================================================
-- 🎨 SKIN-HANDLER (Diskret ins Original-System integriert)
-- ====================================================================

-- Skin-Validierung
local function isValidSkin(ply, skinId)
    if not IsValid(ply) then return false end
    local maxSkins = ply:SkinCount() or 1
    return skinId >= 0 and skinId < maxSkins
end

-- Network Handler: Skin ändern
net.Receive("Wardrobe_ChangeSkin", function(len, ply)
    local skinId = net.ReadInt(8)
    
    if not isValidSkin(ply, skinId) then
        ply:ChatPrint("[Wardrobe] Ungültiger Skin für dein Model!")
        return
    end
    
    ply:SetSkin(skinId)
    
    -- Optional: Log für Admins
    if cfg.Debug and cfg.Debug.log_changes then
        print(string.format("[Wardrobe] %s hat Skin geändert zu: %d", ply:Nick(), skinId))
    end
end)

print("[Wardrobe] Server module loaded mit Skin-Unterstützung")
