--!strict
local Tekscripts = {}
Tekscripts.__index = Tekscripts

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

---
-- Tabela de Constantes de Design (Tema Dark Clean com mais contraste)
---
local DESIGN = {
    -- Janelas e planos de fundo
    WindowColor1 = Color3.fromRGB(25, 26, 28),
    WindowColor2 = Color3.fromRGB(20, 21, 23),
    BlockScreenColor = Color3.fromRGB(0, 0, 0, 0.65),

    -- Tipografia
    TitleColor = Color3.fromRGB(240, 240, 245),
    ComponentTextColor = Color3.fromRGB(215, 215, 220),
    InputTextColor = Color3.fromRGB(230, 230, 235),
    NotifyTextColor = Color3.fromRGB(220, 220, 225),
    EmptyStateTextColor = Color3.fromRGB(150, 150, 155),

    -- Fundos e componentes
    ComponentBackground = Color3.fromRGB(34, 35, 38),
    InputBackgroundColor = Color3.fromRGB(42, 43, 47),
    AccentColor = Color3.fromRGB(90, 160, 255), -- Azul com leve toque neon
    ItemHoverColor = Color3.fromRGB(50, 52, 57),
    ComponentHoverColor = Color3.fromRGB(65, 68, 75),

    -- Botões e toggles
    ActiveToggleColor = Color3.fromRGB(90, 160, 255),
    InactiveToggleColor = Color3.fromRGB(55, 56, 60),
    MinimizeButtonColor = Color3.fromRGB(180, 180, 185),
    CloseButtonColor = Color3.fromRGB(255, 85, 100),
    FloatButtonColor = Color3.fromRGB(45, 46, 52),

    -- Dropdown
    DropdownBackground = Color3.fromRGB(32, 33, 37),
    DropdownItemHover = Color3.fromRGB(55, 57, 63),

    -- Tabs
    TabActiveColor = Color3.fromRGB(90, 160, 255),
    TabInactiveColor = Color3.fromRGB(36, 37, 41),

    -- Slider
    SliderTrackColor = Color3.fromRGB(58, 59, 63),
    SliderFillColor = Color3.fromRGB(90, 160, 255),
    ThumbColor = Color3.fromRGB(240, 240, 245),
    ThumbOutlineColor = Color3.fromRGB(45, 46, 50),

    -- Outros elementos
    HRColor = Color3.fromRGB(75, 76, 82),
    ResizeHandleColor = Color3.fromRGB(60, 61, 66),
    NotifyBackground = Color3.fromRGB(38, 39, 43),
    TagBackground = Color3.fromRGB(90, 160, 255),

    -- Dimensões e layout
    WindowSize = UDim2.new(0, 520, 0, 480),
    MinWindowSize = Vector2.new(520, 370),
    MaxWindowSize = Vector2.new(820, 580),
    TitleHeight = 44,
    TitlePadding = 10,

    ComponentHeight = 46,
    ComponentPadding = 10,
    ContainerPadding = 3,
    CornerRadius = 9,
    ButtonIconSize = 24,
    IconSize = 28,

    TabButtonWidth = 140,
    TabButtonHeight = 40,

    FloatButtonSize = UDim2.new(0, 140, 0, 46),
    ResizeHandleSize = 16,
    NotifyWidth = 280,
    NotifyHeight = 72,
    TagHeight = 30,
    TagWidth = 115,

    HRHeight = 2,
    HRTextPadding = 14,
    HRMinTextSize = 20,
    HRMaxTextSize = 30,

    DropdownWidth = 150,
    DropdownItemHeight = 35,

    BlurEffectSize = 10,
    AnimationSpeed = 0.25,

    EdgeThreshold = 15,
    EdgeButtonSize = 40,
    EdgeButtonPadding = 5,
    EdgeButtonCornerRadius = 6,
}
---
-- Funções de Criação de Componentes
---

-- cache de TweenInfo (evita recriar o mesmo objeto várias vezes)
local tweenInfo = TweenInfo.new(DESIGN.AnimationSpeed, Enum.EasingStyle.Quad)

-- utilitário para criar cantos arredondados (reutilizável e limpo)
local function addRoundedCorners(instance: Instance, radius: number?)
	if not instance or not instance:IsA("GuiObject") then return end

	local corner = instance:FindFirstChildOfClass("UICorner")
	if not corner then
		corner = Instance.new("UICorner")
		corner.Name = "Corner"
		corner.Parent = instance
	end

	corner.CornerRadius = UDim.new(0, radius or DESIGN.CornerRadius)
	return corner
end

-- efeito de hover otimizado e com cleanup
local function addHoverEffect(button: GuiObject, originalColor: Color3, hoverColor: Color3, condition: (() -> boolean)?)
	if not button or not button:IsA("GuiObject") then return end

	local isHovering, isDown = false, false
	local activeTween

	local function safeTween(targetColor)
		if activeTween then
			activeTween:Cancel()
			activeTween = nil
		end
		if not condition or condition() then
			activeTween = TweenService:Create(button, tweenInfo, { BackgroundColor3 = targetColor })
			activeTween:Play()
		end
	end

	-- Conexões armazenadas para facilitar desconexão no Destroy
	local connections = {}

	table.insert(connections, button.MouseEnter:Connect(function()
		isHovering = true
		if not isDown then safeTween(hoverColor) end
	end))

	table.insert(connections, button.MouseLeave:Connect(function()
		isHovering = false
		if not isDown then safeTween(originalColor) end
	end))

	table.insert(connections, button.MouseButton1Down:Connect(function()
		isDown = true
	end))

	table.insert(connections, button.MouseButton1Up:Connect(function()
		isDown = false
		if not isHovering then safeTween(originalColor) end
	end))

	-- Cleanup automático ao destruir o botão
	button.AncestryChanged:Connect(function(_, parent)
		if not parent then
			for _, conn in ipairs(connections) do
				conn:Disconnect()
			end
			connections = {}
			activeTween = nil
		end
	end)
end

-- criação do botão
local function createButton(text: string, size: UDim2?, parent: Instance)
	local btn = Instance.new("TextButton")
	btn.Text = text
	btn.Size = size or UDim2.new(1, 0, 0, DESIGN.ComponentHeight)
	btn.BackgroundColor3 = DESIGN.ComponentBackground
	btn.TextColor3 = DESIGN.ComponentTextColor
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.Roboto
	btn.TextScaled = true
	btn.AutoButtonColor = false -- desativa o hover padrão
	btn.Parent = parent

	addRoundedCorners(btn, DESIGN.CornerRadius)
	addHoverEffect(btn, DESIGN.ComponentBackground, DESIGN.ComponentHoverColor)

	return btn
end

---
-- Lógica do Tab
---
local Tab = {}
Tab.__index = Tab

function Tab.new(name: string, parent: Instance)
    local self = setmetatable({}, Tab)

    self.Name = name

    -- Container principal
    local c = Instance.new("ScrollingFrame")
    self.Container = c
    c.Size = UDim2.new(1, 0, 1, 0)
    c.BackgroundTransparency = 1
    c.BorderSizePixel = 0
    c.ScrollBarThickness = 6
    c.ScrollBarImageColor3 = DESIGN.ComponentHoverColor
    c.AutomaticCanvasSize = Enum.AutomaticSize.Y
    c.CanvasSize = UDim2.new(0, 0, 0, 0)
    c.ScrollingDirection = Enum.ScrollingDirection.Y
    c.ClipsDescendants = true
    c.Parent = parent

    -- Padding interno
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, DESIGN.ContainerPadding)
    padding.PaddingLeft = UDim.new(0, DESIGN.ContainerPadding)
    padding.PaddingRight = UDim.new(0, DESIGN.ContainerPadding)
    padding.PaddingBottom = UDim.new(0, DESIGN.ContainerPadding)
    padding.Parent = c

    -- Layout dos componentes
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, DESIGN.ComponentPadding)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = c

    self.Components = {}

    -- 🧱 Camada fixa acima do conteúdo para o box vazio
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.BackgroundTransparency = 1
    overlay.ZIndex = 5
    overlay.Parent = c

    -- Box centralizado
    local emptyBox = Instance.new("Frame")
    emptyBox.Size = UDim2.new(0.6, 0, 0.2, 0)
    emptyBox.AnchorPoint = Vector2.new(0.5, 0.5)
    emptyBox.Position = UDim2.new(0.5, 0, 0.5, 0)
    emptyBox.BackgroundColor3 = DESIGN.EmptyStateBoxColor or Color3.fromRGB(30, 30, 30)
    emptyBox.BackgroundTransparency = 0.2
    emptyBox.BorderSizePixel = 0
    emptyBox.Visible = true
    emptyBox.ZIndex = 6
    emptyBox.Parent = overlay

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius or 10)
    corner.Parent = emptyBox

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = DESIGN.EmptyStateBorderColor or Color3.fromRGB(80, 80, 80)
    stroke.Transparency = 0.3
    stroke.Parent = emptyBox

    local emptyText = Instance.new("TextLabel")
    emptyText.Size = UDim2.new(1, -10, 1, -10)
    emptyText.AnchorPoint = Vector2.new(0.5, 0.5)
    emptyText.Position = UDim2.new(0.5, 0, 0.5, 0)
    emptyText.BackgroundTransparency = 1
    emptyText.Text = "Parece que ainda não há nada aqui."
    emptyText.TextColor3 = DESIGN.EmptyStateTextColor or Color3.fromRGB(180, 180, 180)
    emptyText.Font = Enum.Font.Roboto
    emptyText.TextScaled = true
    emptyText.TextWrapped = true
    emptyText.ZIndex = 7
    emptyText.Parent = emptyBox

    self.EmptyBox = emptyBox
    self._overlay = overlay

    -- Controle automático de visibilidade
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local hasComponents = #self.Components > 0
        overlay.Visible = not hasComponents

        local totalContentHeight = listLayout.AbsoluteContentSize.Y + (DESIGN.ContainerPadding * 2)
        local containerHeight = c.AbsoluteSize.Y
        c.ScrollBarImageTransparency = totalContentHeight > containerHeight and 0 or 1
    end)

    return self
end

---
-- Construtor da GUI
---

function Tekscripts.new(options: { Name: string?, Parent: Instance?, FloatText: string?, startTab: string?, iconId: string? })
    options = options or {}
    
    -- // ESTRUTURA E ESTADOS INICIAIS
    
    local self = setmetatable({
        ScreenGui = nil,
        MinimizedState = nil, -- nil, "float", "left", "right", "top", "bottom"
        Tabs = {},
        CurrentTab = nil,
        IsDragging = false,
        IsResizing = false,
        Window = nil,
        TitleBar = nil,
        TabContainer = nil,
        TabContentContainer = nil,
        ResizeHandle = nil,
        FloatButton = nil,
        EdgeButtons = {},
        Connections = {},
        BlockScreen = nil,
        Blocked = false,
        startTab = options.startTab,
        DropdownMenu = nil,
        NoTabsLabel = nil,
        Title = nil,
        TitleScrollTween = nil,
        TitleScrollConnection = nil,
        BlurEffect = nil,
        LastWindowPosition = nil,
        LastWindowSize = nil,
        _activeTween = nil, -- Para gerenciamento de tweens
        _dragStart = nil,
        _resizeStart = nil,
        _lastMousePos = nil,
        _isSmallScreen = nil,
        _viewSize = nil
    }, Tekscripts)

    -- Variáveis de Ambiente (calculadas uma vez, mas com listener para resize)
    self:_UpdateScreenSize()
    self.Connections.ViewportChanged = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        self:_UpdateScreenSize()
        self:UpdateContainersSize()
    end)

    -- Criação do ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = options.Name or "Tekscripts"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = options.Parent or localPlayer:WaitForChild("PlayerGui")
    
    -- // JANELA PRINCIPAL (WINDOW)
    
    self.Window = Instance.new("Frame")
    self.Window.Size = self:_GetWindowSize()
    self.Window.Position = self:_GetWindowPosition()
    self.Window.AnchorPoint = self._isSmallScreen and Vector2.new(0.5, 0.5) or Vector2.new(0, 0)
    self.Window.BackgroundColor3 = DESIGN.WindowColor1
    self.Window.BorderSizePixel = 0
    self.Window.Parent = self.ScreenGui
    self.Window.ClipsDescendants = true

    addRoundedCorners(self.Window, DESIGN.CornerRadius)

    local windowGradient = Instance.new("UIGradient")
    windowGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, DESIGN.WindowColor1),
        ColorSequenceKeypoint.new(1, DESIGN.WindowColor2)
    })
    windowGradient.Rotation = 90
    windowGradient.Parent = self.Window
    
    -- // BARRA DE TÍTULO (TITLE BAR) E CABEÇALHO
    
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, DESIGN.TitleHeight)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundTransparency = 1
    self.TitleBar.Parent = self.Window

    local mainHeader = Instance.new("Frame")
    mainHeader.Size = UDim2.new(1, 0, 1, 0)
    mainHeader.BackgroundTransparency = 1
    mainHeader.LayoutOrder = 1
    mainHeader.Parent = self.TitleBar

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = mainHeader

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = mainHeader

	-- Ícone
	local iconFrame = Instance.new("Frame")
	iconFrame.Size = UDim2.new(0, DESIGN.IconSize, 0, DESIGN.IconSize)
	iconFrame.BackgroundTransparency = 1
	iconFrame.ClipsDescendants = true
	iconFrame.Parent = mainHeader
	
	local icon = Instance.new("ImageLabel")
	icon.Image = options.iconId or "rbxassetid://10590477450"
	icon.Size = UDim2.new(1, 0, 1, 0)
	icon.BackgroundTransparency = 1
	icon.Parent = iconFrame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = iconFrame

    -- Título
    local titleFrame = Instance.new("Frame")
    local titleWidth = UDim2.new(1, -(DESIGN.IconSize + DESIGN.TitlePadding + DESIGN.TitleHeight * 2), 1, 0)
    titleFrame.Size = titleWidth
    titleFrame.BackgroundTransparency = 1
    titleFrame.ClipsDescendants = true
    titleFrame.Parent = mainHeader

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = options.Name or "Tekscripts"
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = DESIGN.TitleColor
    title.Font = Enum.Font.RobotoMono
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleFrame
    self.Title = title

    self:SetupTitleScroll()

    -- Botões de Controle
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(0, DESIGN.TitleHeight * 2, 1, 0)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = mainHeader
    
    local buttonListLayout = Instance.new("UIListLayout")
    buttonListLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    buttonListLayout.Padding = UDim.new(0, 5)
    buttonListLayout.Parent = buttonFrame

    local controlBtn = Instance.new("TextButton")
    controlBtn.Text = "•••"
    controlBtn.Size = UDim2.new(0, DESIGN.TitleHeight, 0, DESIGN.TitleHeight)
    controlBtn.BackgroundColor3 = DESIGN.ComponentBackground
    controlBtn.TextColor3 = DESIGN.ComponentTextColor
    controlBtn.Font = Enum.Font.Roboto
    controlBtn.TextScaled = true
    controlBtn.BorderSizePixel = 0
    controlBtn.Parent = buttonFrame

    addRoundedCorners(controlBtn, DESIGN.CornerRadius)
    addHoverEffect(controlBtn, DESIGN.ComponentBackground, DESIGN.ComponentHoverColor)

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Text = "−"
    minimizeBtn.Size = UDim2.new(0, DESIGN.TitleHeight, 0, DESIGN.TitleHeight)
    minimizeBtn.BackgroundColor3 = DESIGN.MinimizeButtonColor
    minimizeBtn.TextColor3 = DESIGN.ComponentTextColor
    minimizeBtn.Font = Enum.Font.Roboto
    minimizeBtn.TextScaled = true
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = buttonFrame

    addRoundedCorners(minimizeBtn, DESIGN.CornerRadius)
    addHoverEffect(minimizeBtn, DESIGN.MinimizeButtonColor, DESIGN.ComponentHoverColor)

    self.Connections.MinimizeClick = minimizeBtn.MouseButton1Click:Connect(function()
        self:Minimize()
    end)
    
    -- Sistema de arrastar (otimizado, sem tweens por frame)
    self:SetupDragSystem()
    
    
    -- // MENU DROPDOWN
    
    self.DropdownMenu = Instance.new("Frame")
    self.DropdownMenu.Size = UDim2.new(0, DESIGN.DropdownWidth, 0, 0)
    self.DropdownMenu.Position = UDim2.new(1, -DESIGN.DropdownWidth - 5, 0, DESIGN.TitleHeight + 5)
    self.DropdownMenu.BackgroundColor3 = DESIGN.DropdownBackground
    self.DropdownMenu.BorderSizePixel = 0
    self.DropdownMenu.Visible = false
    self.DropdownMenu.Parent = self.ScreenGui

    addRoundedCorners(self.DropdownMenu)

    local dropdownLayout = Instance.new("UIListLayout")
    dropdownLayout.Padding = UDim.new(0, 5)
    dropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
    dropdownLayout.Parent = self.DropdownMenu

    local dropdownPadding = Instance.new("UIPadding")
    dropdownPadding.PaddingTop = UDim.new(0, 5)
    dropdownPadding.PaddingBottom = UDim.new(0, 5)
    dropdownPadding.Parent = self.DropdownMenu
    
    -- Opção "Fechar"
    local closeOption = Instance.new("TextButton")
    closeOption.Text = "Fechar"
    closeOption.Size = UDim2.new(1, -10, 0, DESIGN.DropdownItemHeight)
    closeOption.BackgroundColor3 = DESIGN.DropdownBackground
    closeOption.TextColor3 = DESIGN.CloseButtonColor
    closeOption.Font = Enum.Font.Roboto
    closeOption.TextScaled = true
    closeOption.BorderSizePixel = 0
    closeOption.Parent = self.DropdownMenu

    addRoundedCorners(closeOption, 5)
    addHoverEffect(closeOption, DESIGN.DropdownBackground, DESIGN.DropdownItemHover)

    self.Connections.CloseClick = closeOption.MouseButton1Click:Connect(function()
        self:Destroy()
        self.DropdownMenu.Visible = false
    end)

    -- Ajusta o tamanho do dropdown (usar BindToClose ou algo, mas aqui calculado uma vez)
    self.DropdownMenu.Size = UDim2.new(0, DESIGN.DropdownWidth, 0, dropdownLayout.AbsoluteContentSize.Y + 10)

    -- Conexões do Dropdown
    self.Connections.ControlBtn = controlBtn.MouseButton1Click:Connect(function()
        self.DropdownMenu.Visible = not self.DropdownMenu.Visible
    end)

    self.Connections.InputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if self.DropdownMenu.Visible and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local dropdownPos = self.DropdownMenu.AbsolutePosition
            local dropdownSize = self.DropdownMenu.AbsoluteSize
            local controlBtnPos = controlBtn.AbsolutePosition
            local controlBtnSize = controlBtn.AbsoluteSize

            local isOutsideDropdown = mousePos.X < dropdownPos.X or mousePos.X > dropdownPos.X + dropdownSize.X or mousePos.Y < dropdownPos.Y or mousePos.Y > dropdownPos.Y + dropdownSize.Y
            local isOutsideControlBtn = mousePos.X < controlBtnPos.X or mousePos.X > controlBtnPos.X + controlBtnSize.X or mousePos.Y < controlBtnPos.Y or mousePos.Y > controlBtnPos.Y + controlBtnSize.Y

            if isOutsideDropdown and isOutsideControlBtn then
                self.DropdownMenu.Visible = false
            end
        end
    end)
    
    
    -- // CONTAINER DAS ABAS (TAB CONTAINER)
    
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = self:_GetTabContainerSize()
    self.TabContainer.Position = UDim2.new(0, 0, 0, DESIGN.TitleHeight)
    self.TabContainer.BackgroundColor3 = DESIGN.WindowColor2
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.Window

    addRoundedCorners(self.TabContainer, DESIGN.CornerRadius)

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = self.TabContainer

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.PaddingLeft = UDim.new(0, 5)
    tabPadding.PaddingRight = UDim.new(0, 5)
    tabPadding.Parent = self.TabContainer

    -- Mensagem de "sem abas"
    self.NoTabsLabel = Instance.new("TextLabel")
    self.NoTabsLabel.Size = UDim2.new(1, 0, 1, 0)
    self.NoTabsLabel.BackgroundTransparency = 1
    self.NoTabsLabel.Text = "não tem tabs :("
    self.NoTabsLabel.TextColor3 = DESIGN.EmptyStateTextColor
    self.NoTabsLabel.Font = Enum.Font.Roboto
    self.NoTabsLabel.TextScaled = true
    self.NoTabsLabel.TextXAlignment = Enum.TextXAlignment.Center
    self.NoTabsLabel.TextYAlignment = Enum.TextYAlignment.Center
    self.NoTabsLabel.Parent = self.TabContainer
    self.NoTabsLabel.Visible = true

    
    -- // CONTEÚDO DAS ABAS (TAB CONTENT CONTAINER)
    
    self.TabContentContainer = Instance.new("Frame")
    self.TabContentContainer.Size = self:_GetContentContainerSize()
    self.TabContentContainer.Position = UDim2.new(self:_GetTabContainerSize().X.Scale, self:_GetTabContainerSize().X.Offset, 0, DESIGN.TitleHeight)
    self.TabContentContainer.BackgroundTransparency = 1
    self.TabContentContainer.Parent = self.Window

    
    -- // OUTROS COMPONENTES
    
    self:SetupResizeSystem()
    self:SetupFloatButton(options.FloatText or "📋 Expandir")
    self:CreateEdgeButtons()

    -- Tela de bloqueio
    self.BlockScreen = Instance.new("Frame")
    self.BlockScreen.Size = UDim2.new(1, 0, 1, 0)
    self.BlockScreen.BackgroundTransparency = 0.5
    self.BlockScreen.BackgroundColor3 = DESIGN.BlockScreenColor
    self.BlockScreen.ZIndex = 10
    self.BlockScreen.Visible = false
    self.BlockScreen.Parent = self.ScreenGui

    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = self.BlockScreen
    self.BlurEffect = blur

    
    -- // CONEXÕES DE LIMPEZA
    
    self.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
        if player == localPlayer then
            self:Destroy()
        end
    end)
    
    return self
