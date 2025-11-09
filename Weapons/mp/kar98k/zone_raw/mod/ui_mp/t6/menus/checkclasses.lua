require("T6.CoDBase")
CoD.CheckClasses = {}
CoD.CheckClasses.checkGameModeMastery = function (f1_arg0, f1_arg1, f1_arg2)
	local f1_local0 = false
	local f1_local1 = Engine.GetChallengeInfoForImages(f1_arg1, f1_arg2)
	local f1_local2 = #f1_local1
	local f1_local3, f1_local4 = nil
	local f1_local5 = 0
	local f1_local6 = 0
	for f1_local10, f1_local11 in ipairs(f1_local1) do
		local f1_local12 = f1_local11.challengeRow
		local f1_local13 = f1_local11.tableNum
		local f1_local14 = f1_local11.isLocked
		local f1_local15, f1_local16 = nil
		if f1_local12 ~= nil then
			if UIExpression.TableLookupGetColumnValueForRow(f1_arg1, "mp/statsmilestones" .. f1_local13 + 1 .. ".csv", f1_local12, 5) == "CHALLENGE_MASTERY_GAMEMODE" then
				f1_local3 = f1_local11.currentChallengeRow
				f1_local5 = f1_local11.currChallengeStatValue
				f1_local4 = f1_local11.challengeStatName
			end
			if f1_local14 == false then
				f1_local6 = f1_local6 + 1
			end
		end
	end
	if f1_local4 ~= nil and f1_local5 ~= f1_local6 then
		f1_arg0.PlayerStatsByGameType[f1_arg2][f1_local4].challengeValue:set(f1_local6)
		f1_local0 = true
	end
	return f1_local0
end

CoD.CheckClasses.CheckChallenges = function (f2_arg0, f2_arg1)
	local f2_local0 = false
	local f2_local1 = {
		{
			"weapon_assault",
			"primary_mastery",
			135,
			0
		},
		{
			"weapon_pistol",
			"secondary_mastery",
			75,
			0
		},
		{
			"weapon_smg",
			"primary_mastery",
			90,
			0
		},
		{
			"weapon_lmg",
			"primary_mastery",
			60,
			0
		},
		{
			"weapon_sniper",
			"primary_mastery",
			60,
			0
		},
		{
			"weapon_cqb",
			"primary_mastery",
			60,
			0
		},
		{
			"weapon_launcher",
			"secondary_mastery",
			45,
			0
		},
		{
			"weapon_special",
			"secondary_mastery",
			60,
			0
		}
	}
	local f2_local2 = {
		{
			"primary_mastery",
			0
		},
		{
			"secondary_mastery",
			0
		}
	}
	local f2_local3 = CoD.MAX_RANKXP
	local f2_local4 = tonumber(CoD.MAX_PRESTIGE)
	local f2_local5 = f2_arg0.playerStatsList.RANKXP.statValue
	local f2_local6 = f2_arg0.playerStatsList.PLEVEL.statValue
	local f2_local7 = f2_local5:get()
	local f2_local8 = f2_local6:get()
	local f2_local9
	f2_local5:set(f2_local3)
	f2_local6:set(f2_local4)
	for f2_local9 = 0, 84, 1 do --84 --end of guns section (miscweapon).
		local f2_local12 = f2_arg0.itemStats[f2_local9].stats.challenges.challengeValue
		local f2_local13 = f2_local12:get()
		if f2_local12:get() > 0 then
			local f2_local14 = 0
			for f2_local15 = 1, 14, 1 do
				if not Engine.GetItemOptionLocked(f2_arg1, f2_local9, f2_local15) then
					f2_local14 = f2_local14 + 1
				end
			end
			if f2_local14 == 14 then
				f2_local14 = 15
			end
			if f2_local14 ~= f2_local12:get() then
				f2_local12:set(f2_local14)
				f2_local0 = true
			end
			if f2_local14 > 0 and not Engine.GetDLCNameForItem(f2_local9) then
				local f2_local16 = UIExpression.GetItemGroup(nil, f2_local9)
				if f2_local16 and f2_local16 ~= "" then
					for f2_local25, f2_local26 in ipairs(f2_local1) do
						if string.lower(f2_local16) == f2_local26[1] then
							f2_local26[4] = f2_local26[4] + f2_local14
							if f2_local26[3] <= f2_local26[4] then
								for f2_local23, f2_local24 in ipairs(f2_local2) do
									if string.lower(f2_local24[1]) == f2_local26[2] then
										f2_local24[2] = f2_local24[2] + 1
									end
								end
							end
						end
					end
				end
			end
		end
	end
	for f2_local27, f2_local12 in ipairs(f2_local1) do
		local f2_local13 = f2_arg0.groupStats[f2_local12[1]].stats.challenges.challengeValue
		local f2_local14 = f2_local13:get()
		if f2_local13:get() ~= f2_local12[4] then
			f2_local13:set(f2_local12[4])
			f2_local0 = true
		end
	end
	for f2_local27, f2_local12 in ipairs(f2_local2) do
		local f2_local13 = f2_arg0.playerStatsList[f2_local12[1]].challengeValue
		local f2_local14 = f2_local13:get()
		if f2_local13:get() ~= f2_local12[2] then
			f2_local13:set(f2_local12[2])
			f2_local0 = true
		end
	end
	f2_local5:set(f2_local7)
	f2_local6:set(f2_local8)
	f2_local9 = CoD.CheckClasses.checkGameModeMastery(f2_arg0, f2_arg1, "dem")
	if f2_local9 ~= 0 then
		f2_local0 = f2_local9
	else

	end
	f2_local9 = CoD.CheckClasses.checkGameModeMastery(f2_arg0, f2_arg1, "sd")
	if f2_local9 ~= 0 then
		f2_local0 = f2_local9
	else

	end
	return f2_local0
