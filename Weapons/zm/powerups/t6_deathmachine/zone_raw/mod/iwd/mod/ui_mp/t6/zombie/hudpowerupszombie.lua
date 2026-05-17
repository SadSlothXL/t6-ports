CoD.PowerUps = {}
CoD.PowerUps.IconSize = 48
CoD.PowerUps.UpgradeIconSize = 36
CoD.PowerUps.Spacing = 8
CoD.PowerUps.STATE_OFF = 0
CoD.PowerUps.STATE_ON = 1
CoD.PowerUps.STATE_FLASHING_OFF = 2
CoD.PowerUps.STATE_FLASHING_ON = 3
CoD.PowerUps.FLASHING_STAGE_DURATION = 500
CoD.PowerUps.MOVING_DURATION = 500
CoD.PowerUps.UpGradeIconColorRed = {
	r = 1,
	g = 0,
	b = 0
}
CoD.PowerUps.ClientFieldNames = {}
CoD.PowerUps.ClientFieldNames[1] = {
	clientFieldName = "powerup_instant_kill",
	material = RegisterMaterial("specialty_instakill_zombies")
}
CoD.PowerUps.ClientFieldNames[2] = {
	clientFieldName = "powerup_double_points",
	material = RegisterMaterial("specialty_doublepoints_zombies"),
	z_material = RegisterMaterial("specialty_doublepoints_zombies_blue")
}
CoD.PowerUps.ClientFieldNames[3] = {
	clientFieldName = "powerup_fire_sale",
	material = RegisterMaterial("specialty_firesale_zombies")
}
CoD.PowerUps.ClientFieldNames[4] = {
	clientFieldName = "powerup_bon_fire",
	material = RegisterMaterial("zom_icon_bonfire")
}
CoD.PowerUps.ClientFieldNames[5] = {
	clientFieldName = "powerup_mini_gun",
	material = RegisterMaterial("zom_icon_minigun")
}
CoD.PowerUps.ClientFieldNames[6] = {
	clientFieldName = "powerup_zombie_blood",
	material = RegisterMaterial("specialty_zomblood_zombies")
}
CoD.PowerUps.ClientFieldNames[7] = {
	clientFieldName = "deathmachine_powerup",
	material = RegisterMaterial("ui_powerup_deathmachine")
}
CoD.PowerUps.DeathMachineDvarName = "deathmachine_powerup_state"
CoD.PowerUps.UpgradeClientFieldNames = {}
CoD.PowerUps.UpgradeClientFieldNames[1] = {
	clientFieldName = CoD.PowerUps.ClientFieldNames[1].clientFieldName .. "_ug",
	material = RegisterMaterial("specialty_instakill_zombies"),
	color = CoD.PowerUps.UpGradeIconColorRed
}

CoD.PowerUps.DeathMachineAmmoCounterHidden = {}

CoD.PowerUps.IsDeathMachineAmmoCounterHidden = function (Controller)
	if Controller == nil then
		Controller = 0
	end

	if CoD.PowerUps.DeathMachineAmmoCounterHidden ~= nil and CoD.PowerUps.DeathMachineAmmoCounterHidden[Controller] == true then
		return true
	end

	if UIExpression ~= nil and UIExpression.DvarInt ~= nil then
		local PowerupState = UIExpression.DvarInt(Controller, CoD.PowerUps.DeathMachineDvarName)
		if PowerupState ~= nil and PowerupState ~= CoD.PowerUps.STATE_OFF then
			return true
		end
	end

	return false
end

CoD.PowerUps.HideAmmoDigits = function (Element)
	if Element == nil or Element.ammoDigits == nil then
		return
	end

	for DigitIndex = 1, #Element.ammoDigits, 1 do
		Element.ammoDigits[DigitIndex]:setAlpha(0)
	end
end


CoD.PowerUps.ShowAmmoDigits = function (Element)
	if Element == nil or Element.ammoDigits == nil then
		return
	end

	for DigitIndex = 1, #Element.ammoDigits, 1 do
		Element.ammoDigits[DigitIndex]:setAlpha(1)
	end
end

CoD.PowerUps.DeathMachineAmmoElements = {}

