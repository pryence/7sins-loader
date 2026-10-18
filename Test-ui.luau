local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "7sinsUI"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local colors = {
	bg = Color3.fromRGB(198, 91, 25),
	panel = Color3.fromRGB(116, 52, 15),
	row = Color3.fromRGB(116, 52, 15),
	border = Color3.fromRGB(255, 140, 0),
	border2 = Color3.fromRGB(242, 138, 66),
	text = Color3.fromRGB(255, 255, 255),
	muted = Color3.fromRGB(217, 138, 82),
	accent = Color3.fromRGB(255, 140, 0),
	selected = Color3.fromRGB(72, 30, 10),
	topSelected = Color3.fromRGB(170, 76, 22),
	topHover = Color3.fromRGB(85, 37, 12),
	bottomHover = Color3.fromRGB(170, 76, 22),
	searchBg = Color3.fromRGB(65, 28, 12),
	hubText = Color3.fromRGB(58, 22, 7)
}

local function create(class, props, parent)
	local obj = Instance.new(class)
	for k, v in pairs(props) do
		obj[k] = v
	end
	-- Apply a subtle black outline to all UI text, including the search field.
	if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
		obj.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		obj.TextStrokeTransparency = 0.25
	end
	obj.Parent = parent
	return obj
end

local window = create("Frame", {
	Name = "MainWindow",
	Size = UDim2.fromOffset(500, 600),
	Position = UDim2.new(0.5, -308.5, 0.5, -370.5),
	BackgroundColor3 = colors.bg,
	BorderSizePixel = 0
}, gui)


-- Anime character above the UI
local animeGirl = Instance.new("ImageLabel")
animeGirl.Name = "AnimeGirl"
animeGirl.Parent = window
animeGirl.BackgroundTransparency = 1
animeGirl.Size = UDim2.fromOffset(250, 250)
animeGirl.Position = UDim2.new(0.5, -125, 0, -251)
animeGirl.Image = "rbxassetid://86575735230563"
animeGirl.ScaleType = Enum.ScaleType.Fit
animeGirl.ZIndex = 5


create("UIStroke", {
	Color = colors.border,
	Thickness = 2
}, window)

local header = create("TextButton", {
	Size = UDim2.new(1, 0, 0, 30),
	BackgroundColor3 = colors.panel,
	BorderSizePixel = 0,
	Text = "",
	TextColor3 = colors.text,
	TextSize = 17,
	Font = Enum.Font.Gotham,
	AutoButtonColor = false
}, window)

-- Separate title labels so only "hub" is darker.
local titleHolder = create("Frame", {
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, -35, 0, 0),
	Size = UDim2.fromOffset(120, 30),
	BackgroundTransparency = 1
}, header)
local titleFirst = create("TextLabel", {
	Size = UDim2.fromOffset(65, 30),
	BackgroundTransparency = 1,
	Text = "7sins ",
	TextColor3 = colors.text,
	TextSize = 17,
	Font = Enum.Font.Gotham,
	TextXAlignment = Enum.TextXAlignment.Right
}, titleHolder)
create("TextLabel", {
	Position = UDim2.fromOffset(65, 0),
	Size = UDim2.fromOffset(55, 30),
	BackgroundTransparency = 1,
	Text = "hub",
	TextColor3 = colors.hubText,
	TextSize = 17,
	Font = Enum.Font.Gotham,
	TextXAlignment = Enum.TextXAlignment.Left
}, titleHolder)

local search = create("TextBox", {
	Size = UDim2.fromOffset(140, 23),
	Position = UDim2.new(1, -150, 0, 3),
	BackgroundColor3 = colors.searchBg,
	BorderSizePixel = 0,
	Text = "",
	PlaceholderText = "search...",
	TextColor3 = colors.text,
	PlaceholderColor3 = colors.text,
	TextSize = 15,
	Font = Enum.Font.Gotham,
	ClearTextOnFocus = false
}, window)

create("UIStroke", {
	Color = Color3.fromRGB(0, 0, 0),
	Thickness = 1
}, search)

-- Dragging
local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = window.Position
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		window.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

local mainTabs = {
	"7sins", "Farm", "Player", "ESP", "World", "Other"
}

-- Each top category has its own bottom category list.
local subTabsByMain = {
	["7sins"] = {"Home"},
	["Farm"] = {"Mob Farm", "Player Farm", "Insta kill", "Combat", "Trinkets", "Rarity Farm", "Boss Farm", "Network"},
	["Player"] = {"Movement", "Utility", "Misc"},
	["ESP"] = {"ESP"},
	["World"] = {"Camera", "Effects", "Performance", "Teleport", "TP NPCs", "TP Areas", "Attach"},
	["Other"] = {"Settings"}
}

