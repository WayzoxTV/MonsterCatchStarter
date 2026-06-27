--[[
	DexView
	Construit et gère l'écran de l'Index (le "Dex"). Ne contient aucune
	logique de sauvegarde : reçoit juste un set de créatures découvertes
	et affiche en conséquence. Le Controller décide quand l'ouvrir/fermer
	et quelles données lui donner.

	⚠️ Les icônes de créature/type sont des placeholders colorés tant qu'il
	   n'y a pas d'assets visuels (images) — à remplacer par des ImageLabel
	   avec rbxassetid plus tard, sans changer le reste de la structure.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UITheme = require(ReplicatedStorage.Shared.UI.UITheme)
local UIBuilder = require(ReplicatedStorage.Shared.UI.UIBuilder)
local DexEntryBuilder = require(ReplicatedStorage.Shared.UI.DexEntryBuilder)
local MutationConfig = require(ReplicatedStorage.Shared.Data.MutationConfig)
local RarityConfig = require(ReplicatedStorage.Shared.Data.RarityConfig)
local ElementConfig = require(ReplicatedStorage.Shared.Data.ElementConfig)

local UNDISCOVERED_TEXT = "???"

local DexView = {}
DexView.__index = DexView

function DexView.new(parent: Instance)
	local self = setmetatable({}, DexView)

	self._discoveredSet = {}
	self._searchText = ""
	self._activeMutation = MutationConfig.Order[1]
	self._tabButtons = {}
	self._sidebarBars = {}

	self:_build(parent)
	self:_refreshTabsHighlight()
	self:_refreshGrid()
	self:_refreshSidebar()

	return self
end

function DexView:SetDiscoveredSet(discoveredSet: { [string]: boolean })
	self._discoveredSet = discoveredSet
	self:_refreshGrid()
	self:_refreshSidebar()
end

function DexView:Show()
	self._root.Visible = true
end

function DexView:Hide()
	self._root.Visible = false
end

function DexView:Toggle()
	self._root.Visible = not self._root.Visible
end

function DexView:IsVisible(): boolean
	return self._root.Visible
end

-- ===== Construction =====

function DexView:_build(parent: Instance)
	local root = UIBuilder.CreateFrame({
		Name = "DexFrame",
		Size = UDim2.fromScale(0.8, 0.85),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor = UITheme.Colors.Background,
		CornerRadius = 16,
		Parent = parent,
	})
	root.Visible = false
	self._root = root

	self:_buildHeader(root)
	self:_buildTabBar(root)
	self:_buildBody(root)
end

function DexView:_buildHeader(root: Frame)
	local header = UIBuilder.CreateFrame({
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 60),
		BackgroundTransparency = 1,
		Parent = root,
	})

	UIBuilder.CreateLabel({
		Name = "Title",
		Text = "INDEX",
		Size = UDim2.new(0, 200, 1, 0),
		Position = UDim2.new(0, 20, 0, 0),
		TextColor = UITheme.Colors.Text,
		TextSize = 28,
		Font = UITheme.Font,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = header,
	})

	local searchBox = Instance.new("TextBox")
	searchBox.Name = "SearchBox"
	searchBox.PlaceholderText = "RECHERCHER"
	searchBox.Text = ""
	searchBox.Size = UDim2.new(0, 320, 0, 36)
	searchBox.Position = UDim2.new(0.5, -160, 0.5, -18)
	searchBox.BackgroundColor3 = UITheme.Colors.Panel
	searchBox.TextColor3 = UITheme.Colors.Text
	searchBox.PlaceholderColor3 = UITheme.Colors.TextMuted
	searchBox.Font = UITheme.FontBody
	searchBox.TextSize = 16
	searchBox.BorderSizePixel = 0
	searchBox.ClearTextOnFocus = false
	searchBox.Parent = header

	local searchCorner = Instance.new("UICorner")
	searchCorner.CornerRadius = UDim.new(0, 8)
	searchCorner.Parent = searchBox

	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		self._searchText = searchBox.Text:lower()
		self:_refreshGrid()
	end)

	local closeButton = UIBuilder.CreateButton({
		Name = "CloseButton",
		Text = "X",
		Size = UDim2.new(0, 36, 0, 36),
		Position = UDim2.new(1, -56, 0.5, -18),
		BackgroundColor = UITheme.Colors.PanelLight,
		TextColor = UITheme.Colors.Text,
		CornerRadius = 8,
		Parent = header,
	})
	closeButton.MouseButton1Click:Connect(function()
		self:Hide()
	end)
end