end

function Tekscripts:_UpdateScreenSize()
    self._viewSize = workspace.CurrentCamera.ViewportSize
    self._isSmallScreen = self._viewSize.X < DESIGN.MinWindowSize.X
end

function Tekscripts:_GetWindowSize()
    return self._isSmallScreen and UDim2.new(0.95, 0, 0.95, 0) or DESIGN.WindowSize
end

function Tekscripts:_GetWindowPosition()
    if self._isSmallScreen then
        return UDim2.new(0.5, 0, 0.5, 0)
    else
        local size = DESIGN.WindowSize
        return UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2)
    end
end

function Tekscripts:_GetTabContainerSize()
    return self._isSmallScreen and UDim2.new(0.3, 0, 1, -DESIGN.TitleHeight) or UDim2.new(0, DESIGN.TabButtonWidth, 1, -DESIGN.TitleHeight)
end

function Tekscripts:_GetContentContainerSize()
    local tabWidth = self._isSmallScreen and UDim.new(0.3, 0) or UDim.new(0, DESIGN.TabButtonWidth)
    return self._isSmallScreen and UDim2.new(0.7, 0, 1, -DESIGN.TitleHeight) or UDim2.new(1, -DESIGN.TabButtonWidth - DESIGN.ResizeHandleSize, 1, -DESIGN.TitleHeight)
end

function Tekscripts:Destroy()
    if self.TitleScrollConnection then
        self.TitleScrollConnection:Disconnect()
        self.TitleScrollConnection = nil
    end
    if self.TitleScrollTween then
        self.TitleScrollTween:Cancel()
        self.TitleScrollTween = nil
    end
    if self._activeTween then
        self._activeTween:Cancel()
        self._activeTween = nil
    end
    for _, buttonData in pairs(self.EdgeButtons) do
        if buttonData.Frame then
            buttonData.Frame:Destroy()
        end
    end
    self.EdgeButtons = {}
    if self.ScreenGui then
        self.ScreenGui:Destroy()
        self.ScreenGui = nil
    end
    for _, connection in pairs(self.Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    self.Connections = {}
    for _, tab in pairs(self.Tabs) do
        if tab.Destroy then
            tab:Destroy()
        end
    end
    self.Tabs = {}
    setmetatable(self, nil)
end

---
-- NOVO: Sistema de rolagem de título (otimizado para não criar tweens desnecessários)
---
function Tekscripts:SetupTitleScroll()
    local title = self.Title
    local parent = title.Parent
    if not title or not parent then return end

    local isScrolling = false

    local function checkAndScroll()
        local textWidth = title.TextBounds.X
        local parentWidth = parent.AbsoluteSize.X
        if textWidth <= parentWidth then
            if isScrolling then
                if self.TitleScrollTween then
                    self.TitleScrollTween:Cancel()
                    self.TitleScrollTween = nil
                end
                title.Position = UDim2.new(0, 0, 0, 0)
                isScrolling = false
            end
            return
        end

        if not isScrolling then
            isScrolling = true
            local scrollDistance = textWidth - parentWidth + 5
            local scrollTime = scrollDistance / 50

            local tweenInfo = TweenInfo.new(
                scrollTime,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.InOut,
                -1,
                false,
                0
            )

            self.TitleScrollTween = TweenService:Create(title, tweenInfo, { Position = UDim2.new(0, -scrollDistance, 0, 0) })
            self.TitleScrollTween:Play()
        end
    end

    self.TitleScrollConnection = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(checkAndScroll)
    title:GetPropertyChangedSignal("TextBounds"):Connect(checkAndScroll)

    -- Verificação inicial
    checkAndScroll()
end

---
-- Sistema de Arrastar (otimizado: atualização direta, sem tweens por input)
---
function Tekscripts:SetupDragSystem()
    self.Connections.DragBegin = self.TitleBar.InputBegan:Connect(function(input)
        if self.Blocked or self.MinimizedState then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.IsDragging = true
            self._dragStart = input.Position
            self._startPos = self.Window.Position
            self._lastMousePos = UserInputService:GetMouseLocation()
        end
    end)

    self.Connections.DragChanged = UserInputService.InputChanged:Connect(function(input)
        if not self.IsDragging or self.Blocked or self.MinimizedState then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local currentPos = UserInputService:GetMouseLocation()
            local delta = currentPos - self._dragStart
            self.Window.Position = UDim2.new(
                self._startPos.X.Scale, self._startPos.X.Offset + delta.X,
                self._startPos.Y.Scale, self._startPos.Y.Offset + delta.Y
            )
            self._lastMousePos = currentPos
        end
    end)

    self.Connections.DragEnded = UserInputService.InputEnded:Connect(function(input)
        if not self.IsDragging then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.IsDragging = false
            if not self.MinimizedState then
                self:CheckEdgeProximity()
            end
        end
    end)
end

---
-- Verifica proximidade das bordas da tela (otimizado com cache)
---
function Tekscripts:CheckEdgeProximity()
    local screen = workspace.CurrentCamera.ViewportSize
    local windowPos = self.Window.AbsolutePosition
    local windowSize = self.Window.AbsoluteSize
    local threshold = DESIGN.EdgeThreshold

    local edges = {
        left = windowPos.X <= threshold,
        right = windowPos.X + windowSize.X >= screen.X - threshold,
        top = windowPos.Y <= threshold,
        bottom = windowPos.Y + windowSize.Y >= screen.Y - threshold
    }

    local delta = (windowPos - (self.LastWindowPosition or windowPos)).Magnitude
    self.LastWindowPosition = windowPos

    local minDragSpeed = 150

    if delta >= minDragSpeed then
        if edges.left then
            self:MinimizeToEdge("left")
        elseif edges.right then
            self:MinimizeToEdge("right")
        elseif edges.top then
            self:MinimizeToEdge("top")
        elseif edges.bottom then
            self:MinimizeToEdge("bottom")
        end
    end
end

---
-- Cria os botões nas bordas da tela (criados sob demanda)
---
function Tekscripts:CreateEdgeButtons()
    local edges = {"left", "right", "top", "bottom"}
    local arrowChars = {
        left = "→",
        right = "←",
        top = "↓",
        bottom = "↑"
    }

    for _, edge in ipairs(edges) do
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Size = UDim2.new(0, DESIGN.EdgeButtonSize, 0, DESIGN.EdgeButtonSize)
        buttonFrame.BackgroundTransparency = 1
        buttonFrame.Visible = false
        buttonFrame.Parent = self.ScreenGui

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundColor3 = DESIGN.ComponentBackground
        button.Text = ""
        button.BorderSizePixel = 0
        button.Parent = buttonFrame

        addRoundedCorners(button, DESIGN.EdgeButtonCornerRadius)
        addHoverEffect(button, DESIGN.ComponentBackground, DESIGN.ComponentHoverColor)

        local arrow = Instance.new("TextLabel")
        arrow.Size = UDim2.new(0.7, 0, 0.7, 0)
        arrow.Position = UDim2.new(0.15, 0, 0.15, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = arrowChars[edge]
        arrow.TextColor3 = DESIGN.ComponentTextColor
        arrow.Font = Enum.Font.Roboto
        arrow.TextScaled = true
        arrow.Parent = button

        self.EdgeButtons[edge] = {
            Frame = buttonFrame,
            Button = button,
            Arrow = arrow
        }

        self:UpdateEdgeButtonPosition(edge)
        self:SetupEdgeButtonDragSystem(edge)
    end
end

---
-- Atualiza a posição do botão de borda
---
function Tekscripts:UpdateEdgeButtonPosition(edge: string)
    local button = self.EdgeButtons[edge]
    if not button then return end
    
    local size = DESIGN.EdgeButtonSize
    
    local pos
    if edge == "left" then
        pos = UDim2.new(0, -size, 0.5, -size/2)
    elseif edge == "right" then
        pos = UDim2.new(1, 0, 0.5, -size/2)
    elseif edge == "top" then
        pos = UDim2.new(0.5, -size/2, 0, -size)
    elseif edge == "bottom" then
        pos = UDim2.new(0.5, -size/2, 1, 0)
    end
    
    button.Frame.Position = pos
end

---
-- Sistema de arrastar para os botões de borda (otimizado)
---
function Tekscripts:SetupEdgeButtonDragSystem(edge: string)
    local buttonData = self.EdgeButtons[edge]
    if not buttonData then return end

    local size = DESIGN.EdgeButtonSize
    local dragThreshold = 20
    local dragging = false
    local dragStart, startPos

    local function clampPosition(x, y, screen)
        if edge == "left" then
            x = math.clamp(x, -size, screen.X / 2)
            y = math.clamp(y, 0, screen.Y - size)
        elseif edge == "right" then
            x = math.clamp(x, screen.X / 2, screen.X)
        elseif edge == "top" then
            x = math.clamp(x, 0, screen.X - size)
            y = math.clamp(y, -size, screen.Y / 2)
        elseif edge == "bottom" then
            x = math.clamp(x, 0, screen.X - size)
            y = math.clamp(y, screen.Y / 2, screen.Y)
        end
        return x, y
    end

    local function onInputBegan(input)
        if self.Blocked or self.MinimizedState ~= edge then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = buttonData.Frame.Position
        end
    end

    local function onInputChanged(input)
        if not dragging or self.Blocked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            local screen = workspace.CurrentCamera.ViewportSize
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y
            newX, newY = clampPosition(newX, newY, screen)

            buttonData.Frame.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)

            if math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold then
                self:ExpandFromEdge(edge)
            end
        end
    end

    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if self.MinimizedState == edge then
                self:ExpandFromEdge(edge)
            end
        end
    end

    local button = buttonData.Button
    self.Connections["EdgeBegin_" .. edge] = button.InputBegan:Connect(onInputBegan)
    self.Connections["EdgeChanged_" .. edge] = button.InputChanged:Connect(onInputChanged)
    self.Connections["EdgeEnded_" .. edge] = button.InputEnded:Connect(onInputEnded)
end

---
-- Minimiza para a borda especificada
---
function Tekscripts:MinimizeToEdge(edge: string)
    if self.MinimizedState or self.Blocked then return end
    
    self.LastWindowPosition = self.Window.Position
    self.LastWindowSize = self.Window.Size
    
    self.Window.Visible = false
    self.MinimizedState = edge
    
    local button = self.EdgeButtons[edge]
    if button then
        button.Frame.Visible = true
        local tween = TweenService:Create(
            button.Frame,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Position = self:GetEdgeButtonTargetPosition(edge) }
        )
        tween:Play()
    end
end

---
-- Obtém posição alvo para o botão de borda
---
function Tekscripts:GetEdgeButtonTargetPosition(edge: string): UDim2
    local screen = workspace.CurrentCamera.ViewportSize
    local size = DESIGN.EdgeButtonSize
    local padding = DESIGN.EdgeButtonPadding
    
    if edge == "left" then
        return UDim2.new(0, padding, 0.5, -size/2)
    elseif edge == "right" then
        return UDim2.new(1, -size - padding, 0.5, -size/2)
    elseif edge == "top" then
        return UDim2.new(0.5, -size/2, 0, padding)
    elseif edge == "bottom" then
        return UDim2.new(0.5, -size/2, 1, -size - padding)
    end
    
    return UDim2.new(0.5, -size/2, 0.5, -size/2)
end

---
-- Expande a partir da borda
---
function Tekscripts:ExpandFromEdge(edge: string)
    if self.MinimizedState ~= edge or self.Blocked then return end
    
    local button = self.EdgeButtons[edge]
    if button then
        button.Frame.Visible = false
    end
    
    self.Window.Visible = true
    self.MinimizedState = nil
    
    local screenSize = workspace.CurrentCamera.ViewportSize
    local windowW = math.min(DESIGN.WindowSize.X.Offset, screenSize.X * 0.8)
    local windowH = math.min(DESIGN.WindowSize.Y.Offset, screenSize.Y * 0.8)
    
    local newPos = UDim2.new(
        0.5, -windowW/2,
        0.5, -windowH/2
    )
    
    local tween = TweenService:Create(
        self.Window,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Position = newPos,
            Size = UDim2.new(0, windowW, 0, windowH)
        }
    )
    tween:Play()
end

---
-- Sistema de Redimensionamento (atualização direta)
---
function Tekscripts:SetupResizeSystem()
    self.ResizeHandle = Instance.new("Frame")
    self.ResizeHandle.Size = UDim2.new(0, DESIGN.ResizeHandleSize, 0, DESIGN.ResizeHandleSize)
    self.ResizeHandle.Position = UDim2.new(1, -DESIGN.ResizeHandleSize, 1, -DESIGN.ResizeHandleSize)
    self.ResizeHandle.BackgroundColor3 = DESIGN.ResizeHandleColor
    self.ResizeHandle.BorderSizePixel = 0
    self.ResizeHandle.Parent = self.Window
    addRoundedCorners(self.ResizeHandle, 4)

    local resizeIcon = Instance.new("TextLabel")
    resizeIcon.Size = UDim2.new(1, 0, 1, 0)
    resizeIcon.BackgroundTransparency = 1
    resizeIcon.Text = "↘"
    resizeIcon.TextColor3 = DESIGN.ComponentTextColor
    resizeIcon.TextScaled = true
    resizeIcon.Font = Enum.Font.Roboto
    resizeIcon.Parent = self.ResizeHandle

    self.Connections.ResizeBegin = self.ResizeHandle.InputBegan:Connect(function(input)
        if self.Blocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.IsResizing = true
            self._resizeStart = input.Position
            self._startSize = self.Window.Size
        end
    end)

    self.Connections.ResizeChanged = UserInputService.InputChanged:Connect(function(input)
        if not self.IsResizing or self.Blocked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - self._resizeStart
            local screen = workspace.CurrentCamera.ViewportSize
            local maxW = math.min(DESIGN.MaxWindowSize.X, screen.X * 0.9)
            local maxH = math.min(DESIGN.MaxWindowSize.Y, screen.Y * 0.9)
            
            local newWidth = math.clamp(self._startSize.X.Offset + delta.X, DESIGN.MinWindowSize.X, maxW)
            local newHeight = math.clamp(self._startSize.Y.Offset + delta.Y, DESIGN.MinWindowSize.Y, maxH)

            self.Window.Size = UDim2.new(0, newWidth, 0, newHeight)
            self:UpdateContainersSize()
        end
    end)

    self.Connections.ResizeEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.IsResizing = false
        end
    end)
