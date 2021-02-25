--//////////////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Wondrous Goody Huts by SailorCat
-- Special Thanks: Gedemon
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////
--ExposedMembers.GameEvents = GameEvents
--// Testing Purposes Only
--[[local sContinentsInUse = Map.GetContinentsInUse()
for i, k in ipairs(sContinentsInUse) do
	local sContinentPlots = Map.GetContinentPlots(k)
	for i, v in ipairs(sContinentPlots) do
		local sPlot = Map.GetPlotByIndex(v)
		if sPlot:GetImprovementType() ~= -1 then
			local sPlotIndex = sPlot:GetImprovementType()
			local sPlotImpType = GameInfo.Improvements[sPlotIndex].ImprovementType
			if sPlotImpType == "IMPROVEMENT_GOODY_HUT" or sPlotImpType == "IMPROVEMENT_BARBARIAN_CAMP" then
				local sPlayerVisibility = PlayersVisibility[0]
				local sVisibility = sPlayerVisibility:GetVisibilityCount(sPlot)
				sPlayerVisibility:ChangeVisibilityCount(sPlot, 1)
			end
		end
	end
end]]--

--// Gathering wonder plots for later...
local tSailorWonderTable = {}
local sailorContinentsInUse = Map.GetContinentsInUse()
for i, pContinent in ipairs(sailorContinentsInUse) do
	local sailorContinentPlots = Map.GetContinentPlots(pContinent)
	for i, plot in ipairs(sailorContinentPlots) do
		pPlot = Map.GetPlotByIndex(plot)
		if pPlot:IsNaturalWonder() == true then
			local pPlotFeatureIndex = pPlot:GetFeatureType()
			local pPlotFeatureType = GameInfo.Features[pPlotFeatureIndex].FeatureType
			table.insert(tSailorWonderTable, pPlot)
		end
	end
end

--///////////////////////////////////////////////////////
-- Expanded Goodies Main Function
--///////////////////////////////////////////////////////
local abilityResource		= "ABILITY_SAILOR_GOODY_RANDOMRESOURCE"
local abilityUnit			= "ABILITY_SAILOR_GOODY_RANDOMUNIT"
local abilityImprovement	= "ABILITY_SAILOR_GOODY_RANDOMIMPROVEMENT"
local abilitySight			= "ABILITY_SAILOR_GOODY_SIGHTBOMB"
local abilityFormation		= "ABILITY_SAILOR_GOODY_FORMATION"
local abilityPolicy			= "ABILITY_SAILOR_GOODY_RANDOMPOLICY"
local abilityWonder			= "ABILITY_SAILOR_GOODY_WONDER"
local abilityCityState		= "ABILITY_SAILOR_GOODY_CITYSTATE"

function Sailor_Expanded_Goodies(playerID, unitID, iUnknown1, iUnknown2)
	local sPlayer = Players[playerID]
	local sPlayerUnits = sPlayer:GetUnits()
	local sUnit = sPlayerUnits:FindID(unitID)
	local iX, iY = sUnit:GetX(), sUnit:GetY()
	local unitList:table = Units.GetUnitsInPlotLayerID(iX, iY, MapLayers.ANY)
	if unitList ~= nil then
		for i, pUnit in ipairs(unitList) do
			local pUnitAbility = pUnit:GetAbility()
			local pOwner = pUnit:GetOwner()
			local pPlayer = Players[pOwner]

			local switchRandResource		= pUnitAbility:GetAbilityCount(abilityResource)
			local switchRandUnit			= pUnitAbility:GetAbilityCount(abilityUnit)
			local switchRandImprovement		= pUnitAbility:GetAbilityCount(abilityImprovement)
			local switchSightBomb			= pUnitAbility:GetAbilityCount(abilitySight)
			local switchFormation			= pUnitAbility:GetAbilityCount(abilityFormation)
			local switchRandPolicy			= pUnitAbility:GetAbilityCount(abilityPolicy)
			local switchWonder				= pUnitAbility:GetAbilityCount(abilityWonder)
			local switchCityState			= pUnitAbility:GetAbilityCount(abilityCityState)
