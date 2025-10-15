-- Client-side UI and networking for Keksi Kleiderschrank
if not CLIENT then return end

include("wardrobe/sh_config.lua")
local cfg = WardrobeConfig

-- Safety fallback für fehlende Konfiguration
if not cfg or not cfg.Colors then
    print("[Keksi Kleiderschrank] Config nicht gefunden - verwende Fallback-Farben")
    cfg = cfg or {}
    cfg.Colors = {
        primary = Color(120, 80, 255, 255),
        secondary = Color(80, 60, 180, 255),
        dark = Color(40, 30, 80, 255),
        background = Color(0, 0, 0, 255),
        glow = Color(120, 80, 255, 100),
        warning = Color(255, 102, 102, 255),
        danger = Color(255, 102, 102, 255),
        success = Color(100, 200, 255, 255),
        text = Color(240, 240, 245, 255),
        text_muted = Color(100, 80, 160, 255),
        panel = Color(40, 30, 80, 240),
        accent = Color(120, 80, 255, 255),
        hover = Color(80, 60, 180, 200)
    }
    cfg.Fonts = cfg.Fonts or {
        header = {name = "KeksiKleiderschrank.Header", font = "DermaLarge", size = 22, weight = 700},
        normal = {name = "KeksiKleiderschrank.Normal", font = "DermaDefault", size = 14, weight = 500},
        small = {name = "KeksiKleiderschrank.Small", font = "DermaDefaultSmall", size = 12, weight = 400}
    }
    cfg.PrintName = cfg.PrintName or "Keksi Kleiderschrank"
end

-- Globale Variablen für Set-Management
local currentSets = {}
local globalBuildSets = nil