end

function Tekscripts:UpdateContainersSize()
    local tabContainerSize = self:_GetTabContainerSize()
    local contentContainerSize = self:_GetContentContainerSize()

    if self.TabContainer then
        self.TabContainer.Size = tabContainerSize
        self.TabContainer.Position = UDim2.new(0, 0, 0, DESIGN.TitleHeight)
    end

    if self.TabContentContainer then
        self.TabContentContainer.Position = UDim2.new(tabContainerSize.X.Scale, tabContainerSize.X.Offset, 0, DESIGN.TitleHeight)
        self.TabContentContainer.Size = contentContainerSize
    end

    if self.ResizeHandle then
        self.ResizeHandle.Position = UDim2.new(1, -DESIGN.ResizeHandleSize, 1, -DESIGN.ResizeHandleSize)
    end
end

---
-- Float Button (otimizado)
---
function Tekscripts:SetupFloatButton(text: string)
    local float = Instance.new("Frame")
    float.Name = "FloatButton"
    float.Size = DESIGN.FloatButtonSize
    float.Position = UDim2.new(1, -130, 0, 20)
    float.BackgroundColor3 = DESIGN.FloatButtonColor
    float.BorderSizePixel = 0
    float.Visible = false
    float.Parent = self.ScreenGui
    self.FloatButton = float

    addRoundedCorners(float, DESIGN.CornerRadius)

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new(DESIGN.FloatButtonColor, DESIGN.WindowColor2)
    grad.Rotation = 45
    grad.Parent = float

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = DESIGN.ComponentTextColor
    btn.Font = Enum.Font.Roboto
    btn.TextScaled = true
    btn.Parent = float

    addHoverEffect(btn, nil, DESIGN.ComponentHoverColor)

    self.Connections.FloatExpand = btn.MouseButton1Click:Connect(function()
        if not self.Blocked then
            self:ExpandFromFloat()
        end
    end)

    local dragging = false
    local dragStart, startPos

    self.Connections.FloatBegin = btn.InputBegan:Connect(function(input)
        if self.Blocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = UserInputService:GetMouseLocation()
            startPos = float.Position
        end
    end)

    self.Connections.FloatChange = UserInputService.InputChanged:Connect(function(input)
        if not dragging or self.Blocked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = UserInputService:GetMouseLocation() - dragStart
            float.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    self.Connections.FloatEnd = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

---
-- Lógica de Abas (com lazy visibility para performance)
---
function Tekscripts:CreateTab(options: { Title: string })
    local title = assert(options.Title, "CreateTab: argumento 'Title' inválido")
    assert(type(title) == "string", "CreateTab: argumento 'Title' deve ser string")

    local tab = Tab.new(title, self.TabContentContainer) -- Assumindo Tab.new definido em outro lugar
    tab._connections = {}
    self.Tabs[title] = tab
    tab._parentRef = self

    local button = Instance.new("TextButton")
    button.Name = title
    button.Text = title
    button.Size = UDim2.new(1, 0, 0, DESIGN.TabButtonHeight)
    button.BackgroundColor3 = DESIGN.TabInactiveColor
    button.TextColor3 = DESIGN.ComponentTextColor
    button.Font = Enum.Font.Roboto
    button.TextScaled = true
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.ZIndex = 3
    button.Parent = self.TabContainer
    tab.Button = button

    addRoundedCorners(button, DESIGN.CornerRadius)
    addHoverEffect(button, DESIGN.TabInactiveColor, DESIGN.ComponentHoverColor, function()
        return self.CurrentTab ~= tab
    end)

    table.insert(tab._connections, button.MouseButton1Click:Connect(function()
        if not self.Blocked then
            self:SetActiveTab(tab)
        end
    end))

    tab.Container.Visible = false

    if (self.startTab == title) or not self.CurrentTab then
        self:SetActiveTab(tab)
    end
    self.NoTabsLabel.Visible = #self.Tabs == 0

    function tab:Destroy()
        if self._destroyed then return end
        self._destroyed = true
        local parent = self._parentRef
        self._parentRef = nil

        for _, c in ipairs(self._connections) do
            if c.Connected then c:Disconnect() end
        end
        self._connections = {}

        for _, comp in pairs(self.Components or {}) do
            if typeof(comp) == "table" and comp.Destroy then
                comp:Destroy()
            end
        end
        self.Components = nil

        if self.Container then self.Container:Destroy() end
        if self.Button then self.Button:Destroy() end

        if parent and parent.Tabs then
            parent.Tabs[title] = nil
            if parent.CurrentTab == self then
                local nextTab = next(parent.Tabs)
                parent.CurrentTab = nextTab and parent.Tabs[nextTab] or nil
                parent.NoTabsLabel.Visible = not nextTab
                if nextTab then
                    parent:SetActiveTab(parent.Tabs[nextTab])
                end
            end
        end

        table.clear(self)
    end

    table.insert(tab._connections, button.AncestryChanged:Connect(function(_, p)
        if not p and not tab._destroyed then
            tab:Destroy()
        end
    end))

    return tab
end

function Tekscripts:SetActiveTab(tab)
    if self.CurrentTab then
        self.CurrentTab.Container.Visible = false
        self.CurrentTab.Button.BackgroundColor3 = DESIGN.TabInactiveColor
    end

    self.CurrentTab = tab
    if tab then
        tab.Container.Visible = true
        tab.Button.BackgroundColor3 = DESIGN.TabActiveColor
    end
end

---
-- Funções de Estado (Minimizar/Expandir) otimizadas
---
function Tekscripts:Minimize()
    if self.Blocked or self.MinimizedState then return end

    self.MinimizedState = "float"
    self.LastWindowPosition = self.Window.Position
    self.LastWindowSize = self.Window.Size

    if self._activeTween then self._activeTween:Cancel() end

    local minimizeTween = TweenService:Create(self.Window, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    self._activeTween = minimizeTween

    minimizeTween.Completed:Connect(function()
        self.Window.Visible = false
        self.FloatButton.Visible = true
        local floatTween = TweenService:Create(self.FloatButton, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = DESIGN.FloatButtonSize
        })
        floatTween:Play()
        self._activeTween = nil
    end)

    minimizeTween:Play()
end

function Tekscripts:ExpandFromFloat()
    if self.MinimizedState ~= "float" or self.Blocked then return end

    local floatTween = TweenService:Create(self.FloatButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0)
    })
    floatTween:Play()

    floatTween.Completed:Connect(function()
        self.FloatButton.Visible = false
        self.Window.Visible = true

        local screenSize = workspace.CurrentCamera.ViewportSize
        local windowW = math.min(DESIGN.WindowSize.X.Offset, screenSize.X * 0.8)
        local windowH = math.min(DESIGN.WindowSize.Y.Offset, screenSize.Y * 0.8)
        
        local newPos = UDim2.new(0.5, -windowW/2, 0.5, -windowH/2)
        
        local expandTween = TweenService:Create(self.Window, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, windowW, 0, windowH),
            Position = newPos
        })
        expandTween:Play()
        
        self.MinimizedState = nil
    end)
end

function Tekscripts:Block(state: boolean)
    self.Blocked = state
    self.BlockScreen.Visible = state
    local targetSize = state and DESIGN.BlurEffectSize or 0
    TweenService:Create(self.BlurEffect, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
end
---
-- Funções Públicas para criar componentes
---
-- 🟩 API COPY

-- 🔹 Copiar texto universalmente
function Tekscripts:Copy(text: string)
	assert(type(text) == "string", "O texto precisa ser uma string")

	local success, msg = false, ""

	-- 1️⃣ Exploits comuns
	if typeof(setclipboard) == "function" then
		pcall(setclipboard, text)
		success, msg = true, "[Clipboard] Copiado com setclipboard."

	elseif typeof(toclipboard) == "function" then
		pcall(toclipboard, text)
		success, msg = true, "[Clipboard] Copiado com toclipboard."

	-- 2️⃣ Roblox Studio (plugin dev)
	elseif plugin and typeof(plugin.SetClipboard) == "function" then
		pcall(function()
			plugin:SetClipboard(text)
			success = true
			msg = "[Clipboard] Copiado com plugin:SetClipboard."
		end)

	-- 3️⃣ getgenv() fallback
	elseif rawget(getgenv and getgenv() or {}, "setclipboard") then
		pcall(getgenv().setclipboard, text)
		success, msg = true, "[Clipboard] Copiado via getgenv().setclipboard."

	else
		msg = "[Clipboard] Nenhuma API de cópia disponível neste ambiente."
	end

	if success then
		print(msg)
	else
		warn(msg .. " Texto: " .. text)
	end

	return success
end


-- 🔹 Copiar path de instância automaticamente
function Tekscripts:CopyInstancePath(instance: Instance)
	assert(typeof(instance) == "Instance", "O argumento precisa ser uma instância válida")
	local path = instance:GetFullName()
	return self:Copy(path)
end
-- 🟩 FIM API COPY

-- 🟩 API DIRECTORY
function Tekscripts:WriteFile(path: string, content: string)
	assert(type(path) == "string", "Caminho inválido")
	assert(type(content) == "string", "Conteúdo inválido")

	local writeFunc =
		writefile
		or (fluxus and fluxus.writefile)
		or (trigon and trigon.writeFile)
		or (codex and codex.writefile)
		or (syn and syn.write_file)
		or (KRNL and KRNL.WriteFile)

	if not writeFunc then
		warn("[FS] Executor não suporta escrita de arquivos")
		return false
	end

	local ok, err = pcall(writeFunc, path, content)
	if not ok then warn("[FS] Erro ao escrever arquivo:", err) end
	return ok
end

function Tekscripts:ReadFile(path: string)
	assert(type(path) == "string", "Caminho inválido")

	local readFunc =
		readfile
		or (fluxus and fluxus.readFile)
		or (trigon and trigon.readFile)
		or (codex and codex.readFile)
		or (syn and syn.read_file)
		or (KRNL and KRNL.ReadFile)

	local existsFunc =
		isfile
		or (fluxus and fluxus.isfile)
		or (trigon and trigon.isfile)
		or (codex and codex.isfile)
		or (syn and syn.file_exists)
		or (KRNL and KRNL.IsFile)
		or function() return false end

	if not readFunc or not existsFunc(path) then
		warn("[FS] Arquivo não existe ou leitura não suportada")
		return nil
	end

	local ok, result = pcall(readFunc, path)
	if ok then
		return result
	else
		warn("[FS] Erro ao ler arquivo:", result)
		return nil
	end
end

function Tekscripts:IsFile(path: string)
	assert(type(path) == "string", "Caminho inválido")

	local existsFunc =
		isfile
		or (fluxus and fluxus.isfile)
		or (trigon and trigon.isfile)
		or (codex and codex.isfile)
		or (syn and syn.file_exists)
		or (KRNL and KRNL.IsFile)
		or function() return false end

	return existsFunc(path)
end

-- 🟩 FIM API DIRECTORY

-- 🟩 API REQUEST
function Tekscripts:Request(options)
	assert(type(options) == "table", "As opções precisam ser uma tabela.")

	local HttpService = game:GetService("HttpService")

	-- 🔹 Funções de request suportadas
	local requestFunc =
		(syn and syn.request)
		or (fluxus and fluxus.request)
		or (http and http.request)
		or (krnl and krnl.request)
		or (getgenv().request)
		or request

	if not requestFunc then
		warn("[HTTP] Nenhuma função de request disponível neste executor.")
		return nil
	end

	-- 🔹 Conversão automática de Body para JSON
	if options.Body and type(options.Body) == "table" then
		options.Headers = options.Headers or {}
		if not options.Headers["Content-Type"] then
			options.Headers["Content-Type"] = "application/json"
		end

		local ok, encoded = pcall(HttpService.JSONEncode, HttpService, options.Body)
		if ok then
			options.Body = encoded
		else
			warn("[HTTP] Falha ao converter Body para JSON:", encoded)
			return nil
		end
	end

	-- 🔹 Executa a requisição
	local ok, response = pcall(requestFunc, options)
	if not ok then
		warn("[HTTP] Erro na requisição:", response)
		return nil
	end

	return response
end

-- 🟩 FIM DA API REQUEST


function Tekscripts:CreateFloatingButton(options: {
    BorderRadius: number?,
    Text: string?,
    Title: string?,
    Value: boolean?,
    Visible: boolean?,
    Drag: boolean?,
    Block: boolean?,
    Callback: ((boolean) -> ())?
})
    options = options or {}
    local width = 100 -- Largura fixa
    local height = 100 -- Altura fixa
    local borderRadius = tonumber(options.BorderRadius) or 8
    local text = tostring(options.Text or "Clique Aqui")
    local title = tostring(options.Title or "Cabeçote")
    local value = options.Value == nil and false or options.Value
    local visible = options.Visible == nil and false or options.Visible
    local drag = options.Drag == nil and true or options.Drag
    local block = options.Block == nil and false or options.Block
    local callback = options.Callback

    -- ScreenGui independente
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FloatingButtonGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    -- Container geral (box único)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, width, 0, height + 25)
    container.Position = UDim2.new(0.5, -width/2, 0.5, -(height + 25)/2)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Dark theme
    container.Visible = visible
    container.Parent = screenGui

    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, borderRadius)
    containerCorner.Parent = container

    -- Cabeçote
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 25)
    header.BackgroundTransparency = 1
    header.Text = title
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.TextSize = 16
    header.Font = Enum.Font.GothamBold
    header.Parent = container

    -- Linha divisória opcional
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.Position = UDim2.new(0, 0, 0, 25)
    divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    divider.BorderSizePixel = 0
    divider.Parent = container

    -- Botão principal
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, -25)
    button.Position = UDim2.new(0, 0, 0, 25)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = not block
    button.TextScaled = true -- Adaptação de texto
    button.TextWrapped = true -- Adaptação de texto
    button.Parent = container

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, borderRadius)
    buttonCorner.Parent = button

    -- Estado interno drag
    local dragging = false
    local dragInput, dragStart, startPos
    local UIS = game:GetService("UserInputService")

    -- Atualizar visuais
    local function updateVisuals()
        container.Size = UDim2.new(0, width, 0, height + 25)
        header.Text = title
        button.Text = text
        container.Visible = visible
        button.AutoButtonColor = not block
        containerCorner.CornerRadius = UDim.new(0, borderRadius)
        buttonCorner.CornerRadius = UDim.new(0, borderRadius)
    end

    -- Toggle no clique
    button.MouseButton1Click:Connect(function()
        if block then return end
        value = not value
        if callback then
            task.spawn(callback, value)
        end
    end)

    -- Drag pelo cabeçote (com delta e lock no input inicial)
    if drag then
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = container.Position
                dragInput = input
            end
        end)

        header.InputChanged:Connect(function(input)
            if input == dragInput then
                dragInput = input
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                container.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)

        header.InputEnded:Connect(function(input)
            if input == dragInput then
                dragging = false
                dragInput = nil
            end
        end)
    end

    -- API pública
    local publicApi = {
        _instance = container,
        State = function()
            return {
                BorderRadius = borderRadius,
                Text = text,
                Title = title,
                Value = value,
                Visible = visible,
                Drag = drag,
                Block = block
            }
        end,
        Update = function(newOptions)
            if newOptions then
                borderRadius = tonumber(newOptions.BorderRadius) or borderRadius
                text = tostring(newOptions.Text or text)
                title = tostring(newOptions.Title or title)
                value = newOptions.Value == nil and value or newOptions.Value
                visible = newOptions.Visible == nil and visible or newOptions.Visible
                drag = newOptions.Drag == nil and drag or newOptions.Drag
                block = newOptions.Block == nil and block or newOptions.Block
                callback = newOptions.Callback or callback
                updateVisuals()
            end
        end,
        Destroy = function()
            if screenGui then
                screenGui:Destroy()
                screenGui = nil
            end
        end
    }

    updateVisuals()
    return publicApi
end