--// Random Resource
			if switchRandResource == 1 then
				print("//// Wondrous Goody Type Activated: Random Resource")
				local pTile, iResource = Sailor_Goody_RandomResource(pPlayer) --// Call Random Resource Roller Function
				if pTile ~= nil then
					ResourceBuilder.SetResourceType(pTile, iResource, 1)
					if pPlayer:IsHuman() then
						Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_LIGHTBLUE]Resource spawned![ENDCOLOR]"), pTile:GetX(), pTile:GetY(), 0)
					end
					pUnitAbility:ChangeAbilityCount(abilityResource, -switchRandResource)
					break
				else --// Catch for nil: random unit spawner...
					print("Door's stuck! Spawning unit instead.")
					local sTargetUnit, iSpawnX, iSpawnY = Sailor_Goody_RandomUnit(pPlayer) --// Call Random Unit Roller Function
					UnitManager.InitUnit(pOwner, sTargetUnit, iSpawnX, iSpawnY)
					pUnitAbility:ChangeAbilityCount(abilityResource, -switchRandResource)
					if pPlayer:IsHuman() then
						Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_LIGHTBLUE]Valid placement not found! Spawning unit instead.[ENDCOLOR]"), iX, iY, 0)
					end
					break
				end
			end
--// Random Unit
			if switchRandUnit == 1 then
				print("//// Wondrous Goody Type Activated: Random Unit")
				local sTargetUnit, iSpawnX, iSpawnY = Sailor_Goody_RandomUnit(pPlayer) --// Call Random Unit Roller Function
				UnitManager.InitUnit(pOwner, sTargetUnit, iSpawnX, iSpawnY)
				pUnitAbility:ChangeAbilityCount(abilityUnit, -switchRandUnit)
				break
			end
--// Random Improvement
			if switchRandImprovement == 1 then 
				print("//// Wondrous Goody Type Activated: Random Improvement")
				local pTile, iImprovement = Sailor_Goody_RandomImprovement(pPlayer) --// Call Random Improvement Roller Function
				if pTile ~= nil then
					ImprovementBuilder.SetImprovementType(pTile, iImprovement, 1)
					pUnitAbility:ChangeAbilityCount(abilityImprovement, -switchRandImprovement)
					break
				else --// Catch for nil: random unit spawner...
					print("Door's stuck! Spawning unit instead.")
					local sTargetUnit, iSpawnX, iSpawnY = Sailor_Goody_RandomUnit(pPlayer) --// Call Random Unit Roller Function
					UnitManager.InitUnit(pOwner, sTargetUnit, iSpawnX, iSpawnY)
					pUnitAbility:ChangeAbilityCount(abilityImprovement, -switchRandImprovement)
					if pPlayer:IsHuman() then
						Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_LIGHTBLUE]Valid placement not found! Spawning unit instead.[ENDCOLOR]"), iX, iY, 0)
					end
					break
				end
			end
--// Sight
			if switchSightBomb == 1 then
				print("//// Wondrous Goody Type Activated: Wilderness Training")
				local sAbility = pUnitAbility:GetAbilityCount("ABILITY_SAILOR_GOODY_WILDERNESS")
				if sAbility == 0 then
					pUnitAbility:ChangeAbilityCount("ABILITY_SAILOR_GOODY_WILDERNESS", 1)
					pUnitAbility:ChangeAbilityCount(abilitySight, -switchSightBomb)
				else
					print("Door's stuck! Spawning unit instead.")
					local sTargetUnit, iSpawnX, iSpawnY = Sailor_Goody_RandomUnit(pPlayer) --// Call Random Unit Roller Function
					UnitManager.InitUnit(pOwner, sTargetUnit, iSpawnX, iSpawnY)
					if pPlayer:IsHuman() then
						Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_LIGHTBLUE]Unit already has ability! Spawning unit instead.[ENDCOLOR]"), iX, iY, 0)
					end
					pUnitAbility:ChangeAbilityCount(abilitySight, -switchSightBomb)
					break
				end
			end