local tabBar = create("Frame", {
	Position = UDim2.fromOffset(8, 32),
	Size = UDim2.new(1, -16, 0, 20),
	BackgroundTransparency = 1
}, window)

local content = create("Frame", {
	Position = UDim2.fromOffset(10, 53),
	Size = UDim2.new(1, -20, 1, -69),
	BackgroundTransparency = 1
}, window)

local subBar = create("Frame", {
	Size = UDim2.new(1, 0, 0, 15),
	BackgroundColor3 = colors.panel,
	BorderSizePixel = 0
}, content)

-- Orange separator above the bottom category row.
create("Frame", {
	Name = "SubTabTopLine",
	Size = UDim2.new(1, 0, 0, 2),
	Position = UDim2.fromOffset(0, 0),
	BackgroundColor3 = colors.border,
	BorderSizePixel = 0,
	ZIndex = 3
}, subBar)

local body = create("ScrollingFrame", {
	Position = UDim2.fromOffset(0, 27),
	Size = UDim2.new(1, 0, 1, -27),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = colors.border,
	CanvasSize = UDim2.fromOffset(0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y
}, content)

local layout = create("UIListLayout", {
	Padding = UDim.new(0, 3),
	SortOrder = Enum.SortOrder.LayoutOrder
}, body)

local function clearBody()
	for _, child in ipairs(body:GetChildren()) do
		if child ~= layout then
			child:Destroy()
		end
	end
end

local function addRate(labelText)
	local value = 0

	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, 25),
		BackgroundColor3 = colors.row,
		BorderSizePixel = 0
	}, body)

	create("TextLabel", {
		Size = UDim2.new(0.72, 0, 1, 0),
		Position = UDim2.fromOffset(5, 0),
		BackgroundTransparency = 1,
		Text = labelText,
		TextColor3 = colors.text,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left
	}, row)

	local rate = create("TextButton", {
		Size = UDim2.new(0.25, 0, 1, 0),
		Position = UDim2.new(0.75, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = "0/100%",
		TextColor3 = colors.text,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Right
	}, row)

	rate.MouseButton1Click:Connect(function()
		value = (value + 10) % 110
		rate.Text = value .. "/100%"
	end)
end

local function addDropdown(title, options)
	local holder = create("Frame", {
		Size = UDim2.new(1, 0, 0, 54),
		BackgroundColor3 = colors.row,
		BorderSizePixel = 0,
		ClipsDescendants = true
	}, body)

	create("TextLabel", {
		Size = UDim2.new(1, -10, 0, 23),
		Position = UDim2.fromOffset(5, 0),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = colors.text,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left
	}, holder)

	local button = create("TextButton", {
		Position = UDim2.fromOffset(5, 25),
		Size = UDim2.new(1, -10, 0, 23),
		BackgroundColor3 = colors.panel,
		Text = "Select...                         ▼",
		TextColor3 = colors.text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left
	}, holder)

	create("UIStroke", { Color = Color3.fromRGB(255, 140, 0), Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, button)

	local open = false

	button.MouseButton1Click:Connect(function()
		open = not open

		for _, child in ipairs(holder:GetChildren()) do
			if child.Name == "Option" then
				child:Destroy()
			end
		end

		if open then
			holder.Size = UDim2.new(1, 0, 0, 54 + #options * 25)

			for i, option in ipairs(options) do
				local item = create("TextButton", {
					Name = "Option",
					Position = UDim2.fromOffset(5, 54 + (i - 1) * 25),
					Size = UDim2.new(1, -10, 0, 24),
					BackgroundColor3 = colors.panel,
					Text = option,
					TextColor3 = colors.text,
					TextSize = 13,
					Font = Enum.Font.Gotham
				}, holder)

				create("UIStroke", { Color = Color3.fromRGB(255, 140, 0), Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, item)

				item.MouseButton1Click:Connect(function()
					button.Text = option .. "                         ▼"
					open = false
					holder.Size = UDim2.new(1, 0, 0, 54)
					for _, obj in ipairs(holder:GetChildren()) do
						if obj.Name == "Option" then
							obj:Destroy()
						end
					end
				end)
			end
		else
			holder.Size = UDim2.new(1, 0, 0, 54)
		end
	end)
end

local function addButton(text)
	local button = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundColor3 = colors.row,
		BorderSizePixel = 0,
		Text = text,
		TextColor3 = colors.text,
		TextSize = 14,
		Font = Enum.Font.Gotham
	}, body)

	button.MouseButton1Click:Connect(function()
		print("Clicked:", text)
	end)
end

local activeTab = "7sins"
local activeSub = "Home"

local function render()
	clearBody()
	-- Placeholder content until settings are added to each category.
	addButton(activeTab .. " / " .. activeSub)
	addRate("Example Setting")
	addDropdown("Example Options", {
		"Option 1", "Option 2", "Option 3"
	})
end

local mainButtons = {}
local subButtons = {}
local hoveredMainTabs = {}
local hoveredSubTabs = {}

local function refreshTabs()
	for name, button in pairs(mainButtons) do
		button.TextColor3 = name == activeTab and colors.text or colors.muted
		button.BackgroundColor3 = (name == activeTab and colors.topSelected)
			or (hoveredMainTabs[name] and colors.topHover)
			or colors.panel
	end

	for name, button in pairs(subButtons) do
		button.TextColor3 = name == activeSub and colors.text or colors.muted
		button.BackgroundColor3 = (name == activeSub and colors.selected)
			or (hoveredSubTabs[name] and colors.bottomHover)
			or colors.panel
	end
end

local rebuildSubTabs

for i, name in ipairs(mainTabs) do
	local button = create("TextButton", {
		Size = UDim2.new(1 / #mainTabs, -2, 1, 0),
		Position = UDim2.new((i - 1) / #mainTabs, 0, 0, 0),
		BackgroundColor3 = colors.panel,
		BorderSizePixel = 0,
		Text = name,
		TextColor3 = colors.muted,
		TextSize = 11,
		Font = Enum.Font.Gotham,
		AutoButtonColor = false -- Custom hover only for unselected tabs.
	}, tabBar)

	create("Frame", {
		Name = "Underline",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 2),
		BackgroundColor3 = colors.border2,
		BorderSizePixel = 0,
		ZIndex = 3
	}, button)

	mainButtons[name] = button

	button.MouseEnter:Connect(function()
		hoveredMainTabs[name] = true
		refreshTabs()
	end)

	button.MouseLeave:Connect(function()
		hoveredMainTabs[name] = nil
		refreshTabs()
	end)

	button.MouseButton1Click:Connect(function()
		if activeTab ~= name then
			activeTab = name
			activeSub = subTabsByMain[name][1]
			rebuildSubTabs()
		end
		refreshTabs()
		render()
	end)
end

-- Rebuild bottom tabs whenever the top category changes.
rebuildSubTabs = function()
	for _, button in pairs(subButtons) do
		button:Destroy()
	end
	table.clear(subButtons)
	table.clear(hoveredSubTabs)

	local subTabs = subTabsByMain[activeTab]
	for i, name in ipairs(subTabs) do
		local button = create("TextButton", {
			Size = UDim2.new(1 / #subTabs, -2, 1, 0),
			Position = UDim2.new((i - 1) / #subTabs, 0, 0, 0),
			BackgroundColor3 = colors.panel,
			BorderSizePixel = 0,
			Text = name,
			TextColor3 = colors.muted,
			TextSize = 13,
			TextScaled = true,
			Font = Enum.Font.Gotham,
			AutoButtonColor = false
		}, subBar)

		-- Fit longer Farm/World names without altering the tab bar layout.
		create("UITextSizeConstraint", {
			MinTextSize = 8,
			MaxTextSize = 13
		}, button)

		subButtons[name] = button

		button.MouseEnter:Connect(function()
			hoveredSubTabs[name] = true
			refreshTabs()
		end)

		button.MouseLeave:Connect(function()
			hoveredSubTabs[name] = nil
			refreshTabs()
		end)

		button.MouseButton1Click:Connect(function()
			activeSub = name
			refreshTabs()
			render()
		end)
	end
	refreshTabs()
end

-- Search highlights matching settings
search:GetPropertyChangedSignal("Text"):Connect(function()
	local query = string.lower(search.Text)

	for _, item in ipairs(body:GetChildren()) do
		if item:IsA("Frame") then
			local found = query == ""

			for _, descendant in ipairs(item:GetDescendants()) do
				if descendant:IsA("TextLabel") then
					if string.find(
						string.lower(descendant.Text),
						query,
						1,
						true
						) then
						found = true
					end
				end
			end

			item.Visible = found
		end
	end
end)

rebuildSubTabs()
render()