function Tekscripts:CreateLabel(tab, options)
    assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateLabel")
    assert(type(options) == "table" and type(options.Title) == "string", "Invalid arguments for CreateLabel")

    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    -- Valores padrão
    local defaultOptions = {
        Title = options.Title,
        Desc = options.Desc,
        Icon = options.Icon,
        TitleColor = DESIGN.ComponentTextColor,
        DescColor = Color3.fromRGB(200, 200, 200),
        Align = Enum.TextXAlignment.Left,
        Highlight = false
    }

    -- Box principal (com sombra sutil)
    local outerBox = Instance.new("Frame")
    outerBox.Size = UDim2.new(1, 0, 0, 0)
    outerBox.BackgroundColor3 = DESIGN.ComponentBackground
    outerBox.BorderSizePixel = 0
    outerBox.ClipsDescendants = true
    outerBox.Parent = tab.Container
    addRoundedCorners(outerBox, DESIGN.CornerRadius)

    -- Sombra sutil (opcional, mas elegante)
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.Position = UDim2.new(0, 0, 0, 2)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.92
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    addRoundedCorners(shadow, DESIGN.CornerRadius)
    shadow.Parent = outerBox

    -- Container interno
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -DESIGN.ComponentPadding * 2, 1, -DESIGN.ComponentPadding * 2)
    container.Position = UDim2.new(0, DESIGN.ComponentPadding, 0, DESIGN.ComponentPadding)
    container.BackgroundTransparency = 1
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Parent = outerBox

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.HorizontalAlignment = defaultOptions.Align == Enum.TextXAlignment.Center and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Left
    listLayout.Parent = container

    -- Ícone (opcional)
    local iconLabel
    if defaultOptions.Icon then
        local iconContainer = Instance.new("Frame")
        iconContainer.Size = UDim2.new(0, 24, 0, 24)
        iconContainer.BackgroundTransparency = 1
        iconContainer.Parent = container

        iconLabel = Instance.new("ImageLabel")
        iconLabel.Image = defaultOptions.Icon
        iconLabel.Size = UDim2.new(1, 0, 1, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Parent = iconContainer
    end

    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = defaultOptions.Title
    titleLabel.Size = UDim2.new(1, 0, 0, 26)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = defaultOptions.TitleColor
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = defaultOptions.Align
    titleLabel.TextWrapped = true
    titleLabel.Parent = container

    -- Linha de destaque (opcional)
    local highlightLine
    if defaultOptions.Highlight then
        highlightLine = Instance.new("Frame")
        highlightLine.Size = UDim2.new(0, 40, 0, 2)
        highlightLine.BackgroundColor3 = DESIGN.AccentColor or Color3.fromRGB(100, 180, 255)
        highlightLine.Position = UDim2.new(0, 0, 1, 4)
        highlightLine.Parent = titleLabel
        addRoundedCorners(highlightLine, 1)
    end

    -- Descrição
    local descLabel
    if defaultOptions.Desc then
        descLabel = Instance.new("TextLabel")
        descLabel.Text = defaultOptions.Desc
        descLabel.Size = UDim2.new(1, 0, 0, 0)
        descLabel.AutomaticSize = Enum.AutomaticSize.Y
        descLabel.BackgroundTransparency = 1
        descLabel.TextColor3 = defaultOptions.DescColor
        descLabel.Font = Enum.Font.GothamMedium
        descLabel.TextSize = 15
        descLabel.TextXAlignment = defaultOptions.Align
        descLabel.TextWrapped = true
        descLabel.LineHeight = 1.15
        descLabel.Parent = container
    end

    -- Ajuste automático de altura
    local layoutConnection = listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local totalHeight = listLayout.AbsoluteContentSize.Y + DESIGN.ComponentPadding * 2
        outerBox.Size = UDim2.new(1, 0, 0, totalHeight)
        if shadow then
            shadow.Size = UDim2.new(1, 0, 0, totalHeight)
        end
    end)

    -- API pública
    local publicApi = {
        _instance = outerBox,
        _connections = { layoutConnection },
        _titleLabel = titleLabel,
        _descLabel = descLabel,
        _iconLabel = iconLabel
    }

    -- Atualiza título com transição suave
    function publicApi.SetTitle(newTitle, color)
        if not newTitle then return end
        titleLabel.Text = newTitle
        if color then
            TweenService:Create(titleLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { TextColor3 = color }):Play()
        end
    end

    -- Atualiza descrição
    function publicApi.SetDesc(newDesc, color)
        if newDesc == nil then
            if descLabel then
                descLabel:Destroy()
                descLabel = nil
            end
            return
        end

        if not descLabel then
            descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(1, 0, 0, 0)
            descLabel.AutomaticSize = Enum.AutomaticSize.Y
            descLabel.BackgroundTransparency = 1
            descLabel.Font = Enum.Font.GothamMedium
            descLabel.TextSize = 15
            descLabel.TextXAlignment = defaultOptions.Align
            descLabel.TextWrapped = true
            descLabel.LineHeight = 1.15
            descLabel.Parent = container
        end

        descLabel.Text = newDesc
        if color then
            descLabel.TextColor3 = color
        end
    end

    -- Atualiza ícone
    function publicApi.SetIcon(iconAsset)
        if iconAsset then
            if not iconLabel then
                local iconContainer = Instance.new("Frame")
                iconContainer.Size = UDim2.new(0, 24, 0, 24)
                iconContainer.BackgroundTransparency = 1
                iconContainer.Parent = container

                -- Mantém o ícone no topo
                table.insert(publicApi._connections, listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    iconContainer.LayoutOrder = -1
                end))

                iconLabel = Instance.new("ImageLabel")
                iconLabel.Image = iconAsset
                iconLabel.Size = UDim2.new(1, 0, 1, 0)
                iconLabel.BackgroundTransparency = 1
                iconLabel.Parent = iconContainer
                publicApi._iconLabel = iconLabel
            else
                iconLabel.Image = iconAsset
            end
        else
            if iconLabel and iconLabel.Parent then
                iconLabel.Parent:Destroy()
                iconLabel = nil
                publicApi._iconLabel = nil
            end
        end
    end

    -- Atualiza alinhamento
    function publicApi.SetAlignment(align)
        if not align then return end
        titleLabel.TextXAlignment = align
        if descLabel then
            descLabel.TextXAlignment = align
        end
        listLayout.HorizontalAlignment = align == Enum.TextXAlignment.Center and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Left
    end

    -- Atualização em lote (compatível com antigo)
    function publicApi.Update(newOptions)
        if newOptions.Title ~= nil then
            publicApi.SetTitle(newOptions.Title, newOptions.TitleColor)
        end
        if newOptions.Desc ~= nil then
            publicApi.SetDesc(newOptions.Desc, newOptions.DescColor)
        end
        if newOptions.Icon ~= nil then
            publicApi.SetIcon(newOptions.Icon)
        end
        if newOptions.Align then
            publicApi.SetAlignment(newOptions.Align)
        end
    end

    -- Destruição segura
    function publicApi.Destroy()
        if publicApi._instance then
            for _, conn in pairs(publicApi._connections) do
                if conn and conn.Connected then
                    conn:Disconnect()
                end
            end
            publicApi._instance:Destroy()
            publicApi._instance = nil
            publicApi._connections = nil
        end
        table.clear(publicApi)
    end

    table.insert(tab.Components, publicApi)
    return publicApi
end

function Tekscripts:CreateSlider(tab: any, options: { 
    Text: string?, 
    Min: number?, 
    Max: number?, 
    Step: number?, 
    Value: number?, 
    Callback: ((number) -> ())? 
})
    assert(tab and tab.Container, "Invalid Tab object provided to CreateSlider")

    options = options or {}
    local title = options.Text or "Slider"
    local minv = tonumber(options.Min) or 0
    local maxv = tonumber(options.Max) or 100
    local step = tonumber(options.Step) or 1
    local value = tonumber(options.Value) or minv
    local callback = options.Callback

    local function clamp(n)
        return math.max(minv, math.min(maxv, n))
    end

    local function roundToStep(n)
        if step <= 0 then return n end
        return math.floor(n / step + 0.5) * step
    end

    value = clamp(roundToStep(value))

    -- Serviços
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    
    -- Configurações de animação
    local ANIM = {
        ThumbHover = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        ThumbPress = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        ValueChange = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        FillChange = TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
    }

    -- Base visual com sombra sutil
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight)
    box.BackgroundColor3 = DESIGN.ComponentBackground
    box.BorderSizePixel = 0
    box.Parent = tab.Container

    Instance.new("UICorner", box).CornerRadius = UDim.new(0, DESIGN.CornerRadius)
    
    -- Sombra sutil para profundidade
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.92
    shadow.ZIndex = 0
    shadow.Parent = box
    
    local padding = Instance.new("UIPadding", box)
    padding.PaddingLeft = UDim.new(0, DESIGN.ComponentPadding)
    padding.PaddingRight = UDim.new(0, DESIGN.ComponentPadding)

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = box

    local listLayout = Instance.new("UIListLayout", container)
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Padding = UDim.new(0, 6)

    -- Header com melhor espaçamento
    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 20)
    headerFrame.BackgroundTransparency = 1
    headerFrame.Parent = container

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -70, 1, 0)
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = DESIGN.ComponentTextColor
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title
    titleLabel.Parent = headerFrame

    -- Badge para o valor com fundo
    local valueBadge = Instance.new("Frame")
    valueBadge.Size = UDim2.new(0, 65, 0, 22)
    valueBadge.AnchorPoint = Vector2.new(1, 0)
    valueBadge.Position = UDim2.new(1, 0, 0, -1)
    valueBadge.BackgroundColor3 = DESIGN.SliderFillColor or Color3.fromRGB(88, 101, 242)
    valueBadge.BorderSizePixel = 0
    valueBadge.Parent = headerFrame
    Instance.new("UICorner", valueBadge).CornerRadius = UDim.new(0, 6)

    local valueLabel = Instance.new("TextBox")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(1, -8, 1, 0)
    valueLabel.Position = UDim2.new(0, 4, 0, 0)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextColor3 = Color3.new(1, 1, 1)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Center
    valueLabel.Text = tostring(value)
    valueLabel.ClearTextOnFocus = false
    valueLabel.TextEditable = true
    valueLabel.Parent = valueBadge

    -- Track com altura maior e melhor aparência
    local trackContainer = Instance.new("Frame")
    trackContainer.Size = UDim2.new(1, 0, 0, 12)
    trackContainer.BackgroundTransparency = 1
    trackContainer.Parent = container

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 6)
    track.AnchorPoint = Vector2.new(0, 0.5)
    track.Position = UDim2.new(0, 0, 0.5, 0)
    track.BackgroundColor3 = DESIGN.SliderTrackColor or Color3.fromRGB(40, 40, 45)
    track.BorderSizePixel = 0
    track.Parent = trackContainer
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    -- Fill com gradiente sutil
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((value - minv) / math.max(1, (maxv - minv)), 0, 1, 0)
    fill.BackgroundColor3 = DESIGN.SliderFillColor or Color3.fromRGB(88, 101, 242)
    fill.BorderSizePixel = 0
    fill.ZIndex = 2
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    -- Gradiente no fill para dar profundidade
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0.9, 0.9, 0.95))
    }
    gradient.Rotation = 90
    gradient.Parent = fill

    -- Thumb moderno com sombra
    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 20, 0, 20)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0)
    thumb.BackgroundColor3 = Color3.new(1, 1, 1)
    thumb.BorderSizePixel = 0
    thumb.ZIndex = 3
    thumb.Parent = trackContainer
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

    -- Anel interno do thumb para destaque
    local thumbRing = Instance.new("Frame")
    thumbRing.Size = UDim2.new(0.5, 0, 0.5, 0)
    thumbRing.AnchorPoint = Vector2.new(0.5, 0.5)
    thumbRing.Position = UDim2.new(0.5, 0, 0.5, 0)
    thumbRing.BackgroundColor3 = DESIGN.SliderFillColor or Color3.fromRGB(88, 101, 242)
    thumbRing.BorderSizePixel = 0
    thumbRing.ZIndex = 4
    thumbRing.Parent = thumb
    Instance.new("UICorner", thumbRing).CornerRadius = UDim.new(1, 0)

    -- Lógica
    local connections = {}
    local dragging = false
    local hovering = false

    local publicApi = {
        _instance = nil,
        _connections = nil,
        _onChanged = {},
        _locked = false,
    }

    local function updateVisuals(animate)
        local denom = math.max(1, (maxv - minv))
        local frac = (value - minv) / denom
        frac = math.clamp(frac, 0, 1)
        
        if animate then
            TweenService:Create(fill, ANIM.FillChange, {
                Size = UDim2.new(frac, 0, 1, 0)
            }):Play()
            TweenService:Create(thumb, ANIM.FillChange, {
                Position = UDim2.new(frac, 0, 0.5, 0)
            }):Play()
        else
            fill.Size = UDim2.new(frac, 0, 1, 0)
            thumb.Position = UDim2.new(frac, 0, 0.5, 0)
        end
        
        -- Animação do valor com bounce
        local formattedValue = tostring(math.floor((value or 0) * 100) / 100)
        valueLabel.Text = formattedValue
        
        if animate then
            valueBadge.Size = UDim2.new(0, 70, 0, 22)
            TweenService:Create(valueBadge, ANIM.ValueChange, {
                Size = UDim2.new(0, 65, 0, 22)
            }):Play()
        end
    end

    local function safeCall(fn, ...)
        if type(fn) == "function" then
            pcall(fn, ...)
        end
    end

    local function handleDrag(inputPos)
        local absPos = track.AbsolutePosition or Vector2.new(0, 0)
        local absSize = track.AbsoluteSize or Vector2.new(1, 1)
        local absSizeX = math.max(1, absSize.X)
        local relativeX = math.clamp(inputPos.X - absPos.X, 0, absSizeX)
        local newFrac = relativeX / absSizeX
        newFrac = math.clamp(newFrac, 0, 1)
        local newVal = clamp(roundToStep(minv + newFrac * (maxv - minv)))
        
        if newVal ~= value then
            value = newVal
            updateVisuals(false)
            safeCall(callback, value)
            for _, fn in ipairs(publicApi._onChanged) do
                safeCall(fn, value)
            end
        end
    end

    local function handleInputBegan(input)
        if publicApi._locked then return end
        if input and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            -- Animação de pressão
            TweenService:Create(thumb, ANIM.ThumbPress, {
                Size = UDim2.new(0, 24, 0, 24)
            }):Play()
            
            pcall(function() handleDrag(input.Position) end)
        end
    end

    local function handleInputChanged(input)
        if dragging and input and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            pcall(function() handleDrag(input.Position) end)
        end
    end

    local function handleInputEnded(input)
        if input and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            -- Animação de soltura
            local targetSize = hovering and UDim2.new(0, 22, 0, 22) or UDim2.new(0, 20, 0, 20)
            TweenService:Create(thumb, ANIM.ThumbHover, {
                Size = targetSize
            }):Play()
        end
    end

    -- Efeito hover no thumb
    table.insert(connections, thumb.MouseEnter:Connect(function()
        if publicApi._locked then return end
        hovering = true
        if not dragging then
            TweenService:Create(thumb, ANIM.ThumbHover, {
                Size = UDim2.new(0, 22, 0, 22)
            }):Play()
        end
    end))

    table.insert(connections, thumb.MouseLeave:Connect(function()
        hovering = false
        if not dragging then
            TweenService:Create(thumb, ANIM.ThumbHover, {
                Size = UDim2.new(0, 20, 0, 20)
            }):Play()
        end
    end))

    table.insert(connections, track.InputBegan:Connect(handleInputBegan))
    table.insert(connections, UIS.InputChanged:Connect(handleInputChanged))
    table.insert(connections, UIS.InputEnded:Connect(handleInputEnded))

    -- Input filter for numbers only
    table.insert(connections, valueLabel:GetPropertyChangedSignal("Text"):Connect(function()
        local text = valueLabel.Text
        local filtered = text:gsub("[^%d%.%-]", "")
        if filtered ~= text then
            valueLabel.Text = filtered
        end
    end))

    -- Update on focus lost
    table.insert(connections, valueLabel.FocusLost:Connect(function()
        if publicApi._locked then
            valueLabel.Text = tostring(math.floor((value or 0) * 100) / 100)
            return
        end
        local newVal = tonumber(valueLabel.Text)
        if newVal then
            newVal = clamp(roundToStep(newVal))
            value = newVal
            updateVisuals(true)
            safeCall(callback, value)
            for _, fn in ipairs(publicApi._onChanged) do
                safeCall(fn, value)
            end
        else
            valueLabel.Text = tostring(math.floor((value or 0) * 100) / 100)
        end
    end))

    publicApi._instance = box
    publicApi._connections = connections

    -- API pública
    function publicApi.Set(v)
        value = clamp(roundToStep(tonumber(v) or value))
        updateVisuals(true)
        safeCall(callback, value)
        for _, fn in ipairs(publicApi._onChanged) do
            safeCall(fn, value)
        end
    end

    function publicApi.Get()
        return value
    end

    function publicApi.GetPercent()
        if maxv == minv then return 0 end
        return (value - minv) / (maxv - minv)
    end

    function publicApi.SetRange(min, max, s)
        minv = tonumber(min) or minv
        maxv = tonumber(max) or maxv
        if s ~= nil then step = tonumber(s) or step end
        value = clamp(roundToStep(value))
        updateVisuals(true)
    end

    function publicApi.AnimateTo(targetValue, duration)
        local newVal = clamp(roundToStep(tonumber(targetValue) or value))
        local denom = math.max(1, (maxv - minv))
        local frac = (newVal - minv) / denom
        frac = math.clamp(frac, 0, 1)
        local dur = tonumber(duration) or 0.3
        
        pcall(function()
            TweenService:Create(fill, TweenInfo.new(dur, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Size = UDim2.new(frac, 0, 1, 0)
            }):Play()
            TweenService:Create(thumb, TweenInfo.new(dur, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Position = UDim2.new(frac, 0, 0.5, 0)
            }):Play()
        end)
        
        value = newVal
        valueLabel.Text = tostring(math.floor(value * 100) / 100)
        safeCall(callback, value)
        for _, fn in ipairs(publicApi._onChanged) do
            safeCall(fn, value)
        end
    end

    function publicApi.OnChanged(fn)
        if type(fn) == "function" then
            table.insert(publicApi._onChanged, fn)
        end
    end

    function publicApi.Lock(state)
        publicApi._locked = state and true or false
        valueLabel.TextEditable = not publicApi._locked
        local targetAlpha = publicApi._locked and 0.4 or 1
        
        TweenService:Create(thumb, ANIM.ThumbHover, {
            BackgroundTransparency = publicApi._locked and 0.5 or 0
        }):Play()
        TweenService:Create(thumbRing, ANIM.ThumbHover, {
            BackgroundTransparency = publicApi._locked and 0.7 or 0
        }):Play()
        TweenService:Create(fill, ANIM.ThumbHover, {
            BackgroundTransparency = publicApi._locked and 0.6 or 0
        }):Play()
        TweenService:Create(track, ANIM.ThumbHover, {
            BackgroundTransparency = publicApi._locked and 0.7 or 0
        }):Play()
        TweenService:Create(valueBadge, ANIM.ThumbHover, {
            BackgroundTransparency = publicApi._locked and 0.6 or 0
        }):Play()
        TweenService:Create(valueLabel, ANIM.ThumbHover, {
            TextTransparency = publicApi._locked and 0.5 or 0
        }):Play()
    end

    function publicApi.Update(newOptions)
        options = newOptions or options
        title = options.Text or title
        minv = tonumber(options.Min) or minv
        maxv = tonumber(options.Max) or maxv
        step = tonumber(options.Step) or step
        value = tonumber(options.Value) or value
        callback = options.Callback or callback
        value = clamp(roundToStep(value))
        titleLabel.Text = title
        updateVisuals(true)
    end

    function publicApi.Destroy()
        dragging = false
        hovering = false
        for _, c in ipairs(connections) do
            if c then
                pcall(function() c:Disconnect() end)
            end
        end
        if publicApi._instance and publicApi._instance.Parent then
            pcall(function() publicApi._instance:Destroy() end)
        end
        publicApi._instance = nil
        publicApi._connections = nil
        publicApi._onChanged = nil
    end

    updateVisuals(false)
    table.insert(tab.Components, publicApi)
    return publicApi
