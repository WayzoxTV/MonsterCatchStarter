--[[
	DexController
	Point d'entrée client : crée l'écran de l'Index et gère le raccourci
	clavier pour l'ouvrir/fermer.

	⚠️ Le "discoveredSet" ci-dessous est factice (codé en dur) en attendant
	   le vrai système de sauvegarde (DataStore). Quand on l'aura, il
	   suffira de remplacer mockDiscoveredSet par les vraies données du
	   joueur — DexView n'a pas besoin de changer.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local DexView = require(script.Parent.UI.DexView)

local TOGGLE_KEY = Enum.KeyCode.I

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DexGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local dexView = DexView.new(screenGui)

local mockDiscoveredSet = {
	glaconix_Normal = true,
	flammeloup_Normal = true,
	flammeloup_Or = true,
	terrabosse_Normal = true,
}
dexView:SetDiscoveredSet(mockDiscoveredSet)

UserInputService.InputBegan:Connect(function(input, isProcessingGameEvent)
	if isProcessingGameEvent then
		return
	end

	if input.KeyCode == TOGGLE_KEY then
		dexView:Toggle()
	end
end)
