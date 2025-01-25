--[[Author informations]]
--
SWEP.Author = "Manix84"; -- The orginal author of this addon
SWEP.Contact = "https://steamcommunity.com/id/manix84";

if (SERVER) then
  AddCSLuaFile();
  CreateConVar("discord_muter_dart_time", 15, FCVAR_ARCHIVE, "How long to mute the player.");
end

if CLIENT then
  SWEP.PrintName = "Muter Dart";
  SWEP.Slot = 6;
  SWEP.ViewModelFlip = false;
  SWEP.ViewModelFOV = 54;
  -- Path to the icon material
  SWEP.Icon = "VGUI/ttt/icon_discord_muter_dart";

  SWEP.EquipMenuData = {
    name = "Discord Muter Dart",
    type = "Weapon",
    desc = "Mute a players discord for " .. GetConVar("discord_muter_dart_time"):GetInt() .. " seconds."
  };
end

if SERVER then
  resource.AddFile("materials/VGUI/ttt/icon_discord_muter_dart.vmt");
end

-- Always derive from weapon_tttbase.
SWEP.Base = "weapon_tttbase";
--- Standard GMod values
SWEP.HoldType = "pistol";
SWEP.Primary.Delay = 1;
SWEP.Primary.Recoil = 0.5;
SWEP.Primary.Automatic = false;
SWEP.Primary.Damage = 0;
SWEP.Primary.Cone = 0.02;
SWEP.Primary.Ammo = "muter_dart";
SWEP.Primary.ClipSize = 5;
SWEP.Primary.ClipMax = 15; -- This isn't working, and I don't know why.
SWEP.Primary.DefaultClip = 15;
SWEP.Primary.Sound = Sound("Weapon_USP.SilencedShot");
SWEP.Primary.SoundLevel = 50;
SWEP.Primary.Force = 0;
SWEP.UseHands = true;
SWEP.ViewModel = "models/weapons/cstrike/c_pist_usp.mdl";
SWEP.WorldModel = "models/weapons/w_pist_usp_silencer.mdl";
SWEP.IronSightsPos = Vector(-5.91, -4, 2.84);
SWEP.IronSightsAng = Vector(-0.5, 0, 0);
SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK_SILENCED;
SWEP.ReloadAnim = ACT_VM_RELOAD_SILENCED;

--- TTT config values
SWEP.CanBuy = {ROLE_TRAITOR};

SWEP.Kind = WEAPON_EQUIP1;
SWEP.AutoSpawnable = false;
SWEP.InLoadoutFor = nil;
SWEP.LimitedStock = false;
SWEP.AllowDrop = true;
SWEP.IsSilent = false;
SWEP.NoSights = true;

function SWEP:Deploy()
  self:SendWeaponAnim(ACT_VM_DRAW_SILENCED);

  return self.BaseClass.Deploy(self);
end

function SWEP:ShootBullet(damage, recoil, num_bullets, cone)
  local owner = self:GetOwner();
  local muteTime = GetConVar("discord_muter_dart_time"):GetInt();
  local dart = {};
  dart.Num = num_bullets;
  dart.Src = owner:GetShootPos();
  dart.Dir = owner:GetAimVector();
  dart.Spread = Vector(cone, cone, 0);
  dart.Tracer = 0;
  dart.Force = 0;
  dart.Damage = damage;

  dart.Callback = function(_attacker, trace)
    local victim = trace.Entity;

    if SERVER and victim:IsPlayer() then
      victim:PrintMessage(HUD_PRINTCENTER, "Shhhh...");
      hook.Run("DTTTMute", victim, muteTime);
      local str = ""
      if muteTime then
        str = muteTime + " seconds."
      else
        str = "the entire round."
      end
      owner:PrintMessage(HUD_PRINTTALK, "[Discord Muter Dart] " .. victim:GetName() .. " is Muted for " .. str);
    end
  end;

  self:SendWeaponAnim(self.PrimaryAnim);
  owner:SetAnimation(PLAYER_ATTACK1);
  owner:FireBullets(dart);
end