CoD.PowerUps.RegisterDeathMachineAmmoElement = function (Element, Event, EventType)
	if Element == nil then
		return
	end

	if CoD.PowerUps.DeathMachineAmmoElements == nil then
		CoD.PowerUps.DeathMachineAmmoElements = {}
	end

	if Element.deathmachineAmmoRegistered ~= true then
		Element.deathmachineAmmoRegistered = true
		table.insert(CoD.PowerUps.DeathMachineAmmoElements, Element)
	end

	Element.deathmachineWasHidden = true

	if Event ~= nil then
		Element.deathmachineLastEvent = Event

		if Event.controller ~= nil then
			Element.deathmachineController = Event.controller
		end

		if EventType == "ammo" then
			Element.deathmachineLastAmmoEvent = Event
		elseif EventType == "overheat" then
			Element.deathmachineLastOverheatEvent = Event
		elseif EventType == "weapon" then
			Element.deathmachineLastWeaponEvent = Event
		elseif EventType == "visibility" then
			Element.deathmachineLastVisibilityEvent = Event
		elseif EventType == "heat" then
			Element.deathmachineLastHeatEvent = Event
		elseif EventType == "fuel" then
			Element.deathmachineLastFuelEvent = Event
		end
	end
end

CoD.PowerUps.RestoreAmmoElement = function (Element, Controller)
	if Element == nil or Element.deathmachineWasHidden ~= true then
		return
	end

	local Event = Element.deathmachineLastWeaponEvent or Element.deathmachineLastAmmoEvent or Element.deathmachineLastOverheatEvent or Element.deathmachineLastVisibilityEvent or Element.deathmachineLastEvent
	if Event == nil then
		Event = {
			name = "hud_update_refresh",
			controller = Controller
		}
	elseif Event.controller == nil then
		Event.controller = Controller
	end

	Element.deathmachineWasHidden = nil
	Element.hideAmmo = nil

	if Element.ammoLabel ~= nil then
		Element.ammoLabel:setAlpha(1)
	end

	if Element.deathmachineCounterType == "zombie" and CoD.AmmoAreaZombie ~= nil then
		if CoD.AmmoAreaZombie.deathmachineOriginalUpdateVisibility ~= nil then
			CoD.AmmoAreaZombie.deathmachineOriginalUpdateVisibility(Element, Event)
		end

		if Element.deathmachineLastWeaponEvent ~= nil and CoD.AmmoAreaZombie.deathmachineOriginalUpdateWeapon ~= nil then
			CoD.AmmoAreaZombie.deathmachineOriginalUpdateWeapon(Element, Element.deathmachineLastWeaponEvent)
		end

		if Element.deathmachineLastAmmoEvent ~= nil and CoD.AmmoAreaZombie.deathmachineOriginalUpdateAmmo ~= nil then
			CoD.AmmoAreaZombie.deathmachineOriginalUpdateAmmo(Element, Element.deathmachineLastAmmoEvent)
		elseif Element.deathmachineLastOverheatEvent ~= nil and CoD.AmmoAreaZombie.deathmachineOriginalUpdateOverheat ~= nil then
			CoD.AmmoAreaZombie.deathmachineOriginalUpdateOverheat(Element, Element.deathmachineLastOverheatEvent)
		else
			CoD.PowerUps.ShowAmmoDigits(Element)
		end
	elseif Element.deathmachineCounterType == "normal" and CoD.AmmoCounter ~= nil then
		if CoD.AmmoCounter.deathmachineOriginalUpdateVisibility ~= nil then
			CoD.AmmoCounter.deathmachineOriginalUpdateVisibility(Element, Event)
		end

		if Element.deathmachineLastAmmoEvent ~= nil and CoD.AmmoCounter.deathmachineOriginalUpdateAmmo ~= nil then
			CoD.AmmoCounter.deathmachineOriginalUpdateAmmo(Element, Element.deathmachineLastAmmoEvent)
		end
	elseif Element.deathmachineCounterType == "other" and CoD.OtherAmmoCounters ~= nil then
		if CoD.OtherAmmoCounters.deathmachineOriginalUpdateVisibility ~= nil then
			CoD.OtherAmmoCounters.deathmachineOriginalUpdateVisibility(Element, Event)
		end

		if Element.deathmachineLastHeatEvent ~= nil and CoD.OtherAmmoCounters.deathmachineOriginalUpdateHeat ~= nil then
			CoD.OtherAmmoCounters.deathmachineOriginalUpdateHeat(Element, Element.deathmachineLastHeatEvent)
		elseif Element.deathmachineLastFuelEvent ~= nil and CoD.OtherAmmoCounters.deathmachineOriginalUpdateFuel ~= nil then
			CoD.OtherAmmoCounters.deathmachineOriginalUpdateFuel(Element, Element.deathmachineLastFuelEvent)
		end
	else
		CoD.PowerUps.ShowAmmoDigits(Element)
	end

end