end

CoD.CheckClasses.IsItemValid = function (f3_arg0, f3_arg1, f3_arg2, f3_arg3)
	if 0 < f3_arg1 and Engine.ItemIndexValid(f3_arg1) == false then
		return false
	elseif f3_arg2 and (UIExpression.IsItemPurchased(f3_arg0, f3_arg1) == 0 or f3_arg3 == 0) then
		return false
	else
		return true
	end
end

CoD.CheckClasses.ClearWeapon = function (f4_arg0, f4_arg1)
	f4_arg0[f4_arg1 .. "attachment1"]:set(0)
	f4_arg0[f4_arg1 .. "attachment2"]:set(0)
	f4_arg0[f4_arg1 .. "attachment3"]:set(0)
	f4_arg0[f4_arg1 .. "emblem"]:set(0)
	f4_arg0[f4_arg1 .. "camo"]:set(0)
	f4_arg0[f4_arg1 .. "tag"]:set(0)
	f4_arg0[f4_arg1 .. "reticle"]:set(0)
end

CoD.CheckClasses.ClearSlot = function (f5_arg0, f5_arg1)
	f5_arg0[f5_arg1]:set(0)
end

CoD.CheckClasses.GetEquippedBonusCards = function (f6_arg0, f6_arg1, f6_arg2)
	local f6_local0 = f6_arg1.customclass[f6_arg2]
	if f6_local0 == nil then
		return false
	end
	local f6_local1 = {}
	for f6_local2 = 1, 3, 1 do
		local f6_local5 = f6_local0["bonuscard" .. f6_local2]:get()
		local f6_local6 = UIExpression.GetItemRef(nil, f6_local5)
		if f6_local5 > 0 then
			f6_local1[f6_local6] = true
		end
	end
	return f6_local1
end

