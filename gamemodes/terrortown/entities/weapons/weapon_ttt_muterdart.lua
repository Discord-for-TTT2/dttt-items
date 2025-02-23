--[[Author informations]]
--
SWEP.Author = "vertiKarl"; -- The orginal author of this addon: Manix84
SWEP.Contact = "https://steamcommunity.com/id/vertiKarl"; -- https://steamcommunity.com/id/manix84
CreateConVar("dttt_md_mute_time", 15, {FCVAR_ARCHIVE,FCVAR_REPLICATED}, "How long to mute the player.", 0);
CreateConVar("dttt_md_deafen_time", 15, {FCVAR_ARCHIVE,FCVAR_REPLICATED}, "How long to deafen the player.", 0);
CreateConVar("dttt_md_mute_cost", 1, {FCVAR_ARCHIVE,FCVAR_REPLICATED}, "The cost of mute darts.");
CreateConVar("dttt_md_deafen_cost", 2, {FCVAR_ARCHIVE,FCVAR_REPLICATED}, "The cost of deafen darts.");

local function getCost(attack)
  if attack == "MUTE" then
    return GetConVar("dttt_md_mute_cost"):GetInt()
  elseif attack == "DEAFEN" then
    return GetConVar("dttt_md_deafen_cost"):GetInt()
  elseif attack == "MUTE_DEAFEN" then
    return GetConVar("dttt_md_mute_cost"):GetInt() + GetConVar("dttt_md_deafen_cost"):GetInt()
  else
    print("[dttt-items] Invalid attack, returning cost 999")
    return 999 -- invalid state
  end
end

local ATTACKS = {
  "MUTE",
  "DEAFEN",
  "MUTE_DEAFEN"
}


if (SERVER) then
  AddCSLuaFile();
  resource.AddFile("materials/VGUI/ttt/icon_muterdart.vmt")
  resource.AddFile("materials/VGUI/ttt/icon_muterdart.vtf")
end

if CLIENT then
  SWEP.PrintName = "Muter Dart";
  SWEP.ViewModelFlip = false;
  SWEP.ViewModelFOV = 54;
  -- Path to the icon material
  SWEP.Icon = "VGUI/ttt/icon_muterdart.vmt";
  if not file.Exists("materials/VGUI/ttt/icon_muterdart.vmt", "GAME") then
    print("[DTTT Muter Dart] Warning: Missing material for Muter Dart icon.")
  end

  local str = ""

  if ConVarExists("dttt_md_mute_time") and GetConVar("dttt_md_mute_time"):GetInt() ~= nil then
    str = "Mute a players discord for " .. GetConVar("dttt_md_mute_time"):GetInt() .. " seconds.\n"
  else
    str = "Mute a player in discord.\n"
  end

  if ConVarExists("dttt_md_deafen_time") and GetConVar("dttt_md_deafen_time"):GetInt() ~= nil then
    str = str .. "Deafen a players discord for " .. GetConVar("dttt_md_mute_time"):GetInt() .. " seconds.\n"
  else
    str = str .. "Deafen a player in discord.\n"
  end

  SWEP.EquipMenuData = {
    name = "Discord Muter Dart",
    type = "Weapon",
    desc = str
  };

  function SWEP:GetHudText()
    dttt_logger.PrintLog("items", "GetHudText", true)
    local attack = ATTACKS[self.current_attack];
    local str = "";
    if attack == "MUTE" then
      str = "Mute";
    elseif attack == "DEAFEN" then
      str = "Deafen";
    elseif attack == "MUTE_DEAFEN" then
      str = "Mute and deafen";
    else
      return; -- invalid state
    end

    primary_text = str .. " your target using " .. getCost(attack) .. " ammo.";

    secondary_text = "Switch the mode";
    return primary_text, secondary_text
  end

  function SWEP:Deploy()
    dttt_logger.PrintLog("items", "Deploy", true)
    local primary, secondary = self:GetHudText()
    self:AddTTT2HUDHelp(primary, secondary);
  end

  function SWEP:AddToSettingsMenu(parent)

  dttt_logger.PrintLog("items", "AddToSettingsMenu", true)
    local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")

    form:MakeHelp({
        label = "help_item_armor_value",
    })

    form:MakeSlider({
        serverConvar = "dttt_md_mute_time",
        label = "label_dttt_md_mute_time",
        min = 0,
        max = 100,
        decimal = 0,
    })
    form:MakeSlider({
      serverConvar = "dttt_md_deafen_time",
      label = "label_dttt_md_deafen_time",
      min = 0,
      max = 100,
      decimal = 0,
    })
    form:MakeSlider({
      serverConvar = "dttt_md_mute_cost",
      label = "label_dttt_md_mute_cost",
      min = 0,
      max = 5,
      decimal = 0,
    })
    form:MakeSlider({
      serverConvar = "dttt_md_deafen_cost",
      label = "label_dttt_md_deafen_cost",
      min = 0,
      max = 5,
      decimal = 0,
    })
  end
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
SWEP.Primary.DefaultClip = 5;
SWEP.Primary.Sound = Sound("Weapon_USP.SilencedShot");
SWEP.Primary.SoundLevel = 50;
SWEP.Primary.Force = 0;

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0

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