function DexView:_buildTabBar(root: Frame)
	local tabBar = UIBuilder.CreateFrame({
		Name = "TabBar",
		Size = UDim2.new(1, -40, 0, 36),
		Position = UDim2.new(0, 20, 0, 64),
		BackgroundTransparency = 1,
		Parent = root,
	})

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = tabBar

	for index, mutationId in MutationConfig.Order do
		local definition = MutationConfig.Definitions[mutationId]

		local tabButton = UIBuilder.CreateButton({
			Name = mutationId .. "Tab",
			Text = definition.DisplayName:upper(),
			Size = UDim2.new(0, 130, 1, 0),
			BackgroundColor = UITheme.Colors.Panel,
			TextColor = UITheme.Colors.TextMuted,
			TextSize = 14,
			CornerRadius = 8,
			Parent = tabBar,
		})
		tabButton.LayoutOrder = index

		tabButton.MouseButton1Click:Connect(function()
			self._activeMutation = mutationId
			self:_refreshTabsHighlight()
			self:_refreshGrid()
		end)

		self._tabButtons[mutationId] = tabButton
	end
end

function DexView:_buildBody(root: Frame)
	local body = UIBuilder.CreateFrame({
		Name = "Body",
		Size = UDim2.new(1, -40, 1, -120),
		Position = UDim2.new(0, 20, 0, 110),
		BackgroundTransparency = 1,
		Parent = root,
	})

	self:_buildGrid(body)
	self:_buildSidebar(body)
end

function DexView:_buildGrid(body: Frame)
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "Grid"
	scrollFrame.Size = UDim2.new(0.72, -10, 1, 0)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollFrame.Parent = body

	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellSize = UDim2.new(0.32, 0, 0, 170)
	gridLayout.CellPadding = UDim2.new(0.02, 0, 0, 10)
	gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	gridLayout.Parent = scrollFrame

	self._grid = scrollFrame
end

function DexView:_buildSidebar(body: Frame)
	local sidebar = UIBuilder.CreateFrame({
		Name = "Sidebar",
		Size = UDim2.new(0.26, 0, 1, 0),
		Position = UDim2.new(0.74, 0, 0, 0),
		BackgroundTransparency = 1,
		Parent = body,
	})

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 10)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = sidebar

	self._globalLabel, self._globalBar = self:_createProgressBar(sidebar, "DISCOVERED", 0, UITheme.Colors.Accent)

	for index, mutationId in MutationConfig.Order do
		local definition = MutationConfig.Definitions[mutationId]
		local label, bar = self:_createProgressBar(sidebar, definition.DisplayName:upper(), index, definition.Color)
		self._sidebarBars[mutationId] = { Label = label, Bar = bar }
	end
end

function DexView:_createProgressBar(parent: Instance, titleText: string, layoutOrder: number, fillColor: Color3)
	local container = UIBuilder.CreateFrame({
		Name = titleText .. "Container",
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundColor = UITheme.Colors.Panel,
		CornerRadius = 8,
		Parent = parent,
	})
	container.LayoutOrder = layoutOrder

	local titleLabel = UIBuilder.CreateLabel({
		Name = "Title",
		Text = titleText,
		Size = UDim2.new(1, -16, 0, 18),
		Position = UDim2.new(0, 8, 0, 4),
		TextColor = fillColor,
		TextSize = 13,
		Font = UITheme.Font,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = container,
	})

	local barBackground = UIBuilder.CreateFrame({
		Name = "BarBackground",
		Size = UDim2.new(1, -16, 0, 10),
		Position = UDim2.new(0, 8, 1, -18),
		BackgroundColor = UITheme.Colors.PanelLight,
		CornerRadius = 5,
		Parent = container,
	})

	local barFill = UIBuilder.CreateFrame({
		Name = "BarFill",
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor = fillColor,
		CornerRadius = 5,
		Parent = barBackground,
	})

	return titleLabel, barFill
end

-- ===== Rafraîchissement =====

function DexView:_refreshTabsHighlight()
	for mutationId, button in self._tabButtons do
		local isActive = mutationId == self._activeMutation
		button.BackgroundColor3 = if isActive then UITheme.Colors.Accent else UITheme.Colors.Panel
		button.TextColor3 = if isActive then UITheme.Colors.Background else UITheme.Colors.TextMuted
	end
end

function DexView:_refreshGrid()
	for _, child in self._grid:GetChildren() do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local entries = DexEntryBuilder.BuildTab(self._activeMutation, self._discoveredSet)

	for index, entry in entries do
		local matchesSearch = self._searchText == ""
			or (entry.IsDiscovered and entry.Name:lower():find(self._searchText, 1, true) ~= nil)

		if matchesSearch then
			local card = self:_createCard(entry)
			card.LayoutOrder = index
			card.Parent = self._grid
		end
	end
end

