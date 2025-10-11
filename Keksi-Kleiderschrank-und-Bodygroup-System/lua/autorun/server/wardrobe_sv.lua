-- Server-side logic for Keksi Kleiderschrank
-- Handles persistence, validation and secure networking
if not SERVER then return end

AddCSLuaFile("wardrobe/sh_config.lua") -- make config available to clients (autorun/shared style)

-- Load config
local cfg = include("wardrobe/sh_config.lua") or WardrobeConfig
if not cfg then
    error("[Keksi Kleiderschrank] Failed to load configuration file")
end

util.AddNetworkString("Wardrobe_RequestSets")
util.AddNetworkString("Wardrobe_SyncSets")
util.AddNetworkString("Wardrobe_ApplySet")
util.AddNetworkString("Wardrobe_SaveSet")
util.AddNetworkString("Wardrobe_Notify")

local function playerDataPath(ply)
    local id = ply:SteamID64() or tostring(ply:SteamID())
    return string.format("%s/%s.txt", cfg.Save.folder, id)
end

-- Validate a single bodygroup entry against player's model
local function validateBodygroupEntry(ply, bg)
    -- bg should be table: {name = "", index = 0, value = 0}
    if not istable(bg) then return false end
    local name = tostring(bg.name or "")
    local index = tonumber(bg.index)
    local value = tonumber(bg.value)
    if not name or index == nil or value == nil then return false end

    local bgs = ply:GetBodyGroups() or {}
    local found = false
    for _, descriptor in ipairs(bgs) do
        if descriptor.name == name and descriptor.id == index then
            found = true
            -- clamp value to allowed range
            value = math.Clamp(math.floor(value), 0, descriptor.num - 1)
            break
        end
    end
    return found, index, value
end

-- Load saved sets for a player
local function loadSets(ply)
    local path = playerDataPath(ply)
    if not file.Exists(path, "DATA") then return {} end
    local raw = file.Read(path, "DATA")
    if not raw or raw == "" then return {} end
    local ok, t = pcall(util.JSONToTable, raw)
    if not ok or not istable(t) then return {} end
    return t
end

-- Save sets for a player
local function saveSets(ply, sets)
    if not istable(sets) then return false end
    -- enforce max sets
    while #sets > cfg.Save.max_sets do
        table.remove(sets, 1)
    end
    local raw = util.TableToJSON(sets)
    if string.len(raw) > cfg.Save.max_set_size_kb * 1024 then return false end
    local path = playerDataPath(ply)
    file.CreateDir(cfg.Save.folder)
    file.Write(path, raw)
    return true
end

-- When client requests their sets
net.Receive("Wardrobe_RequestSets", function(len, ply)
    -- send back player's saved sets
    local sets = loadSets(ply)
    net.Start("Wardrobe_SyncSets")
        net.WriteTable(sets)
    net.Send(ply)
end)

-- Save a set from client
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

    -- load existing and append
    local sets = loadSets(ply)
    table.insert(sets, { name = name, bodygroups = safe, time = os.time() })
    if not saveSets(ply, sets) then
        net.Start("Wardrobe_Notify") net.WriteString("Speichern fehlgeschlagen (Größe/Limit)") net.Send(ply)
        return
    end

    net.Start("Wardrobe_Notify") net.WriteString('Du hast dein Set "' .. name .. '" gespeichert') net.Send(ply)
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

    -- validate then apply
    local applied = 0
    for _, bg in ipairs(set.bodygroups or {}) do
        local found, idx, val = validateBodygroupEntry(ply, bg)
        if found then
            ply:SetBodygroup(idx, val)
            applied = applied + 1
        end
    end

    -- Nur Chat-Nachricht bei gespeicherten Sets mit Namen
    local setName = set.name
    if setName and setName ~= "" and string.len(setName) > 0 then
        -- Gespeichertes Set wurde angewendet
        net.Start("Wardrobe_Notify") 
        net.WriteString('Du hast dich umgezogen und benutzt jetzt dein Set "' .. setName .. '"') 
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



print("[Wardrobe] Server module loaded")
