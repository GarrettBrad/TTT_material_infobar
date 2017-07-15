if SERVER then
	AddCSLuaFile("cool_hud/cl_main.lua")

	resource.AddFile("materials/cool_hud/ammo_gradient.png")
	resource.AddFile("materials/cool_hud/gradient.png")
	resource.AddFile("materials/cool_hud/ttt_hud.png")
	resource.AddFile("materials/cool_hud/ttt_hud_ammo.png")

elseif CLIENT then
	cool_hud = {}
	local function load()
		include("cool_hud/cl_main.lua")
	end
	if GAMEMODE_LOADED then
		load()
	else
		hook.Add("PostGamemodeLoaded", "csgo_hud_Initialize", function() 
			load() 
		end )
	end
end