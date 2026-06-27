--[[
	DexEntryBuilder
	Assemble les données de CreatureFactory + l'état "découvert" du joueur
	en entrées prêtes à afficher dans l'Index. Aucune logique d'affichage
	ici — uniquement de la donnée.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreatureFactory = require(ReplicatedStorage.Shared.Data.CreatureFactory)

local DexEntryBuilder = {}

-- Construit la clé unique d'une entrée du dex (une espèce dans une mutation donnée).
function DexEntryBuilder.BuildKey(speciesId: string, mutationId: string): string
	return speciesId .. "_" .. mutationId
end

-- Construit toutes les entrées d'un onglet (une mutation), avec leur état découvert.
function DexEntryBuilder.BuildTab(mutationId: string, discoveredSet: { [string]: boolean })
	local entries = {}

	for _, species in CreatureFactory.GetAllSpecies() do
		local entry = CreatureFactory.BuildEntry(species.Id, mutationId, 1)
		entry.IsDiscovered = discoveredSet[DexEntryBuilder.BuildKey(species.Id, mutationId)] == true
		table.insert(entries, entry)
	end

	return entries
end

-- Nombre d'espèces découvertes pour une mutation donnée.
function DexEntryBuilder.CountDiscoveredForMutation(mutationId: string, discoveredSet: { [string]: boolean }): number
	local count = 0
	for _, species in CreatureFactory.GetAllSpecies() do
		if discoveredSet[DexEntryBuilder.BuildKey(species.Id, mutationId)] then
			count += 1
		end
	end
	return count
end

-- Nombre total d'entrées découvertes, toutes mutations confondues.
function DexEntryBuilder.CountTotalDiscovered(discoveredSet: { [string]: boolean }): number
	local count = 0
	for _, isDiscovered in discoveredSet do
		if isDiscovered then
			count += 1
		end
	end
	return count
end

-- Nombre total d'espèces dans la base de données (indépendant des mutations).
function DexEntryBuilder.GetSpeciesCount(): number
	return #CreatureFactory.GetAllSpecies()
end

return DexEntryBuilder
