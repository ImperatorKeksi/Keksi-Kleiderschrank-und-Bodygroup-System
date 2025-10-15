--[[
    Keksi Kleiderschrank - Dresser Entity (Shared)
    ==============================================
    
    Diese Datei definiert die grundlegenden Eigenschaften der Kleiderschrank-Entity.
    Sie wird sowohl auf Client als auch Server geladen.
    
    Die Dresser-Entity ist ein physisches Objekt, das Spieler spawnen können,
    um das Kleiderschrank-System durch Interaktion (E-Taste) zu öffnen.
    
    Entwickelt von: Imperator Keksi
    https://guns.lol/imperatorkeksi
--]]

-- Entity-Typ und Basis-Klasse
ENT.Type = "anim"                -- Animierte Entity
ENT.Base = "base_gmodentity"     -- Standard GMod Entity Basis

-- Entity-Informationen für das Spawn-Menü
ENT.PrintName = "Keksi Kleiderschrank"
ENT.Author = "Imperator Keksi"
ENT.Information = "Bodygroup-System - Ein Kleiderschrank zum Ändern von Bodygroups und Skins"
ENT.Category = "Keksi Tools"

-- Spawn-Berechtigungen
ENT.Spawnable = true    -- Kann von Spielern gespawnt werden
ENT.AdminOnly = false   -- Setze auf true, wenn nur Admins spawnen sollen

-- 3D-Model der Entity
ENT.Model = "models/props_c17/FurnitureDresser001a.mdl"