CoD.CheckClasses.CheckItems = function (f7_arg0, f7_arg1, f7_arg2, items_count, f7_arg4) --(9, true).
	local classsets = {
		"class_custom_assault",
		"class_custom_smg",
		"class_custom_lmg",
		"class_custom_cqb",
		"class_custom_sniper"
	}
	local f7_local1 = false
	local f7_local2 = CoD.CACUtility.loadoutSlotNames
	local f7_local3 = f7_arg2.customclass
	local f7_local4 = f7_arg0.playerStatsList.RANKXP.statValue:get()
	local gunsection_eidx = 162 --59 --Guns section end in statstable.csv.
	local grenadesection_sidx = 163 --63 --Grenades section start in statstable.csv.
	local grenadesection_eidx = 180 --78 --Grenades section end in statstable.csv.
	for i = 0, items_count, 1 do
		local f7_local11 = f7_local3[i]
		if f7_local11 == nil then
			break
		end
		local f7_local12 = CoD.CheckClasses.GetEquippedBonusCards(f7_arg0, f7_arg2, i)
		for f7_local24, f7_local25 in pairs(f7_local2) do
			local f7_local16 = nil
			if string.find(f7_local25, "killstreak") then
				f7_local16 = f7_arg2[f7_local25]
			else
				f7_local16 = f7_local11[f7_local25]
			end
			if f7_local16 then
				local f7_local17 = f7_local16:get()
				if not CoD.CheckClasses.IsItemValid(f7_arg1, f7_local17, f7_arg4, f7_local4) then
					local f7_local18 = tonumber(UIExpression.GetDefaultClassSlot(f7_arg1, classsets[i % 5 + 1], f7_local25)) --5 comes from 5x classsets in that array. The custom classes.
					if f7_local18 ~= f7_local17 then
						f7_local1 = true
						f7_local16:set(f7_local18)
						if f7_local25 == "primary" or f7_local25 == "secondary" then
							CoD.CheckClasses.ClearWeapon(f7_local11, f7_local25)
						end
					end
				elseif f7_local25 == "primary" or f7_local25 == "secondary" then
					if f7_local17 == 0 then
						CoD.CheckClasses.ClearWeapon(f7_local11, f7_local25)
					elseif gunsection_eidx < f7_local17 then
						local f7_local18 = tonumber(UIExpression.GetDefaultClassSlot(f7_arg1, classsets[i % 5 + 1], f7_local25))
						if f7_local18 ~= f7_local17 then
							f7_local1 = true
							f7_local16:set(f7_local18)
							CoD.CheckClasses.ClearWeapon(f7_local11, f7_local25)
						end
					else
						local f7_local19 = Engine.GetNumAttachments(f7_local17)
						for f7_local18 = 0, 2, 1 do
							local f7_local22 = f7_local11[f7_local25 .. "attachment" .. f7_local18 + 1]
							local f7_local23 = f7_local22:get()
							if f7_local19 < f7_local23 or f7_arg4 and Engine.GetItemAttachmentLocked(f7_arg1, f7_local17, f7_local23) ~= 0 then
								f7_local22:set(0)
							end
						end
						local f7_local18 = f7_local11[f7_local25 .. "camo"]
						local f7_local20 = f7_local18:get()
						if f7_local20 > 0 and Engine.GetItemOptionLocked(f7_arg1, f7_local17, f7_local20) then
							f7_local18:set(0)
						end
					end
				elseif f7_local25 == "primarygrenade" or f7_local25 == "specialgrenade" then
					local f7_local19 = f7_local11[f7_local25 .. "count"]
					local f7_local18 = f7_local19:get()
					if f7_local18 == 0 then
						f7_local11[f7_local25]:set(0)
					elseif f7_local18 > 2 then
						f7_local19:set(2)
					end
					if f7_local17 ~= 0 and (grenadesection_eidx < f7_local17 or f7_local17 < grenadesection_sidx) then
						CoD.CheckClasses.ClearSlot(f7_local11, f7_local25)
						f7_local1 = true
					end
				end
				if f7_local25 == "primarygrenade" then
					if Engine.GetLoadoutSlotForItem(f7_local17) == "specialgrenade" then
						if f7_local12.bonuscard_two_tacticals ~= true then
							CoD.CheckClasses.ClearSlot(f7_local11, f7_local25)
							f7_local1 = true
						end
					end
					if f7_local11[f7_local25 .. "count"]:get() == 2 and f7_local12.bonuscard_danger_close ~= true then
						CoD.CheckClasses.ClearSlot(f7_local11, f7_local25)
						f7_local1 = true
					end
				end
				if f7_local25 == "specialty4" then
					if f7_local17 > 0 and f7_local12.bonuscard_perk_1_greed ~= true then
						CoD.CheckClasses.ClearSlot(f7_local11, f7_local25)
						f7_local1 = true
					end
				end
				if f7_local25 == "specialty5" then
					if f7_local17 > 0 and f7_local12.bonuscard_perk_2_greed ~= true then
						CoD.CheckClasses.ClearSlot(f7_local11, f7_local25)
						f7_local1 = true
					end
				end
				if f7_local25 == "specialty6" then
					if f7_local17 > 0 and f7_local12.bonuscard_perk_3_greed ~= true then
						CoD.CheckClasses.ClearSlot(f7_local11, f7_local25)
						f7_local1 = true
					end
				end
				if f7_local25 == "primary" then
					if f7_local11[f7_local25 .. "attachment3"]:get() > 0 and f7_local12.bonuscard_primary_gunfighter ~= true then
						CoD.CheckClasses.ClearSlot(f7_local11, f7_local25 .. "attachment3")
						f7_local1 = true
					end
				end
				if f7_local25 == "secondary" then
					if Engine.GetLoadoutSlotForItem(f7_local17) == "primary" and f7_local12.bonuscard_overkill ~= true then
						CoD.CheckClasses.ClearSlot(f7_local11, f7_local25)
						f7_local1 = true
					end
					if f7_local11[f7_local25 .. "attachment2"]:get() > 0 and f7_local12.bonuscard_secondary_gunfighter ~= true then
						CoD.CheckClasses.ClearSlot(f7_local11, f7_local25 .. "attachment2")
						f7_local1 = true
					end
				end
			end
		end
	end
	return f7_local1
