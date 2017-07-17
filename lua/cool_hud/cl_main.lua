local table = table
local surface = surface
local draw = draw
local math = math
local string = string

local function GetAmmo() 
   local weap = LocalPlayer():GetActiveWeapon()
   if not weap or weap == NULL or not LocalPlayer():Alive() then return -1 end

   local ammo_inv = weap:Ammo1() or 0
   local ammo_clip = weap:Clip1() or 0
   local ammo_max = weap.Primary.ClipSize or 0
   return ammo_clip, ammo_max, ammo_inv 
end

--[[-------------------------------------------------------------------------
Diffrent sizes
---------------------------------------------------------------------------]]
surface.CreateFont("TTTHUDFOUNT", {
    font = "CloseCaption_Bold",
    size = 25, 
} )

surface.CreateFont("TTTOVERTIMEFOUNT", {
    font = "CloseCaption_Bold",
    size = 15, 
} )

local UsesAmmo = false
local gradent = Material("cool_hud/gradient.png")
local ammo_gradient = Material("cool_hud/ammo_gradient.png")
local Hud_Ammo_OutLine = Material("cool_hud/ttt_hud_ammo.png")
local Hud_OutLine = Material("cool_hud/ttt_hud.png")
function ttt_drawOutLine()
   if UsesAmmo then
      surface.SetDrawColor( 255, 255, 255, 255 )
      surface.SetMaterial( Hud_Ammo_OutLine )
      surface.DrawTexturedRect( 0, ScrH() - 169, 300, 169 )
   else
      surface.SetDrawColor( 255, 255, 255, 255 )
      surface.SetMaterial( Hud_OutLine )
      surface.DrawTexturedRect( 0, ScrH() - 169, 300, 169 )
   end
end