--// Formation
			if switchFormation == 1 then
				print("//// Wondrous Goody Type Activated: Formation")
				local pUnitFormation = pUnit:GetMilitaryFormation()
				if pUnitFormation > 1 or GameInfo.Units[pUnit:GetType()].FormationClass == 'FORMATION_CLASS_CIVILIAN' or GameInfo.Units[pUnit:GetType()].FormationClass == 'FORMATION_CLASS_SUPPORT' then
					print("Door's stuck! Spawning unit instead.")
					local sTargetUnit, iSpawnX, iSpawnY = Sailor_Goody_RandomUnit(pPlayer) --// Call Random Unit Roller Function
					UnitManager.InitUnit(pOwner, sTargetUnit, iSpawnX, iSpawnY)
					if pPlayer:IsHuman() then
						Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_LIGHTBLUE]Can't apply formation! Spawning unit instead.[ENDCOLOR]"), iX, iY, 0)
					end
					--Sailor_Goodies_Reroller(pUnitAbility, iX, iY, eOwner)
					break
				elseif pUnitFormation == 1 then
					local armyAbility = pUnitAbility:GetAbilityCount("ABILITY_SAILOR_GOODY_FORMATION_ARMY")
					pUnitAbility:ChangeAbilityCount("ABILITY_SAILOR_GOODY_FORMATION_ARMY", 1)
					pUnitAbility:ChangeAbilityCount(abilityFormation, -switchFormation)
					break
				else
					local corpsAbility = pUnitAbility:GetAbilityCount("ABILITY_SAILOR_GOODY_FORMATION_CORPS")
					pUnitAbility:ChangeAbilityCount("ABILITY_SAILOR_GOODY_FORMATION_CORPS", 1)
					pUnitAbility:ChangeAbilityCount(abilityFormation, -switchFormation)
					break
					--GameEvents.Sailor_GoodiesFormationSwitch.Call(unitID, pUnit, pUnitFormation, pPlayer)
				end
			end
--// RandomPolicy
			if switchRandPolicy == 1 then
				print("//// Wondrous Goody Type Activated: Policy")
				local pPlayerCulture = pPlayer:GetCulture()
				local iPolicy = Sailor_Goody_RandomPolicy(pPlayer)
				if iPolicy ~= nil then
					pPlayerCulture:UnlockPolicy(iPolicy)
					pUnitAbility:ChangeAbilityCount(abilityPolicy, -switchRandPolicy)
					break
				else --// Catch for nil: random unit spawner...
					print("Door's stuck! Spawning unit instead.")
					local sTargetUnit, iSpawnX, iSpawnY = Sailor_Goody_RandomUnit(pPlayer) --// Call Random Unit Roller Function
					UnitManager.InitUnit(pOwner, sTargetUnit, iSpawnX, iSpawnY)
					pUnitAbility:ChangeAbilityCount(abilityPolicy, -switchRandPolicy)
					if pPlayer:IsHuman() then
						Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_LIGHTBLUE]Valid policy not found! Spawning unit instead.[ENDCOLOR]"), iX, iY, 0)
					end
					break
				end
			end
--// Wonder
			if switchWonder == 1 then
				local pPlayerVisibility = PlayersVisibility[pPlayer:GetID()]
				print("//// Wondrous Goody Type Activated: Wonder")
				local wonTable = Sailor_Goody_Wonder(pPlayer, pPlayerVisibility)
				if wonTable ~= nil then
					for k, v in ipairs(wonTable) do
						local pVisibility = pPlayerVisibility:GetVisibilityCount(v)
						pPlayerVisibility:ChangeVisibilityCount(v, 1)
					end
					--[[ Old, will teleport unit to wonder.							
					UnitManager.RestoreMovement(pUnit)
					UnitManager.PlaceUnit(pUnit, iWonX, iWonY)
					pUnitAbility:ChangeAbilityCount(abilityWonder, -switchWonder)]]--
					break
				else --// Catch for nil: random unit spawner...
					print("Door's stuck! Spawning unit instead.")
					local sTargetUnit, iSpawnX, iSpawnY = Sailor_Goody_RandomUnit(pPlayer) --// Call Random Unit Roller Function
					UnitManager.InitUnit(pOwner, sTargetUnit, iSpawnX, iSpawnY)
					pUnitAbility:ChangeAbilityCount(abilityWonder, -switchWonder)
					if pPlayer:IsHuman() then
						Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_LIGHTBLUE]Valid wonder not found! Spawning unit instead.[ENDCOLOR]"), iX, iY, 0)
					end
					break
				end
			end
			--[[ Old, will teleport unit to wonder.
			if switchWonder == 1 then
				print("//// Wondrous Goody Type Activated: Wonder")
				local iWonX, iWonY = Sailor_Goody_Wonder(pPlayer)
				if (iWonX ~= nil) and (iWonY ~= nil) then
					UnitManager.RestoreMovement(pUnit)
					UnitManager.PlaceUnit(pUnit, iWonX, iWonY)
					pUnitAbility:ChangeAbilityCount(abilityWonder, -switchWonder)
					break
				else --// Catch for nil: random unit spawner...
					print("Door's stuck! Spawning unit instead.")
					local sTargetUnit, iSpawnX, iSpawnY = Sailor_Goody_RandomUnit(pPlayer) --// Call Random Unit Roller Function
					UnitManager.InitUnit(pOwner, sTargetUnit, iSpawnX, iSpawnY)
					pUnitAbility:ChangeAbilityCount(abilityWonder, -switchWonder)
					if pPlayer:IsHuman() then
						Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_LIGHTBLUE]Valid wonder not found! Spawning unit instead.[ENDCOLOR]"), iX, iY, 0)
					end
					break
				end
			end
			]]--
