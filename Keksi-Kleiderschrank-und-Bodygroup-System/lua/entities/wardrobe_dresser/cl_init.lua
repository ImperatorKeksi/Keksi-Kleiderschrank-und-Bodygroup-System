-- Client-side Entity für Keksi Kleiderschrank
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_c17/FurnitureDresser001a.mdl")
end

function ENT:Draw()
    self:DrawModel()
end

-- Optional: Hints wenn man nahe ist
function ENT:Think()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    
    local distance = ply:GetPos():Distance(self:GetPos())
    if distance <= 150 then -- Etwas größere Distanz für Hints
        -- Hint wird bereits vom HUDPaint Hook im autorun script gehandelt
    end
end