--[[
	MutationConfig
	Les 6 variantes de mutation (skin) qu'une créature peut porter.
	Chaque mutation applique un multiplicateur sur PV / Dégâts / Chance
	par rapport aux stats de base de l'espèce (CreatureDatabase).

	⚠️ Valeurs d'équilibrage provisoires — à ajuster une fois en jeu.
]]

local MutationConfig = {}

MutationConfig.Order = { "Normal", "Or", "Desert", "Foret", "Glace", "Lave" }

MutationConfig.Definitions = {
	Normal = {
		DisplayName = "Normal",
		Color = Color3.fromRGB(200, 200, 200),
		PvMultiplier = 1.00,
		DegatsMultiplier = 1.00,
		ChanceMultiplier = 1.00,
	},
	Or = {
		DisplayName = "Or",
		Color = Color3.fromRGB(255, 215, 0),
		PvMultiplier = 1.10,
		DegatsMultiplier = 1.15,
		ChanceMultiplier = 1.50,
	},
	Desert = {
		DisplayName = "Désert",
		Color = Color3.fromRGB(237, 201, 175),
		PvMultiplier = 1.05,
		DegatsMultiplier = 1.20,
		ChanceMultiplier = 1.10,
	},
	Foret = {
		DisplayName = "Forêt",
		Color = Color3.fromRGB(76, 175, 80),
		PvMultiplier = 1.20,
		DegatsMultiplier = 1.05,
		ChanceMultiplier = 1.10,
	},
	Glace = {
		DisplayName = "Glace",
		Color = Color3.fromRGB(79, 195, 247),
		PvMultiplier = 1.10,
		DegatsMultiplier = 1.10,
		ChanceMultiplier = 1.20,
	},
	Lave = {
		DisplayName = "Lave",
		Color = Color3.fromRGB(255, 87, 34),
		PvMultiplier = 1.10,
		DegatsMultiplier = 1.30,
		ChanceMultiplier = 1.30,
	},
}

return MutationConfig