--// City-State
			if switchCityState == 1 then
				print("//// Wondrous Goody Type Activated: City-State")
				local pPlayerDiplomacy = pPlayer:GetDiplomacy()
				local sTargetCS = Sailor_Goody_CityState(pOwner, pPlayer, pPlayerDiplomacy)
				if sTargetCS ~= nil then
					pPlayerDiplomacy:SetHasMet(sTargetCS)
					pUnitAbility:ChangeAbilityCount(abilityCityState, -switchCityState)
					break
				else --// Catch for nil: random unit spawner...
					print("Door's stuck! Spawning unit instead.")
					local sTargetUnit, iSpawnX, iSpawnY = Sailor_Goody_RandomUnit(pPlayer) --// Call Random Unit Roller Function
					UnitManager.InitUnit(pOwner, sTargetUnit, iSpawnX, iSpawnY)
					pUnitAbility:ChangeAbilityCount(abilityCityState, -switchCityState)
					if pPlayer:IsHuman() then
						Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_LIGHTBLUE]Valid city-state not found! Spawning unit instead.[ENDCOLOR]"), iX, iY, 0)
					end
					break
				end
			end
		end
	end
end
Events.GoodyHutReward.Add(Sailor_Expanded_Goodies)

--// Swap to UI...
--[[function Sailor_GoodiesFormationSwitch(unitID, pUnit, pUnitFormation, pPlayer)
	Sailor_GoodiesFormation(unitID, pUnit, pUnitFormation, pPlayer)
end]]--

--///////////////////////////////////////////////////////
-- Grabbing City Plots
--///////////////////////////////////////////////////////
local iCityRadius = 5
function GetCityPlots(pCity, resourceSwitch)
	local tTempTable = {}
	if pCity ~= nil then
		local iCityOwner = pCity:GetOwner()
		local iCityX, iCityY = pCity:GetX(), pCity:GetY()
		for dx = (iCityRadius * -1), iCityRadius do
			for dy = (iCityRadius * -1), iCityRadius do
				local pPlotNearCity = Map.GetPlotXYWithRangeCheck(iCityX, iCityY, dx, dy, iCityRadius);
				if pPlotNearCity and (pPlotNearCity:GetOwner() == iCityOwner) and (pCity == Cities.GetPlotPurchaseCity(pPlotNearCity:GetIndex())) then
					local pPlotTerrainIndex = pPlotNearCity:GetTerrainType()
					local pPlotTerrainType = GameInfo.Terrains[pPlotTerrainIndex].TerrainType
					local pPlotFeatureType = ""
					if pPlotNearCity:GetFeatureType() > -1 then
						local pPlotFeatureIndex = pPlotNearCity:GetFeatureType()
						pPlotFeatureType = GameInfo.Features[pPlotFeatureIndex].FeatureType
					end
					if resourceSwitch == 1 then
						if (not pPlotNearCity:IsMountain()) and (pPlotFeatureType ~= "FEATURE_GEOTHERMAL_FISSURE") and (pPlotNearCity:GetResourceType() == -1) and (not pPlotNearCity:IsNaturalWonder()) then
							table.insert(tTempTable, pPlotNearCity)
						end
					else 
						local invalidTile = 0
						if (not pPlotNearCity:IsMountain())	and (not pPlotNearCity:IsNaturalWonder()) and (pPlotNearCity:GetImprovementType() == -1) then
							local pCityDistricts = pCity:GetDistricts()
							for i = 0, pCityDistricts:GetNumDistricts() - 1 do
								local pDistrict = pCityDistricts:GetDistrictByIndex(i)
								local iPlotX, iPlotY = pPlotNearCity:GetX(), pPlotNearCity:GetY()
								local iDistrictX, iDistrictY = pDistrict:GetX(), pDistrict:GetY()
								if (iPlotX == iDistrictX) and (iPlotY == iDistrictY) then
									invalidTile = 1
								end
							end
							if invalidTile == 0 then 
								table.insert(tTempTable, pPlotNearCity)
							end
						end
					end
				end
			end
		end
	end
	return tTempTable