CoD.PowerUps.RestoreAmmoCounters = function (Controller)
	if CoD.PowerUps.DeathMachineAmmoElements == nil then
		return
	end

	for ElementIndex = 1, #CoD.PowerUps.DeathMachineAmmoElements, 1 do
		CoD.PowerUps.RestoreAmmoElement(CoD.PowerUps.DeathMachineAmmoElements[ElementIndex], Controller)
	end
end

CoD.PowerUps.PatchNormalAmmoCounter = function ()
	if CoD.AmmoCounter == nil or CoD.AmmoCounter.deathmachinePatch == true then
		return
	end

	CoD.AmmoCounter.deathmachinePatch = true
	CoD.AmmoCounter.deathmachineOriginalShouldHideAmmoCounter = CoD.AmmoCounter.ShouldHideAmmoCounter
	CoD.AmmoCounter.deathmachineOriginalUpdateVisibility = CoD.AmmoCounter.UpdateVisibility
	CoD.AmmoCounter.deathmachineOriginalUpdateAmmo = CoD.AmmoCounter.UpdateAmmo

	CoD.AmmoCounter.ShouldHideAmmoCounter = function (Element, Event)
		local Controller = nil
		if Event ~= nil then
			Controller = Event.controller
		end

		if CoD.PowerUps.IsDeathMachineAmmoCounterHidden(Controller) then
			return true
		end

		return CoD.AmmoCounter.deathmachineOriginalShouldHideAmmoCounter(Element, Event)
	end

	CoD.AmmoCounter.UpdateVisibility = function (Element, Event)
		local Controller = nil
		if Event ~= nil then
			Controller = Event.controller
		end

		if CoD.PowerUps.IsDeathMachineAmmoCounterHidden(Controller) then
			Element.deathmachineCounterType = "normal"
			CoD.PowerUps.RegisterDeathMachineAmmoElement(Element, Event, "visibility")
			if Element.animateToState ~= nil then
				Element:animateToState("hide")
			end
			if Element.ammoLabel ~= nil then
				Element.ammoLabel:setAlpha(0)
			end
			Element.visible = nil
			Element:dispatchEventToChildren(Event)
			return
		end

		if Element.ammoLabel ~= nil then
			Element.ammoLabel:setAlpha(1)
		end

		CoD.AmmoCounter.deathmachineOriginalUpdateVisibility(Element, Event)
	end

	CoD.AmmoCounter.UpdateAmmo = function (Element, Event)
		local Controller = nil
		if Event ~= nil then
			Controller = Event.controller
		end

		if CoD.PowerUps.IsDeathMachineAmmoCounterHidden(Controller) then
			Element.deathmachineCounterType = "normal"
			CoD.PowerUps.RegisterDeathMachineAmmoElement(Element, Event, "ammo")
			if Element.animateToState ~= nil then
				Element:animateToState("hide")
			end
			if Element.ammoLabel ~= nil then
				Element.ammoLabel:setAlpha(0)
			end
			Element.visible = nil
			return
		end

		if Element.ammoLabel ~= nil then
			Element.ammoLabel:setAlpha(1)
		end

		CoD.AmmoCounter.deathmachineOriginalUpdateAmmo(Element, Event)
	end
end

