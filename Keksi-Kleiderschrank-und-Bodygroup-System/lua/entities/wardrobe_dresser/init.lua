-- Server-side Entity für Keksi Kleiderschrank
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_c17/FurnitureDresser001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:SetMass(100) -- Nicht zu schwer, nicht zu leicht
    end
    
    -- Setze Material falls gewünscht
    -- self:SetMaterial("materials/path/to/custom/material.vmt")
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    
    -- Load config
    local cfg = include("wardrobe/sh_config.lua")
    if not cfg then return end
    
    -- Prüfe Distanz
    local distance = activator:GetPos():Distance(self:GetPos())
    if distance > (cfg.Dresser.max_distance or 100) then return end
    
    -- Network strings müssen bereits vom autorun script registriert sein
    net.Start("Wardrobe_OpenFromDresser")
    net.Send(activator)
    
    -- Keine Chat-Nachricht beim Öffnen
    
    -- Sound effect (optional)
    self:EmitSound("doors/door_wood_open1.wav", 60, 100)
end

-- Verhindere Duplikator-Probleme
function ENT:OnDuplicated()
    self:Initialize()
end