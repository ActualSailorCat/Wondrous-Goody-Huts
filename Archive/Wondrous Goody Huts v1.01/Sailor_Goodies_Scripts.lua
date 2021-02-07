--//////////////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Wondrous Goody Huts by SailorCat
-- Special Thanks: Chrisy15, Gedemon
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- / Gathering wonder plots for later...
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
-- Expanded Goodies by SailorCat
--///////////////////////////////////////////////////////
function Sailor_Expanded_Goodies(iX, iY, eOwner)
	if eOwner == -1 then
		local unitList:table = Units.GetUnitsInPlotLayerID(iX, iY, MapLayers.ANY)
		if unitList ~= nil then
			for i, pUnit in ipairs(unitList) do
				local pUnitAbility = pUnit:GetAbility()
				local pOwner = pUnit:GetOwner()
				local pPlayer = Players[pOwner]

				local switchRandResource = pUnitAbility:GetAbilityCount("ABILITY_SAILOR_GOODY_RANDOMRESOURCE")
				local switchRandUnit = pUnitAbility:GetAbilityCount("ABILITY_SAILOR_GOODY_RANDOMUNIT")
				local switchRandImprovement = pUnitAbility:GetAbilityCount("ABILITY_SAILOR_GOODY_RANDOMIMPROVEMENT")
				local switchSightBomb = pUnitAbility:GetAbilityCount("ABILITY_SAILOR_GOODY_SIGHTBOMB")
				local switchRandPolicy = pUnitAbility:GetAbilityCount("ABILITY_SAILOR_GOODY_RANDOMPOLICY")
				local switchWonder = pUnitAbility:GetAbilityCount("ABILITY_SAILOR_GOODY_WONDER")
				local switchCityState = pUnitAbility:GetAbilityCount("ABILITY_SAILOR_GOODY_CITYSTATE")
-- / Random Resource
				if switchRandResource == 1 then
					print("//// Wondrous Goody Type Activated: Random Resource")
					local pTile, iResource = Sailor_Goody_RandomResource(pPlayer) -- / Call Random Resource Roller Function
					if pTile ~= nil then
						ResourceBuilder.SetResourceType(pTile, iResource, 1)
						if pPlayer:IsHuman() then
							Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_LIGHTBLUE]Resource spawned![ENDCOLOR]"), pTile:GetX(), pTile:GetY(), 0)
						end
						pUnitAbility:ChangeAbilityCount("ABILITY_SAILOR_GOODY_RANDOMRESOURCE", -switchRandResource)
						break
					else -- / Catch for nil: random unit spawner...
						print("Door's stuck! Spawning unit instead.")
						local sTargetUnit, iSpawnX, iSpawnY = Sailor_Goody_RandomUnit(pPlayer) -- / Call Random Unit Roller Function
						UnitManager.InitUnit(pOwner, sTargetUnit, iSpawnX, iSpawnY)
						pUnitAbility:ChangeAbilityCount("ABILITY_SAILOR_GOODY_RANDOMRESOURCE", -switchRandPolicy)
						if pPlayer:IsHuman() then
							Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_LIGHTBLUE]Valid placement not found! Spawning unit instead.[ENDCOLOR]"), iX, iY, 0)
						end
						break
					end
				end
-- / Random Unit
				if switchRandUnit == 1 then
					print("//// Wondrous Goody Type Activated: Random Unit")
					local sTargetUnit, iSpawnX, iSpawnY = Sailor_Goody_RandomUnit(pPlayer) -- / Call Random Unit Roller Function
					UnitManager.InitUnit(pOwner, sTargetUnit, iSpawnX, iSpawnY)
					pUnitAbility:ChangeAbilityCount("ABILITY_SAILOR_GOODY_RANDOMUNIT", -switchRandUnit)
					break
				end
-- / Random Improvement
				if switchRandImprovement == 1 then 
					print("//// Wondrous Goody Type Activated: Random Improvement")
					local pTile, iImprovement = Sailor_Goody_RandomImprovement(pPlayer) -- / Call Random Improvement Roller Function
					if pTile ~= nil then
						ImprovementBuilder.SetImprovementType(pTile, iImprovement, 1)
						pUnitAbility:ChangeAbilityCount("ABILITY_SAILOR_GOODY_RANDOMIMPROVEMENT", -switchRandImprovement)
						break
					else -- / Catch for nil: random unit spawner...
						print("Door's stuck! Spawning unit instead.")
						local sTargetUnit, iSpawnX, iSpawnY = Sailor_Goody_RandomUnit(pPlayer) -- / Call Random Unit Roller Function
						UnitManager.InitUnit(pOwner, sTargetUnit, iSpawnX, iSpawnY)
						pUnitAbility:ChangeAbilityCount("ABILITY_SAILOR_GOODY_RANDOMIMPROVEMENT", -switchRandImprovement)
						if pPlayer:IsHuman() then
							Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_LIGHTBLUE]Valid placement not found! Spawning unit instead.[ENDCOLOR]"), iX, iY, 0)
						end
						break
					end
				end
