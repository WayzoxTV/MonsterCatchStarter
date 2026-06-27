--[[
	UIBuilder
	Petits constructeurs pour créer des instances Roblox stylées (coins
	arrondis, contours...) sans répéter le même bloc de code partout.
]]

local UIBuilder = {}

export type FrameOptions = {
	Name: string?,
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	BackgroundColor: Color3?,
	BackgroundTransparency: number?,
	CornerRadius: number?,
	StrokeColor: Color3?,
	StrokeThickness: number?,
	Parent: Instance?,
}

function UIBuilder.CreateFrame(options: FrameOptions): Frame
	local frame = Instance.new("Frame")
	frame.Name = options.Name or "Frame"
	frame.Size = options.Size or UDim2.fromScale(1, 1)
	frame.Position = options.Position or UDim2.fromScale(0, 0)
	frame.AnchorPoint = options.AnchorPoint or Vector2.new(0, 0)
	frame.BackgroundColor3 = options.BackgroundColor or Color3.new(1, 1, 1)
	frame.BackgroundTransparency = options.BackgroundTransparency or 0
	frame.BorderSizePixel = 0

	if options.CornerRadius then
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, options.CornerRadius)
		corner.Parent = frame
	end

	if options.StrokeColor then
		local stroke = Instance.new("UIStroke")
		stroke.Color = options.StrokeColor
		stroke.Thickness = options.StrokeThickness or 1
		stroke.Parent = frame
	end

	frame.Parent = options.Parent
	return frame
end

export type LabelOptions = {
	Name: string?,
	Text: string,
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	TextColor: Color3?,
	TextSize: number?,
	Font: Enum.Font?,
	TextXAlignment: Enum.TextXAlignment?,
	BackgroundColor: Color3?,
	BackgroundTransparency: number?,
	CornerRadius: number?,
	Parent: Instance?,
}

function UIBuilder.CreateLabel(options: LabelOptions): TextLabel
	local label = Instance.new("TextLabel")
	label.Name = options.Name or "Label"
	label.Text = options.Text
	label.Size = options.Size or UDim2.fromScale(1, 1)
	label.Position = options.Position or UDim2.fromScale(0, 0)
	label.AnchorPoint = options.AnchorPoint or Vector2.new(0, 0)
	label.TextColor3 = options.TextColor or Color3.new(1, 1, 1)
	label.TextSize = options.TextSize or 16
	label.Font = options.Font or Enum.Font.Gotham
	label.TextXAlignment = options.TextXAlignment or Enum.TextXAlignment.Center
	label.BackgroundColor3 = options.BackgroundColor or Color3.new(0, 0, 0)
	label.BackgroundTransparency = if options.BackgroundTransparency ~= nil then options.BackgroundTransparency else 1
	label.BorderSizePixel = 0
	label.TextWrapped = true

	if options.CornerRadius then
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, options.CornerRadius)
		corner.Parent = label
	end

	label.Parent = options.Parent
	return label
end

export type ButtonOptions = {
	Name: string?,
	Text: string,
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	TextColor: Color3?,
	TextSize: number?,
	Font: Enum.Font?,
	BackgroundColor: Color3?,
	CornerRadius: number?,
	Parent: Instance?,
}

function UIBuilder.CreateButton(options: ButtonOptions): TextButton
	local button = Instance.new("TextButton")
	button.Name = options.Name or "Button"
	button.Text = options.Text
	button.Size = options.Size or UDim2.fromScale(1, 1)
	button.Position = options.Position or UDim2.fromScale(0, 0)
	button.AnchorPoint = options.AnchorPoint or Vector2.new(0, 0)
	button.TextColor3 = options.TextColor or Color3.new(1, 1, 1)
	button.TextSize = options.TextSize or 16
	button.Font = options.Font or Enum.Font.GothamBold
	button.BackgroundColor3 = options.BackgroundColor or Color3.new(0.2, 0.2, 0.2)
	button.AutoButtonColor = true
	button.BorderSizePixel = 0

	if options.CornerRadius then
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, options.CornerRadius)
		corner.Parent = button
	end

	button.Parent = options.Parent
	return button
end

return UIBuilder