CoD.PowerUps.PatchOtherAmmoCounters = function ()
	if CoD.OtherAmmoCounters == nil or CoD.OtherAmmoCounters.deathmachinePatch == true then
		return
	end

	CoD.OtherAmmoCounters.deathmachinePatch = true
	CoD.OtherAmmoCounters.deathmachineOriginalShouldHideAmmoCounter = CoD.OtherAmmoCounters.ShouldHideAmmoCounter
	CoD.OtherAmmoCounters.deathmachineOriginalUpdateVisibility = CoD.OtherAmmoCounters.UpdateVisibility
	CoD.OtherAmmoCounters.deathmachineOriginalUpdateHeat = CoD.OtherAmmoCounters.UpdateHeat
	CoD.OtherAmmoCounters.deathmachineOriginalUpdateFuel = CoD.OtherAmmoCounters.UpdateFuel

	CoD.OtherAmmoCounters.ShouldHideAmmoCounter = function (Element, Event)
		local Controller = nil
		if Event ~= nil then
			Controller = Event.controller
		end

		if CoD.PowerUps.IsDeathMachineAmmoCounterHidden(Controller) then
			return true
		end

		return CoD.OtherAmmoCounters.deathmachineOriginalShouldHideAmmoCounter(Element, Event)
	end

	CoD.OtherAmmoCounters.UpdateVisibility = function (Element, Event)
		local Controller = nil
		if Event ~= nil then
			Controller = Event.controller
		end

		if CoD.PowerUps.IsDeathMachineAmmoCounterHidden(Controller) then
			Element.deathmachineCounterType = "other"
			CoD.PowerUps.RegisterDeathMachineAmmoElement(Element, Event, "visibility")
			Element:beginAnimation("hide")
			Element:setAlpha(0)
			Element.visible = nil
			Element:dispatchEventToChildren(Event)
			return
		end

		CoD.OtherAmmoCounters.deathmachineOriginalUpdateVisibility(Element, Event)
	end

	CoD.OtherAmmoCounters.UpdateHeat = function (Element, Event)
		local Controller = nil
		if Event ~= nil then
			Controller = Event.controller
		end

		if CoD.PowerUps.IsDeathMachineAmmoCounterHidden(Controller) then
			Element.deathmachineCounterType = "other"
			CoD.PowerUps.RegisterDeathMachineAmmoElement(Element, Event, "heat")
			Element:setAlpha(0)
			return
		end

		CoD.OtherAmmoCounters.deathmachineOriginalUpdateHeat(Element, Event)
	end

	CoD.OtherAmmoCounters.UpdateFuel = function (Element, Event)
		local Controller = nil
		if Event ~= nil then
			Controller = Event.controller
		end

		if CoD.PowerUps.IsDeathMachineAmmoCounterHidden(Controller) then
			Element.deathmachineCounterType = "other"
			CoD.PowerUps.RegisterDeathMachineAmmoElement(Element, Event, "fuel")
			Element:setAlpha(0)
			return
		end

		CoD.OtherAmmoCounters.deathmachineOriginalUpdateFuel(Element, Event)
	end
end

CoD.PowerUps.PatchZombieAmmoArea = function ()
	if CoD.AmmoAreaZombie == nil or CoD.AmmoAreaZombie.deathmachinePatch == true then
		return
	end

	CoD.AmmoAreaZombie.deathmachinePatch = true
	CoD.AmmoAreaZombie.deathmachineOriginalShouldHideAmmoCounter = CoD.AmmoAreaZombie.ShouldHideAmmoCounter
	CoD.AmmoAreaZombie.deathmachineOriginalUpdateAmmo = CoD.AmmoAreaZombie.UpdateAmmo
	CoD.AmmoAreaZombie.deathmachineOriginalUpdateOverheat = CoD.AmmoAreaZombie.UpdateOverheat
	CoD.AmmoAreaZombie.deathmachineOriginalUpdateVisibility = CoD.AmmoAreaZombie.UpdateVisibility
	CoD.AmmoAreaZombie.deathmachineOriginalUpdateAmmoVisibility = CoD.AmmoAreaZombie.UpdateAmmoVisibility
	CoD.AmmoAreaZombie.deathmachineOriginalUpdateWeapon = CoD.AmmoAreaZombie.UpdateWeapon

	CoD.AmmoAreaZombie.ShouldHideAmmoCounter = function (Element, Event)
		local Controller = nil
		if Event ~= nil then
			Controller = Event.controller
		end

		if CoD.PowerUps.IsDeathMachineAmmoCounterHidden(Controller) then
			return false
		end

		return CoD.AmmoAreaZombie.deathmachineOriginalShouldHideAmmoCounter(Element, Event)
	end

	CoD.AmmoAreaZombie.UpdateAmmo = function (Element, Event)
		local Controller = nil
		if Event ~= nil then
			Controller = Event.controller
		end

		if CoD.PowerUps.IsDeathMachineAmmoCounterHidden(Controller) then
			Element.deathmachineCounterType = "zombie"
			CoD.PowerUps.RegisterDeathMachineAmmoElement(Element, Event, "ammo")
			CoD.PowerUps.HideAmmoDigits(Element)
			Element:dispatchEventToChildren(Event)
			return
		end

		CoD.AmmoAreaZombie.deathmachineOriginalUpdateAmmo(Element, Event)
	end

	CoD.AmmoAreaZombie.UpdateOverheat = function (Element, Event)
		local Controller = nil
		if Event ~= nil then
			Controller = Event.controller
		end

		if CoD.PowerUps.IsDeathMachineAmmoCounterHidden(Controller) then
			Element.deathmachineCounterType = "zombie"
			CoD.PowerUps.RegisterDeathMachineAmmoElement(Element, Event, "overheat")
			CoD.PowerUps.HideAmmoDigits(Element)
			Element:dispatchEventToChildren(Event)
			return
		end

		CoD.AmmoAreaZombie.deathmachineOriginalUpdateOverheat(Element, Event)
	end

	CoD.AmmoAreaZombie.UpdateVisibility = function (Element, Event)
		CoD.AmmoAreaZombie.deathmachineOriginalUpdateVisibility(Element, Event)

		local Controller = nil
		if Event ~= nil then
			Controller = Event.controller
		end

		if CoD.PowerUps.IsDeathMachineAmmoCounterHidden(Controller) then
			Element.deathmachineCounterType = "zombie"
			CoD.PowerUps.RegisterDeathMachineAmmoElement(Element, Event, "visibility")
			CoD.PowerUps.HideAmmoDigits(Element)
		end
	end

	CoD.AmmoAreaZombie.UpdateAmmoVisibility = function (Element, Event)
		local Controller = nil
		if Event ~= nil then
			Controller = Event.controller
		end

		if CoD.PowerUps.IsDeathMachineAmmoCounterHidden(Controller) then
			Element.deathmachineCounterType = "zombie"
			CoD.PowerUps.RegisterDeathMachineAmmoElement(Element, Event, "visibility")
			CoD.PowerUps.HideAmmoDigits(Element)
			return
		end

		CoD.AmmoAreaZombie.deathmachineOriginalUpdateAmmoVisibility(Element, Event)

		if Element.deathmachineWasHidden == true and (CoD.AmmoAreaZombie.deathmachineOriginalShouldHideAmmoCounter == nil or CoD.AmmoAreaZombie.deathmachineOriginalShouldHideAmmoCounter(Element, Event) ~= false) then
			Element.deathmachineWasHidden = nil
			CoD.PowerUps.ShowAmmoDigits(Element)
		end
	end

	CoD.AmmoAreaZombie.UpdateWeapon = function (Element, Event)
		CoD.AmmoAreaZombie.deathmachineOriginalUpdateWeapon(Element, Event)

		local Controller = nil
		if Event ~= nil then
			Controller = Event.controller
		end

		if CoD.PowerUps.IsDeathMachineAmmoCounterHidden(Controller) then
			Element.deathmachineCounterType = "zombie"
			CoD.PowerUps.RegisterDeathMachineAmmoElement(Element, Event, "weapon")
			Element.hideAmmo = true
			CoD.PowerUps.HideAmmoDigits(Element)
		else
			Element.hideAmmo = nil

			if Element.deathmachineWasHidden == true then
				Element.deathmachineWasHidden = nil

				if CoD.AmmoAreaZombie.deathmachineOriginalShouldHideAmmoCounter == nil or CoD.AmmoAreaZombie.deathmachineOriginalShouldHideAmmoCounter(Element, Event) ~= false then
					CoD.PowerUps.ShowAmmoDigits(Element)
				end
			end
		end
	end