-- / Sight Bomb
				if switchSightBomb == 1 then
					print("//// Wondrous Goody Type Activated: Sight Bomb")
					pUnitAbility:ChangeAbilityCount("ABILITY_SAILOR_GOODY_SIGHTBOMB", -switchSightBomb)
					break
				end
-- / RandomPolicy
				if switchRandPolicy == 1 then
					print("//// Wondrous Goody Type Activated: Policy")
					local pPlayerCulture = pPlayer:GetCulture()
					local iPolicy = Sailor_Goody_RandomPolicy(pPlayer)
					if iPolicy ~= nil then
						pPlayerCulture:UnlockPolicy(iPolicy)
						pUnitAbility:ChangeAbilityCount("ABILITY_SAILOR_GOODY_RANDOMPOLICY", -switchRandPolicy)
						break
					else -- / Catch for nil: random unit spawner...
						print("Door's stuck! Spawning unit instead.")
						local sTargetUnit, iSpawnX, iSpawnY = Sailor_Goody_RandomUnit(pPlayer) -- / Call Random Unit Roller Function
						UnitManager.InitUnit(pOwner, sTargetUnit, iSpawnX, iSpawnY)
						pUnitAbility:ChangeAbilityCount("ABILITY_SAILOR_GOODY_RANDOMPOLICY", -switchRandPolicy)
						if pPlayer:IsHuman() then
							Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_LIGHTBLUE]Valid policy not found! Spawning unit instead.[ENDCOLOR]"), iX, iY, 0)
						end
						break
					end
				end
-- / Wonder
				if switchWonder == 1 then
					print("//// Wondrous Goody Type Activated: Wonder")
					local iWonX, iWonY = Sailor_Goody_Wonder(pPlayer)
					if (iWonX ~= nil) and (iWonY ~= nil) then
						UnitManager.RestoreMovement(pUnit)
						UnitManager.PlaceUnit(pUnit, iWonX, iWonY)
						pUnitAbility:ChangeAbilityCount("ABILITY_SAILOR_GOODY_WONDER", -switchWonder)
						break
					else -- / Catch for nil: random unit spawner...
						print("Door's stuck! Spawning unit instead.")
						local sTargetUnit, iSpawnX, iSpawnY = Sailor_Goody_RandomUnit(pPlayer) -- / Call Random Unit Roller Function
						UnitManager.InitUnit(pOwner, sTargetUnit, iSpawnX, iSpawnY)
						pUnitAbility:ChangeAbilityCount("ABILITY_SAILOR_GOODY_WONDER", -switchWonder)
						if pPlayer:IsHuman() then
							Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_LIGHTBLUE]Valid wonder not found! Spawning unit instead.[ENDCOLOR]"), iX, iY, 0)
						end
						break
					end
				end
-- / City-State
				if switchCityState == 1 then
					print("//// Wondrous Goody Type Activated: City-State")
					local pPlayerDiplomacy = pPlayer:GetDiplomacy()
					local sTargetCS = Sailor_Goody_CityState(pOwner, pPlayer, pPlayerDiplomacy)
					if sTargetCS ~= nil then
						pPlayerDiplomacy:SetHasMet(sTargetCS)
						pUnitAbility:ChangeAbilityCount("ABILITY_SAILOR_GOODY_CITYSTATE", -switchCityState)
						break
					else -- / Catch for nil: random unit spawner...
						print("Door's stuck! Spawning unit instead.")
						local sTargetUnit, iSpawnX, iSpawnY = Sailor_Goody_RandomUnit(pPlayer) -- / Call Random Unit Roller Function
						UnitManager.InitUnit(pOwner, sTargetUnit, iSpawnX, iSpawnY)
						pUnitAbility:ChangeAbilityCount("ABILITY_SAILOR_GOODY_CITYSTATE", -switchCityState)
						if pPlayer:IsHuman() then
							Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_LIGHTBLUE]Valid city-state not found! Spawning unit instead.[ENDCOLOR]"), iX, iY, 0)
						end
						break
					end
				end
			end
		end
	end
end
Events.ImprovementRemovedFromMap.Add(Sailor_Expanded_Goodies)