end

CoD.CheckClasses.UpdateTrackerLeaderboard = function (f8_arg0)
	Engine.ExecNow(f8_arg0, "trackerupdate super_offensive 1")
end

CoD.CheckClasses.CheckMTXPurchased = function (f9_arg0, f9_arg1, f9_arg2)
	local f9_local0 = {}
	local f9_local1 = "mp/mtxitems.csv"
	local f9_local2 = Engine.GetTableRowCount(f9_local1)
	local f9_local3 = 0
	local f9_local4 = 1
	local f9_local5 = "mp/attachmentTable.csv"
	local f9_local6 = 16
	local f9_local7 = 0
	local f9_local8 = false
	for f9_local9 = 0, f9_local2, 1 do
		local f9_local12 = UIExpression.TableLookupGetColumnValueForRow(nil, f9_local1, f9_local9, f9_local4)
		if string.len(f9_local12) > 0 then
			local f9_local13 = Engine.TableFindRows(f9_local5, f9_local6, f9_local12)
			if f9_local13 ~= nil then
				for f9_local17, f9_local18 in pairs(f9_local13) do
					f9_local0[UIExpression.TableLookupGetColumnValueForRow(nil, f9_local5, f9_local18, f9_local7)] = Engine.HasMTX(f9_arg0, f9_local12)
				end
			end
		end
	end
	local f9_local9 = 9
	local f9_local10 = f9_arg2.customclass
	for f9_local11 = 0, f9_local9, 1 do
		local f9_local14 = f9_local10[f9_local11]
		if f9_local14 == nil then
			break
		elseif CoD.CheckClasses.CheckMTXItem(f9_local14, "primarycamo", f9_local0) then
			f9_local8 = true
		end
		if CoD.CheckClasses.CheckMTXItem(f9_local14, "primaryreticle", f9_local0) then
			f9_local8 = true
		end
		if CoD.CheckClasses.CheckMTXItem(f9_local14, "secondarycamo", f9_local0) then
			f9_local8 = true
		end
		if CoD.CheckClasses.CheckMTXItem(f9_local14, "secondaryreticle", f9_local0) then
			f9_local8 = true
		end
		if CoD.CheckClasses.CheckMTXItem(f9_local14, "knifecamo", f9_local0) then
			f9_local8 = true
		end
	end
	if f9_local8 then
		CoD.CheckClasses.UpdateTrackerLeaderboard(f9_arg0)
	end
	return f9_local8
end