end

--///////////////////////////////////////////////////////
-- Random Resource Roller
--///////////////////////////////////////////////////////
function Sailor_Goody_RandomResource(pPlayer)
	local tValidTiles = {}
	local resourceSwitch = 1
	local pPlayerCities = pPlayer:GetCities()

    --// Rolling city...
    local iNumberofCities = 0
	local tCities = {}
    for i, pIterCity in pPlayerCities:Members() do
		tCities[i] = pIterCity
        iNumberofCities = iNumberofCities + 1
    end

    while iNumberofCities > 0 do
        iRandom = TerrainBuilder.GetRandomNumber(iNumberofCities, "City Roller")+1
        for i, pIterCity in ipairs(tCities) do
            if i == iRandom then
                local pCityLoc = pIterCity:GetName()
				local iIteration = i
                --// Rolling tiles...
                local pCityPlots = GetCityPlots(pIterCity, resourceSwitch)
                local iNumberofTiles = 0
                for i, pTile in ipairs(pCityPlots, resourceSwitch) do
                    iNumberofTiles = iNumberofTiles + 1
                end

                if iNumberofTiles > 0 then
                    iRandom2 = TerrainBuilder.GetRandomNumber(iNumberofTiles, "Tile Roller")+1
                    for i, pTile in ipairs(pCityPlots) do
                        if i == iRandom2 then

                            --// Gathering and validating resources...
                            local tValidResources = {}
                            local pTileIndex = pTile:GetTerrainType()
                            local pTileTerrainType = GameInfo.Terrains[pTileIndex].TerrainType
                            local pPlayerTechs = pPlayer:GetTechs()
							local iNumberofResources = 0
							for i, tRow in ipairs(DB.Query("SELECT ResourceType FROM Resources WHERE (Frequency > 0 OR SeaFrequency > 0) AND (ResourceType IN (SELECT ResourceType from Resource_ValidTerrains WHERE TerrainType = '" .. pTileTerrainType .. "'))")) do
								if (tRow.PrereqTech == nil) or (pPlayerTechs:HasTech(GameInfo.Technologies[tRow.PrereqTech].Index)) then
									tValidResources[i] = tRow
									iNumberofResources = iNumberofResources + 1
								end
                            end

                            --// Rolling resources...
                            if iNumberofResources > 0 then
                                iRandom3 = TerrainBuilder.GetRandomNumber(iNumberofResources-1, "Resource Roller")+1
                                for i, pResource in ipairs(tValidResources) do
                                    if i == iRandom3 then
                                        local pResourceRolled = pResource.ResourceType
                                        local iResource = GameInfo.Resources[pResourceRolled].Index
                                        return pTile, iResource
                                    end
                                end
                            end
                        end
                    end
				else
					iNumberofCities = iNumberofCities - 1
					table.remove(tCities, iIteration)
					break
				end
            end
        end
    end
end