end


-- Hover universal
local function addHoverEffect(element, normalColor, hoverColor)
	local tweenService = game:GetService("TweenService")
	element.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			tweenService:Create(element, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
		end
	end)
	element.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			tweenService:Create(element, TweenInfo.new(0.15), {BackgroundColor3 = normalColor}):Play()
		end
	end)
end

function Tekscripts:CreateSection(tab: any, options: { Title: string?, Open: boolean?, Fixed: boolean? })
    assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateSection")

    local DESIGN = DESIGN or {}
    local minClosedHeight = 30 
    local titleHeight = 30
    local contentPadding = 10 

    local TweenService = game:GetService("TweenService")

    -- Container principal da section
    local sectionContainer = Instance.new("Frame")
    sectionContainer.BackgroundColor3 = DESIGN.SectionColor or Color3.fromRGB(30, 30, 30)
    sectionContainer.BorderSizePixel = 0
    sectionContainer.ClipsDescendants = true
    sectionContainer.Parent = tab.Container

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 8)
    uicorner.Parent = sectionContainer

    -- Frame do título com fundo interativo
    local titleFrame = Instance.new("Frame")
    titleFrame.BackgroundColor3 = DESIGN.TitleBackgroundColor or Color3.fromRGB(40, 40, 40)
    titleFrame.BackgroundTransparency = 0.2
    titleFrame.Size = UDim2.new(1, 0, 0, titleHeight)
    titleFrame.Position = UDim2.new(0, 0, 0, 0)
    titleFrame.ZIndex = 2
    titleFrame.Active = true
    titleFrame.Parent = sectionContainer

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleFrame

    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = options.Title or ""
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18 -- Aumentado para destaque
    titleLabel.TextColor3 = DESIGN.SectionTitleColor or Color3.fromRGB(230, 230, 230) -- Cor mais clara para destaque
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -30, 0, 20)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.ZIndex = 3
    titleLabel.Parent = titleFrame

    -- Indicador de seta
    local arrowLabel = Instance.new("TextLabel")
    arrowLabel.Text = "▼"
    arrowLabel.Font = Enum.Font.GothamBold
    arrowLabel.TextSize = 14
    arrowLabel.TextColor3 = DESIGN.SectionTitleColor or Color3.fromRGB(230, 230, 230)
    arrowLabel.BackgroundTransparency = 1
    arrowLabel.Size = UDim2.new(0, 20, 0, 20)
    arrowLabel.Position = UDim2.new(1, -25, 0, 5)
    arrowLabel.ZIndex = 3
    arrowLabel.Parent = titleFrame
    arrowLabel.TextYAlignment = Enum.TextYAlignment.Center

    -- Linha separadora
    local separatorLine = Instance.new("Frame")
    separatorLine.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    separatorLine.Size = UDim2.new(1, -20, 0, 1)
    separatorLine.Position = UDim2.new(0, 10, 0, titleHeight - 1)
    separatorLine.BorderSizePixel = 0
    separatorLine.ZIndex = 2
    separatorLine.Parent = sectionContainer

    local function setHover(state)
        local targetTransparency = state and 0 or 0.2
        local targetTextSize = state and 20 or 18 -- Ajustado para corresponder ao novo tamanho do título
        local targetColor = state and (DESIGN.SectionTitleHoverColor or Color3.fromRGB(200, 200, 200))
                            or (DESIGN.SectionTitleColor or Color3.fromRGB(230, 230, 230))
        
        TweenService:Create(
            titleFrame,
            TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
            { BackgroundTransparency = targetTransparency }
        ):Play()
        TweenService:Create(
            titleLabel,
            TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
            { TextSize = targetTextSize, TextColor3 = targetColor }
        ):Play()
        TweenService:Create(
            arrowLabel,
            TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
            { TextColor3 = targetColor }
        ):Play()
    end

    -- Conexões de Input para Hover (otimizadas)
    local isMouseOver = false
    titleFrame.MouseEnter:Connect(function()
        isMouseOver = true
        setHover(true)
    end)
    titleFrame.MouseLeave:Connect(function()
        isMouseOver = false
        setHover(false)
    end)
    
    -- Container interno dos componentes
    local contentContainer = Instance.new("Frame")
    contentContainer.BackgroundTransparency = 1
    contentContainer.Size = UDim2.new(1, -20, 1, -titleHeight)
    contentContainer.Position = UDim2.new(0, 10, 0, titleHeight)
    contentContainer.Parent = sectionContainer
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = contentContainer
    
    -- Overlay de bloqueio
    local blockOverlay = Instance.new("Frame")
    blockOverlay.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    blockOverlay.BackgroundTransparency = 0.6
    blockOverlay.Size = UDim2.new(1, 0, 0, 0)
    blockOverlay.Position = UDim2.new(0, 0, 0, titleHeight)
    blockOverlay.Visible = false
    blockOverlay.ZIndex = 5
    blockOverlay.Active = true
    blockOverlay.Parent = sectionContainer
    
    local overlayCorner = Instance.new("UICorner")
    overlayCorner.CornerRadius = UDim.new(0, 8)
    overlayCorner.Parent = blockOverlay
    
    local blockLabel = Instance.new("TextLabel")
    blockLabel.Text = "Bloqueado"
    blockLabel.Font = Enum.Font.GothamBold
    blockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    blockLabel.TextSize = 24
    blockLabel.TextScaled = false
    blockLabel.BackgroundTransparency = 1
    blockLabel.Size = UDim2.new(1, 0, 1, 0)
    blockLabel.TextXAlignment = Enum.TextXAlignment.Center
    blockLabel.TextYAlignment = Enum.TextYAlignment.Center
    blockLabel.TextWrapped = true
    blockLabel.ZIndex = 6
    blockLabel.Parent = blockOverlay
    
    -- Conexão para atualizar tamanho do overlay
    local sizeConnection = contentContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if blockOverlay.Visible then
            blockOverlay.Size = UDim2.new(1, 0, 0, contentContainer.AbsoluteSize.Y)
        end
    end)
    
    -- Estados
    local open = options.Open ~= false
    local fixed = options.Fixed == true
    
    local function updateHeight()
        local contentHeight = layout.AbsoluteContentSize.Y
        local targetOpenHeight = titleHeight + contentHeight + contentPadding
        local targetHeight = open and targetOpenHeight or minClosedHeight
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        
        TweenService:Create(
            sectionContainer,
            tweenInfo,
            { Size = UDim2.new(1, 0, 0, targetHeight) }
        ):Play()
        
        -- Animação da Rotação da Seta
        local targetRotation = open and 180 or 0 
        TweenService:Create(
            arrowLabel,
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            { Rotation = targetRotation }
        ):Play()

        -- Atualiza o tamanho do overlay
        if blockOverlay.Visible and open then
            blockOverlay.Size = UDim2.new(1, 0, 0, contentHeight)
        elseif not open then
             TweenService:Create(
                blockOverlay,
                tweenInfo,
                { Size = UDim2.new(1, 0, 0, 0) }
            ):Play()
        end
    end
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateHeight)
    task.defer(updateHeight)
    
    local publicApi = {
        _instance = sectionContainer,
        _content = contentContainer,
        Components = {},
        _blocked = false
    }
    
    function publicApi:AddComponent(component)
        if component._instance then
            component._instance.Parent = contentContainer
            table.insert(publicApi.Components, component)
            task.defer(updateHeight)
        else
            warn("Componente inválido para Section:AddComponent")
        end
    end
    
    function publicApi:SetTitle(text)
        titleLabel.Text = text or ""
    end
    
    function publicApi:Toggle()
        if fixed then return end
        open = not open
        blockOverlay.Visible = publicApi._blocked and open
        updateHeight()
    end
    
    titleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            publicApi:Toggle()
        end
    end)
    
    function publicApi:Block(state: boolean, message: string?)
        publicApi._blocked = state
        blockLabel.Text = message or "Bloqueado"
        blockOverlay.Visible = state and open
        if state and open then
            blockOverlay.Size = UDim2.new(1, 0, 0, contentContainer.AbsoluteSize.Y)
        elseif not state and not open then
             blockOverlay.Visible = false
        end
    end
    
    function publicApi:Destroy()
        if sizeConnection then
            sizeConnection:Disconnect()
        end
        for _, comp in ipairs(publicApi.Components) do
            if comp.Destroy then comp:Destroy() end
        end
        sectionContainer:Destroy()
    end
    
    table.insert(tab.Components, publicApi)
    return publicApi
end

function Tekscripts:CreateTextBox(tab, options)
    assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateTextBox")
    assert(type(options) == "table" and type(options.Text) == "string", "Invalid arguments for CreateTextBox")

    local title = options.Text or "Log"
    local desc = options.Desc
    local defaultText = options.Default or ""
    local readonly = options.ReadOnly or true

    -- // CONTAINER BASE
    local boxHolder = Instance.new("Frame")
    boxHolder.Name = "TextBox"
    boxHolder.BackgroundColor3 = DESIGN.ComponentBackground
    boxHolder.Size = UDim2.new(1, 0, 0, desc and 140 or 120)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius)
    corner.Parent = boxHolder

    local stroke = Instance.new("UIStroke")
    stroke.Color = DESIGN.HRColor
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = boxHolder

    -- // LAYOUT BASE
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, DESIGN.ComponentPadding)
    padding.PaddingBottom = UDim.new(0, DESIGN.ComponentPadding)
    padding.PaddingLeft = UDim.new(0, DESIGN.ComponentPadding)
    padding.PaddingRight = UDim.new(0, DESIGN.ComponentPadding)
    padding.Parent = boxHolder

    -- // TÍTULO
    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.TextColor3 = DESIGN.ComponentTextColor
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Size = UDim2.new(1, -10, 0, 18)
    titleLabel.Parent = boxHolder

    -- // SUBTÍTULO
    local currentY = 22
    if desc then
        local sub = Instance.new("TextLabel")
        sub.BackgroundTransparency = 1
        sub.Text = desc
        sub.Font = Enum.Font.GothamSemibold
        sub.TextColor3 = Color3.fromRGB(150, 150, 150)
        sub.TextSize = 12
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.Position = UDim2.new(0, 0, 0, currentY)
        sub.Size = UDim2.new(1, -10, 0, 16)
        sub.Parent = boxHolder
        currentY += 20
    end

    -- // CONTAINER DO TEXTO (com scroll)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "Scroll"
    scroll.BackgroundColor3 = DESIGN.InputBackgroundColor
    scroll.BorderSizePixel = 0
    scroll.Position = UDim2.new(0, 0, 0, currentY + 6)
    scroll.Size = UDim2.new(1, 0, 1, desc and -currentY - 14 or -28)
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = DESIGN.SliderTrackColor
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ClipsDescendants = true
    scroll.Active = true
    scroll.Parent = boxHolder

    local innerPadding = Instance.new("UIPadding")
    innerPadding.PaddingTop = UDim.new(0, 6)
    innerPadding.PaddingLeft = UDim.new(0, 6)
    innerPadding.PaddingRight = UDim.new(0, 6)
    innerPadding.PaddingBottom = UDim.new(0, 6)
    innerPadding.Parent = scroll

    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 6)
    scrollCorner.Parent = scroll

    local scrollStroke = Instance.new("UIStroke")
    scrollStroke.Color = DESIGN.SliderTrackColor
    scrollStroke.Thickness = 1
    scrollStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    scrollStroke.Parent = scroll

    -- // TEXTO PRINCIPAL
    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = DESIGN.InputTextColor
    textLabel.Font = Enum.Font.Code
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.TextWrapped = true
    textLabel.Text = defaultText
    textLabel.Size = UDim2.new(1, -8, 0, 0)
    textLabel.AutomaticSize = Enum.AutomaticSize.Y
    textLabel.Parent = scroll

    -- // INTERAÇÃO
    local function updateInteractivity()
        local blocked = self.Blocked or readonly
        scroll.Active = not blocked
        textLabel.TextTransparency = blocked and 0.5 or 0
        scroll.BackgroundColor3 = blocked and DESIGN.WindowColor2 or DESIGN.InputBackgroundColor
        scrollStroke.Color = blocked and DESIGN.HRColor or DESIGN.SliderTrackColor
    end

    updateInteractivity()

    -- // API PÚBLICA
    local publicApi = {
        _instance = boxHolder,
        _scroll = scroll,
        _label = textLabel,
        _readonly = readonly
    }

    function publicApi:SetText(newText)
        textLabel.Text = tostring(newText)
        task.wait()
        scroll.CanvasPosition = Vector2.new(0, math.huge)
    end

    function publicApi:GetText()
        return textLabel.Text
    end

    function publicApi:Append(line)
        textLabel.Text = textLabel.Text .. "\n" .. tostring(line)
        task.wait()
        scroll.CanvasPosition = Vector2.new(0, math.huge)
    end

    function publicApi:Clear()
        textLabel.Text = ""
    end

    function publicApi:SetBlocked(state)
        self._blocked = state
        updateInteractivity()
    end

    function publicApi:Destroy()
        if publicApi._instance then
            publicApi._instance:Destroy()
            publicApi._instance = nil
        end
    end

    table.insert(tab.Components, publicApi)
    boxHolder.Parent = tab.Container

    if self.BlockChanged then
        self.BlockChanged:Connect(updateInteractivity)
    end

    return publicApi
end