function SWEP:CanPrimaryAttack()

  dttt_logger.PrintLog("items", "PrimaryAttack Check", true)
  if not IsValid(self:GetOwner()) then
    return
  end

  local attack = ATTACKS[self.current_attack]
  return self:Clip1() >= getCost(attack);
end

-- this is just from the original TTT2 weapon_ttt_base, but having the TakePrimaryAmmo changed
function SWEP:PrimaryAttack(worldsnd)

  dttt_logger.PrintLog("items", "Primary Attack", true)
  self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
  self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

  if not self:CanPrimaryAttack() then
      return
  end

  if not worldsnd then
      self:EmitSound(self.Primary.Sound, self.Primary.SoundLevel)
  elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
  end

  self:ShootBullet(
      self.Primary.Damage,
      self:GetPrimaryRecoil(),
      self.Primary.NumShots,
      self:GetPrimaryCone()
  )
  self:TakePrimaryAmmo(getCost(ATTACKS[self.current_attack]))

  local owner = self:GetOwner()

  if not IsValid(owner) or owner:IsNPC() or not owner.ViewPunch then
      return
  end

  owner:ViewPunch(
      Angle(
          util.SharedRandom(self:GetClass(), -0.2, -0.1, 0) * self:GetPrimaryRecoil(),
          util.SharedRandom(self:GetClass(), -0.1, 0.1, 1) * self:GetPrimaryRecoil(),
          0
      )
  )
end

function SWEP:SecondaryAttack()
  dttt_logger.PrintLog("items", "Secondary Attack", true);
  self.current_attack = self.current_attack + 1;
  if (self.current_attack > #ATTACKS) then self.current_attack = 1 end

  if CLIENT then
    local primary, secondary = self:GetHudText();
    self:AddTTT2HUDHelp(primary, secondary);
  end

  self:SetNextSecondaryFire(CurTime() + 1);
end

function SWEP:Initialize()
  dttt_logger.PrintLog("items", "Initialize", true)
  self.current_attack = 1

  if self.EnableConfigurableClip then
      self.Primary.ClipSize = self.ConfigurableClip or self.Primary.DefaultClip

      self:SetClip1(self.ConfigurableClip or self.Primary.DefaultClip)
  end

  if CLIENT and self:Clip1() == -1 then
      self:SetClip1(self.Primary.DefaultClip)
  elseif SERVER then
      self.fingerprints = {}

      self:SetZoom(false)
      self:SetIronsights(false)
  end

  self:SetDeploySpeed(self.DeploySpeed)
  self:SetHoldType(self.HoldType or "pistol")
end

function SWEP:ShootBullet(damage, recoil, num_bullets, cone)

  dttt_logger.PrintLog("items", "ShootBullet", true)
  local owner = self:GetOwner();
  local muteTime = GetConVar("dttt_md_mute_time"):GetInt();
  local deafenTime = GetConVar("dttt_md_deafen_time"):GetInt();
  local attack = ATTACKS[self.current_attack];
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

    if not SERVER or not victim:IsPlayer() then return end

    if attack == "MUTE" then
      victim:PrintMessage(HUD_PRINTCENTER, "Shhhh...");
      hook.Run("DTTTMute", victim, muteTime);
      local str = "";
      if muteTime then
        str = muteTime .. " seconds.";
      else
        str = "the entire round.";
      end
      owner:PrintMessage(HUD_PRINTTALK, "[DTTT Muter Dart] " .. victim:GetName() .. " is Muted for " .. str);
    end

    if attack == "DEAFEN" then
      victim:PrintMessage(HUD_PRINTCENTER, "Silence...");
      hook.Run("DTTTDeafen", victim, deafenTime);
      local str = ""
      if deafenTime then
        str = deafenTime .. " seconds.";
      else
        str = "the entire round.";
      end
      owner:PrintMessage(HUD_PRINTTALK, "[DTTT Muter Dart] " .. victim:GetName() .. " is Deafened for " .. str);
    end;

    if attack == "MUTE_DEAFEN" then
      victim:PrintMessage(HUD_PRINTCENTER, "Solitude...");
      hook.Run("DTTTMute", victim, muteTime);
      hook.Run("DTTTDeafen", victim, deafenTime);
      local str = "";
      if muteTime then
        str = " is muted for " .. muteTime .. " seconds";
      else
        str = "the entire round";
      end

      if deafenTime then
        str = str .. " and deafened for " .. deafenTime .. " seconds.";
      else
        str = str .. " the entire round.";
      end
      owner:PrintMessage(HUD_PRINTTALK, "[DTTT Muter Dart] " .. victim:GetName() .. str);
    end

  end;

  self:SendWeaponAnim(self.PrimaryAnim);
  owner:SetAnimation(PLAYER_ATTACK1);
  owner:FireBullets(dart);
end