--///////////////////////////////////////////////////////
-- Random Unit Roller
--///////////////////////////////////////////////////////
function Sailor_Goody_RandomUnit(pPlayer)
    local pPlayerEras = pPlayer:GetEras()
    local pPlayerEra = pPlayerEras:GetEra()
    local pPlayerEraType = GameInfo.Eras[pPlayerEra].EraType
    local pPlayerTechs = pPlayer:GetTechs()
    local pPlayerCulture = pPlayer:GetCulture()
    local pPlayerCities = pPlayer:GetCities()
    local pCap = pPlayerCities:GetCapitalCity()
    local sailorGoodyEraGap = 3

    --// Dowsing for water...
    local pCapRadius = 5
    local sWaterTable = {}
	local iNumberWaterTiles = 0
    for dx = (pCapRadius * -1), pCapRadius do
        for dy = (pCapRadius * -1), pCapRadius do
            local sPlotNearCap = Map.GetPlotXYWithRangeCheck(pCap:GetX(), pCap:GetY(), dx, dy, pCapRadius);
            if sPlotNearCap and ((sPlotNearCap:GetOwner() == pPlayer) or (sPlotNearCap:GetOwner() == -1)) then
                local pPlotTerrainIndex = sPlotNearCap:GetTerrainType()
                local pPlotTerrainType = GameInfo.Terrains[pPlotTerrainIndex].TerrainType
                if pPlotTerrainType == "TERRAIN_COAST" then
                    table.insert(sWaterTable, sPlotNearCap)
					iNumberWaterTiles = iNumberWaterTiles + 1
                end
            end
        end
    end
    local sailorWaterSwitch = ""
    if iNumberWaterTiles > 0 then
        sailorWaterSwitch = "Domain != 'DOMAIN_AIR'"
        else sailorWaterSwitch = "Domain = 'DOMAIN_LAND'"
    end

    --// Unit collection...
    local tValidUnits = {}
	local iNumberValidUnits = 0
    for i, tRow in ipairs(DB.Query("SELECT * FROM Units WHERE " .. sailorWaterSwitch .. " AND ReligiousStrength = 0 AND CanTrain = 1 AND UnitType NOT LIKE 'UNIT_HERO%' AND UnitType NOT IN ('UNIT_ARCHAEOLOGIST', 'UNIT_SPY', 'UNIT_NATURALIST', 'UNIT_ROCK_BAND', 'UNIT_BARBARIAN_RAIDER')")) do
        if not((pPlayerEra > sailorGoodyEraGap) and (tRow.Combat > 0) and (tRow.PrereqTech == nil) and (tRow.PrereqCivic == nil)) then --/ Catching starting units...
			if (((tRow.PrereqTech == nil) or (pPlayerTechs:HasTech(GameInfo.Technologies[tRow.PrereqTech].Index) and ((pPlayerEra - GameInfo.Eras[GameInfo.Technologies[tRow.PrereqTech].EraType].Index) <= sailorGoodyEraGap)))
			 and ((tRow.PrereqCivic == nil) or (pPlayerCulture:HasCivic(GameInfo.Civics[tRow.PrereqCivic].Index) and ((pPlayerEra - GameInfo.Eras[GameInfo.Civics[tRow.PrereqCivic].EraType].Index) <= sailorGoodyEraGap)))) then
            table.insert(tValidUnits, tRow)
			iNumberValidUnits = iNumberValidUnits + 1
			end
        end
    end

    if iNumberValidUnits > 0 then
        --// Roll unit type...
        sailorRandomUnitNum = TerrainBuilder.GetRandomNumber(iNumberValidUnits, "Unit Roll") + 1
        for i, nUnit in ipairs(tValidUnits) do
            if i == sailorRandomUnitNum then
                local sTargetUnit = nUnit.UnitType
                if nUnit.Domain == 'DOMAIN_SEA' then --/ Sea spawn...
                    sailorWaterTileRoll = TerrainBuilder.GetRandomNumber(iNumberWaterTiles, "Water Tile Roll") + 1
                    for i, nTile in ipairs(sWaterTable) do
                        if i == sailorWaterTileRoll then
                            local iWaterX, iWaterY = nTile:GetX(), nTile:GetY()
                            return sTargetUnit, iWaterX, iWaterY
                        end
                    end
                else  --// Land spawn...
                    local iCapX, iCapY = pCap:GetX(), pCap:GetY()
                    return sTargetUnit, iCapX, iCapY
                end
            end
        end
    end
end