function Tekscripts:CreateColorPicker(tab: any, options: {
    Title: string?,
    Color: Color3?,
    Blocked: boolean?,
    Callback: ((Color3) -> ())?
})
    -- Validação inicial
    assert(tab and tab.Container, "CreateColorPicker: 'tab' e 'tab.Container' válidos são necessários.")

    -- // DEPENDÊNCIAS E SERVIÇOS //
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    -- // CONFIGURAÇÃO INICIAL //
    local defaultOptions = {
        Title = "Color",
        Color = Color3.new(1, 1, 1),
        Blocked = false,
        Callback = function() end
    }
    options = options or {}
    for key, value in pairs(defaultOptions) do
        if options[key] == nil then
            options[key] = value
        end
    end

    if typeof(options.Color) ~= "Color3" then
        warn("CreateColorPicker: 'options.Color' inválido. Esperado Color3, recebido " .. typeof(options.Color) .. ". Usando cor padrão.")
        options.Color = defaultOptions.Color
    end

    -- // ESTADO DO COMPONENTE //
    local state = {
        isExpanded = false,
        isBlocked = options.Blocked,
        isDraggingHue = false,
        isDraggingSV = false,
        h = 0, s = 1, v = 1,
        confirmedColor = options.Color
    }
    state.h, state.s, state.v = options.Color:ToHSV()

    local connections = {}

    -- // FUNÇÕES AUXILIARES //
    local function createInstance(className, properties)
        local inst = Instance.new(className)
        for prop, value in pairs(properties) do
            inst[prop] = value
        end
        return inst
    end

    local function addHoverEffect(button, originalColor, hoverColor)
        local isHovering = false
        local isDown = false

        table.insert(connections, button.MouseEnter:Connect(function()
            isHovering = true
            if not isDown and not state.isBlocked then
                TweenService:Create(button, TweenInfo.new(DESIGN.AnimationSpeed, Enum.EasingStyle.Quad), { BackgroundColor3 = hoverColor }):Play()
            end
        end))
        table.insert(connections, button.MouseLeave:Connect(function()
            isHovering = false
            if not isDown and not state.isBlocked then
                TweenService:Create(button, TweenInfo.new(DESIGN.AnimationSpeed, Enum.EasingStyle.Quad), { BackgroundColor3 = originalColor }):Play()
            end
        end))
        table.insert(connections, button.MouseButton1Down:Connect(function()
            isDown = true
        end))
        table.insert(connections, button.MouseButton1Up:Connect(function()
            isDown = false
            if isHovering and not state.isBlocked then
                TweenService:Create(button, TweenInfo.new(DESIGN.AnimationSpeed, Enum.EasingStyle.Quad), { BackgroundColor3 = hoverColor }):Play()
            else
                TweenService:Create(button, TweenInfo.new(DESIGN.AnimationSpeed, Enum.EasingStyle.Quad), { BackgroundColor3 = originalColor }):Play()
            end
        end))
    end

    -- // CRIAÇÃO DA UI //
    local box = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight),
        BackgroundColor3 = DESIGN.ComponentBackground,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = tab.Container,
        LayoutOrder = #tab.Components + 1
    })

    createInstance("UICorner", { CornerRadius = UDim.new(0, DESIGN.CornerRadius), Parent = box })
    createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, DESIGN.ComponentPadding),
        PaddingRight = UDim.new(0, DESIGN.ComponentPadding),
        PaddingTop = UDim.new(0, 0),
        PaddingBottom = UDim.new(0, 0),
        Parent = box
    })

    -- Botão principal (título + cor)
    local mainFrame = createInstance("TextButton", {
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight),
        BackgroundColor3 = DESIGN.ComponentBackground,
        Text = "",
        BorderSizePixel = 0,
        Parent = box
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, DESIGN.CornerRadius), Parent = mainFrame })
    createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, DESIGN.ComponentPadding),
        PaddingRight = UDim.new(0, DESIGN.ComponentPadding),
        Parent = mainFrame
    })

    local mainLayout = createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, DESIGN.ComponentPadding),
        Parent = mainFrame
    })

    local titleLabel = createInstance("TextLabel", {
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.Roboto,
        TextSize = 15,
        TextColor3 = DESIGN.ComponentTextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Text = options.Title,
        Parent = mainFrame
    })

    local colorBox = createInstance("Frame", {
        Size = UDim2.new(0, DESIGN.IconSize, 0, DESIGN.ComponentHeight),
        BackgroundColor3 = options.Color,
        BorderSizePixel = 1,
        BorderColor3 = DESIGN.ThumbOutlineColor,
        Parent = mainFrame
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, DESIGN.CornerRadius / 2), Parent = colorBox })

    -- Container do picker (oculto inicialmente)
    local svHeight = 150
    local pickerInnerHeight = svHeight + 2 * DESIGN.ComponentHeight + 2 * DESIGN.ComponentPadding
    local pickerHeight = pickerInnerHeight + 2 * DESIGN.ComponentPadding
    local pickerContainer = createInstance("Frame", {
        Position = UDim2.new(0, 0, 0, DESIGN.ComponentHeight),
        Size = UDim2.new(1, 0, 0, pickerHeight),
        BackgroundColor3 = DESIGN.ComponentBackground,
        BorderSizePixel = 0,
        Visible = false,
        Parent = box
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, DESIGN.CornerRadius), Parent = pickerContainer })
    createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, DESIGN.ComponentPadding),
        Parent = pickerContainer
    })
    createInstance("UIPadding", {
        PaddingTop = UDim.new(0, DESIGN.ComponentPadding),
        PaddingBottom = UDim.new(0, DESIGN.ComponentPadding),
        PaddingLeft = UDim.new(0, DESIGN.ComponentPadding),
        PaddingRight = UDim.new(0, DESIGN.ComponentPadding),
        Parent = pickerContainer
    })

    -- Paleta SV
    local svPalette = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, svHeight),
        BackgroundColor3 = Color3.fromHSV(state.h, 1, 1),
        Parent = pickerContainer
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, DESIGN.CornerRadius), Parent = svPalette })

    local svWhiteGradient = createInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(state.h, 1, 1))
        }),
        Parent = svPalette
    })

    local svBlackOverlay = createInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = svPalette
    })
    createInstance("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0, 1))
        }),
        Parent = svBlackOverlay
    })

    local svThumb = createInstance("Frame", {
        Size = UDim2.new(0, DESIGN.ResizeHandleSize, 0, DESIGN.ResizeHandleSize),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = DESIGN.ThumbColor,
        BorderSizePixel = 1,
        BorderColor3 = DESIGN.ThumbOutlineColor,
        Parent = svPalette
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = svThumb })

    -- Seletor de matiz
    local hueTrack = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight),
        BackgroundColor3 = DESIGN.SliderTrackColor,
        Parent = pickerContainer
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, DESIGN.CornerRadius), Parent = hueTrack })
    createInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.new(1, 1, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.new(0, 1, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.new(0, 1, 1)),
            ColorSequenceKeypoint.new(0.67, Color3.new(0, 0, 1)),
            ColorSequenceKeypoint.new(0.83, Color3.new(1, 0, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))
        }),
        Parent = hueTrack
    })
    local hueThumb = createInstance("Frame", {
        Size = UDim2.new(0, DESIGN.ResizeHandleSize, 1, 0),
        BackgroundColor3 = DESIGN.ThumbColor,
        BorderSizePixel = 1,
        BorderColor3 = DESIGN.ThumbOutlineColor,
        Parent = hueTrack
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = hueThumb })

    -- Input e botão
    local inputConfirmContainer = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight),
        BackgroundTransparency = 1,
        Parent = pickerContainer
    })
    createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, DESIGN.ComponentPadding),
        Parent = inputConfirmContainer
    })

    local colorInput = createInstance("TextBox", {
        Size = UDim2.new(0, DESIGN.DropdownWidth, 0, DESIGN.ComponentHeight),
        Font = Enum.Font.Roboto,
        TextSize = 14,
        TextColor3 = DESIGN.InputTextColor,
        BackgroundColor3 = DESIGN.InputBackgroundColor,
        BorderSizePixel = 1,
        BorderColor3 = DESIGN.ThumbOutlineColor,
        Text = string.format("%d, %d, %d", math.floor(options.Color.R * 255), math.floor(options.Color.G * 255), math.floor(options.Color.B * 255)),
        Parent = inputConfirmContainer
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, DESIGN.CornerRadius), Parent = colorInput })
    createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, DESIGN.ComponentPadding),
        PaddingRight = UDim.new(0, DESIGN.ComponentPadding),
        Parent = colorInput
    })

    local confirmButton = createInstance("TextButton", {
        Size = UDim2.new(0, DESIGN.TagWidth, 0, DESIGN.ComponentHeight),
        Font = Enum.Font.Roboto,
        TextSize = 14,
        TextColor3 = DESIGN.ComponentTextColor,
        BackgroundColor3 = DESIGN.ComponentBackground,
        Text = "Confirm",
        Parent = inputConfirmContainer
    })
    createInstance("UICorner", { CornerRadius = UDim.new(0, DESIGN.CornerRadius), Parent = confirmButton })

    -- Overlay de bloqueio
    local blockedOverlay = createInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0.5,
        BackgroundColor3 = DESIGN.BlockScreenColor,
        Visible = state.isBlocked,
        ZIndex = 10,
        Parent = box
    })

    -- // LÓGICA //
    local function updateColorVisuals(useTween: boolean)
        local newColor = Color3.fromHSV(state.h, state.s, state.v)
        if useTween then
            TweenService:Create(colorBox, TweenInfo.new(DESIGN.AnimationSpeed, Enum.EasingStyle.Quad), { BackgroundColor3 = newColor }):Play()
        else
            colorBox.BackgroundColor3 = newColor
        end

        svPalette.BackgroundColor3 = Color3.fromHSV(state.h, 1, 1)
        svWhiteGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(state.h, 1, 1))
        })
        colorInput.Text = string.format("%d, %d, %d", math.floor(newColor.R * 255), math.floor(newColor.G * 255), math.floor(newColor.B * 255))
    end

    local function updateThumbs()
        hueThumb.Position = UDim2.fromScale(state.h, 0.5)
        svThumb.Position = UDim2.fromScale(state.s, 1 - state.v)
        updateColorVisuals(false)
    end

    local function handleHueDrag(inputPos: Vector2)
        local relX = math.clamp(inputPos.X - hueTrack.AbsolutePosition.X, 0, hueTrack.AbsoluteSize.X)
        state.h = relX / hueTrack.AbsoluteSize.X
        hueThumb.Position = UDim2.fromScale(state.h, 0.5)
        updateColorVisuals(true)
    end

    local function handleSVDrag(inputPos: Vector2)
        local relX = math.clamp(inputPos.X - svPalette.AbsolutePosition.X, 0, svPalette.AbsoluteSize.X)
        local relY = math.clamp(inputPos.Y - svPalette.AbsolutePosition.Y, 0, svPalette.AbsoluteSize.Y)
        state.s = relX / svPalette.AbsoluteSize.X
        state.v = 1 - (relY / svPalette.AbsoluteSize.Y)
        svThumb.Position = UDim2.fromScale(state.s, 1 - state.v)
        updateColorVisuals(true)
    end

    local function parseRGBInput(text: string): Color3?
        local r, g, b = text:match("^(%d+)%s*,%s*(%d+)%s*,%s*(%d+)$")
        if r and g and b then
            local rNum, gNum, bNum = tonumber(r), tonumber(g), tonumber(b)
            if rNum and gNum and bNum and rNum >= 0 and rNum <= 255 and gNum >= 0 and gNum <= 255 and bNum >= 0 and bNum <= 255 then
                return Color3.fromRGB(rNum, gNum, bNum)
            end
        end
        return nil
    end

    local function expand()
        if state.isExpanded or state.isBlocked then return end
        state.isExpanded = true

        local h, s, v = state.confirmedColor:ToHSV()
        state.h, state.s, state.v = h, s, v
        updateThumbs()

        pickerContainer.Visible = true
        local finalHeight = DESIGN.ComponentHeight + pickerHeight
        local finalSize = UDim2.new(1, 0, 0, finalHeight)
        TweenService:Create(box, TweenInfo.new(DESIGN.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = finalSize }):Play()

        tab.EmptyLabel.Visible = false
    end

    local function collapse()
        if not state.isExpanded or state.isBlocked then return end
        state.isExpanded = false

        local finalSize = UDim2.new(1, 0, 0, DESIGN.ComponentHeight)
        local closeTween = TweenService:Create(box, TweenInfo.new(DESIGN.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = finalSize })
        closeTween:Play()
        closeTween.Completed:Once(function()
            if not state.isExpanded then
                pickerContainer.Visible = false
            end
            tab.EmptyLabel.Visible = #tab.Components == 0
        end)
    end

    local function onMainFrameClick()
        if state.isBlocked then
            local originalPos = box.Position
            TweenService:Create(box, TweenInfo.new(DESIGN.AnimationSpeed, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 1, true), { Position = originalPos + UDim2.new(0, DESIGN.ComponentPadding, 0, 0) }):Play()
            return
        end
        if state.isExpanded then
            collapse()
        else
            expand()
        end
    end

    local function onConfirmClick()
        if state.isBlocked then return end
        state.confirmedColor = Color3.fromHSV(state.h, state.s, state.v)
        pcall(options.Callback, state.confirmedColor)
        colorBox.BackgroundColor3 = state.confirmedColor
        collapse()
    end

    local function onColorInputChanged()
        if state.isBlocked then return end
        local newColor = parseRGBInput(colorInput.Text)
        if newColor then
            state.h, state.s, state.v = newColor:ToHSV()
            updateThumbs()
        else
            -- Reverter para o valor atual se inválido
            updateColorVisuals(false)
        end
    end

    -- // EVENTOS //
    addHoverEffect(mainFrame, DESIGN.ComponentBackground, DESIGN.ComponentHoverColor)
    addHoverEffect(confirmButton, DESIGN.ComponentBackground, DESIGN.ComponentHoverColor)
    table.insert(connections, mainFrame.MouseButton1Click:Connect(onMainFrameClick))
    table.insert(connections, confirmButton.MouseButton1Click:Connect(onConfirmClick))
    table.insert(connections, colorInput.FocusLost:Connect(onColorInputChanged))

    table.insert(connections, hueTrack.InputBegan:Connect(function(input)
        if state.isExpanded and not state.isBlocked and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            state.isDraggingHue = true
            handleHueDrag(input.Position)
        end
    end))

    table.insert(connections, svPalette.InputBegan:Connect(function(input)
        if state.isExpanded and not state.isBlocked and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            state.isDraggingSV = true
            handleSVDrag(input.Position)
        end
    end))

    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if not state.isExpanded or state.isBlocked then return end
        if state.isDraggingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            handleHueDrag(input.Position)
        elseif state.isDraggingSV and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            handleSVDrag(input.Position)
        end
    end))

    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            state.isDraggingHue = false
            state.isDraggingSV = false
        end
    end))

    updateThumbs()

    -- // API PÚBLICA //
    local publicApi = {}

    function publicApi.SetColor(newColor: Color3)
        if typeof(newColor) ~= "Color3" then
            warn("SetColor: Cor inválida. Esperado Color3, recebido " .. typeof(newColor))
            return
        end
        state.confirmedColor = newColor
        colorBox.BackgroundColor3 = newColor
        local h, s, v = newColor:ToHSV()
        state.h, state.s, state.v = h, s, v
        if state.isExpanded then
            updateThumbs()
        end
        pcall(options.Callback, newColor)
    end

    function publicApi.GetColor(): Color3
        return state.confirmedColor
    end

    function publicApi.SetBlocked(isBlocked: boolean)
        state.isBlocked = isBlocked
        blockedOverlay.Visible = isBlocked
    end

    function publicApi.Destroy()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        table.clear(connections)
        if box and box.Parent then
            box:Destroy()
        end
        for k in pairs(publicApi) do
            publicApi[k] = nil
        end
        for i, comp in ipairs(tab.Components) do
            if comp == publicApi then
                table.remove(tab.Components, i)
                break
            end
        end
        tab.EmptyLabel.Visible = #tab.Components == 0
        local listLayout = tab.Container:FindFirstChildOfClass("UIListLayout")
        if listLayout then
            tab.Container.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + DESIGN.ContainerPadding * 2)
        end
    end

    publicApi._instance = box
    publicApi._connections = connections
    table.insert(tab.Components, publicApi)

    local listLayout = tab.Container:FindFirstChildOfClass("UIListLayout")
    if listLayout then
        tab.Container.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + DESIGN.ContainerPadding * 2)
    end

    return publicApi
end

function Tekscripts:CreateButton(tab, options)
    -- // VALIDAÇÃO
    assert(typeof(tab) == "table" and tab.Container, "CreateButton: 'tab' inválido ou sem Container.")
    assert(typeof(options) == "table" and typeof(options.Text) == "string", "CreateButton: 'options' inválido.")

    -- // SERVIÇOS
    local TweenService = game:GetService("TweenService")

    -- // CONFIG
    local callback = typeof(options.Callback) == "function" and options.Callback or function() end
    local debounceTime = tonumber(options.Debounce or 0.25)
    local lastClick = 0
    local btnColor = DESIGN.ComponentBackground
    local hoverColor = DESIGN.ComponentHoverColor
    local errorColor = Color3.fromRGB(255, 60, 60)

    -- // INSTÂNCIA
    local btn = Instance.new("TextButton")
    btn.Name = "Button"
    btn.Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight)
    btn.BackgroundColor3 = btnColor
    btn.TextColor3 = DESIGN.ComponentTextColor
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = options.Text
    btn.AutoButtonColor = false
    btn.ClipsDescendants = true
    btn.Parent = tab.Container

    -- // VISUAL
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = DESIGN.HRColor
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    -- // ANIMAÇÕES
    local function tweenTo(props, duration)
        if not btn or not btn.Parent then return end
        local tween = TweenService:Create(btn, TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad), props)
        tween:Play()
        return tween
    end

    local function pulseError()
        tweenTo({BackgroundColor3 = errorColor}, 0.1)
        task.delay(0.2, function()
            tweenTo({BackgroundColor3 = btnColor}, 0.2)
        end)
    end

    -- // EVENTOS
    local hoverConn = btn.MouseEnter:Connect(function()
        if not self.Blocked then tweenTo({BackgroundColor3 = hoverColor}) end
    end)

    local leaveConn = btn.MouseLeave:Connect(function()
        if not self.Blocked then tweenTo({BackgroundColor3 = btnColor}) end
    end)

    local clickConn = btn.MouseButton1Click:Connect(function()
        if self.Blocked then return end
        if tick() - lastClick < debounceTime then return end
        lastClick = tick()

        tweenTo({Size = UDim2.new(0.95, 0, 0, DESIGN.ComponentHeight * 0.9)}, 0.1)
        task.delay(0.1, function()
            tweenTo({Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight)}, 0.1)
        end)

        task.spawn(function()
            local ok, err = pcall(callback)
            if not ok then
                warn("[CreateButton] Callback error:", err)
                pulseError()
                if Tekscripts.Log then
                    Tekscripts.Log("[Button Error] " .. tostring(err))
                end
            end
        end)
    end)

    -- // API PÚBLICA
    local publicApi = {
        _instance = btn,
        _connections = {clickConn, hoverConn, leaveConn},
        _blocked = false,
        _callback = callback
    }

    function publicApi:SetBlocked(state)
        self._blocked = state
        self._instance.Active = not state
        local color = state and Color3.fromRGB(60, 60, 60) or btnColor
        tweenTo({BackgroundColor3 = color}, 0.15)
    end

    function publicApi:Update(newOptions)
        if typeof(newOptions) ~= "table" then return end
        if newOptions.Text then btn.Text = tostring(newOptions.Text) end
        if typeof(newOptions.Callback) == "function" then
            callback = newOptions.Callback
            self._callback = callback
        end
        if newOptions.Debounce then
            debounceTime = tonumber(newOptions.Debounce)
        end
    end

    function publicApi:Destroy()
        for _, c in ipairs(self._connections) do
            if c.Connected then c:Disconnect() end
        end
        if self._instance then
            self._instance:Destroy()
        end
        self._connections = nil
        self._instance = nil
        self._callback = nil
        setmetatable(self, nil)
        table.clear(self)
    end

    table.insert(tab.Components, publicApi)
    return publicApi
end

