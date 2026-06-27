--[[
	CreatureDatabase
	Base de données des espèces de créatures.

	Chaque espèce a des stats de base (= mutation "Normal", niveau 1).
	Une espèce existe ensuite en 6 variantes de mutation via
	CreatureFactory.BuildEntry(speciesId, mutationId, level).

	⚠️ Liste de départ avec 5 exemples (1 par élément) pour valider l'archi.
	   Noms, stats et descriptions 100% originaux — à étoffer ensuite.
]]

local CreatureDatabase = {}

CreatureDatabase.Species = {
	{
		Id = "glaconix",
		Name = "Glaçonix",
		Element = "Glace",
		Rarity = "Commun",
		BasePv = 40,
		BaseDegats = 8,
		BaseChance = 5,
		Description = "Un petit bloc de glace qui grelotte tout seul.",
	},
	{
		Id = "flammeloup",
		Name = "Flammeloup",
		Element = "Feu",
		Rarity = "Rare",
		BasePv = 55,
		BaseDegats = 14,
		BaseChance = 8,
		Description = "Un loup voxel à la crinière en flammes.",
	},
	{
		Id = "terrabosse",
		Name = "Terrabosse",
		Element = "Terre",
		Rarity = "Commun",
		BasePv = 60,
		BaseDegats = 7,
		BaseChance = 4,
		Description = "Increvable, mais pas le plus rapide du lot.",
	},
	{
		Id = "aerolin",
		Name = "Aérolin",
		Element = "Air",
		Rarity = "Epique",
		BasePv = 45,
		BaseDegats = 18,
		BaseChance = 12,
		Description = "Plane au-dessus des autres, littéralement.",
	},
	{
		Id = "aquanide",
		Name = "Aquanide",
		Element = "Eau",
		Rarity = "Rare",
		BasePv = 50,
		BaseDegats = 13,
		BaseChance = 9,
		Description = "Toujours suintant, jamais sec.",
	},
}

return CreatureDatabase