--///////////////////////////////////////////////////////
-- Random Improvement Roller by SailorCat
--///////////////////////////////////////////////////////
function Sailor_Goody_RandomImprovement(pPlayer)
	local tValidTiles = {}
	local resourceSwitch = 0
	local pPlayerCities = pPlayer:GetCities()

    --// Rolling city...
    local iNumberofCities = 0
    for i, pIterCity in pPlayerCities:Members() do
        iNumberofCities = iNumberofCities + 1
    end

    if iNumberofCities > 0 then
        iRandom = TerrainBuilder.GetRandomNumber(iNumberofCities, "City Roller")+1
        for i, pIterCity in pPlayerCities:Members() do
            if i == iRandom then
                local pCityLoc = pIterCity:GetName()

                --// Rolling tiles...
                local pCityPlots = GetCityPlots(pIterCity, resourceSwitch)
                local iNumberofTiles = 0
                for k, v in ipairs(pCityPlots) do
                    iNumberofTiles = iNumberofTiles + 1
                end

                if iNumberofTiles > 0 then
					local improvementFound = 0
					while (improvementFound == 0) and (iNumberofTiles > 0) do
						iRandom2 = TerrainBuilder.GetRandomNumber(iNumberofTiles, "Tile Roller")+1
						for i, pTile in ipairs(pCityPlots) do
							if i == iRandom2 then
								--/// Gathering and validating improvements...
								local tValidImprovements = {}
								local pPlayerTechs = pPlayer:GetTechs()
								local pPlayerCulture = pPlayer:GetCulture()
								if pTile:GetResourceType() > -1 then --// Resource check...
									local pResource = GameInfo.Resources[pTile:GetResourceType()].ResourceType
									local tQuery = DB.Query("SELECT ImprovementType FROM Improvement_ValidResources WHERE ResourceType = '" .. pResource .. "' AND ImprovementType NOT IN ('IMPROVEMENT_CORPORATION', 'IMPROVEMENT_INDUSTRY')")
									for k, v in ipairs(tQuery) do
										local iImprovement = GameInfo.Improvements[v.ImprovementType].Index
										if GameInfo.Resources[pTile:GetResourceType()].PrereqTech ~= nil then
											local resourceTech = GameInfo.Resources[pResource].PrereqTech
												if pPlayerTechs:HasTech(GameInfo.Technologies[resourceTech].Index) then
													return pTile, iImprovement
												end
										else
											return pTile, iImprovement
										end
									end
								else
									for i, tRow in ipairs(DB.Query("SELECT ImprovementType FROM Improvements WHERE RemoveOnEntry = 0 AND ImprovementType NOT IN ('IMPROVEMENT_SAILOR_WATCHTOWER', 'IMPROVEMENT_CORPORATION', 'IMPROVEMENT_INDUSTRY')")) do
										local pTileImprovement = tRow.ImprovementType
										if ((tRow.PrereqTech == nil) or (pPlayerTechs:HasTech(GameInfo.Technologies[tRow.PrereqTech].Index))) and ((tRow.PrereqCivic == nil) or (pPlayerCulture:HasCivic(GameInfo.Civics[tRow.PrereqCivic].Index))) then
										--// Gotta do terrain and feature piecemeal or things will conflict...
											if pTile:GetFeatureType() > -1 then --// Feature check...
												local pTileFeature = GameInfo.Features[pTile:GetFeatureType()].FeatureType
												local tQuery = DB.Query("SELECT FeatureType FROM Improvement_ValidFeatures WHERE ImprovementType = '" .. pTileImprovement .. "'")
												for k, v in ipairs(tQuery) do
													if v.FeatureType == pTileFeature then
														table.insert(tValidImprovements, tRow)
													end
												end
											else --// Terrain check...
												local pTileTerrain = pTile:GetTerrainType()
												local pTileTerrainType = GameInfo.Terrains[pTileTerrain].TerrainType
												local tQuery = DB.Query("SELECT TerrainType FROM Improvement_ValidTerrains WHERE ImprovementType = '" .. pTileImprovement .. "'")
												for k, v in ipairs(tQuery) do
													if v.TerrainType == pTileTerrainType then 
														table.insert(tValidImprovements, tRow)
													end
												end
											end
										end
									end
								end

								--// Rolling improvements...
								local iNumberofImprovements = 0
								for i, pImprovement in ipairs(tValidImprovements) do
									iNumberofImprovements = iNumberofImprovements + 1
								end

								if iNumberofImprovements == 0 then 
									iNumberofTiles = iNumberofTiles - 1
									table.remove(pCityPlots, i)
									break 
								else
									iRandom3 = TerrainBuilder.GetRandomNumber(iNumberofImprovements-1, "Improvement Roller")+1
									for i, pImprovement in ipairs(tValidImprovements) do
										if i == iRandom3 then
											local pImprovementRolled = pImprovement.ImprovementType
											local iImprovement = GameInfo.Improvements[pImprovementRolled].Index
											return pTile, iImprovement
										end
									end
								end
							end
						end
                    end
                end
            end
        end
    end
end

