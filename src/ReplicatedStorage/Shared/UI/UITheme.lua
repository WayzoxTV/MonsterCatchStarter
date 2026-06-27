--[[
	UITheme
	Palette de couleurs et polices communes à toute l'UI du jeu.
	Un seul endroit à modifier pour changer le thème visuel global.
]]

local UITheme = {}

UITheme.Colors = {
	Background = Color3.fromRGB(15, 23, 42),
	Panel = Color3.fromRGB(24, 35, 58),
	PanelLight = Color3.fromRGB(32, 46, 74),
	Accent = Color3.fromRGB(56, 189, 248),
	Text = Color3.fromRGB(241, 245, 249),
	TextMuted = Color3.fromRGB(148, 163, 184),
	Damage = Color3.fromRGB(239, 68, 68),
	Luck = Color3.fromRGB(74, 222, 128),
}

UITheme.Font = Enum.Font.GothamBold
UITheme.FontBody = Enum.Font.Gotham

return UITheme
