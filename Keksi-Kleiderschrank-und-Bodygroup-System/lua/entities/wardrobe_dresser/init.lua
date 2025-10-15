--[[
    Keksi Kleiderschrank - Dresser Entity (Server)
    ==============================================
    
    Diese Datei enthält die Server-seitige Logik der Kleiderschrank-Entity.
    Sie behandelt:
    - Entity-Initialisierung und Physik
    - Spieler-Interaktionen (E-Taste)
    - Distanz-Validierung
    - Netzwerk-Kommunikation mit dem Client
    
    Entwickelt von: Imperator Keksi
    https://guns.lol/imperatorkeksi
--]]

-- Client-Dateien für Download verfügbar machen
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

-- Shared-Definitionen einbinden
include("shared.lua")

-- Entity wird initialisiert (beim Spawnen)
function ENT:Initialize()
    -- 3D-Model setzen
    self:SetModel("models/props_c17/FurnitureDresser001a.mdl")
    
    -- Physik-System initialisieren
    self:PhysicsInit(SOLID_VPHYSICS)    -- Vollständige VPhysics-Kollision
    self:SetMoveType(MOVETYPE_VPHYSICS) -- Kann von Physik bewegt werden
    self:SetSolid(SOLID_VPHYSICS)       -- Solide für VPhysics
    self:SetUseType(SIMPLE_USE)         -- Kann mit E-Taste verwendet werden
    
    -- Physik-Objekt konfigurieren
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()         -- Physik aktivieren
        phys:SetMass(100)   -- Masse setzen (nicht zu schwer, nicht zu leicht)
    end
    
    -- Optional: Benutzerdefiniertes Material setzen
    -- self:SetMaterial("materials/path/to/custom/material.vmt")
end

-- Wird aufgerufen, wenn ein Spieler die Entity benutzt (E-Taste)
function ENT:Use(activator, caller)
    -- Sicherheitsprüfungen
    if not IsValid(activator) or not activator:IsPlayer() then return end
    
    -- Konfiguration laden
    local cfg = include("wardrobe/sh_config.lua")
    if not cfg then return end
    
    -- Distanz prüfen (Anti-Cheat: Spieler muss nah genug sein)
    local distance = activator:GetPos():Distance(self:GetPos())
    if distance > (cfg.Dresser.max_distance or 100) then return end
    
    -- Kleiderschrank für den Spieler öffnen
    -- (Network String muss bereits vom autorun Script registriert sein)
    net.Start("Wardrobe_OpenFromDresser")
    net.Send(activator)
    
    -- Optional: Sound-Effekt beim Öffnen
    self:EmitSound("doors/door_wood_open1.wav", 60, 100)
end

-- Verhindert Probleme beim Duplizieren (Advanced Duplicator 2)
function ENT:OnDuplicated()
    self:Initialize()
end