function Tekscripts:CreateToggle(tab: any, options: { Text: string, Desc: string?, Callback: (state: boolean) -> () })
    assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateToggle")
    assert(type(options) == "table" and type(options.Text) == "string", "Invalid arguments for CreateToggle")

    local TweenService = game:GetService("TweenService")
    local descHeight = options.Desc and 16 or 0
    local padding = 6
    local totalHeight = DESIGN.ComponentHeight + descHeight + padding

    -- Outer box
    local outerBox = Instance.new("Frame")
    outerBox.Size = UDim2.new(1, 0, 0, totalHeight)
    outerBox.BackgroundColor3 = DESIGN.ComponentBackground
    outerBox.BorderSizePixel = 0
    outerBox.Parent = tab.Container
    addRoundedCorners(outerBox, DESIGN.CornerRadius)

    -- Internal container
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -DESIGN.ComponentPadding*2, 1, 0)
    container.Position = UDim2.new(0, DESIGN.ComponentPadding, 0, 0)
    container.BackgroundTransparency = 1
    container.Parent = outerBox

    -- Label
    local label = Instance.new("TextLabel")
    label.Text = options.Text
    label.Size = UDim2.new(0.7, -10, 0, DESIGN.ComponentHeight)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = DESIGN.ComponentTextColor
    label.Font = Enum.Font.Roboto
    label.TextScaled = false
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    -- Description
    local descLabel
    if options.Desc then
        descLabel = Instance.new("TextLabel")
        descLabel.Text = options.Desc
        descLabel.Size = UDim2.new(0.7, -10, 0, descHeight)
        descLabel.Position = UDim2.new(0, 0, 0, DESIGN.ComponentHeight)
        descLabel.BackgroundTransparency = 1
        descLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
        descLabel.Font = Enum.Font.Roboto
        descLabel.TextScaled = false
        descLabel.TextSize = 14
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = container
    end

    -- Switch
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 50, 0, 24)
    switch.Position = UDim2.new(0.85, 0, 0, (totalHeight - 24)/2)
    switch.BackgroundColor3 = DESIGN.InactiveToggleColor
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.ClipsDescendants = true
    switch.Parent = container
    addRoundedCorners(switch, 100)

    -- Knob
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 2, 0, 2)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = switch
    addRoundedCorners(knob, 100)

    -- Error indicator
    local errorIndicator = Instance.new("Frame")
    errorIndicator.Size = UDim2.new(0, 8, 0, 8)
    errorIndicator.Position = UDim2.new(1, -10, 0, 2)
    errorIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    errorIndicator.Visible = false
    errorIndicator.Parent = switch
    addRoundedCorners(errorIndicator, 100)

    -- Internal state
    local state = false
    local locked = false
    local inError = false
    local connections = {}

    local function animateToggle(newState)
        if not switch or not knob then return end
        TweenService:Create(switch, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            BackgroundColor3 = inError and Color3.fromRGB(255,60,60)
                                or (newState and DESIGN.ActiveToggleColor or DESIGN.InactiveToggleColor)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Position = newState and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
        }):Play()
    end

    local function setError(state)
        inError = state
        errorIndicator.Visible = state
        animateToggle(state or state)
    end

    local function pulseError()
        setError(true)
        task.delay(0.5, function()
            setError(false)
        end)
    end

    local function toggle(newState, skipCallback)
        if locked then return end
        state = newState
        animateToggle(state)
        if not skipCallback and typeof(options.Callback) == "function" then
            local ok, err = pcall(function() options.Callback(state) end)
            if not ok then
                warn("[Toggle Error] ", err)
                pulseError()
            end
        end
    end

    connections.Click = switch.MouseButton1Click:Connect(function()
        toggle(not state)
    end)

    -- Hover logic respecting error
    connections.Enter = switch.MouseEnter:Connect(function()
        if not locked then
            TweenService:Create(switch, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                BackgroundColor3 = inError and Color3.fromRGB(255,60,60)
                                    or (state and DESIGN.ActiveToggleColor or DESIGN.ComponentHoverColor)
            }):Play()
        end
    end)
    connections.Leave = switch.MouseLeave:Connect(function()
        if not locked then
            animateToggle(state)
        end
    end)

    -- Public API
    local publicApi = {
        _instance = outerBox,
        _connections = connections
    }

    function publicApi:SetState(newState: boolean) toggle(newState, true) end
    function publicApi:GetState(): boolean return state end
    function publicApi:Toggle() toggle(not state) end
    function publicApi:SetText(newText: string) if label then label.Text = newText end end
    function publicApi:SetDesc(newDesc: string) if descLabel then descLabel.Text = newDesc end end
    function publicApi:SetCallback(newCallback)
        if typeof(newCallback) == "function" then options.Callback = newCallback end
    end
    function publicApi:SetLocked(isLocked: boolean)
        locked = isLocked
        switch.AutoButtonColor = not locked
        animateToggle(state)
    end
    function publicApi:Update(newOptions: { Text: string?, Desc: string?, State: boolean? })
        if newOptions.Text then publicApi:SetText(newOptions.Text) end
        if newOptions.Desc then publicApi:SetDesc(newOptions.Desc) end
        if newOptions.State ~= nil then toggle(newOptions.State) end
    end
    function publicApi:Destroy()
        for _, c in pairs(publicApi._connections) do
            if c and c.Connected then c:Disconnect() end
        end
        if publicApi._instance then
            publicApi._instance:Destroy()
            publicApi._instance = nil
        end
        publicApi._connections = nil
    end

    table.insert(tab.Components, publicApi)
    return publicApi
end

function Tekscripts:CreateInput(tab, options)
	assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateInput")
	assert(type(options) == "table" and type(options.Text) == "string", "Invalid arguments for CreateInput")

	local TweenService = game:GetService("TweenService")

	local box = Instance.new("Frame")
	box.Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight + 30)
	box.BackgroundColor3 = DESIGN.ComponentBackground
	box.BackgroundTransparency = 0.05
	box.Parent = tab.Container
	addRoundedCorners(box, DESIGN.CornerRadius)

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.Parent = box

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, 4)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = box

	local topRow = Instance.new("Frame")
	topRow.Size = UDim2.new(1, 0, 0, 28)
	topRow.BackgroundTransparency = 1
	topRow.Parent = box

	local rowLayout = Instance.new("UIListLayout")
	rowLayout.FillDirection = Enum.FillDirection.Horizontal
	rowLayout.Padding = UDim.new(0, 6)
	rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
	rowLayout.Parent = topRow

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0.4, 0, 1, 0)
	title.BackgroundTransparency = 1
	title.Text = options.Text
	title.Font = Enum.Font.GothamBold
	title.TextScaled = true
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextColor3 = DESIGN.ComponentTextColor
	title.Parent = topRow

	local textbox = Instance.new("TextBox")
	textbox.Size = UDim2.new(0.6, 0, 1, 0)
	textbox.BackgroundColor3 = DESIGN.InputBackgroundColor
	textbox.PlaceholderText = options.Placeholder or ""
	textbox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
	textbox.TextColor3 = DESIGN.InputTextColor
	textbox.TextScaled = true
	textbox.Font = Enum.Font.Roboto
	textbox.TextXAlignment = Enum.TextXAlignment.Left
	textbox.TextYAlignment = Enum.TextYAlignment.Center
	textbox.BorderSizePixel = 0
	textbox.Text = ""
	textbox.ClipsDescendants = true
	textbox.Parent = topRow
	addRoundedCorners(textbox, DESIGN.CornerRadius)
	addHoverEffect(textbox, DESIGN.InputBackgroundColor, DESIGN.InputHoverColor)

	-- Bloqueio visual
	local blockOverlay = Instance.new("Frame")
	blockOverlay.Size = UDim2.new(1, 0, 1, 0)
	blockOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	blockOverlay.BackgroundTransparency = 0.35
	blockOverlay.Visible = false
	blockOverlay.ZIndex = textbox.ZIndex + 2
	addRoundedCorners(blockOverlay, DESIGN.CornerRadius)
	blockOverlay.Parent = textbox

	local blockText = Instance.new("TextLabel")
	blockText.AnchorPoint = Vector2.new(0.5, 0.5)
	blockText.Position = UDim2.new(0.5, 0, 0.5, 0)
	blockText.Size = UDim2.new(1, -8, 1, -8)
	blockText.BackgroundTransparency = 1
	blockText.Text = options.BlockText or "🔒 BLOQUEADO"
	blockText.Font = Enum.Font.GothamBold
	blockText.TextScaled = true
	blockText.TextColor3 = Color3.fromRGB(255, 85, 85)
	blockText.ZIndex = blockOverlay.ZIndex + 1
	blockText.Parent = blockOverlay

	-- Indicador de erro
	local errorIndicator = Instance.new("Frame")
	errorIndicator.Size = UDim2.new(0, 8, 0, 8)
	errorIndicator.Position = UDim2.new(1, -10, 0, 2)
	errorIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	errorIndicator.Visible = false
	errorIndicator.ZIndex = textbox.ZIndex + 3
	addRoundedCorners(errorIndicator, 100)
	errorIndicator.Parent = textbox

	-- Desc
	local desc
	if options.Desc then
		desc = Instance.new("TextLabel")
		desc.Size = UDim2.new(1, 0, 0, 14)
		desc.BackgroundTransparency = 1
		desc.Text = options.Desc
		desc.Font = Enum.Font.Gotham
		desc.TextScaled = true
		desc.TextWrapped = true
		desc.TextXAlignment = Enum.TextXAlignment.Left
		desc.TextColor3 = DESIGN.ComponentTextColor:lerp(Color3.new(0.7, 0.7, 0.7), 0.6)
		desc.Parent = box
	end

	local connections = {}
	local publicApi = { _instance = box, _connections = connections, Blocked = false }
	local inError = false

	local function pulseError()
		if not textbox then return end
		inError = true
		errorIndicator.Visible = true
		TweenService:Create(textbox, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(255, 60, 60) }):Play()
		task.delay(0.5, function()
			if textbox and not publicApi.Blocked then
				inError = false
				errorIndicator.Visible = false
				TweenService:Create(textbox, TweenInfo.new(0.2), { BackgroundColor3 = DESIGN.InputBackgroundColor }):Play()
			end
		end)
	end

	local function safeCallback(value)
		if publicApi.Blocked or not options.Callback then return end
		local ok, err = pcall(function() options.Callback(value) end)
		if not ok then
			warn("[Input Error]:", err)
			pulseError()
		end
	end

	if options.Type and options.Type:lower() == "number" then
		connections.Changed = textbox:GetPropertyChangedSignal("Text"):Connect(function()
			if publicApi.Blocked then return end
			local newText = textbox.Text
			if tonumber(newText) or newText == "" or newText == "-" then
				safeCallback(tonumber(newText) or 0)
			else
				textbox.Text = newText:sub(1, #newText - 1)
			end
		end)
	else
		connections.FocusLost = textbox.FocusLost:Connect(function(enterPressed)
			if publicApi.Blocked then return end
			if enterPressed then safeCallback(textbox.Text) end
		end)
	end

	function publicApi:SetBlocked(state, text)
		self.Blocked = state
		textbox.Active = not state
		textbox.TextEditable = not state
		blockOverlay.Visible = state
		if text then blockText.Text = tostring(text) end
	end

	function publicApi:Update(newOptions)
		if not newOptions then return end
		if newOptions.Text then title.Text = newOptions.Text end
		if newOptions.Placeholder then textbox.PlaceholderText = newOptions.Placeholder end
		if newOptions.Desc then
			if desc then desc.Text = newOptions.Desc
			elseif newOptions.Desc ~= "" then
				desc = Instance.new("TextLabel")
				desc.Size = UDim2.new(1, 0, 0, 14)
				desc.BackgroundTransparency = 1
				desc.TextColor3 = DESIGN.ComponentTextColor:lerp(Color3.new(0.7, 0.7, 0.7), 0.6)
				desc.Font = Enum.Font.Gotham
				desc.TextScaled = true
				desc.TextWrapped = true
				desc.TextXAlignment = Enum.TextXAlignment.Left
				desc.Text = newOptions.Desc
				desc.Parent = box
			end
		end
		if newOptions.Value ~= nil then textbox.Text = tostring(newOptions.Value) end
		if newOptions.BlockText then blockText.Text = tostring(newOptions.BlockText) end
	end

	function publicApi:Destroy()
		if self._connections then
			for _, conn in pairs(self._connections) do
				if conn and conn.Connected then conn:Disconnect() end
			end
			self._connections = nil
		end
		if self._instance then
			self._instance:Destroy()
			self._instance = nil
		end
	end

	table.insert(tab.Components, publicApi)
	return publicApi
end

function Tekscripts:CreateBind(tab, options)
	assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateBind")
	assert(type(options) == "table" and type(options.Text) == "string", "Invalid arguments for CreateBind")

	local title = options.Text or "Keybind"
	local desc = options.Desc
	local defaultKey = options.Default or Enum.KeyCode.F
	local callback = typeof(options.Callback) == "function" and options.Callback or function() end

	local UserInputService = game:GetService("UserInputService")

	-- CRIAÇÃO DE ELEMENTOS
	local box = Instance.new("Frame")
	box.Name = "BindBox"
	box.BackgroundColor3 = DESIGN.ComponentBackground
	box.Size = UDim2.new(1, 0, 0, desc and DESIGN.ComponentHeight + 10 or DESIGN.ComponentHeight)
	box.ClipsDescendants = true

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius)
	corner.Parent = box

	local stroke = Instance.new("UIStroke")
	stroke.Color = DESIGN.HRColor
	stroke.Thickness = 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = box

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, DESIGN.ComponentPadding / 2)
	padding.PaddingBottom = UDim.new(0, DESIGN.ComponentPadding / 2)
	padding.PaddingLeft = UDim.new(0, DESIGN.ComponentPadding)
	padding.PaddingRight = UDim.new(0, DESIGN.ComponentPadding)
	padding.Parent = box

	local holder = Instance.new("Frame")
	holder.BackgroundTransparency = 1
	holder.Size = UDim2.new(1, 0, 1, 0)
	holder.Parent = box

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Text = title
	label.Font = Enum.Font.Gotham
	label.TextColor3 = DESIGN.ComponentTextColor
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Size = UDim2.new(1, -80, 1, 0)
	label.Parent = holder

	if desc then
		label.TextYAlignment = Enum.TextYAlignment.Top
		local sub = Instance.new("TextLabel")
		sub.BackgroundTransparency = 1
		sub.Text = desc
		sub.Font = Enum.Font.GothamSemibold
		sub.TextColor3 = DESIGN.EmptyStateTextColor
		sub.TextSize = 12
		sub.TextXAlignment = Enum.TextXAlignment.Left
		sub.TextYAlignment = Enum.TextYAlignment.Bottom
		sub.Size = UDim2.new(1, -80, 1, 0)
		sub.Parent = holder
	end

	local button = Instance.new("TextButton")
	button.AnchorPoint = Vector2.new(1, 0.5)
	button.Position = UDim2.new(1, -DESIGN.ComponentPadding, 0.5, 0)
	button.Size = UDim2.new(0, 80, 0, DESIGN.ComponentHeight * 0.5)
	button.BackgroundColor3 = DESIGN.InputBackgroundColor
	button.Text = defaultKey.Name
	button.TextColor3 = DESIGN.InputTextColor
	button.Font = Enum.Font.Gotham
	button.TextSize = 13
	button.AutoButtonColor = false
	button.Parent = holder

	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = DESIGN.HRColor
	btnStroke.Thickness = 1
	btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	btnStroke.Parent = button

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, DESIGN.CornerRadius / 2)
	btnCorner.Parent = button

	-- SEGURANÇA DE ESTADO
	local destroyed = false
	local listening = false
	local currentKey = defaultKey
	local connections = {}

	-- FUNÇÃO SEGURA DE CONEXÃO
	local function safeConnect(signal, func)
		local conn = signal:Connect(function(...)
			if destroyed then return end
			local ok, err = pcall(func, ...)
			if not ok then
				warn("[CreateBind:CallbackError]:", err)
			end
		end)
		table.insert(connections, conn)
		return conn
	end

	-- LISTEN SEGURO
	local function listenForKey()
		if listening or destroyed then return end
		listening = true
		button.Text = "Pressione..."

		local inputConn
		inputConn = safeConnect(UserInputService.InputBegan, function(input, processed)
			if destroyed or processed or not listening then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				currentKey = input.KeyCode
				pcall(function()
					if button then button.Text = currentKey.Name end
				end)
				listening = false
				if inputConn and inputConn.Connected then
					inputConn:Disconnect()
				end
			end
		end)
	end

	-- FEEDBACK SEGURO
	safeConnect(button.MouseEnter, function()
		if button and not destroyed then
			button.BackgroundColor3 = DESIGN.ItemHoverColor
		end
	end)

	safeConnect(button.MouseLeave, function()
		if button and not destroyed then
			button.BackgroundColor3 = DESIGN.InputBackgroundColor
		end
	end)

	safeConnect(button.MouseButton1Click, function()
		listenForKey()
	end)

	safeConnect(UserInputService.InputBegan, function(input, processed)
		if destroyed or processed then return end
		if input.KeyCode == currentKey and not self.Blocked then
			local ok, err = pcall(callback, currentKey)
			if not ok then
				warn("[BindError]:", err)
				pcall(function()
					if button and not destroyed then
						button.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
						task.delay(0.25, function()
							if button and not destroyed then
								button.BackgroundColor3 = DESIGN.InputBackgroundColor
							end
						end)
					end
				end)
			end
		end
	end)

	-- API PÚBLICA SEGURA
	local publicApi = {
		_instance = box,
		_connections = connections,
	}

	function publicApi:GetKey()
		return currentKey
	end

	function publicApi:SetKey(newKey)
		if destroyed then return end
		if typeof(newKey) == "EnumItem" and newKey.EnumType == Enum.KeyCode then
			currentKey = newKey
			pcall(function()
				if button then button.Text = newKey.Name end
			end)
		end
	end

	function publicApi:Listen()
		if not destroyed then
			listenForKey()
		end
	end

	function publicApi:Update(newOptions)
		if destroyed or not newOptions then return end
		pcall(function()
			if newOptions.Text then label.Text = newOptions.Text end
			if newOptions.Desc then desc = newOptions.Desc end
			if newOptions.Default then
				currentKey = newOptions.Default
				button.Text = newOptions.Default.Name
			end
		end)
	end

	function publicApi:Destroy()
		if destroyed then return end
		destroyed = true
		pcall(function()
			for _, conn in ipairs(connections) do
				if conn and conn.Connected then conn:Disconnect() end
			end
			table.clear(connections)
			if box then box:Destroy() end
		end)
	end

	table.insert(tab.Components, publicApi)
	box.Parent = tab.Container

	return publicApi
end