end

CoD.PowerUps.PatchAmmoCounters = function ()
	CoD.PowerUps.PatchNormalAmmoCounter()

	if CoD.OtherAmmoCounters ~= nil then
		CoD.PowerUps.PatchOtherAmmoCounters()
	end

	if CoD.AmmoAreaZombie ~= nil then
		CoD.PowerUps.PatchZombieAmmoArea()
	end
end


CoD.PowerUps.InstallAmmoCounterRequireHook = function ()
	if CoD.PowerUps.deathmachineRequireHookInstalled == true or require == nil then
		return
	end

	CoD.PowerUps.deathmachineRequireHookInstalled = true
	CoD.PowerUps.deathmachineOriginalRequire = require

	require = function (ModuleName)
		local Result = CoD.PowerUps.deathmachineOriginalRequire(ModuleName)

		if ModuleName ~= nil then
			local LowerModuleName = string.lower(ModuleName)
			if string.find(LowerModuleName, "ammoareazombie") ~= nil or string.find(LowerModuleName, "otherammocounters") ~= nil or string.find(LowerModuleName, "ammocounter") ~= nil then
				if CoD.PowerUps ~= nil and CoD.PowerUps.PatchAmmoCounters ~= nil then
					CoD.PowerUps.PatchAmmoCounters()
				end
			end
		end

		return Result
	end
end

CoD.PowerUps.InstallAmmoCounterRequireHook()
CoD.PowerUps.PatchAmmoCounters()

