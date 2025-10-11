-- Autorun shared include to ensure shared config is loaded on both realms
if SERVER then AddCSLuaFile("wardrobe/sh_config.lua") end
if CLIENT then include("wardrobe/sh_config.lua") end
