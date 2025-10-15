--[[
    Keksi Kleiderschrank - Shared Autorun
    =====================================
    
    Diese Datei sorgt dafür, dass die Shared-Konfiguration sowohl auf Client als auch Server geladen wird.
    Sie wird automatisch beim Laden des Addons ausgeführt.
    
    Entwickelt von: Imperator Keksi
    https://guns.lol/imperatorkeksi
--]]

-- Server: Konfiguration für Clients verfügbar machen
if SERVER then 
    AddCSLuaFile("wardrobe/sh_config.lua") 
end

-- Client: Konfiguration einbinden
if CLIENT then 
    include("wardrobe/sh_config.lua") 
end