LUI.createMenu.PowerUpsArea = function (f1_arg0)
	local f1_local0 = CoD.Menu.NewSafeAreaFromState("PowerUpsArea", f1_arg0)
	f1_local0:setOwner(f1_arg0)
	f1_local0.scaleContainer = CoD.SplitscreenScaler.new(nil, CoD.Zombie.SplitscreenMultiplier)
	f1_local0.scaleContainer:setLeftRight(false, false, 0, 0)
	f1_local0.scaleContainer:setTopBottom(false, true, 0, 0)
	f1_local0:addElement(f1_local0.scaleContainer)
	local f1_local1 = CoD.PowerUps.IconSize * 0.5
	local f1_local2 = CoD.PowerUps.IconSize + CoD.PowerUps.UpgradeIconSize + 10
	local Widget = nil
	f1_local0.powerUps = {}
	for f1_local4 = 1, #CoD.PowerUps.ClientFieldNames, 1 do
		Widget = LUI.UIElement.new()
		Widget:setLeftRight(false, false, -f1_local1, f1_local1)
		Widget:setTopBottom(false, true, -f1_local2, 0)
		Widget:registerEventHandler("transition_complete_off_fade_out", CoD.PowerUps.PowerUpIcon_UpdatePosition)
		
		local powerUpIcon = LUI.UIImage.new()
		powerUpIcon:setLeftRight(true, true, 0, 0)
		powerUpIcon:setTopBottom(false, true, -CoD.PowerUps.IconSize, 0)
		powerUpIcon:setAlpha(0)
		Widget:addElement(powerUpIcon)
		Widget.powerUpIcon = powerUpIcon
		
		local upgradePowerUpIcon = LUI.UIImage.new()
		upgradePowerUpIcon:setLeftRight(false, false, -CoD.PowerUps.UpgradeIconSize / 2, CoD.PowerUps.UpgradeIconSize / 2)
		upgradePowerUpIcon:setTopBottom(true, false, 0, CoD.PowerUps.UpgradeIconSize)
		upgradePowerUpIcon:setAlpha(0)
		Widget:addElement(upgradePowerUpIcon)
		Widget.upgradePowerUpIcon = upgradePowerUpIcon
		
		Widget.powerupId = nil
		f1_local0.scaleContainer:addElement(Widget)
		f1_local0.powerUps[f1_local4] = Widget
		f1_local0:registerEventHandler(CoD.PowerUps.ClientFieldNames[f1_local4].clientFieldName, CoD.PowerUps.Update)
		f1_local0:registerEventHandler(CoD.PowerUps.ClientFieldNames[f1_local4].clientFieldName .. "_ug", CoD.PowerUps.UpgradeUpdate)
	end
	f1_local0.activePowerUpCount = 0
	f1_local0.deathmachinePowerupState = -1
	f1_local0:registerEventHandler("deathmachine_powerup_dvar_update", CoD.PowerUps.DeathMachineDvarUpdate)
	f1_local0:addElement(LUI.UITimer.new(100, "deathmachine_powerup_dvar_update", false, f1_local0))
	f1_local0:registerEventHandler("hud_update_refresh", CoD.PowerUps.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.PowerUps.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.PowerUps.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.PowerUps.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.PowerUps.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.PowerUps.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.PowerUps.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.PowerUps.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.PowerUps.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.PowerUps.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.PowerUps.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.PowerUps.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.PowerUps.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.PowerUps.UpdateVisibility)
	f1_local0:registerEventHandler("powerups_update_position", CoD.PowerUps.UpdatePosition)
	f1_local0.visible = true
	return f1_local0
end


CoD.PowerUps.DeathMachineDvarUpdate = function (Menu, ClientInstance)
	local LocalClientIndex = nil
	if ClientInstance ~= nil then
		LocalClientIndex = ClientInstance.controller
	end
	if LocalClientIndex == nil then
		LocalClientIndex = Menu.m_ownerController
	end
	if LocalClientIndex == nil then
		LocalClientIndex = 0
	end

	local PowerupState = UIExpression.DvarInt(LocalClientIndex, CoD.PowerUps.DeathMachineDvarName)
	if PowerupState == nil then
		PowerupState = CoD.PowerUps.STATE_OFF
	end

	CoD.PowerUps.PatchAmmoCounters()

	local HideAmmoCounter = PowerupState ~= CoD.PowerUps.STATE_OFF
	CoD.PowerUps.DeathMachineAmmoCounterHidden[LocalClientIndex] = HideAmmoCounter

	if HideAmmoCounter ~= Menu.deathmachineAmmoCounterHidden then
		Menu.deathmachineAmmoCounterHidden = HideAmmoCounter

		if HideAmmoCounter == false then
			CoD.PowerUps.RestoreAmmoCounters(LocalClientIndex)
		end

		if Menu.dispatchEventToRoot ~= nil then
			Menu:dispatchEventToRoot({
				name = "hud_update_refresh",
				controller = LocalClientIndex
			})
		end
	end

	if PowerupState ~= Menu.deathmachinePowerupState then
		Menu.deathmachinePowerupState = PowerupState
		Menu:processEvent({
			name = "deathmachine_powerup",
			controller = LocalClientIndex,
			newValue = PowerupState
		})
	end
