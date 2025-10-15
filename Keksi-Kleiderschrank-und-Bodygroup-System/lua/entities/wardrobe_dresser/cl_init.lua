--[[
    Keksi Kleiderschrank - Dresser Entity (Client)
    ==============================================
    
    Diese Datei enthält die Client-seitige Logik der Kleiderschrank-Entity.
    Sie behandelt:
    - Entity-Rendering und Darstellung
    - Interaktions-Hints für Spieler
    - Visuelle Effekte (falls gewünscht)
    
    Entwickelt von: Imperator Keksi
    https://guns.lol/imperatorkeksi
--]]

-- Shared-Definitionen einbinden
include("shared.lua")

-- Entity wird client-seitig initialisiert
function ENT:Initialize()
    -- 3D-Model setzen (muss identisch mit Server sein)
    self:SetModel("models/props_c17/FurnitureDresser001a.mdl")
end

-- Entity wird gerendert/gezeichnet
function ENT:Draw()
    -- Standard-Model-Rendering
    self:DrawModel()
    
    -- Hier könnten zusätzliche visuelle Effekte hinzugefügt werden:
    -- - Glow-Effekte bei Nähe
    -- - Partikel-Effekte
    -- - Zusätzliche Overlays
end

-- Entity-Update-Schleife (optional)
function ENT:Think()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    
    -- Distanz zum Spieler berechnen
    local distance = ply:GetPos():Distance(self:GetPos())
    if distance <= 150 then -- Etwas größere Distanz für Hints
        -- Interaktions-Hinweise werden vom HUDPaint Hook im Autorun-Script behandelt
        -- Hier könnten zusätzliche Nähe-Effekte implementiert werden
    end
end