--///////////////////////////////////////////////////////
-- Random Policy Roller
--///////////////////////////////////////////////////////
function Sailor_Goody_RandomPolicy(pPlayer)
    local pPlayerEras = pPlayer:GetEras()
    local pPlayerEra = pPlayerEras:GetEra()
    local pPlayerEraType = GameInfo.Eras[pPlayerEra].EraType

    --// Policy check...
    local pPlayerCulture = pPlayer:GetCulture()
    local tPolicyList = {}
	local iNumberofPolicies = 0
    for i, pRow in ipairs(DB.Query("SELECT PolicyType FROM Policies WHERE ((PolicyType IN (SELECT PolicyType FROM Policies WHERE PrereqCivic IN (SELECT CivicType FROM Civics WHERE EraType = '" .. pPlayerEraType .. "'))) OR (PolicyType IN (SELECT PolicyType FROM Policies WHERE PrereqTech IN (SELECT TechnologyType FROM Technologies WHERE EraType = '" .. pPlayerEraType .. "'))))")) do
		if not pPlayerCulture:IsPolicyUnlocked(GameInfo.Policies[pRow.PolicyType].Index) then
			table.insert(tPolicyList, pRow)
			iNumberofPolicies = iNumberofPolicies + 1
		end
    end

	--// Rolling policy...
	if iNumberofPolicies > 0 then
		iPolicyRoll = TerrainBuilder.GetRandomNumber(iNumberofPolicies-1, "Policy Roller")+1
        for i, pPolicy in ipairs(tPolicyList) do
			if i == iPolicyRoll then
				local pPolicyRolled = pPolicy.PolicyType
                local iPolicy = GameInfo.Policies[pPolicyRolled].Index
                return iPolicy
            end
        end
	end
end

--///////////////////////////////////////////////////////
-- Wonder Indiana Jones
--///////////////////////////////////////////////////////
function Sailor_Goody_Wonder(pPlayer, pPlayerVisibility)
	if pPlayerVisibility ~= nil then
		for i, pPlot in ipairs(tSailorWonderTable) do
			if not pPlayerVisibility:IsRevealed(pPlot:GetX(), pPlot:GetY()) then
				local pPlotWonder = pPlot:GetFeatureType()
				local pPlotWonderType = GameInfo.Features[pPlotWonder].FeatureType
				local targetTiles = GameInfo.Features[pPlotWonder].Tiles
				local tilesHidden = 1
				local wonderVisible = false
				while (tilesHidden < targetTiles) and (wonderVisible == false) do
					for i, sPlot in ipairs(tSailorWonderTable) do
						if sPlot ~= pPlot then
							local sPlotWonder = sPlot:GetFeatureType()
							local sPlotWonderType = GameInfo.Features[sPlotWonder].FeatureType
							if sPlotWonderType == pPlotWonderType then
								if not pPlayerVisibility:IsRevealed(sPlot:GetX(), sPlot:GetY()) then
									tilesHidden = tilesHidden + 1
								else wonderVisible = true
								end
							end
						end
					end
				end
				if (tilesHidden == targetTiles) and (wonderVisible == false) then
					local wonderTable = {}
					for i, iPlot in ipairs(tSailorWonderTable) do
						if iPlot:GetFeatureType() == pPlotWonder then
							table.insert(wonderTable, iPlot)
						end
					end
					return wonderTable
				end
				--[[Old, teleport unit to wonder
				if (tilesHidden == targetTiles) and (wonderVisible == false) then
					for i, iPlot in ipairs(tSailorWonderTable) do
						if iPlot:GetFeatureType() == pPlotWonder then
							for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
								local adjacentPlot = Map.GetAdjacentPlot(iPlot:GetX(), iPlot:GetY(), direction)
								if (not adjacentPlot:IsNaturalWonder()) and (not adjacentPlot:IsMountain()) and (not adjacentPlot:IsWater()) then
									local iWonX, iWonY = adjacentPlot:GetX(), adjacentPlot:GetY()
									return iWonX, iWonY
								end
							end
							for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
								local adjacentPlot = Map.GetAdjacentPlot(iPlot:GetX(), iPlot:GetY(), direction)
								if (not adjacentPlot:IsNaturalWonder()) and (not adjacentPlot:IsMountain()) and (not adjacentPlot:IsWater()) then
									local iWonX, iWonY = adjacentPlot:GetX(), adjacentPlot:GetY()
									return iWonX, iWonY
								end
							end
							
						end
					end
				end	
				]]--
			end		
		end
	end
end

--///////////////////////////////////////////////////////
-- City-State Greetings Card
--///////////////////////////////////////////////////////
function Sailor_Goody_CityState(pOwner, pPlayer, pPlayerDiplomacy)
	for i, v in ipairs(PlayerManager.GetAliveIDs()) do
		if v ~= pOwner then
		local oPlayer = Players[v]
		local civType = PlayerConfigurations[v]:GetCivilizationLevelTypeName()
			if civType == "CIVILIZATION_LEVEL_CITY_STATE" then
				if not pPlayerDiplomacy:HasMet(v) then
					return v
				end
			end
		end
	end
end