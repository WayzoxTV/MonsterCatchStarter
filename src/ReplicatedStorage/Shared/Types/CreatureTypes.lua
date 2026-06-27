--[[
	CreatureTypes
	Définitions de types Luau partagées pour le système de créatures.
	Aucune logique ici, uniquement des types — à require pour l'autocomplétion
	dans les autres modules (Data, Managers, UI...).
]]

export type ElementType = "Feu" | "Eau" | "Terre" | "Air" | "Glace"

export type RarityId =
	"Commun"
	| "Rare"
	| "Epique"
	| "Legendaire"
	| "Mythique"
	| "Secret"
	| "Divine"

export type MutationId = "Normal" | "Or" | "Desert" | "Foret" | "Glace" | "Lave"

-- Une espèce de créature, indépendante de sa mutation et de son niveau.
export type CreatureSpecies = {
	Id: string,
	Name: string,
	Element: ElementType,
	Rarity: RarityId,
	BasePv: number,
	BaseDegats: number,
	BaseChance: number,
	Description: string?,
}

-- Le résultat final calculé par CreatureFactory (espèce + mutation + niveau).
export type CreatureEntry = {
	SpeciesId: string,
	Name: string,
	Element: ElementType,
	Rarity: RarityId,
	MutationId: MutationId,
	Level: number,
	Pv: number,
	Degats: number,
	Chance: number,
}

export type MutationDefinition = {
	DisplayName: string,
	Color: Color3,
	PvMultiplier: number,
	DegatsMultiplier: number,
	ChanceMultiplier: number,
}

export type RarityDefinition = {
	DisplayName: string,
	Color: Color3,
	Order: number,
}

return {}
