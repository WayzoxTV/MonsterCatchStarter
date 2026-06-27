--[[
	RarityConfig
	Les 7 paliers de rareté de base, dans l'ordre croissant de puissance.
	C'est une propriété de l'espèce (fixe), à ne pas confondre avec la
	mutation (skin variable, voir MutationConfig).
]]

local RarityConfig = {}

RarityConfig.Order = {
	"Commun",
	"Rare",
	"Epique",
	"Legendaire",
	"Mythique",
	"Secret",
	"Divine",
}

RarityConfig.Definitions = {
	Commun = { DisplayName = "Commun", Color = Color3.fromRGB(176, 176, 176), Order = 1 },
	Rare = { DisplayName = "Rare", Color = Color3.fromRGB(79, 195, 247), Order = 2 },
	Epique = { DisplayName = "Épique", Color = Color3.fromRGB(186, 104, 200), Order = 3 },
	Legendaire = { DisplayName = "Légendaire", Color = Color3.fromRGB(255, 193, 7), Order = 4 },
	Mythique = { DisplayName = "Mythique", Color = Color3.fromRGB(244, 67, 54), Order = 5 },
	Secret = { DisplayName = "Secret", Color = Color3.fromRGB(33, 33, 33), Order = 6 },
	Divine = { DisplayName = "Divine", Color = Color3.fromRGB(255, 255, 255), Order = 7 },
}

return RarityConfig