end

CoD.PowerUps.UpdateVisibility = function (f2_arg0, f2_arg1)
	local f2_local0 = f2_arg1.controller
	if UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IS_PLAYER_IN_AFTERLIFE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_SCOREBOARD_OPEN) == 0 and (not CoD.IsShoutcaster(f2_local0) or CoD.ExeProfileVarBool(f2_local0, "shoutcaster_teamscore")) and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IS_SCOPED) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IS_FLASH_BANGED) == 0 then
		if not f2_arg0.visible then
			f2_arg0:setAlpha(1)
			f2_arg0.visible = true
		end
	elseif f2_arg0.visible then
		f2_arg0:setAlpha(0)
		f2_arg0.visible = nil
	end
end

CoD.PowerUps.Update = function (f3_arg0, f3_arg1)
	CoD.PowerUps.UpdateState(f3_arg0, f3_arg1)
	CoD.PowerUps.UpdatePosition(f3_arg0, f3_arg1)
end

CoD.PowerUps.UpdateState = function (f4_arg0, f4_arg1)
	local f4_local0 = nil
	local f4_local1 = CoD.PowerUps.GetExistingPowerUpIndex(f4_arg0, f4_arg1.name)
	if f4_local1 ~= nil then
		f4_local0 = f4_arg0.powerUps[f4_local1]
		if f4_arg1.newValue == CoD.PowerUps.STATE_ON then
			f4_local0.powerUpId = f4_arg1.name
			f4_local0.powerUpIcon:setImage(CoD.PowerUps.GetMaterial(f4_arg0, f4_arg1.controller, f4_arg1.name))
			f4_local0.powerUpIcon:setAlpha(1)
		elseif f4_arg1.newValue == CoD.PowerUps.STATE_OFF then
			f4_local0.powerUpIcon:beginAnimation("off_fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION)
			f4_local0.powerUpIcon:setAlpha(0)
			f4_local0.upgradePowerUpIcon:beginAnimation("off_fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION)
			f4_local0.upgradePowerUpIcon:setAlpha(0)
			f4_local0.powerUpId = nil
			f4_arg0.activePowerUpCount = f4_arg0.activePowerUpCount - 1
		elseif f4_arg1.newValue == CoD.PowerUps.STATE_FLASHING_OFF then
			f4_local0.powerUpIcon:beginAnimation("fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION)
			f4_local0.powerUpIcon:setAlpha(0)
		elseif f4_arg1.newValue == CoD.PowerUps.STATE_FLASHING_ON then
			f4_local0.powerUpIcon:beginAnimation("fade_in", CoD.PowerUps.FLASHING_STAGE_DURATION)
			f4_local0.powerUpIcon:setAlpha(1)
		end
	elseif f4_arg1.newValue == CoD.PowerUps.STATE_ON or f4_arg1.newValue == CoD.PowerUps.STATE_FLASHING_ON then
		local f4_local2 = CoD.PowerUps.GetFirstAvailablePowerUpIndex(f4_arg0)
		if f4_local2 ~= nil then
			f4_local0 = f4_arg0.powerUps[f4_local2]
			f4_local0.powerUpId = f4_arg1.name
			f4_local0.powerUpIcon:setImage(CoD.PowerUps.GetMaterial(f4_arg0, f4_arg1.controller, f4_arg1.name))
			f4_local0.powerUpIcon:setAlpha(1)
			f4_arg0.activePowerUpCount = f4_arg0.activePowerUpCount + 1
		end
	end
end

CoD.PowerUps.UpgradeUpdate = function (f5_arg0, f5_arg1)
	CoD.PowerUps.UpgradeUpdateState(f5_arg0, f5_arg1)
end

CoD.PowerUps.UpgradeUpdateState = function (f6_arg0, f6_arg1)
	local f6_local0 = nil
	local f6_local1 = CoD.PowerUps.GetExistingPowerUpIndex(f6_arg0, string.sub(f6_arg1.name, 0, -4))
	if f6_local1 ~= nil then
		f6_local0 = f6_arg0.powerUps[f6_local1].upgradePowerUpIcon
		if f6_arg1.newValue == CoD.PowerUps.STATE_ON then
			f6_local0:setImage(CoD.PowerUps.GetUpgradeMaterial(f6_arg0, f6_arg1.name))
			f6_local0:setAlpha(1)
			CoD.PowerUps.SetUpgradeColor(f6_local0, f6_arg1.name)
		elseif f6_arg1.newValue == CoD.PowerUps.STATE_OFF then
			f6_local0:beginAnimation("off_fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION)
			f6_local0:setAlpha(0)
		elseif f6_arg1.newValue == CoD.PowerUps.STATE_FLASHING_OFF then
			f6_local0:beginAnimation("fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION)
			f6_local0:setAlpha(0)
		elseif f6_arg1.newValue == CoD.PowerUps.STATE_FLASHING_ON then
			f6_local0:beginAnimation("fade_in", CoD.PowerUps.FLASHING_STAGE_DURATION)
			f6_local0:setAlpha(1)
		end
	end
end

CoD.PowerUps.GetMaterial = function (f7_arg0, f7_arg1, f7_arg2)
	local f7_local0 = nil
	for f7_local1 = 1, #CoD.PowerUps.ClientFieldNames, 1 do
		if CoD.PowerUps.ClientFieldNames[f7_local1].clientFieldName == f7_arg2 then
			f7_local0 = CoD.PowerUps.ClientFieldNames[f7_local1].material
			if UIExpression.IsVisibilityBitSet(f7_arg1, CoD.BIT_IS_PLAYER_ZOMBIE) == 1 and CoD.PowerUps.ClientFieldNames[f7_local1].z_material then
				f7_local0 = CoD.PowerUps.ClientFieldNames[f7_local1].z_material
				break
			end
		end
	end
	return f7_local0
end

CoD.PowerUps.GetUpgradeMaterial = function (f8_arg0, f8_arg1)
	local f8_local0 = nil
	for f8_local1 = 1, #CoD.PowerUps.UpgradeClientFieldNames, 1 do
		if CoD.PowerUps.UpgradeClientFieldNames[f8_local1].clientFieldName == f8_arg1 then
			f8_local0 = CoD.PowerUps.UpgradeClientFieldNames[f8_local1].material
			break
		end
	end
	return f8_local0
end

CoD.PowerUps.SetUpgradeColor = function (f9_arg0, f9_arg1)
	local f9_local0 = nil
	for f9_local1 = 1, #CoD.PowerUps.UpgradeClientFieldNames, 1 do
		if CoD.PowerUps.UpgradeClientFieldNames[f9_local1].clientFieldName == f9_arg1 then
			if CoD.PowerUps.UpgradeClientFieldNames[f9_local1].color then
				f9_arg0:setRGB(CoD.PowerUps.UpgradeClientFieldNames[f9_local1].color.r, CoD.PowerUps.UpgradeClientFieldNames[f9_local1].color.g, CoD.PowerUps.UpgradeClientFieldNames[f9_local1].color.b)
				break
			end
		end
	end
end

CoD.PowerUps.GetExistingPowerUpIndex = function (f10_arg0, f10_arg1)
	for f10_local0 = 1, #CoD.PowerUps.ClientFieldNames, 1 do
		if f10_arg0.powerUps[f10_local0].powerUpId == f10_arg1 then
			return f10_local0
		end
	end
	return nil
end

CoD.PowerUps.GetFirstAvailablePowerUpIndex = function (f11_arg0)
	for f11_local0 = 1, #CoD.PowerUps.ClientFieldNames, 1 do
		if not f11_arg0.powerUps[f11_local0].powerUpId then
			return f11_local0
		end
	end
	return nil
end

CoD.PowerUps.PowerUpIcon_UpdatePosition = function (f12_arg0, f12_arg1)
	if f12_arg1.interrupted ~= true then
		f12_arg0:dispatchEventToParent({
			name = "powerups_update_position"
		})
	end
end

CoD.PowerUps.UpdatePosition = function (f13_arg0, f13_arg1)
	local f13_local0 = nil
	local f13_local1 = 0
	local f13_local2 = 0
	local f13_local3 = nil
	for f13_local4 = 1, #CoD.PowerUps.ClientFieldNames, 1 do
		f13_local0 = f13_arg0.powerUps[f13_local4]
		if f13_local0.powerUpId ~= nil then
			if not f13_local3 then
				f13_local1 = -(CoD.PowerUps.IconSize * 0.5 * f13_arg0.activePowerUpCount + CoD.PowerUps.Spacing * 0.5 * (f13_arg0.activePowerUpCount - 1))
			else
				f13_local1 = f13_local3 + CoD.PowerUps.IconSize + CoD.PowerUps.Spacing
			end
			f13_local2 = f13_local1 + CoD.PowerUps.IconSize
			f13_local0:beginAnimation("move", CoD.PowerUps.MOVING_DURATION)
			f13_local0:setLeftRight(false, false, f13_local1, f13_local2)
			f13_local3 = f13_local1
		end
	end
end

