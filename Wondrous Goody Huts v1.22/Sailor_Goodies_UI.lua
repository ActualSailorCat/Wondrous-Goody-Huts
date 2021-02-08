--[[GameEvents = ExposedMembers.GameEvents
function Sailor_GoodiesFormation(unitID, pUnit, pUnitFormation, pPlayer)
	local pPlayerUnits = pPlayer:GetUnits()
	pPlayerUnits:SetMilitaryFormation(unitID)
end
GameEvents.Sailor_GoodiesFormationSwitch.Add(Sailor_GoodiesFormation)]]--