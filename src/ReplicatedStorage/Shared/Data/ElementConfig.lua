--[[
	ElementConfig
	Table des types élémentaires et de leurs relations de force/faiblesse.

	Cycle à 5 éléments : chaque type est fort contre celui qui le suit dans
	l'ordre, et faible contre celui qui le précède.
	Feu > Glace > Air > Terre > Eau > (retour à Feu)
]]

local CreatureTypes = require(script.Parent.Parent.Types.CreatureTypes)

type ElementType = CreatureTypes.ElementType

local ElementConfig = {}

ElementConfig.Order = { "Feu", "Glace", "Air", "Terre", "Eau" } :: { ElementType }

ElementConfig.Colors = {
	Feu = Color3.fromRGB(255, 87, 34),
	Glace = Color3.fromRGB(79, 195, 247),
	Air = Color3.fromRGB(176, 224, 230),
	Terre = Color3.fromRGB(141, 110, 99),
	Eau = Color3.fromRGB(33, 150, 243),
} :: { [ElementType]: Color3 }

local STRONG_MULTIPLIER = 1.5
local WEAK_MULTIPLIER = 0.5
local NEUTRAL_MULTIPLIER = 1.0

--[[
	Renvoie le multiplicateur de dégâts d'une attaque selon le type de
	l'attaquant et celui du défenseur. À utiliser dans la formule de combat :
		degatsFinaux = degatsDeBase * ElementConfig.GetMultiplier(attaquant, defenseur)
]]
function ElementConfig.GetMultiplier(
	attackerElement: ElementType,
	defenderElement: ElementType
): number
	if attackerElement == defenderElement then
		return NEUTRAL_MULTIPLIER
	end

	local order = ElementConfig.Order
	local total = #order

	local attackerIndex = table.find(order, attackerElement)
	local defenderIndex = table.find(order, defenderElement)

	if not attackerIndex or not defenderIndex then
		return NEUTRAL_MULTIPLIER
	end

	local nextIndex = (attackerIndex % total) + 1
	if order[nextIndex] == defenderElement then
		return STRONG_MULTIPLIER
	end

	local prevIndex = ((attackerIndex - 2) % total) + 1
	if order[prevIndex] == defenderElement then
		return WEAK_MULTIPLIER
	end

	return NEUTRAL_MULTIPLIER
end

return ElementConfig