--///////////////////////////////////////////////////////
-- GetCityPlots by Chrisy15 & SailorCat
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
					if pPlotNearCity:GetFeatureType() > -1 then
						local pPlotFeatureIndex = pPlotNearCity:GetFeatureType()
						local pPlotFeatureType = GameInfo.Features[pPlotFeatureIndex].FeatureType
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
-- Random Resource Roller by SailorCat
--///////////////////////////////////////////////////////
function Sailor_Goody_RandomResource(pPlayer)
	local tValidTiles = {}
	local resourceSwitch = 1
	local pPlayerCities = pPlayer:GetCities()

    -- / Rolling city...
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
                -- / Rolling tiles...
                local pCityPlots = GetCityPlots(pIterCity, resourceSwitch)
                local iNumberofTiles = 0
                for i, pTile in ipairs(pCityPlots, resourceSwitch) do
                    iNumberofTiles = iNumberofTiles + 1
                end

                if iNumberofTiles > 0 then
                    iRandom2 = TerrainBuilder.GetRandomNumber(iNumberofTiles, "Tile Roller")+1
                    for i, pTile in ipairs(pCityPlots) do
                        if i == iRandom2 then

                            -- / Validating resources...
                            local tValidResources = {}
                            local pTileIndex = pTile:GetTerrainType()
                            local pTileTerrainType = GameInfo.Terrains[pTileIndex].TerrainType

                            -- / Resource tech check...
                            local pPlayerTechs = pPlayer:GetTechs()
                            local tResTechList = {}
                            for i, pRow in ipairs(DB.Query("SELECT TechnologyType FROM Technologies WHERE TechnologyType IN (SELECT PrereqTech FROM Resources WHERE PrereqTech IS NOT NULL AND PrereqTech != 'TECH_ANIMAL_HUSBANDRY')")) do
                                tResTechList[i] = pRow.TechnologyType
                            end
                            local tResTechValid = "'TECH_ANIMAL_HUSBANDRY', "

                            for i, pTech in ipairs(tResTechList) do
                                if pPlayerTechs:HasTech(GameInfo.Technologies[pTech].Index) then
                                    tResTechValid = tResTechValid .. "'" .. pTech .. "', "
                                end
                            end

                            -- / Gathering resources...
                            for i, tRow in ipairs(DB.Query("SELECT ResourceType FROM Resources WHERE (Frequency > 0 OR SeaFrequency > 0) AND (ResourceType IN (SELECT ResourceType from Resource_ValidTerrains WHERE TerrainType = '" .. pTileTerrainType .. "')) AND (ResourceType IN (SELECT ResourceType FROM Resources WHERE PrereqTech IS NULL) OR ResourceType IN (SELECT ResourceType FROM Resources WHERE PrereqTech IN (" .. tResTechValid:sub(1,-3) .. ")))")) do
                                tValidResources[i] = tRow
                            end

                            -- / Rolling resources...
                            local iNumberofResources = 0
                            for i, pResource in ipairs(tValidResources) do
                                iNumberofResources = iNumberofResources + 1
                            end

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
-- Random Unit Roller by SailorCat
--///////////////////////////////////////////////////////
function Sailor_Goody_RandomUnit(pPlayer)
    local pPlayerEras = pPlayer:GetEras()
    local pPlayerEra = pPlayerEras:GetEra()
    local pPlayerEraType = GameInfo.Eras[pPlayerEra].EraType
    local sailorGoodyEraGap = 3

    -- / Probably-inefficient tech check...
    local pPlayerTechs = pPlayer:GetTechs()
    local tTechList = {}
    for i, pRow in ipairs(DB.Query("SELECT TechnologyType FROM Technologies WHERE TechnologyType IN (SELECT PrereqTech FROM Units WHERE PrereqTech IS NOT NULL)")) do
        tTechList[i] = pRow.TechnologyType
    end

    local tUnitTechValid = ""
    for i, pTech in ipairs(tTechList) do
        if pPlayerTechs:HasTech(GameInfo.Technologies[pTech].Index) then
            -- / Only from x eras earlier...
            local techEra = GameInfo.Eras[GameInfo.Technologies[pTech].EraType].Index
            if (pPlayerEra - techEra) <= sailorGoodyEraGap then
                tUnitTechValid = tUnitTechValid .. "'" .. pTech .. "', "
            end
        end
    end

    -- / Probably-inefficient civic check...
    local pPlayerCulture = pPlayer:GetCulture()
    local tCivicList = {}
    for i, pRow in ipairs(DB.Query("SELECT CivicType FROM Civics WHERE CivicType IN (SELECT PrereqCivic FROM Units WHERE PrereqCivic IS NOT NULL)")) do
        tCivicList[i] = pRow.CivicType
    end

    local tUnitCivicValid = ""
    for i, pCivic in ipairs(tCivicList) do
        if pPlayerCulture:HasCivic(GameInfo.Civics[pCivic].Index) then
            -- / Only from x eras earlier...
            local civicEra = GameInfo.Eras[GameInfo.Civics[pCivic].EraType].Index
            if (pPlayerEra - civicEra) <= sailorGoodyEraGap then
                tUnitCivicValid = tUnitCivicValid .. "'" .. pCivic .. "', "
            end
        end
    end

    local pPlayerCities = pPlayer:GetCities()
    local pCap = pPlayerCities:GetCapitalCity()

    -- / Dowsing for water...
    local pCapRadius = 5
    local sWaterTable = {}
    for dx = (pCapRadius * -1), pCapRadius do
        for dy = (pCapRadius * -1), pCapRadius do
            local sPlotNearCap = Map.GetPlotXYWithRangeCheck(pCap:GetX(), pCap:GetY(), dx, dy, pCapRadius);
            if sPlotNearCap and ((sPlotNearCap:GetOwner() == pPlayer) or (sPlotNearCap:GetOwner() == -1)) then
                local pPlotTerrainIndex = sPlotNearCap:GetTerrainType()
                local pPlotTerrainType = GameInfo.Terrains[pPlotTerrainIndex].TerrainType
                if pPlotTerrainType == "TERRAIN_COAST" then
                    table.insert(sWaterTable, sPlotNearCap)
                end
            end
        end
    end
    local iNumberWaterTiles = 0
    for k, v in ipairs(sWaterTable) do
        iNumberWaterTiles = iNumberWaterTiles + 1
    end
    local sailorWaterSwitch = ""
    if iNumberWaterTiles > 0 then
        sailorWaterSwitch = "Domain != 'DOMAIN_AIR'"
        else sailorWaterSwitch = "Domain = 'DOMAIN_LAND'"
    end

    -- / Unit collection...
    local tValidUnits = {} -- / Unit Net...
    for i, tRow in ipairs(DB.Query("SELECT * FROM Units WHERE " .. sailorWaterSwitch .. " AND ReligiousStrength = 0 AND CanTrain = 1 AND UnitType NOT LIKE 'UNIT_HERO%' AND UnitType NOT IN ('UNIT_ARCHAEOLOGIST', 'UNIT_SPY', 'UNIT_NATURALIST', 'UNIT_ROCK_BAND') AND ((UnitType IN (SELECT UnitType FROM Units WHERE PrereqTech IS NULL AND PrereqCivic IS NULL)) OR ((UnitType IN (SELECT UnitType FROM Units WHERE PrereqTech IN (" .. tUnitTechValid:sub(1,-3) .. "))) OR (UnitType IN (SELECT UnitType FROM Units WHERE PrereqCivic IN (" .. tUnitCivicValid:sub(1,-3) .. ")))))")) do
        if not((pPlayerEra > sailorGoodyEraGap) and (tRow.Combat > 0) and (tRow.PrereqTech == nil) and (tRow.PrereqCivic == nil)) then --/ Catching starting units...
            table.insert(tValidUnits, tRow)
        end
    end

    -- / Count units...
    local iNumberValidUnits = 0
    for i, cUnit in ipairs(tValidUnits) do
        iNumberValidUnits = iNumberValidUnits + 1
    end

    if iNumberValidUnits > 0 then
        -- / Roll unit type...
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
                else  -- / Land spawn...
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

    -- / Rolling city...
    local iNumberofCities = 0
    for i, pIterCity in pPlayerCities:Members() do
        iNumberofCities = iNumberofCities + 1
    end

    if iNumberofCities > 0 then
        iRandom = TerrainBuilder.GetRandomNumber(iNumberofCities, "City Roller")+1
        for i, pIterCity in pPlayerCities:Members() do
            if i == iRandom then
                local pCityLoc = pIterCity:GetName()

                -- / Rolling tiles...
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
                            -- / Validating improvements...
                            local tValidImprovements = {}

                            -- / Improvement tech check...
                            local pPlayerTechs = pPlayer:GetTechs()
							local tTechList = {}
						    for i, pRow in ipairs(DB.Query("SELECT TechnologyType FROM Technologies WHERE TechnologyType IN (SELECT PrereqTech FROM Improvements WHERE PrereqTech IS NOT NULL)")) do
								tTechList[i] = pRow.TechnologyType
							end

							local tTechValid = ""
							for i, pTech in ipairs(tTechList) do
								if pPlayerTechs:HasTech(GameInfo.Technologies[pTech].Index) then
									tTechValid = tTechValid .. "'" .. pTech .. "', "
								end
							end

							-- / Improvement civic check...
							local pPlayerCulture = pPlayer:GetCulture()
							local tCivicList = {}
						    for i, pRow in ipairs(DB.Query("SELECT CivicType FROM Civics WHERE CivicType IN (SELECT PrereqCivic FROM Improvements WHERE PrereqCivic IS NOT NULL)")) do
								tCivicList[i] = pRow.CivicType
							end

							local tCivicValid = ""
							for i, pCivic in ipairs(tCivicList) do
								if pPlayerCulture:HasCivic(GameInfo.Civics[pCivic].Index) then
									tCivicValid = tCivicValid .. "'" .. pCivic .. "', "
								end
							end

                            -- / Gathering improvements...
							if pTile:GetResourceType() > -1 then -- / Resource check...
								local pResource = GameInfo.Resources[pTile:GetResourceType()].ResourceType
								local tQuery = DB.Query("SELECT ImprovementType FROM Improvement_ValidResources WHERE ResourceType = '" .. pResource .. "'")
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
                            for i, tRow in ipairs(DB.Query("SELECT ImprovementType FROM Improvements WHERE RemoveOnEntry = 0 AND ImprovementType != 'IMPROVEMENT_SAILOR_WATCHTOWER' AND ((ImprovementType IN (SELECT ImprovementType FROM Improvements WHERE PrereqTech IS NULL AND PrereqCivic IS NULL)) OR ((ImprovementType IN (SELECT ImprovementType FROM Improvements WHERE PrereqTech IN (" .. tTechValid:sub(1,-3) .. "))) OR (ImprovementType IN (SELECT ImprovementType FROM Improvements WHERE PrereqCivic IN (" .. tCivicValid:sub(1,-3) .. ")))))")) do
								local pTileImprovement = tRow.ImprovementType
								-- / Gotta do terrain and feature piecemeal or things will conflict...
								if pTile:GetFeatureType() > -1 then -- / Feature check...
									local pTileFeature = GameInfo.Features[pTile:GetFeatureType()].FeatureType
									local tQuery = DB.Query("SELECT FeatureType FROM Improvement_ValidFeatures WHERE ImprovementType = '" .. pTileImprovement .. "'")
									for k, v in ipairs(tQuery) do
										if v.FeatureType == pTileFeature then
											table.insert(tValidImprovements, tRow)
										end
									end
                                else -- / Terrain check...
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

                            -- / Rolling improvements...
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
-- Random Policy Roller by SailorCat
--///////////////////////////////////////////////////////
function Sailor_Goody_RandomPolicy(pPlayer)
    local pPlayerEras = pPlayer:GetEras()
    local pPlayerEra = pPlayerEras:GetEra()
    local pPlayerEraType = GameInfo.Eras[pPlayerEra].EraType

    -- / Policy check...
    local pPlayerCulture = pPlayer:GetCulture()
    local tPolicyList = {}
    for i, pRow in ipairs(DB.Query("SELECT PolicyType FROM Policies WHERE ((PolicyType IN (SELECT PolicyType FROM Policies WHERE PrereqCivic IN (SELECT CivicType FROM Civics WHERE EraType = '" .. pPlayerEraType .. "'))) OR (PolicyType IN (SELECT PolicyType FROM Policies WHERE PrereqTech IN (SELECT TechnologyType FROM Technologies WHERE EraType = '" .. pPlayerEraType .. "'))))")) do
		if not pPlayerCulture:IsPolicyUnlocked(GameInfo.Policies[pRow.PolicyType].Index) then
			table.insert(tPolicyList, pRow)
		end
    end

	local iNumberofPolicies = 0
	for k, v in ipairs(tPolicyList) do
		iNumberofPolicies = iNumberofPolicies + 1
	end

	-- / Rolling policy...
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
-- Wonder Indiana Jones by SailorCat
--///////////////////////////////////////////////////////
function Sailor_Goody_Wonder(pPlayer)
local pPlayerVisibility = PlayersVisibility[pPlayer:GetID()]
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
				for i, iPlot in ipairs(tSailorWonderTable) do
					if iPlot:GetFeatureType() == pPlotWonder then
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
		end		
	end
	end
end

--///////////////////////////////////////////////////////
-- City-State Greetings Card by SailorCat
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