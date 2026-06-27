--[[
	CreatureFactory
	Combine une espèce (CreatureDatabase) + une mutation (MutationConfig) + un
	niveau, pour produire l'objet CreatureEntry final (celui affiché en jeu,
	dans l'Index, dans l'équipe...).

	⚠️ Formule de croissance par niveau provisoire — à ajuster.
]]

local CreatureDatabase = require(script.Parent.CreatureDatabase)
local MutationConfig = require(script.Parent.MutationConfig)

local CreatureFactory = {}

local LEVEL_PV_GROWTH = 0.08 -- +8% de PV par niveau au-dessus de 1
local LEVEL_DEGATS_GROWTH = 0.06 -- +6% de Dégâts par niveau au-dessus de 1

-- Index espèce par Id pour des lookups en O(1) au lieu de boucler la liste.
local speciesById = {}
for _, species in CreatureDatabase.Species do
	speciesById[species.Id] = species
end

function CreatureFactory.GetSpecies(speciesId: string)
	return speciesById[speciesId]
end

function CreatureFactory.GetAllSpecies()
	return CreatureDatabase.Species
end

-- Construit l'objet créature final affiché en jeu.
function CreatureFactory.BuildEntry(speciesId: string, mutationId: string, level: number?)
	local species = speciesById[speciesId]
	assert(species, `CreatureFactory: espèce inconnue "{speciesId}"`)

	local mutation = MutationConfig.Definitions[mutationId]
	assert(mutation, `CreatureFactory: mutation inconnue "{mutationId}"`)

	local lvl = level or 1
	local levelPvFactor = 1 + (lvl - 1) * LEVEL_PV_GROWTH
	local levelDegatsFactor = 1 + (lvl - 1) * LEVEL_DEGATS_GROWTH

	return {
		SpeciesId = species.Id,
		Name = species.Name,
		Element = species.Element,
		Rarity = species.Rarity,
		MutationId = mutationId,
		Level = lvl,
		Pv = math.floor(species.BasePv * mutation.PvMultiplier * levelPvFactor),
		Degats = math.floor(species.BaseDegats * mutation.DegatsMultiplier * levelDegatsFactor),
		Chance = math.floor(species.BaseChance * mutation.ChanceMultiplier),
	}
end

return CreatureFactory