local y = ScrH() - 45
local time = "00:00"
local colar = {} -- with an A because why not
local hastetime = GetGlobalFloat("ttt_haste_end", 0) - CurTime()
local is_haste = HasteMode() and round_state == ROUND_ACTIVE
local Innocent_Time = "00:00"
function ttt_role()
   hastetime = GetGlobalFloat("ttt_haste_end", 0) - CurTime()

   time = util.SimpleTime( math.max(0,
   GetGlobalFloat("ttt_round_end", 0) - CurTime() ), "%02i:%02i" )
   
   Innocent_Time = util.SimpleTime( math.max(0,
   hastetime ), "%02i:%02i" )

   if UsesAmmo then 
      y = 113
   else
      y = 76
   end

   local round_state = GAMEMODE.round_state

   if round_state == 1 then
      draw.SimpleText( "Waiting", "TTTHUDFOUNT", 80, ScrH() - y, COLOR_WHITE,
         TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
      draw.SimpleText( "00:00", "TTTHUDFOUNT", 11, ScrH() - y, COLOR_WHITE,
         TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
   elseif round_state == 2 then
      draw.SimpleText( "Preparing", "TTTHUDFOUNT", 80, ScrH() - y, COLOR_WHITE,
         TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
      draw.SimpleText( time, "TTTHUDFOUNT", 11, ScrH() - y, COLOR_WHITE,
         TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

   elseif round_state == 3 then
      if LocalPlayer():IsTraitor() then
         draw.SimpleText("Traitor", "TTTHUDFOUNT", 100, ScrH() - y, COLOR_RED,
            TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
         if math.ceil( CurTime() ) % 7 <= 2 then
            draw.SimpleText(time, "TTTHUDFOUNT", 11, ScrH() - y,
             Color( 255, 20, 20), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
         else
            if Innocent_Time == "00:00" then
               draw.SimpleText("OVERTIME", "TTTOVERTIMEFOUNT", 11, ScrH() - y,
                Color( 255, 255, 255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
            else
               draw.SimpleText(Innocent_Time, "TTTHUDFOUNT", 11, ScrH() - y,
                Color( 255, 255, 255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
            end
         end
      elseif LocalPlayer():IsDetective() then
         draw.SimpleText("Detective", "TTTHUDFOUNT", 75, ScrH() - y,
            Color(000,238,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
         
         if Innocent_Time == "00:00" then
            draw.SimpleText("OVERTIME", "TTTOVERTIMEFOUNT", 11, ScrH() - y,
               Color( 255, 255, 255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
         else
            draw.SimpleText(Innocent_Time, "TTTHUDFOUNT", 11, ScrH() - y,
             Color( 255, 255, 255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
         end
      else
         draw.SimpleText("Innocent", "TTTHUDFOUNT", 80, ScrH() - y, COLOR_WHITE,
            TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
   
         if Innocent_Time == "00:00" then
            draw.SimpleText("OVERTIME", "TTTOVERTIMEFOUNT", 11, ScrH() - y,
               Color( 255, 255, 255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
         else
            draw.SimpleText(Innocent_Time, "TTTHUDFOUNT", 11, ScrH() - y,
             Color( 255, 255, 255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
         end
      end
   elseif round_state == 4 then
      draw.SimpleText( "Round Over", "TTTHUDFOUNT", 70, ScrH() - y, COLOR_WHITE,
         TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
      draw.SimpleText( time, "TTTHUDFOUNT", 11, ScrH() - y, COLOR_WHITE, 
         TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
   end
end

local ammo_clip, ammo_max, ammo_inv = -1, -1, -1
local ammo_length = 100
local ammo_len = 100
function ttt_ammo()
   local ammo_clip, ammo_max, ammo_inv = GetAmmo()

   if ammo_clip == -1 then
      UsesAmmo = false
   else 
      UsesAmmo = true
      
      ammo_length = ammo_clip / ammo_max

      local ammo_poly = {
         { x = 1, y = ScrH() - 80},
         { x = 188 * ammo_length, y = ScrH() - 80},
         { x = 233 * ammo_length, y = ScrH() - 48},
         { x = 1, y = ScrH() - 48}
      }

      surface.SetMaterial(ammo_gradient)
      surface.SetDrawColor( 255, 255, 255, 175 )      
      surface.DrawPoly( ammo_poly )

      draw.SimpleText( tostring( ammo_clip .. " + " .. ammo_inv .. " Ammo" ),
      "TTTHUDFOUNT", 20, ScrH() - 75, COLOR_WHITE,
      TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP ) 

   end
end
   
local health = {}
local smoothHealth = 100
local smoothHP = 100
local hp = 100 -- Just make it a local var
function ttt_health()
   -- the heatlh stuff
   hp = LocalPlayer():Health() -- needs to be updated

   -- smooth it out
   smoothHealth = Lerp( FrameTime(), smoothHealth, hp)
 
   -- the health number
   if smoothHealth > 100 then
      smoothHP = 100
   else
      smoothHP = smoothHealth
   end

   -- the health poly
   health = { 
      { x = 3, y = ScrH() - 41 },
      { x = ( smoothHP * 2.30 ) + 15, y = ScrH() - 41 },
      { x = ( smoothHP * 2.60 ) + 23, y = ScrH() - 10 },
      { x = ( smoothHP * 2.60 ) + 23, y = ScrH() - 3 },
      { x = 3, y = ScrH() - 3 }
   }

   -- draw the health
   surface.SetMaterial( gradent )
   surface.SetDrawColor( 250, 20, 20, 85  )
   surface.DrawPoly( health )
   
   ----------------- Just to make it a string for the server :)
   draw.SimpleText( tostring( math.Round( smoothHealth, 0 ) .. " HP" ),
   "TTTHUDFOUNT", 20, ScrH() - 35, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

-- IMPORTANT BIT --
-- Hide the standard HUD stuff
local shoulddraw = {
   ["CHudHealth"]          = true,
   ["CHudSecondaryAmmo"]   = true,   
   ["CHudAmmo"]            = true,
   ["TTTInfoPanel"]        = true
}
hook.Add("HUDShouldDraw", "TTT_HUD_PAINT_TTT_OVERRIDE", function(element)
   return not shoulddraw[element]
end)

-- Show our good stuff
hook.Add("HUDPaint", "TTT_HUD_PAINT_TTT", function()
   -- Hides the hud when players are alive
   if LocalPlayer():Alive() and LocalPlayer():Team() != TEAM_SPEC then 
      ttt_drawOutLine()
      ttt_health()
      ttt_ammo()
      ttt_role() 
   end
end )