CoD.CheckClasses.CheckMTXItem = function (f10_arg0, f10_arg1, f10_arg2)
	local f10_local0 = f10_arg0[f10_arg1]
	local f10_local1 = f10_arg2[tostring(f10_local0:get())]
	local f10_local2 = false
	if f10_local1 ~= nil and f10_local1 == false then
		f10_local0:set(0)
		f10_local2 = true
	end
	return f10_local2
end

CoD.CheckClasses.CheckProbation = function (f11_arg0, f11_arg1, f11_arg2)
	local f11_local0 = false
	local f11_local1 = Dvar.probation_public_probationTime:get() * 60
	local f11_local2 = Dvar.probation_league_probationTime:get() * 60
	local f11_local3 = Engine.GetProbationTime(f11_arg0, CoD.GAMEMODE_PUBLIC_MATCH)
	local f11_local4 = Engine.GetProbationTime(f11_arg0, CoD.GAMEMODE_LEAGUE_MATCH)
	if f11_local3 < 0 or f11_local1 < f11_local3 then
		f11_local0 = true
		f11_arg1.probation.PUBLICMATCH.timeWhenProbationIsDone:set(0)
		f11_arg1.probation.PUBLICMATCH.count:set(0)
	end
	if f11_local4 < 0 or f11_local2 < f11_local4 then
		f11_local0 = true
		f11_arg1.probation.LEAGUEMATCH.timeWhenProbationIsDone:set(0)
		f11_arg1.probation.LEAGUEMATCH.count:set(0)
	end
	return f11_local0
end

CoD.CheckClasses.CheckClasses = function (f12_arg0, f12_arg1)
	local f12_local0 = 3
	if CoD.isPC then
		f12_local0 = 0
	end
	for f12_local1 = 0, f12_local0, 1 do
		if UIExpression.AreStatsFetched(f12_local1) == 1 then
			local f12_local4 = Engine.GetPlayerStats(f12_local1)
			local f12_local5 = false
			if f12_local4 then
				local f12_local6 = f12_local4.skill_rating:get()
				if f12_local6 >= 20 or f12_local6 <= -20 then
					f12_local4.skill_rating:set(0)
					f12_local4.skill_variance:set(1)
				end
				local f12_local7 = f12_local4.cacLoadouts
				f12_local7.iamacheater:set(0)
				if CoD.CheckClasses.CheckChallenges(f12_local4, f12_local1) then
					f12_local5 = true
				end
				if CoD.CheckClasses.CheckItems(f12_local4, f12_local1, f12_local7, 9, true) then
					f12_local5 = true
				end
				if CoD.CheckClasses.CheckMTXPurchased(f12_local1, f12_local4, f12_local7) then
					f12_local5 = true
				end
				f12_local7 = f12_local4.customMatchCacLoadouts
				if CoD.CheckClasses.CheckItems(f12_local4, f12_local1, f12_local7, 5, false) then
					f12_local5 = true
				end
				if CoD.CheckClasses.CheckMTXPurchased(f12_local1, f12_local4, f12_local7) then
					f12_local5 = true
				end
				f12_local7 = f12_local4.leagueCacLoadouts
				if CoD.CheckClasses.CheckItems(f12_local4, f12_local1, f12_local7, 5, false) then
					f12_local5 = true
				end
				if CoD.CheckClasses.CheckMTXPurchased(f12_local1, f12_local4, f12_local7) then
					f12_local5 = true
				end
				if CoD.CheckClasses.CheckProbation(f12_local1, f12_local4, f12_local7) then
					f12_local5 = true
				end
				if f12_local5 then
					Engine.Exec(f12_local1, "uploadstats")
				end
			end
		end
	end
end

if not CoD.statsChecker then
	CoD.statsChecker = LUI.UIElement.new()
	LUI.roots.UIRootFull:addElement(CoD.statsChecker)
end
CoD.statsChecker:registerEventHandler("stats_downloaded", CoD.CheckClasses.CheckClasses)
CoD.statsChecker:registerEventHandler("class_sets_downloaded", CoD.CheckClasses.CheckClasses)
CoD.statsChecker:registerEventHandler("elite_cac_import_popup_closed", CoD.CheckClasses.CheckClasses)
CoD.CheckClasses.CheckClasses()