function Tekscripts:CreateDropdown(tab: any, options: {
    Title: string,
    Values: { { Name: string, Image: string? } },
    Callback: (selected: {string} | string) -> (),
    MultiSelect: boolean?,
    MaxVisibleItems: number?,
    InitialValues: {string}?
})
    -- Validações rápidas
    assert(type(tab) == "table" and tab.Container, "Objeto 'tab' inválido")
    assert(type(options) == "table" and type(options.Title) == "string" and type(options.Values) == "table", "Argumentos inválidos")

    local multiSelect = options.MultiSelect or false
    local maxVisibleItems = math.min(options.MaxVisibleItems or 5, 8)
    local itemHeight = 44
    local imagePadding = 8
    local imageSize = itemHeight - (imagePadding * 2)
    
    -- Container principal
    local box = Instance.new("Frame")
    box.AutomaticSize = Enum.AutomaticSize.Y
    box.Size = UDim2.new(1, 0, 0, 0)
    box.BackgroundColor3 = DESIGN.ComponentBackground
    box.BorderSizePixel = 0
    box.Parent = tab.Container
    addRoundedCorners(box, DESIGN.CornerRadius)

    local boxLayout = Instance.new("UIListLayout")
    boxLayout.Padding = UDim.new(0, 0)
    boxLayout.SortOrder = Enum.SortOrder.LayoutOrder
    boxLayout.Parent = box
    
    -- Header
    local main = Instance.new("Frame")
    main.Size = UDim2.new(1, 0, 0, 50)
    main.BackgroundTransparency = 1
    main.LayoutOrder = 1
    main.Parent = box

    local mainPadding = Instance.new("UIPadding")
    mainPadding.PaddingLeft = UDim.new(0, 12)
    mainPadding.PaddingRight = UDim.new(0, 12)
    mainPadding.PaddingTop = UDim.new(0, 12)
    mainPadding.PaddingBottom = UDim.new(0, 12)
    mainPadding.Parent = main

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = options.Title
    title.Size = UDim2.new(1, -110, 1, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = DESIGN.ComponentTextColor
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.Parent = main

    local botaoText = createButton("Selecionar ▼", UDim2.new(0, 100, 1, 0), main)
    botaoText.Name = "BotaoText"
    botaoText.Position = UDim2.new(1, -100, 0, 0)
    botaoText.TextSize = 13
    botaoText.Parent = main

    -- ScrollingFrame para itens
    local lister = Instance.new("ScrollingFrame")
    lister.Name = "Lister"
    lister.Size = UDim2.new(1, 0, 0, 0)
    lister.BackgroundTransparency = 1
    lister.BorderSizePixel = 0
    lister.ClipsDescendants = true
    lister.ScrollBarImageColor3 = DESIGN.AccentColor
    lister.ScrollBarThickness = 5
    lister.ScrollingDirection = Enum.ScrollingDirection.Y
    lister.CanvasSize = UDim2.new(0, 0, 0, 0)
    lister.AutomaticCanvasSize = Enum.AutomaticSize.Y
    lister.LayoutOrder = 2
    lister.Parent = box

    local listerLayout = Instance.new("UIListLayout")
    listerLayout.Padding = UDim.new(0, 4)
    listerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listerLayout.Parent = lister

    local listerPadding = Instance.new("UIPadding")
    listerPadding.PaddingLeft = UDim.new(0, 12)
    listerPadding.PaddingRight = UDim.new(0, 12)
    listerPadding.PaddingTop = UDim.new(0, 8)
    listerPadding.PaddingBottom = UDim.new(0, 12)
    listerPadding.Parent = lister

    -- Estado interno
    local isOpen = false
    local selectedValues = {}
    local connections = {}
    local itemElements = {}
    local itemOrder = {}

    -- Formata valores selecionados
    local function formatSelectedValues(values)
        if multiSelect then
            if #values == 0 then return "Nenhum item selecionado" end
            return table.concat(values, ", ")
        else
            return values or "Nenhum item selecionado"
        end
    end

    -- Atualiza texto do botão
    local function updateButtonText()
        local arrow = isOpen and "▲" or "▼"
        if #selectedValues == 0 then
            botaoText.Text = "Selecionar " .. arrow
        elseif #selectedValues == 1 then
            local displayText = selectedValues[1]
            if #displayText > 10 then displayText = string.sub(displayText, 1, 10) .. "..." end
            botaoText.Text = displayText .. " " .. arrow
        else
            botaoText.Text = string.format("%d itens %s", #selectedValues, arrow)
        end
    end

    -- Toggle dropdown
    local function toggleDropdown()
        isOpen = not isOpen
        local numItems = #itemOrder
        local totalItemHeight = (numItems * itemHeight) + ((numItems - 1) * listerLayout.Padding.Offset)
        local maxHeight = (maxVisibleItems * itemHeight) + ((maxVisibleItems - 1) * listerLayout.Padding.Offset)
        local targetHeight = isOpen and math.min(totalItemHeight + listerPadding.PaddingTop.Offset + listerPadding.PaddingBottom.Offset, maxHeight + listerPadding.PaddingTop.Offset + listerPadding.PaddingBottom.Offset) or 0
        
        lister.CanvasSize = UDim2.new(0, 0, 0, listerLayout.AbsoluteContentSize.Y)
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        TweenService:Create(lister, tweenInfo, { Size = UDim2.new(1, 0, 0, targetHeight) }):Play()
        updateButtonText()
    end

    -- Atualiza estado visual do item
    local function setItemSelected(valueName, isSelected)
        local elements = itemElements[valueName]
        if not elements then return end
        
        local targetColor = isSelected and DESIGN.AccentColor or DESIGN.ComponentBackground
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
        TweenService:Create(elements.container, tweenInfo, { BackgroundColor3 = targetColor }):Play()
        
        if elements.indicator then elements.indicator.Visible = isSelected end
    end

    -- Alterna seleção de item
    local function toggleItemSelection(valueName)
        local isCurrentlySelected = table.find(selectedValues, valueName)
        
        if multiSelect then
            if isCurrentlySelected then
                table.remove(selectedValues, isCurrentlySelected)
                setItemSelected(valueName, false)
            else
                table.insert(selectedValues, valueName)
                setItemSelected(valueName, true)
            end
        else
            for name, _ in pairs(itemElements) do setItemSelected(name, false) end
            if isCurrentlySelected then
                selectedValues = {}
            else
                selectedValues = { valueName }
                setItemSelected(valueName, true)
            end
            if isOpen and not isCurrentlySelected then task.delay(0.15, toggleDropdown) end
        end
        
        updateButtonText()
        local selected = multiSelect and selectedValues or (selectedValues[1] or nil)
        if options.Callback then options.Callback(selected) end
    end

    -- Cria item
    local function createItem(valueInfo, index)
        local hasImage = valueInfo.Image and valueInfo.Image ~= ""
        
        local itemContainer = Instance.new("TextButton")
        itemContainer.Name = "Item_" .. index
        itemContainer.Size = UDim2.new(1, 0, 0, itemHeight)
        itemContainer.BackgroundColor3 = DESIGN.ComponentBackground
        itemContainer.BorderSizePixel = 0
        itemContainer.Text = ""
        itemContainer.AutoButtonColor = false
        itemContainer.LayoutOrder = index
        itemContainer.Parent = lister
        addRoundedCorners(itemContainer, DESIGN.CornerRadius - 2)

        local itemPadding = Instance.new("UIPadding")
        itemPadding.PaddingLeft = UDim.new(0, 10)
        itemPadding.PaddingRight = UDim.new(0, 10)
        itemPadding.Parent = itemContainer

        local contentFrame = Instance.new("Frame")
        contentFrame.Size = UDim2.new(1, 0, 1, 0)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Parent = itemContainer

        local indicator
        if multiSelect then
            indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 18, 0, 18)
            indicator.Position = UDim2.new(1, -18, 0.5, -9)
            indicator.BackgroundColor3 = DESIGN.AccentColor
            indicator.BorderSizePixel = 0
            indicator.Visible = false
            indicator.Parent = contentFrame
            addRoundedCorners(indicator, UDim.new(0, 3))
            
            local checkIcon = Instance.new("TextLabel")
            checkIcon.Size = UDim2.new(1, 0, 1, 0)
            checkIcon.BackgroundTransparency = 1
            checkIcon.Text = "✓"
            checkIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
            checkIcon.Font = Enum.Font.GothamBold
            checkIcon.TextSize = 14
            checkIcon.Parent = indicator
        else
            indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 8, 0, 8)
            indicator.Position = UDim2.new(1, -8, 0.5, -4)
            indicator.BackgroundColor3 = DESIGN.AccentColor
            indicator.BorderSizePixel = 0
            indicator.Visible = false
            indicator.Parent = contentFrame
            addRoundedCorners(indicator, UDim.new(1, 0))
        end

        local foto
        if hasImage then
            foto = Instance.new("ImageLabel")
            foto.Name = "Foto"
            foto.Size = UDim2.new(0, imageSize, 0, imageSize)
            foto.Position = UDim2.new(0, 0, 0.5, -imageSize/2)
            foto.BackgroundTransparency = 1
            foto.Image = valueInfo.Image
            foto.ScaleType = Enum.ScaleType.Fit
            foto.Parent = contentFrame
            addRoundedCorners(foto, UDim.new(0, 4))
        end

        local textXOffset = hasImage and (imageSize + 8) or 0
        local textWidth = multiSelect and -30 or -12
        
        local itemText = Instance.new("TextLabel")
        itemText.Name = "ConteudoText"
        itemText.Size = UDim2.new(1, textWidth, 1, 0)
        itemText.Position = UDim2.new(0, textXOffset, 0, 0)
        itemText.BackgroundTransparency = 1
        itemText.Text = valueInfo.Name
        itemText.TextColor3 = DESIGN.ComponentTextColor
        itemText.Font = Enum.Font.Gotham
        itemText.TextSize = 14
        itemText.TextXAlignment = Enum.TextXAlignment.Left
        itemText.TextYAlignment = Enum.TextYAlignment.Center
        itemText.TextTruncate = Enum.TextTruncate.AtEnd
        itemText.Parent = contentFrame

        itemElements[valueInfo.Name] = {
            container = itemContainer,
            indicator = indicator,
            text = itemText,
            foto = foto,
            connections = {}
        }

        -- Eventos do item
        itemElements[valueInfo.Name].connections.MouseClick = itemContainer.MouseButton1Click:Connect(function()
            toggleItemSelection(valueInfo.Name)
        end)

        itemElements[valueInfo.Name].connections.MouseEnter = itemContainer.MouseEnter:Connect(function()
            if not table.find(selectedValues, valueInfo.Name) then
                TweenService:Create(itemContainer, TweenInfo.new(0.15), { BackgroundColor3 = DESIGN.ItemHoverColor or Color3.fromRGB(45, 45, 50) }):Play()
            end
        end)

        itemElements[valueInfo.Name].connections.MouseLeave = itemContainer.MouseLeave:Connect(function()
            if not table.find(selectedValues, valueInfo.Name) then
                TweenService:Create(itemContainer, TweenInfo.new(0.15), { BackgroundColor3 = DESIGN.ComponentBackground }):Play()
            end
        end)
    end

    -- Cria itens iniciais
    for index, valueInfo in ipairs(options.Values) do
        table.insert(itemOrder, valueInfo.Name)
        createItem(valueInfo, index)
    end

    -- Inicializa seleção
    if options.InitialValues then
        for _, valueToSelect in ipairs(options.InitialValues) do
            if itemElements[valueToSelect] then
                table.insert(selectedValues, valueToSelect)
                setItemSelected(valueToSelect, true)
            end
        end
        updateButtonText()
    end

    -- Evento do botão principal
    connections.ButtonClick = botaoText.MouseButton1Click:Connect(toggleDropdown)

    -- API pública
    local publicApi = {
        _instance = box,
        _connections = connections
    }

    function publicApi:AddItem(valueInfo, position)
        assert(type(valueInfo) == "table" and type(valueInfo.Name) == "string", "valueInfo inválido")
        assert(not itemElements[valueInfo.Name], "Item já existe")
        
        position = position or (#itemOrder + 1)
        position = math.clamp(position, 1, #itemOrder + 1)
        
        table.insert(itemOrder, position, valueInfo.Name)
        createItem(valueInfo, position)
        
        for i, name in ipairs(itemOrder) do
            if itemElements[name] then itemElements[name].container.LayoutOrder = i end
        end
        
        if isOpen then toggleDropdown() toggleDropdown() end
    end

    function publicApi:RemoveItem(valueName)
        assert(type(valueName) == "string", "valueName deve ser string")
        if itemElements[valueName] then
            local elements = itemElements[valueName]
            for _, conn in pairs(elements.connections) do
                if conn and conn.Connected then conn:Disconnect() end
            end
            elements.container:Destroy()
            itemElements[valueName] = nil
            
            local idx = table.find(itemOrder, valueName)
            if idx then table.remove(itemOrder, idx) end
            
            idx = table.find(selectedValues, valueName)
            if idx then table.remove(selectedValues, idx) end
            
            updateButtonText()
            local selected = multiSelect and selectedValues or (selectedValues[1] or nil)
            if options.Callback then options.Callback(selected) end
            
            if isOpen then toggleDropdown() toggleDropdown() end
        end
    end

    function publicApi:ClearItems()
        while #itemOrder > 0 do self:RemoveItem(itemOrder[1]) end
    end

    function publicApi:Destroy()
        if self._instance then
            for _, conn in pairs(self._connections) do
                if conn and conn.Connected then conn:Disconnect() end
            end
            for _, elements in pairs(itemElements) do
                for _, conn in pairs(elements.connections) do
                    if conn and conn.Connected then conn:Disconnect() end
                end
            end
            self._instance:Destroy()
            self._instance = nil
            itemElements = {}
            itemOrder = {}
            selectedValues = {}
        end
    end

    function publicApi:GetSelected()
        return multiSelect and selectedValues or (selectedValues[1] or nil)
    end

    function publicApi:GetSelectedFormatted()
        return formatSelectedValues(multiSelect and selectedValues or (selectedValues[1] or nil))
    end

    function publicApi:SetSelected(values)
        for name, _ in pairs(itemElements) do setItemSelected(name, false) end
        selectedValues = {}
        
        local valuesToSet = type(values) == "table" and values or {values}
        for _, value in ipairs(valuesToSet) do
            if itemElements[value] then
                table.insert(selectedValues, value)
                setItemSelected(value, true)
            end
        end
        
        updateButtonText()
        local selected = multiSelect and selectedValues or (selectedValues[1] or nil)
        if options.Callback then options.Callback(selected) end
    end

    function publicApi:Toggle()
        toggleDropdown()
    end

    function publicApi:Close()
        if isOpen then toggleDropdown() end
    end

    table.insert(tab.Components, publicApi)
    return publicApi
end

function Tekscripts:CreateDialog(options)
    assert(type(options) == "table", "Invalid options")

    local titleText = options.Title or "Título"
    local messageText = options.Message or "Mensagem"
    local buttons = options.Buttons or { {Text = "Ok", Callback = function() end} }

    local player = game:GetService("Players").LocalPlayer
    local PlayerGui = player:WaitForChild("PlayerGui")

    local screen = Instance.new("ScreenGui")
    screen.Name = "TekscriptsDialog"
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.ResetOnSpawn = false
    screen.Parent = PlayerGui

    local box = Instance.new("Frame")
    box.Name = "DialogBox"
    box.Size = UDim2.new(0, 340, 0, 0)
    box.AnchorPoint = Vector2.new(0.5, 0.5)
    box.Position = UDim2.new(0.5, 0, 0.5, 0)
    box.BackgroundColor3 = DESIGN.ComponentBackground
    box.AutomaticSize = Enum.AutomaticSize.Y
    box.ZIndex = 1000
    box.Parent = screen

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius)
    corner.Parent = box

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, DESIGN.ComponentPadding)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = box

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, DESIGN.TitlePadding)
    padding.PaddingBottom = UDim.new(0, DESIGN.TitlePadding)
    padding.PaddingLeft = UDim.new(0, DESIGN.ComponentPadding)
    padding.PaddingRight = UDim.new(0, DESIGN.ComponentPadding)
    padding.Parent = box

    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = titleText
    title.Size = UDim2.new(1, 0, 0, DESIGN.TitleHeight)
    title.BackgroundTransparency = 1
    title.TextColor3 = DESIGN.TitleColor
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.ZIndex = 1001
    title.LayoutOrder = 1
    title.Parent = box

    -- Linha separadora (HR)
    local hr = Instance.new("Frame")
    hr.Name = "TitleDivider"
    hr.Size = UDim2.new(1, 0, 0, 2)
    hr.BackgroundColor3 = DESIGN.DividerColor or Color3.fromRGB(200,200,200)
    hr.BorderSizePixel = 0
    hr.ZIndex = 1001
    hr.LayoutOrder = 2
    hr.Parent = box

    -- Mensagem
    local message = Instance.new("TextLabel")
    message.Name = "Message"
    message.Text = messageText
    message.Size = UDim2.new(1, 0, 0, 0)
    message.AutomaticSize = Enum.AutomaticSize.Y
    message.BackgroundTransparency = 1
    message.TextWrapped = true
    message.TextColor3 = DESIGN.ComponentTextColor
    message.Font = Enum.Font.Gotham
    message.TextSize = 14
    message.TextXAlignment = Enum.TextXAlignment.Center
    message.TextYAlignment = Enum.TextYAlignment.Center
    message.ZIndex = 1001
    message.LayoutOrder = 3
    message.Parent = box

    -- Botões
    local buttonHolder = Instance.new("Frame")
    buttonHolder.Name = "ButtonHolder"
    buttonHolder.Size = UDim2.new(1, 0, 0, 36)
    buttonHolder.BackgroundTransparency = 1
    buttonHolder.LayoutOrder = 4
    buttonHolder.ZIndex = 1001
    buttonHolder.Parent = box

    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLayout.Padding = UDim.new(0, DESIGN.ComponentPadding)
    btnLayout.Parent = buttonHolder

    local connections = {}

    for i, btnInfo in ipairs(buttons) do
        local btn = Instance.new("TextButton")
        btn.Name = btnInfo.Text or ("Button" .. i)
        btn.Size = UDim2.new(0, 100, 0, 30)
        btn.BackgroundColor3 = DESIGN.InputBackgroundColor
        btn.TextColor3 = DESIGN.InputTextColor
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Text = btnInfo.Text or "Button"
        btn.ZIndex = 1002
        btn.AutoButtonColor = false
        btn.Parent = buttonHolder

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, DESIGN.CornerRadius / 2)
        btnCorner.Parent = btn

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = DESIGN.ComponentHoverColor
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = DESIGN.InputBackgroundColor
        end)

        table.insert(connections, btn.MouseButton1Click:Connect(function()
            if btnInfo.Callback then pcall(btnInfo.Callback) end
            screen:Destroy()
        end))
    end

    local api = {
        _screen = screen,
        _connections = connections
    }

    function api:Destroy()
        for _, c in ipairs(connections) do
            if c.Connected then c:Disconnect() end
        end
        screen:Destroy()
    end

    return api
end
return Tekscripts