net.Receive("Wardrobe_SyncSets", function()
    local sets = net.ReadTable() or {}
    currentSets = sets -- Speichere Sets global
    
    -- Globale Update-Funktionen und Variablen (gleich am Anfang definiert)
    local allBgButtons = {} -- Speichere alle Buttons für Updates
    local allCurrentLabels = {} -- Speichere alle aktuell-Labels
    
    -- Wenn Wardrobe bereits offen ist, aktualisiere nur die Sets
    if IsValid(WardrobeFrame) and globalBuildSets then
        globalBuildSets()
        return
    end
    
    -- Öffne neues Wardrobe oder entferne altes
    if IsValid(WardrobeFrame) then
        WardrobeFrame:Remove()
    end
    
    -- Fullscreen UI erstellen
    local scrW, scrH = ScrW(), ScrH()
    WardrobeFrame = vgui.Create("DFrame")
    WardrobeFrame:SetTitle("")
    WardrobeFrame:SetSize(scrW, scrH)
    WardrobeFrame:SetPos(0, 0)
    WardrobeFrame:MakePopup()
    WardrobeFrame:ShowCloseButton(false) -- Eigenen Close Button erstellen
    WardrobeFrame.Paint = function(s, w, h)
        -- Dunkler Vollbild-Hintergrund
        draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 250))
    end

    local padding = cfg.UI.padding
    local scrW, scrH = ScrW(), ScrH()
    
    -- Header mit Titel und Close Button
    local header = vgui.Create("DPanel", WardrobeFrame)
    header:SetPos(0, 0)
    header:SetSize(scrW, 60)
    header.Paint = function(s, w, h)
        -- Gradient Header
        draw.RoundedBox(0, 0, 0, w, h, cfg.Colors.panel)
        draw.RoundedBox(0, 0, h-2, w, 2, cfg.Colors.accent) -- Accent line
        draw.SimpleText(cfg.PrintName, cfg.Fonts.header.name, padding * 2, h/2, cfg.Colors.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    -- Close Button
    local closeBtn = vgui.Create("DButton", header)
    closeBtn:SetPos(scrW - 100, 15)
    closeBtn:SetSize(80, 30)
    closeBtn:SetText("Schließen")
    closeBtn:SetFont(cfg.Fonts.normal.name)
    closeBtn:SetTextColor(cfg.Colors.text)
    closeBtn.Paint = function(s, w, h)
        local col = s:IsHovered() and cfg.Colors.danger or cfg.Colors.hover
        draw.RoundedBox(6, 0, 0, w, h, col)
    end
    closeBtn.DoClick = function()
        WardrobeFrame:Remove()
    end
    
    -- ESC key zum Schließen
    WardrobeFrame.OnKeyCodePressed = function(self, key)
        if key == KEY_ESCAPE then
            self:Remove()
        end
    end
    
    -- Drei-Spalten Layout
    local contentY = 60
    local contentH = scrH - contentY
    local leftW = scrW * 0.3  -- 30% für Model Preview
    local middleW = scrW * 0.4 -- 40% für Bodygroup Controls  
    local rightW = scrW * 0.3  -- 30% für Saved Sets

    -- Linke Spalte: Model Preview
    local leftPanel = vgui.Create("DPanel", WardrobeFrame)
    leftPanel:SetPos(padding, contentY + padding)
    leftPanel:SetSize(leftW - padding*2, contentH - padding*2)
    leftPanel.Paint = function(s, w, h) 
        draw.RoundedBox(8, 0, 0, w, h, cfg.Colors.dark)
        -- Titel-Bereich mit Lila-Blau
        draw.RoundedBox(8, 0, 0, w, 40, cfg.Colors.secondary)
        draw.RoundedBox(8, 2, 2, w-4, 36, cfg.Colors.glow)
        draw.SimpleText("Model Vorschau", cfg.Fonts.header.name, padding, 20, cfg.Colors.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    -- Model Preview (fast Vollbild in der linken Spalte)
    local modelPreview = vgui.Create("DModelPanel", leftPanel)
    modelPreview:SetSize(leftW - padding*4, contentH - 100)
    modelPreview:SetPos(padding, 50)
    modelPreview:SetModel(LocalPlayer():GetModel())
    modelPreview:SetLookAt(Vector(0,0,60))
    modelPreview:SetCamPos(Vector(80,0,60))
    modelPreview:SetFOV(70)
    
    -- WICHTIG: Sync mit aktuellen Spieler-Einstellungen beim Öffnen
    local function syncModelPreviewWithPlayer()
        local ply = LocalPlayer()
        if IsValid(modelPreview) and IsValid(modelPreview.Entity) and IsValid(ply) then
            -- Sync Model
            modelPreview:SetModel(ply:GetModel())
            
            -- Sync alle Bodygroups
            local bodygroups = ply:GetBodyGroups() or {}
            for _, bg in ipairs(bodygroups) do
                local currentValue = ply:GetBodygroup(bg.id)
                modelPreview.Entity:SetBodygroup(bg.id, currentValue)
            end
            
            -- Sync Skin
            local currentSkin = ply:GetSkin() or 0
            modelPreview.Entity:SetSkin(currentSkin)
        end
    end
    
    -- Update Model Preview (lokale Hilfsfunktion)
    local function updateModelPreview()
        if IsValid(modelPreview) then
            local ply = LocalPlayer()
            local ent = modelPreview.Entity
            if IsValid(ent) then
                -- Update Bodygroups
                for _, bg in ipairs(ply:GetBodyGroups()) do
                    local currentValue = ply:GetBodygroup(bg.id)
                    ent:SetBodygroup(bg.id, currentValue)
                end
                
                -- Update Skin
                local currentSkin = ply:GetSkin() or 0
                ent:SetSkin(currentSkin)
            end
        end
    end
    
    -- Sync beim ersten Laden
    timer.Simple(0.1, function()
        syncModelPreviewWithPlayer()
    end)
    
    -- Kamera und Animations-System
    local camDistance = 80
    local camAngle = 0
    local autoRotate = true
    local lastInteraction = CurTime()
    local autoRotateSpeed = 15 -- Grad pro Sekunde
    
    -- Normale Laufanimation setzen
    modelPreview.LayoutEntity = function(self, ent)
        if IsValid(ent) then
            -- Setze normale Laufanimation
            local walkSeq = ent:LookupSequence("walk_all") or ent:LookupSequence("WalkUnarmed") or ent:LookupSequence("walk") or 0
            if walkSeq > 0 then
                ent:ResetSequence(walkSeq)
                ent:SetPlaybackRate(0.5) -- Langsamere Geschwindigkeit
            end
            
            -- Automatische Rotation wenn keine Interaktion
            local currentTime = CurTime()
            if autoRotate and (currentTime - lastInteraction > 3) then
                camAngle = camAngle + autoRotateSpeed * FrameTime()
                local x = math.sin(math.rad(camAngle)) * camDistance
                local y = math.cos(math.rad(camAngle)) * camDistance
                self:SetCamPos(Vector(x, y, 60))
            end
            
            -- Manueller Drag-Modus
            if self.Pressed then
                local mx, my = gui.MousePos()
                local deltaX = mx - (self.PressX or mx)
                camAngle = camAngle + deltaX * 0.5
                
                local x = math.sin(math.rad(camAngle)) * camDistance
                local y = math.cos(math.rad(camAngle)) * camDistance
                self:SetCamPos(Vector(x, y, 60))
                
                self.PressX, self.PressY = mx, my
                lastInteraction = currentTime -- Reset auto-rotate timer
            end
        end
    end
    
    -- Maus-Steuerung
    modelPreview.DragMousePress = function(self)
        self.PressX, self.PressY = gui.MousePos()
        self.Pressed = true
        lastInteraction = CurTime()
    end
    
    modelPreview.DragMouseRelease = function(self)
        self.Pressed = false
    end
    
    modelPreview.OnMouseWheeled = function(self, delta)
        camDistance = math.Clamp(camDistance - delta * 10, 30, 200)
        local x = math.sin(math.rad(camAngle)) * camDistance
        local y = math.cos(math.rad(camAngle)) * camDistance
        self:SetCamPos(Vector(x, y, 60))
        lastInteraction = CurTime() -- Reset auto-rotate timer
    end
    
    -- Steuerungs-Hinweise
    local controlsPanel = vgui.Create("DPanel", leftPanel)
    controlsPanel:SetPos(padding, leftPanel:GetTall() - 40)
    controlsPanel:SetSize(leftW - padding*4, 30)
    controlsPanel.Paint = function(s, w, h)
        draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.hover)
        draw.SimpleText("Maus: Drehen | Mausrad: Zoom | Auto-Rotation nach 3s", cfg.Fonts.small.name, 8, h/2, cfg.Colors.text_muted, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    -- Mittlere Spalte: Bodygroup Controls
    local middlePanel = vgui.Create("DPanel", WardrobeFrame)
    middlePanel:SetPos(leftW + padding, contentY + padding)
    middlePanel:SetSize(middleW - padding*2, contentH - padding*2)
    middlePanel.Paint = function(s, w, h) 
        draw.RoundedBox(8, 0, 0, w, h, cfg.Colors.dark)
        -- Titel-Bereich mit Lila-Blau 
        draw.RoundedBox(8, 0, 0, w, 50, cfg.Colors.secondary)
        draw.RoundedBox(8, 2, 2, w-4, 46, cfg.Colors.glow)
        draw.SimpleText("Bodygroup-System", cfg.Fonts.header.name, padding, 25, cfg.Colors.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local bodygroupScroll = vgui.Create("DScrollPanel", middlePanel)
    bodygroupScroll:SetPos(padding, 60)
    bodygroupScroll:SetSize(middleW - padding*4, contentH - 90)
    
    -- ====================================================================
    -- 🎨 SKIN-SEKTION (Diskret ins Original-Design integriert)
    -- ====================================================================
    
    local ply = LocalPlayer()
    local numSkins = ply:SkinCount() or 0
    local currentSkin = ply:GetSkin() or 0
    
    if numSkins > 1 then -- Nur anzeigen wenn Model mehrere Skins hat
        local skinPanel = bodygroupScroll:Add("DPanel")
        local skinButtonCount = numSkins
        local skinRowsNeeded = math.ceil(skinButtonCount / 3)
        local skinPanelHeight = 150 + (skinRowsNeeded - 1) * 60
        skinPanel:SetTall(skinPanelHeight)
        skinPanel:Dock(TOP)
        skinPanel:DockMargin(8, 8, 8, 20)
        skinPanel.Paint = function(s,w,h) 
            -- Gleicher Stil wie Bodygroups - Lila-Blau Gradient Background
            draw.RoundedBox(12, 0, 0, w, h, cfg.Colors.dark)
            draw.RoundedBox(12, 2, 2, w-4, h-4, cfg.Colors.glow)
            draw.RoundedBox(12, 4, 4, w-8, h-8, Color(cfg.Colors.dark.r + 15, cfg.Colors.dark.g + 15, cfg.Colors.dark.b + 15, 200))
            -- Subtiler Schatten-Effekt
            draw.RoundedBox(12, 1, 1, w-2, 2, cfg.Colors.glow)
        end

        -- Skin Header (im Original-Stil)
        local skinLbl = vgui.Create("DLabel", skinPanel)
        skinLbl:SetText("Model Skins")
        skinLbl:SetFont(cfg.Fonts.header.name)
        skinLbl:SetTextColor(cfg.Colors.primary) -- Lila-Blau wie Bodygroups
        skinLbl:SetPos(padding + 12, 25)
        skinLbl:SizeToContents()

        -- Current Skin Display (im Original-Stil)
        local currentSkinLbl = vgui.Create("DLabel", skinPanel)
        currentSkinLbl:SetText("Aktueller Skin: " .. currentSkin .. " / " .. (numSkins - 1))
        currentSkinLbl:SetFont(cfg.Fonts.normal.name)
        currentSkinLbl:SetTextColor(cfg.Colors.success)
        currentSkinLbl:SetPos(padding + 12, 55)
        currentSkinLbl:SizeToContents()
        
        -- Skin-Buttons (Gleicher Stil wie Bodygroup-Buttons)
        local buttonY = 95
        local buttonX = padding + 20
        local buttonsPerRow = 3
        local buttonWidth = 130
        local buttonHeight = 45
        local buttonSpacing = 145
        
        for i = 0, numSkins - 1 do
            local btn = vgui.Create("DButton", skinPanel)
            btn:SetText("Skin " .. i)
            btn:SetFont(cfg.Fonts.normal.name)
            btn:SetPos(buttonX + (i % buttonsPerRow) * buttonSpacing, buttonY + math.floor(i / buttonsPerRow) * 60)
            btn:SetSize(buttonWidth, buttonHeight)
            btn:SetTextColor(cfg.Colors.text)
            
            local skinValue = i
            btn.isSelected = (currentSkin == skinValue)
            
            btn.Paint = function(s, w, h)
                if s.isSelected then
                    -- Ausgewählter Skin - Lila-Blau Primary mit Glow-Effekt (gleich wie Bodygroups)
                    draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.primary)
                    draw.RoundedBox(6, 2, 2, w-4, h-4, cfg.Colors.glow)
                    draw.RoundedBox(6, 4, 4, w-8, h-8, Color(cfg.Colors.primary.r + 30, cfg.Colors.primary.g + 30, cfg.Colors.primary.b + 30, 180))
                elseif s:IsHovered() then
                    -- Hover - Secondary Lila-Blau (gleich wie Bodygroups)
                    draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.secondary)
                    draw.RoundedBox(6, 2, 2, w-4, h-4, Color(cfg.Colors.secondary.r + 15, cfg.Colors.secondary.g + 15, cfg.Colors.secondary.b + 15, 150))
                else
                    -- Normal - Dark Lila-Blau (gleich wie Bodygroups)
                    draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.dark)
                    draw.RoundedBox(6, 1, 1, w-2, h-2, Color(cfg.Colors.dark.r + 10, cfg.Colors.dark.g + 10, cfg.Colors.dark.b + 10, 120))
                end
            end
            
            -- Speichere skinValue als Property für updateAllUI()
            btn.skinValue = skinValue
            
            btn.DoClick = function(self)
                -- Setze Skin lokal
                ply:SetSkin(skinValue)
                
                -- Update alle Skin-Buttons
                for j = 0, numSkins - 1 do
                    local otherBtn = skinPanel:GetChildren()[j + 3] -- +3 wegen Label-Offset
                    if IsValid(otherBtn) and otherBtn.isSelected ~= nil then
                        otherBtn.isSelected = (j == skinValue)
                    end
                end
                
                -- Update Label
                currentSkinLbl:SetText("Aktueller Skin: " .. skinValue .. " / " .. (numSkins - 1))
                
                -- Model Preview vollständig updaten
                updateModelPreview()
                syncModelPreviewWithPlayer()
                
                -- Send to server für Persistierung
                net.Start("Wardrobe_ChangeSkin")
                net.WriteInt(skinValue, 8)
                net.SendToServer()
            end
        end
    end

    -- Initialisiere die Button-Dictionaries für alle Bodygroups
    for _, bg in ipairs(LocalPlayer():GetBodyGroups() or {}) do
        allBgButtons[bg.id] = {}
    end
    
    -- Update nur eine spezifische Bodygroup
    local function updateSpecificBodygroup(bgId)
        local ply = LocalPlayer()
        local currentValue = ply:GetBodygroup(bgId)
        
        -- Update nur die Buttons dieser einen Bodygroup
        if allBgButtons[bgId] then
            for value, btn in pairs(allBgButtons[bgId]) do
                if IsValid(btn) then
                    btn.isSelected = (value == currentValue)
                end
            end
        end
        
        -- Update nur das Label dieser Bodygroup
        if IsValid(allCurrentLabels[bgId]) then
            allCurrentLabels[bgId]:SetText("Aktuell: Variante " .. (currentValue + 1))
        end
        
        updateModelPreview()
    end
    
    -- Update alle UI-Elemente nach kompletter Set-Änderung
    local function updateAllUI()
        local ply = LocalPlayer()
        
        -- Update Bodygroup Buttons
        for bgId, buttons in pairs(allBgButtons) do
            local currentValue = ply:GetBodygroup(bgId)
            -- Update alle Buttons für diese Bodygroup
            for value, btn in pairs(buttons) do
                if IsValid(btn) then
                    btn.isSelected = (value == currentValue)
                end
            end
        end
        
        -- Update Bodygroup Labels
        for bgId, label in pairs(allCurrentLabels) do
            if IsValid(label) then
                label:SetText("Aktuell: Variante " .. (ply:GetBodygroup(bgId) + 1))
            end
        end
        
        -- Update Skin Buttons (falls Skin-Panel existiert)
        if IsValid(skinPanel) then
            local currentSkin = ply:GetSkin()
            local children = skinPanel:GetChildren()
            
            -- Durchsuche alle Skin-Buttons
            for _, child in ipairs(children) do
                if IsValid(child) and child.skinValue ~= nil then -- Skin-Button erkannt
                    child.isSelected = (child.skinValue == currentSkin)
                end
            end
            
            -- Update Skin Label
            if IsValid(currentSkinLbl) then
                local numSkins = ply:SkinCount() or 1
                currentSkinLbl:SetText("Aktueller Skin: " .. currentSkin .. " / " .. (numSkins - 1))
            end
        end
        
        updateModelPreview()
    end

    local bgs = LocalPlayer():GetBodyGroups() or {}
    for _, bg in ipairs(bgs) do
        -- Buttons werden bereits oben initialisiert - nicht doppelt setzen!
        
        local bgPanel = bodygroupScroll:Add("DPanel")
        local buttonCount = bg.num
        local rowsNeeded = math.ceil(buttonCount / 3) -- 3 Buttons pro Reihe für mehr Platz
        local panelHeight = 150 + (rowsNeeded - 1) * 60 -- Noch viel größere Panels
        bgPanel:SetTall(panelHeight)
        bgPanel:Dock(TOP)
        bgPanel:DockMargin(8, 8, 8, 20) -- Noch mehr Abstand zwischen Panels
        bgPanel.Paint = function(s,w,h) 
            -- Lila-Blau Gradient Background mit Tiefe und Glow
            draw.RoundedBox(12, 0, 0, w, h, cfg.Colors.dark)
            draw.RoundedBox(12, 2, 2, w-4, h-4, cfg.Colors.glow)
            draw.RoundedBox(12, 4, 4, w-8, h-8, Color(cfg.Colors.dark.r + 15, cfg.Colors.dark.g + 15, cfg.Colors.dark.b + 15, 200))
            -- Subtiler Schatten-Effekt
            draw.RoundedBox(12, 1, 1, w-2, 2, cfg.Colors.glow)
        end

        -- Sauberer Bodygroup Name (ohne ID)
        local cleanName = string.gsub(bg.name, "_", " ")
        cleanName = string.gsub(cleanName, "^%l", string.upper) -- Ersten Buchstaben groß
        
        local lbl = vgui.Create("DLabel", bgPanel)
        lbl:SetText(cleanName)
        lbl:SetFont(cfg.Fonts.header.name) -- Größerer Font
        lbl:SetTextColor(cfg.Colors.primary) -- Lila-Blau für Header
        lbl:SetPos(padding + 12, 25) -- Noch mehr Abstand von oben
        lbl:SizeToContents()

        -- Current Value Display
        local currentLbl = vgui.Create("DLabel", bgPanel)
        currentLbl:SetText("Aktuell: Variante " .. (LocalPlayer():GetBodygroup(bg.id) + 1))
        currentLbl:SetFont(cfg.Fonts.normal.name) -- Größerer Font
        currentLbl:SetTextColor(cfg.Colors.success) -- Helles Blau für Status
        currentLbl:SetPos(padding + 12, 55) -- Mehr Abstand
        currentLbl:SizeToContents()
        
        -- Speichere Label für Updates
        allCurrentLabels[bg.id] = currentLbl

        -- Buttons für jede Bodygroup Option (noch größere Buttons mit mehr Abstand)
        local buttonY = 95 -- Noch mehr Abstand von oben
        local buttonX = padding + 20 -- Mehr Abstand von links
        local buttonsPerRow = 3 -- 3 Buttons pro Reihe
        local buttonWidth = 130 -- Noch breitere Buttons
        local buttonHeight = 45 -- Noch höhere Buttons
        local buttonSpacing = 145 -- Noch mehr Abstand zwischen Buttons
        
        for i = 0, bg.num - 1 do
            local btn = vgui.Create("DButton", bgPanel)
            btn:SetText("Variante " .. (i + 1))
            btn:SetFont(cfg.Fonts.normal.name) -- Größerer Font
            btn:SetPos(buttonX, buttonY)
            btn:SetSize(buttonWidth, buttonHeight)
            btn:SetTextColor(cfg.Colors.text)
            
            -- Eindeutige Closure für jeden Button
            local bgId = bg.id
            local bgName = bg.name
            local value = i
            btn.bgId = bgId
            btn.value = value
            btn.isSelected = (LocalPlayer():GetBodygroup(bgId) == value)
            
            -- Speichere Button
            allBgButtons[bgId][value] = btn
            
            btn.Paint = function(s, w, h)
                if s.isSelected then
                    -- Ausgewählter Button - Lila-Blau Primary mit Glow-Effekt
                    draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.primary)
                    draw.RoundedBox(6, 2, 2, w-4, h-4, cfg.Colors.glow)
                    draw.RoundedBox(6, 4, 4, w-8, h-8, Color(cfg.Colors.primary.r + 30, cfg.Colors.primary.g + 30, cfg.Colors.primary.b + 30, 180))
                elseif s:IsHovered() then
                    -- Hover - Secondary Lila-Blau
                    draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.secondary)
                    draw.RoundedBox(6, 2, 2, w-4, h-4, Color(cfg.Colors.secondary.r + 15, cfg.Colors.secondary.g + 15, cfg.Colors.secondary.b + 15, 150))
                else
                    -- Normal - Dark Lila-Blau
                    draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.dark)
                    draw.RoundedBox(6, 1, 1, w-2, h-2, Color(cfg.Colors.dark.r + 10, cfg.Colors.dark.g + 10, cfg.Colors.dark.b + 10, 120))
                end
            end
            
            btn.DoClick = function(self)
                -- Sichere Variablen aus dem Button selbst
                local targetBgId = self.bgId
                local targetValue = self.value
                
                -- Debug: Überprüfe ob die Werte korrekt sind
                if targetBgId == nil or targetValue == nil then
                    print("ERROR: Button-Variablen sind nil!")
                    return
                end
                
                -- Nur diese eine Bodygroup ändern
                LocalPlayer():SetBodygroup(targetBgId, targetValue)
                
                -- Nur die Buttons dieser einen Bodygroup updaten
                local currentValue = LocalPlayer():GetBodygroup(targetBgId)
                if allBgButtons[targetBgId] then
                    for val, button in pairs(allBgButtons[targetBgId]) do
                        if IsValid(button) then
                            button.isSelected = (val == currentValue)
                        end
                    end
                end
                
                -- Label für diese Bodygroup updaten
                if IsValid(allCurrentLabels[targetBgId]) then
                    allCurrentLabels[targetBgId]:SetText("Aktuell: Variante " .. (currentValue + 1))
                end
                
                -- Model Preview updaten
                updateModelPreview()
                
                -- Send nur diese eine Bodygroup to server
                net.Start("Wardrobe_ApplySet")
                    net.WriteTable({ bodygroups = { { name = bgName, index = targetBgId, value = targetValue } } })
                net.SendToServer()
            end
            
            buttonX = buttonX + buttonSpacing
            if (i + 1) % buttonsPerRow == 0 and i < bg.num - 1 then -- Neue Reihe
                buttonX = padding + 20
                buttonY = buttonY + 55 -- Noch mehr Abstand zwischen Reihen
            end
        end
    end

    -- Rechte Spalte: Saved Sets
    local rightPanel = vgui.Create("DPanel", WardrobeFrame)
    rightPanel:SetPos(leftW + middleW + padding, contentY + padding)
    rightPanel:SetSize(rightW - padding*2, contentH - padding*2)
    rightPanel.Paint = function(s,w,h) 
        draw.RoundedBox(8, 0, 0, w, h, cfg.Colors.dark)
        -- Titel-Bereich mit Lila-Blau
        draw.RoundedBox(8, 0, 0, w, 40, cfg.Colors.secondary)
        draw.RoundedBox(8, 2, 2, w-4, 36, cfg.Colors.glow)
        draw.SimpleText("Gespeicherte Sets", cfg.Fonts.header.name, padding, 20, cfg.Colors.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local setsScroll = vgui.Create("DScrollPanel", rightPanel)
    setsScroll:SetPos(padding, 40)
    setsScroll:SetSize(rightW - padding*4, contentH - 140)

    local function buildSets()
        setsScroll:Clear()
        for idx, s in ipairs(currentSets) do
            local pnl = setsScroll:Add("DPanel")
            pnl:SetTall(60)
            pnl:Dock(TOP)
            pnl:DockMargin(0, 0, 0, cfg.UI.spacing)
            pnl.Paint = function(s,w,h) 
                draw.RoundedBox(6, 0, 0, w, h, Color(50, 50, 50, 150)) 
            end

            local nm = vgui.Create("DLabel", pnl)
            nm:SetText(s.name or ("Set " .. idx))
            nm:SetFont(cfg.Fonts.normal.name)
            nm:SetTextColor(cfg.Colors.text)
            nm:SetPos(8, 8)
            nm:SizeToContents()
            
            -- Info über Bodygroup Anzahl
            local info = vgui.Create("DLabel", pnl)
            local bgCount = table.Count(s.bodygroups or {})
            info:SetText(bgCount .. " Bodygroups")
            info:SetFont(cfg.Fonts.small.name)
            info:SetTextColor(cfg.Colors.text_muted)
            info:SetPos(8, 28)
            info:SizeToContents()

            local applyBtn = vgui.Create("DButton", pnl)
            applyBtn:SetText("Anwenden")
            applyBtn:SetPos(rightW - 190, 8)
            applyBtn:SetSize(90, 44)
            applyBtn:SetTextColor(cfg.Colors.text)
            applyBtn.Paint = function(s, w, h)
                if s:IsHovered() then
                    -- Hover - helles Lila-Blau mit Glow
                    draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.primary)
                    draw.RoundedBox(6, 2, 2, w-4, h-4, cfg.Colors.glow)
                else
                    -- Normal - Success Blau 
                    draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.success)
                    draw.RoundedBox(6, 1, 1, w-2, h-2, Color(cfg.Colors.success.r + 20, cfg.Colors.success.g + 20, cfg.Colors.success.b + 20, 150))
                end
            end
            applyBtn.DoClick = function()
                net.Start("Wardrobe_ApplySet") 
                net.WriteTable(s) 
                net.SendToServer()
                
                -- Apply locally für sofortige Vorschau (Bodygroups + Skin!)
                local ply = LocalPlayer()
                
                -- Bodygroups anwenden
                for _, bg in ipairs(s.bodygroups or {}) do
                    ply:SetBodygroup(bg.index, bg.value)
                end
                
                -- Skin anwenden (falls im Set vorhanden)
                if s.skin and s.skin >= 0 then
                    ply:SetSkin(s.skin)
                    
                    -- Auch an Server senden für Persistierung
                    net.Start("Wardrobe_ChangeSkin")
                    net.WriteInt(s.skin, 8)
                    net.SendToServer()
                end
                
                updateAllUI() -- UI komplett aktualisieren
                syncModelPreviewWithPlayer() -- Model Preview syncen
                
                -- Erfolgssound
                ply:EmitSound("garrysmod/balloon_pop_cute.wav")
                
                -- Chat-Nachricht
                chat.AddText(Color(200,200,200), "[Keksi Kleiderschrank] ", cfg.Colors.primary, 'Set "' .. (s.name or "Unbenannt") .. '" angewendet')
            end

            local delBtn = vgui.Create("DButton", pnl)
            delBtn:SetText("X")
            delBtn:SetPos(rightW - 90, 8)
            delBtn:SetSize(44, 44)
            delBtn:SetTextColor(cfg.Colors.text)
            delBtn.Paint = function(s, w, h)
                if s:IsHovered() then
                    -- Hover - Danger Rot mit intensivem Glow
                    draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.danger)
                    draw.RoundedBox(6, 2, 2, w-4, h-4, Color(255, 102, 102, 120))
                else
                    -- Normal - dunkles Lila-Blau
                    draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.dark)
                    draw.RoundedBox(6, 1, 1, w-2, h-2, Color(cfg.Colors.dark.r + 15, cfg.Colors.dark.g + 15, cfg.Colors.dark.b + 15, 150))
                end
            end
            delBtn.DoClick = function()
                -- Bestätigungs-Dialog erstellen
                local confirmFrame = vgui.Create("DFrame")
                confirmFrame:SetTitle("Set löschen?")
                confirmFrame:SetSize(400, 200)
                confirmFrame:Center()
                confirmFrame:MakePopup()
                confirmFrame.Paint = function(s, w, h)
                    draw.RoundedBox(8, 0, 0, w, h, cfg.Colors.background)
                end
                
                local confirmText = vgui.Create("DLabel", confirmFrame)
                confirmText:SetText('Möchtest du das Set "' .. (s.name or "Unbenannt") .. '" wirklich löschen?')
                confirmText:SetFont(cfg.Fonts.normal.name)
                confirmText:SetTextColor(cfg.Colors.text)
                confirmText:SetPos(20, 60)
                confirmText:SetSize(360, 60)
                confirmText:SetWrap(true)
                
                local yesBtn = vgui.Create("DButton", confirmFrame)
                yesBtn:SetText("Ja, löschen")
                yesBtn:SetPos(50, 130)
                yesBtn:SetSize(120, 40)
                yesBtn:SetTextColor(cfg.Colors.text)
                yesBtn.Paint = function(s, w, h)
                    if s:IsHovered() then
                        -- Hover - Danger Rot mit Warning-Glow
                        draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.danger)
                        draw.RoundedBox(6, 2, 2, w-4, h-4, Color(255, 153, 153, 150))
                    else
                        -- Normal - dunkles Lila-Blau
                        draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.dark)
                        draw.RoundedBox(6, 1, 1, w-2, h-2, cfg.Colors.glow)
                    end
                end
                yesBtn.DoClick = function()
                    -- Set-Name für Nachricht merken
                    local setName = s.name or "Unbenannt"
                    
                    -- Set lokal entfernen
                    table.remove(currentSets, idx)
                    
                    -- Sende die aktualisierte Sets-Liste an den Server
                    -- Das nutzt das bestehende SaveSet-System
                    net.Start("Wardrobe_SaveSet")
                    net.WriteTable({
                        action = "replace_all",
                        sets = currentSets
                    })
                    net.SendToServer()
                    
                    -- Chat-Nachricht anzeigen
                    chat.AddText(Color(200,200,200), "[Keksi Kleiderschrank] ", cfg.Colors.primary, 'Set "' .. setName .. '" wurde gelöscht')
                    
                    -- UI sofort aktualisieren
                    buildSets()
                    confirmFrame:Remove()
                end
                
                local noBtn = vgui.Create("DButton", confirmFrame)
                noBtn:SetText("Abbrechen")
                noBtn:SetPos(230, 130)
                noBtn:SetSize(120, 40)
                noBtn:SetTextColor(cfg.Colors.text)
                noBtn.Paint = function(s, w, h)
                    if s:IsHovered() then
                        -- Hover - Primary Lila-Blau 
                        draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.primary)
                        draw.RoundedBox(6, 2, 2, w-4, h-4, cfg.Colors.glow)
                    else
                        -- Normal - Secondary Lila-Blau
                        draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.secondary)
                        draw.RoundedBox(6, 1, 1, w-2, h-2, Color(cfg.Colors.secondary.r + 15, cfg.Colors.secondary.g + 15, cfg.Colors.secondary.b + 15, 150))
                    end
                end
                noBtn.DoClick = function()
                    confirmFrame:Remove()
                end
            end
        end
    end

    buildSets()
    
    -- Globale buildSets Funktion für Updates von außen
    globalBuildSets = buildSets
    
    -- Initial UI update nach kurzem Delay
    timer.Simple(0.1, function()
        if IsValid(modelPreview) then
            updateAllUI() -- Verwende die neue umfassende Update-Funktion
        end
    end)

    -- Save current set controls
    local savePanel = vgui.Create("DPanel", rightPanel)
    savePanel:SetPos(padding, rightPanel:GetTall() - 80)
    savePanel:SetSize(rightW - padding*4, 70)
    savePanel.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, cfg.Colors.secondary)
        draw.RoundedBox(8, 2, 2, w-4, h-4, cfg.Colors.glow)
        draw.RoundedBox(8, 4, 4, w-8, h-8, Color(cfg.Colors.secondary.r + 20, cfg.Colors.secondary.g + 20, cfg.Colors.secondary.b + 20, 180))
        draw.RoundedBox(8, 0, 0, w, 2, cfg.Colors.primary) -- Top accent line
    end
    
    local saveLabel = vgui.Create("DLabel", savePanel)
    saveLabel:SetText("Aktuelles Set speichern:")
    saveLabel:SetFont(cfg.Fonts.normal.name)
    saveLabel:SetTextColor(cfg.Colors.text)
    saveLabel:SetPos(8, 8)
    saveLabel:SizeToContents()

    local saveName = vgui.Create("DTextEntry", savePanel)
    saveName:SetPos(8, 30)
    saveName:SetSize(savePanel:GetWide() - 100, 28)
    saveName:SetFont(cfg.Fonts.normal.name)
    saveName:SetText("Mein neues Set")
    saveName:SetTextColor(cfg.Colors.text)
    saveName.Paint = function(s, w, h)
        if cfg.Colors.dark then
            draw.RoundedBox(4, 0, 0, w, h, cfg.Colors.dark)
            draw.RoundedBox(4, 1, 1, w-2, h-2, Color(cfg.Colors.dark.r + 15, cfg.Colors.dark.g + 15, cfg.Colors.dark.b + 15, 150))
        else
            draw.RoundedBox(4, 0, 0, w, h, Color(40, 30, 80, 255))
            draw.RoundedBox(4, 1, 1, w-2, h-2, Color(55, 45, 95, 150))
        end
        s:DrawTextEntryText(cfg.Colors.text or Color(255,255,255), cfg.Colors.primary or Color(120,80,255), cfg.Colors.text or Color(255,255,255))
    end

    local saveBtn = vgui.Create("DButton", savePanel)
    saveBtn:SetPos(savePanel:GetWide() - 85, 30)
    saveBtn:SetSize(75, 28)
    saveBtn:SetText("Speichern")
    saveBtn:SetTextColor(cfg.Colors.text)
    saveBtn.Paint = function(s, w, h)
        if s:IsHovered() then
            -- Hover - Primary mit Glow
            draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.primary)
            draw.RoundedBox(6, 2, 2, w-4, h-4, cfg.Colors.glow)
        else
            -- Normal - Success Blau
            draw.RoundedBox(6, 0, 0, w, h, cfg.Colors.success)
            draw.RoundedBox(6, 1, 1, w-2, h-2, Color(cfg.Colors.success.r + 20, cfg.Colors.success.g + 20, cfg.Colors.success.b + 20, 150))
        end
    end
    saveBtn.DoClick = function()
        -- Build complete set mit Bodygroups UND Skins
        local ply = LocalPlayer()
        local out = { 
            name = saveName:GetValue(), 
            bodygroups = {},
            skin = ply:GetSkin() or 0  -- WICHTIG: Skin hinzufügen!
        }
        
        -- Sammle alle Bodygroups
        local bgs2 = ply:GetBodyGroups() or {}
        for _, bg in ipairs(bgs2) do
            local val = ply:GetBodygroup(bg.id) or 0
            table.insert(out.bodygroups, { name = bg.name, index = bg.id, value = val })
        end
        
        table.insert(currentSets, out)
        
        -- Send kompletres Set an Server
        net.Start("Wardrobe_SaveSet") 
        net.WriteTable(out) 
        net.SendToServer()
        
        buildSets()
        
        -- Bestätigungsnachricht
        chat.AddText(Color(200,200,200), "[Keksi Kleiderschrank] ", cfg.Colors.primary, 'Set "' .. out.name .. '" gespeichert (Bodygroups + Skin)')
    end
    
    -- Initial sync beim Öffnen des Wardrobes
    timer.Simple(0.1, function() -- Kurzer Delay damit alle UI-Elemente erstellt sind
        if IsValid(WardrobeFrame) then
            updateAllUI()
            syncModelPreviewWithPlayer()
        end
    end)