function DexView:_refreshSidebar()
	local speciesCount = DexEntryBuilder.GetSpeciesCount()
	local totalEntryCount = speciesCount * #MutationConfig.Order
	local totalDiscovered = DexEntryBuilder.CountTotalDiscovered(self._discoveredSet)

	self._globalLabel.Text = `DISCOVERED  {totalDiscovered}/{totalEntryCount}`
	self._globalBar.Size = UDim2.new(if totalEntryCount > 0 then totalDiscovered / totalEntryCount else 0, 0, 1, 0)

	for _, mutationId in MutationConfig.Order do
		local discoveredForMutation = DexEntryBuilder.CountDiscoveredForMutation(mutationId, self._discoveredSet)
		local sidebarEntry = self._sidebarBars[mutationId]
		local definition = MutationConfig.Definitions[mutationId]

		sidebarEntry.Label.Text = `{definition.DisplayName:upper()}  {discoveredForMutation}/{speciesCount}`
		sidebarEntry.Bar.Size =
			UDim2.new(if speciesCount > 0 then discoveredForMutation / speciesCount else 0, 0, 1, 0)
	end
end

function DexView:_createCard(entry): Frame
	local rarityColor = RarityConfig.Definitions[entry.Rarity].Color
	local elementColor = ElementConfig.Colors[entry.Element]
	local borderColor = if entry.IsDiscovered then rarityColor else UITheme.Colors.PanelLight

	local card = UIBuilder.CreateFrame({
		Name = "Card_" .. entry.SpeciesId,
		BackgroundColor = UITheme.Colors.Panel,
		CornerRadius = 10,
		StrokeColor = borderColor,
		StrokeThickness = 2,
	})

	-- Icône (placeholder coloré tant qu'on n'a pas d'assets visuels)
	local icon = UIBuilder.CreateFrame({
		Name = "Icon",
		Size = UDim2.new(1, -16, 0, 64),
		Position = UDim2.new(0, 8, 0, 8),
		BackgroundColor = if entry.IsDiscovered then elementColor else UITheme.Colors.PanelLight,
		CornerRadius = 8,
		Parent = card,
	})

	UIBuilder.CreateLabel({
		Text = if entry.IsDiscovered then entry.Element:sub(1, 1) else "?",
		Size = UDim2.fromScale(1, 1),
		TextColor = UITheme.Colors.Background,
		TextSize = 28,
		Font = UITheme.Font,
		Parent = icon,
	})

	UIBuilder.CreateLabel({
		Name = "Name",
		Text = if entry.IsDiscovered then entry.Name:upper() else UNDISCOVERED_TEXT,
		Size = UDim2.new(1, -16, 0, 20),
		Position = UDim2.new(0, 8, 0, 76),
		TextColor = UITheme.Colors.Text,
		TextSize = 14,
		Font = UITheme.Font,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = card,
	})

	UIBuilder.CreateLabel({
		Name = "Rarity",
		Text = if entry.IsDiscovered then entry.Rarity:upper() else UNDISCOVERED_TEXT,
		Size = UDim2.new(1, -16, 0, 16),
		Position = UDim2.new(0, 8, 0, 96),
		TextColor = if entry.IsDiscovered then rarityColor else UITheme.Colors.TextMuted,
		TextSize = 12,
		Font = UITheme.FontBody,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = card,
	})

	local statsRow = UIBuilder.CreateFrame({
		Name = "StatsRow",
		Size = UDim2.new(1, -16, 0, 20),
		Position = UDim2.new(0, 8, 0, 116),
		BackgroundTransparency = 1,
		Parent = card,
	})

	UIBuilder.CreateLabel({
		Name = "Element",
		Text = entry.Element:upper(),
		Size = UDim2.new(0.34, 0, 1, 0),
		TextColor = elementColor,
		TextSize = 11,
		Font = UITheme.Font,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = statsRow,
	})

	UIBuilder.CreateLabel({
		Name = "Degats",
		Text = if entry.IsDiscovered then `DGT {entry.Degats}` else `DGT {UNDISCOVERED_TEXT}`,
		Size = UDim2.new(0.33, 0, 1, 0),
		Position = UDim2.new(0.34, 0, 0, 0),
		TextColor = UITheme.Colors.Damage,
		TextSize = 11,
		Font = UITheme.FontBody,
		Parent = statsRow,
	})

	UIBuilder.CreateLabel({
		Name = "Chance",
		Text = if entry.IsDiscovered then `LUCK {entry.Chance}` else `LUCK {UNDISCOVERED_TEXT}`,
		Size = UDim2.new(0.33, 0, 1, 0),
		Position = UDim2.new(0.67, 0, 0, 0),
		TextColor = UITheme.Colors.Luck,
		TextSize = 11,
		Font = UITheme.FontBody,
		Parent = statsRow,
	})

	return card
end

return DexView