end)

-- open command for convenience
concommand.Add("keksi_kleiderschrank_open", function()
    net.Start("Wardrobe_RequestSets") net.SendToServer()
end)

-- Legacy command support
concommand.Add("wardrobe_open", function()
    net.Start("Wardrobe_RequestSets") net.SendToServer()
end)

net.Receive("Wardrobe_Notify", function()
    local msg = net.ReadString() or ""
    chat.AddText(Color(200,200,200), "[Keksi Kleiderschrank] ", cfg.Colors.primary, msg)
end)

-- Dresser interaction: öffne Wardrobe wenn vom Server angefragt
net.Receive("Wardrobe_OpenFromDresser", function()
    -- Wardrobe öffnen (gleiche Logik wie der wardrobe_open Command)
    net.Start("Wardrobe_RequestSets") 
    net.SendToServer()
end)

-- Optional: Hint-System für Dresser-Interaktion
if cfg.Dresser and cfg.Dresser.enabled and cfg.Dresser.show_hint then
    hook.Add("HUDPaint", "KeksiKleiderschrank_DresserHint", function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return end
        
        -- Suche nach Wardrobe Dresser Entity in der Nähe
        local eyePos = ply:EyePos()
        local eyeAng = ply:EyeAngles()
        local trace = util.TraceLine({
            start = eyePos,
            endpos = eyePos + eyeAng:Forward() * cfg.Dresser.max_distance,
            filter = ply
        })
        
        -- Prüfe ob es unsere Wardrobe Dresser Entity ist
        if IsValid(trace.Entity) and (trace.Entity:GetClass() == "wardrobe_dresser" or trace.Entity:GetModel() == cfg.Dresser.model) then
            local distance = eyePos:Distance(trace.Entity:GetPos())
            if distance <= cfg.Dresser.max_distance then
                -- Zeige Hint
                local scrW, scrH = ScrW(), ScrH()
                local text = "Drücke E um Keksis Kleiderschrank zu öffnen"
                
                surface.SetFont(cfg.Fonts.normal.name)
                local textW, textH = surface.GetTextSize(text)
                
                local x = scrW / 2 - textW / 2
                local y = scrH / 2 + 100
                
                -- Hintergrund
                draw.RoundedBox(4, x - 10, y - 5, textW + 20, textH + 10, Color(0, 0, 0, 150))
                -- Text
                draw.SimpleText(text, cfg.Fonts.normal.name, scrW / 2, y + textH / 2, cfg.Colors.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end)
end

print("[Wardrobe] Client module loaded")
