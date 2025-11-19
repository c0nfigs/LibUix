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
    WindowTransparency = 0.1, -- Quase transparente
    TabContainerTransparency = 0.15,

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
    MaxWindowSize = Vector2.new(780, 370),
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

-- Necessário que esta função exista no módulo principal (Tekscripts) para funcionar corretamente.
function Tekscripts:HideCloseButton()
    if self.CloseButtonContainer and self.CloseButtonContainer.Parent then
        self.CloseButtonContainer.Visible = false
    end
end

-- Certifique-se de que a função :Destroy() está configurada para limpar corretamente.
-- Exemplo de como :Destroy() deve ser (incluindo a nova chamada):
function Tekscripts:Destroy()
    -- 1. Desliga o botão de fechar individualmente.
    self:HideCloseButton() 
    
    -- 2. Limpa o ScreenGui e conexões (supondo que o restante da sua lógica faça isso)
    for _, conn in pairs(self.Connections) do
        conn:Disconnect()
    end
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

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
        
        -- VARIÁVEIS RENOMEADAS
        CloseButtonContainer = nil, 
        CloseButton = nil,
        -- FIM DAS VARIÁVEIS RENOMEADAS
        
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
    self.Window.BackgroundTransparency = DESIGN.WindowTransparency or 0.1 
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
	icon.Image = options.iconId or "rbxassetid://105089076803454"
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
    controlBtn.Name = "ControlBtn"
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
    
    -- ADIÇÃO: O botão de fechar é escondido quando o painel é minimizado
    self.Connections.MinimizeClick = minimizeBtn.MouseButton1Click:Connect(function()
        self:Minimize()
        self:HideCloseButton() -- Garante que desapareça
    end)
    
    -- Sistema de arrastar (otimizado, sem tweens por frame)
    self:SetupDragSystem()
    
    
    -- // BOTÃO DE FECHAR (SIMPLIFICADO - CORREÇÃO DE POSICIONAMENTO)
    
    -- Container do botão de fechar 
    self.CloseButtonContainer = Instance.new("Frame")
    local buttonWidth = DESIGN.DropdownWidth or 100 
    local buttonHeight = DESIGN.DropdownItemHeight or 25
    self.CloseButtonContainer.Size = UDim2.new(0, buttonWidth + 10, 0, buttonHeight + 10)
    
    -- Posição será ajustada para ser relativa ao controlBtn DENTRO do TitleBar
    self.CloseButtonContainer.BackgroundColor3 = DESIGN.DropdownBackground
    self.CloseButtonContainer.BackgroundTransparency = DESIGN.DropdownTransparency or 0
    self.CloseButtonContainer.BorderSizePixel = 0
    self.CloseButtonContainer.Visible = false
    self.CloseButtonContainer.ZIndex = 10 
    
    -- CORREÇÃO CHAVE: Mudar o Parent para o Window (Painel Principal)
    -- Isso faz com que a posição seja calculada em relação ao painel e se mova junto.
    self.CloseButtonContainer.Parent = self.Window 

    addRoundedCorners(self.CloseButtonContainer)

    -- Botão "Fechar"
    local closeOption = Instance.new("TextButton")
    closeOption.Name = "CloseButton"
    closeOption.Text = "Fechar"
    closeOption.Size = UDim2.new(1, -10, 1, -10) 
    closeOption.Position = UDim2.new(0, 5, 0, 5)
    
    closeOption.BackgroundColor3 = DESIGN.DropdownBackground 
    closeOption.BackgroundTransparency = 1 
    
    closeOption.TextColor3 = DESIGN.CloseButtonColor
    closeOption.Font = Enum.Font.Roboto
    closeOption.TextScaled = true 
    closeOption.TextTransparency = 0 
    closeOption.ZIndex = 11 

    closeOption.TextXAlignment = Enum.TextXAlignment.Center 
    closeOption.TextYAlignment = Enum.TextYAlignment.Center 

    closeOption.BorderSizePixel = 0
    closeOption.Parent = self.CloseButtonContainer
    self.CloseButton = closeOption
    
    addRoundedCorners(closeOption, 5)
    addHoverEffect(closeOption, closeOption.BackgroundColor3, DESIGN.DropdownItemHover)

    -- CORREÇÃO: Chama self:Destroy() e esconde o botão individualmente.
    self.Connections.CloseClick = closeOption.MouseButton1Click:Connect(function()
        self:Destroy()
        -- Não precisa esconder o container aqui, pois Destroy já fará isso (se implementado)
    end)


    -- Conexões do Botão de Controle (ControlBtn)
    self.Connections.ControlBtn = controlBtn.MouseButton1Click:Connect(function()
        local isOpening = not self.CloseButtonContainer.Visible
        self.CloseButtonContainer.Visible = isOpening
        
        if isOpening then
            -- Para que o CloseButtonContainer seja relativo ao Window, 
            -- precisamos calcular a posição do controlBtn DENTRO do Window.
            
            local controlBtnAbsPos = controlBtn.AbsolutePosition
            local windowAbsPos = self.Window.AbsolutePosition
            local closeBtnSize = self.CloseButtonContainer.AbsoluteSize
            
            -- Posição Relativa X: Posição Absoluta do ControlBtn - Posição Absoluta do Window.
            local relativeX = controlBtnAbsPos.X - windowAbsPos.X
            
            -- Ajuste Final X: Alinha o lado direito do botão de fechar com o ControlBtn.
            local newXOffset = relativeX + controlBtn.AbsoluteSize.X - closeBtnSize.X
            
            -- Posição Relativa Y: Fica logo abaixo do TitleBar (altura TitleHeight + 2px de padding)
            local newYOffset = DESIGN.TitleHeight + 2

            -- Aplica a nova posição (agora como Offset, pois o parent é o Window)
            self.CloseButtonContainer.Position = UDim2.new(0, newXOffset, 0, newYOffset)
        end
    end)

    -- Conexão para fechar se clicar fora do botão (Mantém a lógica de InputBegan, mas usa self.Window)
    self.Connections.InputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if self.CloseButtonContainer.Visible and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local closePos = self.CloseButtonContainer.AbsolutePosition
            local closeSize = self.CloseButtonContainer.AbsoluteSize
            local controlBtnPos = controlBtn.AbsolutePosition
            local controlBtnSize = controlBtn.AbsoluteSize

            local isOutsideClose = mousePos.X < closePos.X or mousePos.X > closePos.X + closeSize.X or mousePos.Y < closePos.Y or mousePos.Y > closePos.Y + closeSize.Y
            local isOutsideControlBtn = mousePos.X < controlBtnPos.X or mousePos.X > controlBtnPos.X + controlBtnSize.X or mousePos.Y < controlBtnPos.Y or mousePos.Y > controlBtnPos.Y + controlBtnSize.Y

            if isOutsideClose and isOutsideControlBtn then
                self.CloseButtonContainer.Visible = false
            end
        end
    end)
    
    
    -- // CONTAINER DAS ABAS (TAB CONTAINER)
    
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = self:_GetTabContainerSize()
    self.TabContainer.Position = UDim2.new(0, 0, 0, DESIGN.TitleHeight)
    self.TabContainer.BackgroundColor3 = DESIGN.WindowColor2
    self.TabContainer.BackgroundTransparency = DESIGN.TabContainerTransparency or 0.1 
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
    self:SetupFloatButton(options.FloatText or "Expandir")

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
    local UIS = game:GetService("UserInputService")

    self.Connections.DragBegin = self.TitleBar.InputBegan:Connect(function(input)
        if self.Blocked or self.MinimizedState then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            
            self.IsDragging = true

            local pos = Vector2.new(input.Position.X, input.Position.Y)

            -- Pega o offset correto (dedo - posição da janela)
            local absPos = self.Window.AbsolutePosition
            self._offset = Vector2.new(pos.X - absPos.X, pos.Y - absPos.Y)
        end
    end)

    self.Connections.DragChanged = UIS.InputChanged:Connect(function(input)
        if not self.IsDragging or self.Blocked or self.MinimizedState then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            
            local pos = Vector2.new(input.Position.X, input.Position.Y)

            -- Nova posição = dedo - offset
            local newX = pos.X - self._offset.X
            local newY = pos.Y - self._offset.Y

            self.Window.Position = UDim2.fromOffset(newX, newY)
        end
    end)

    self.Connections.DragEnded = UIS.InputEnded:Connect(function(input)
        if not self.IsDragging then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            
            self.IsDragging = false

            if not self.MinimizedState then
                print("ok")
            end
        end
    end)
end

---
-- Sistema de Redimensionamento (atualização direta)
---
function Tekscripts:SetupResizeSystem()
    local GripVisualSize = 30  -- tamanho do frame pai (só pra organizar)

    -- ==================== GRIP VISUAL (agora fica FORA do painel, na borda externa) ====================
    local ResizeGrip = Instance.new("Frame")
    ResizeGrip.Name = "ResizeGripVisual"
    ResizeGrip.Size = UDim2.new(0, GripVisualSize, 0, GripVisualSize)
    ResizeGrip.Position = UDim2.new(1, -12, 1, -12)  -- começa um pouco pra dentro só pra ancorar
    ResizeGrip.BackgroundTransparency = 1
    ResizeGrip.ClipsDescendants = false  -- ESSENCIAL pra linhas saírem pra fora
    ResizeGrip.ZIndex = 10
    ResizeGrip.Parent = self.Window
    self.ResizeHandle = ResizeGrip

    -- Cria as 3 linhas que tocam a borda externa (igual WindUI)
    local function createLine(offset)
        local line = Instance.new("Frame")
        line.BackgroundColor3 = DESIGN.ResizeHandleColor or Color3.fromRGB(160, 160, 160)
        line.BorderSizePixel = 0
        line.Size = UDim2.new(0, 14, 0, 2)
        line.AnchorPoint = Vector2.new(1, 1)
        line.Position = UDim2.new(1, 2 + offset * -7, 1, 2 + offset * -7)  -- sai pra fora com valores positivos aqui + anchor 1,1
        line.Rotation = 45
        line.BackgroundTransparency = 1
        line.ZIndex = 10
        line.Parent = ResizeGrip
        return line
    end

    local line1 = createLine(0)  -- a mais externa (toca na borda)
    local line2 = createLine(1)
    local line3 = createLine(2)  -- a mais interna

    -- Animação de hover
    local function setHover(hovering)
        local target = hovering and 0 or 1
        local tween = TweenService:Create(line1, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundTransparency = target})
        TweenService:Create(line2, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundTransparency = target}):Play()
        TweenService:Create(line3, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundTransparency = target}):Play()
        tween:Play()
    end

    -- ==================== HITBOX (área de clique grande) ====================
    local Hitbox = Instance.new("Frame")
    Hitbox.Name = "ResizeHitbox"
    Hitbox.Size = UDim2.new(0, 40, 0, 40)
    Hitbox.Position = UDim2.new(1, -40, 1, -40)
    Hitbox.BackgroundTransparency = 1
    Hitbox.ZIndex = 10
    Hitbox.Parent = self.Window

    -- Hover + cursor
    self.Connections.ResizeMouseEnter = Hitbox.MouseEnter:Connect(function()
        setHover(true)
        UserInputService.MouseIcon = "rbxassetid://6258410714"
    end)

    self.Connections.ResizeMouseLeave = Hitbox.MouseLeave:Connect(function()
        setHover(false)
        if not self.IsDragging and not self.IsResizing then
            UserInputService.MouseIcon = ""
        end
    end)

    -- ==================== REDIMENSIONAMENTO ====================
    self.Connections.ResizeBegin = Hitbox.InputBegan:Connect(function(input)
        if self.Blocked or input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        self.IsResizing = true
        self._resizeStart = input.Position
        self._startSize = self.Window.Size
    end)

    self.Connections.ResizeChanged = UserInputService.InputChanged:Connect(function(input)
        if not self.IsResizing or self.Blocked then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local delta = input.Position - self._resizeStart
        local screen = workspace.CurrentCamera.ViewportSize
        local maxW = math.min(DESIGN.MaxWindowSize.X, screen.X * 0.9)
        local maxH = math.min(DESIGN.MaxWindowSize.Y, screen.Y * 0.9)

        local newW = math.clamp(self._startSize.X.Offset + delta.X, DESIGN.MinWindowSize.X, maxW)
        local newH = math.clamp(self._startSize.Y.Offset + delta.Y, DESIGN.MinWindowSize.Y, maxH)

        self.Window.Size = UDim2.new(0, newW, 0, newH)
        self:UpdateContainersSize()
    end)

    self.Connections.ResizeEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.IsResizing = false
            if not self.IsDragging then UserInputService.MouseIcon = "" end
            setHover(false)
        end
    end)
end

-- Atualização da posição (agora o grip sempre fica colado na borda externa)
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

    -- Grip visual sempre encostado na borda externa
    if self.ResizeHandle then
        self.ResizeHandle.Position = UDim2.new(1, -12, 1, -12)
    end

    -- Hitbox sempre no canto
    local hitbox = self.Window:FindFirstChild("ResizeHitbox")
    if hitbox then
        hitbox.Position = UDim2.new(1, -40, 1, -40)
    end
end
---
-- Float Button (otimizado)
---
function Tekscripts:SetupFloatButton(text: string)
    local UIS = game:GetService("UserInputService")

    -- Frame principal
    local float = Instance.new("Frame")
    float.Name = "FloatButton"
    float.Size = UDim2.new(0, 180, 0, 45)
    float.Position = UDim2.new(1, -200, 0, 20)
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

    -- BOTÃO DE ARRASTAR (esquerda)
    local dragBtn = Instance.new("TextButton")
    dragBtn.Name = "DragButton"
    dragBtn.Size = UDim2.new(0, 45, 1, 0)
    dragBtn.Position = UDim2.new(0, 0, 0, 0)
    dragBtn.BackgroundColor3 = DESIGN.FloatButtonColor
    dragBtn.BorderSizePixel = 0
    dragBtn.Text = "≡"
    dragBtn.TextScaled = true
    dragBtn.Font = Enum.Font.RobotoMono  -- ✔️ corrigido
    dragBtn.TextColor3 = DESIGN.ComponentTextColor
    dragBtn.Parent = float

    addHoverEffect(dragBtn, nil, DESIGN.ComponentHoverColor)

    -- BOTÃO DE AÇÃO (texto - abre painel)
    local actionBtn = Instance.new("TextButton")
    actionBtn.Name = "ActionButton"
    actionBtn.Size = UDim2.new(1, -45, 1, 0)
    actionBtn.Position = UDim2.new(0, 45, 0, 0)
    actionBtn.BackgroundTransparency = 1
    actionBtn.Text = text
    actionBtn.Font = Enum.Font.Roboto  -- ✔️ fonte válida
    actionBtn.TextScaled = true
    actionBtn.TextColor3 = DESIGN.ComponentTextColor
    actionBtn.Parent = float

    addHoverEffect(actionBtn, nil, DESIGN.ComponentHoverColor)

    -- Abre painel ao clicar no texto
    self.Connections.FloatExpand = actionBtn.MouseButton1Click:Connect(function()
        if not self.Blocked then
            self:ExpandFromFloat()
        end
    end)

    -- SISTEMA DE DRAG (somente no botão da esquerda)
    local dragging = false
    local dragStart
    local startPos

    self.Connections.FloatBegin = dragBtn.InputBegan:Connect(function(input)
        if self.Blocked then return end

        if input.UserInputType == Enum.UserInputType.MouseButton1 
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = UIS:GetMouseLocation()
            startPos = float.Position
        end
    end)

    self.Connections.FloatChange = UIS.InputChanged:Connect(function(input)
        if not dragging or self.Blocked then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement 
        or input.UserInputType == Enum.UserInputType.Touch then
            
            local delta = UIS:GetMouseLocation() - dragStart

            float.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    self.Connections.FloatEnd = UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
        or input.UserInputType == Enum.UserInputType.Touch then
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

    local tab = Tab.new(title, self.TabContentContainer)
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

    -- CORREÇÃO
    self.NoTabsLabel.Visible = next(self.Tabs) == nil

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
                local nextTabKey = next(parent.Tabs)
                local nextTab = nextTabKey and parent.Tabs[nextTabKey] or nil

                parent.CurrentTab = nextTab
                parent.NoTabsLabel.Visible = nextTab == nil

                if nextTab then
                    parent:SetActiveTab(nextTab)
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
    container.BackgroundColor3 = DESIGN.ComponentBackground -- Usando cor do DESIGN
    -- AQUI 1: Aplica a transparência da janela/componente
    container.BackgroundTransparency = DESIGN.WindowTransparency or DESIGN.TabContainerTransparency 
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
    header.TextColor3 = DESIGN.TitleColor or Color3.fromRGB(255, 255, 255)
    header.TextSize = 16
    header.Font = Enum.Font.GothamBold
    -- AQUI 2: Garante que o texto do cabeçalho caiba no Box
    header.TextScaled = true
    header.TextWrapped = true 
    header.Parent = container

    -- Linha divisória opcional
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.Position = UDim2.new(0, 0, 0, 25)
    divider.BackgroundColor3 = DESIGN.DividerColor or Color3.fromRGB(60, 60, 60)
    divider.BorderSizePixel = 0
    divider.Parent = container

    -- Botão principal
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, -25)
    button.Position = UDim2.new(0, 0, 0, 25)
    button.BackgroundColor3 = DESIGN.InputBackgroundColor or Color3.fromRGB(40, 40, 40)
    button.Text = text
    button.TextColor3 = DESIGN.InputTextColor or Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = not block
    button.TextScaled = true 
    button.TextWrapped = true 
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

function Tekscripts:CreateSection(tab: any, options: { Title: string?, Open: boolean?, Fixed: boolean? })
    assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateSection")

    local DESIGN = DESIGN or {}
    local minClosedHeight = 30 
    local titleHeight = 30
    local contentPadding = 10 

    local TweenService = game:GetService("TweenService")

    -- (Todas as INSTÂNCIAS DE GUI permanecem as mesmas, incluindo a lógica de hover e a transparência aplicada anteriormente)
    
    -- Container principal da section
    local sectionContainer = Instance.new("Frame")
    sectionContainer.BackgroundColor3 = DESIGN.ComponentBackground or Color3.fromRGB(30, 30, 30)
    sectionContainer.BackgroundTransparency = DESIGN.TabContainerTransparency
    sectionContainer.BorderSizePixel = 0
    sectionContainer.ClipsDescendants = true
    sectionContainer.Parent = tab.Container

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 8)
    uicorner.Parent = sectionContainer

    -- Frame do título com fundo interativo
    local titleFrame = Instance.new("Frame")
    titleFrame.BackgroundColor3 = DESIGN.ComponentBackground or Color3.fromRGB(40, 40, 40)
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
    titleLabel.TextSize = 18 
    titleLabel.TextColor3 = DESIGN.ComponentTextColor or Color3.fromRGB(230, 230, 230) 
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
    arrowLabel.TextColor3 = DESIGN.ComponentTextColor or Color3.fromRGB(230, 230, 230)
    arrowLabel.BackgroundTransparency = 1
    arrowLabel.Size = UDim2.new(0, 20, 0, 20)
    arrowLabel.Position = UDim2.new(1, -25, 0, 5)
    arrowLabel.ZIndex = 3
    arrowLabel.Parent = titleFrame
    arrowLabel.TextYAlignment = Enum.TextYAlignment.Center

    -- Linha separadora
    local separatorLine = Instance.new("Frame")
    separatorLine.BackgroundColor3 = DESIGN.HRColor or Color3.fromRGB(100, 100, 100)
    separatorLine.Size = UDim2.new(1, -20, 0, 1)
    separatorLine.Position = UDim2.new(0, 10, 0, titleHeight - 1)
    separatorLine.BorderSizePixel = 0
    separatorLine.ZIndex = 2
    separatorLine.Parent = sectionContainer

    -- Lógica de Hover (mantida)
    local function setHover(state)
        local targetTransparency = state and 0 or 0.2
        local targetTextSize = state and 20 or 18 
        local targetColor = state and (DESIGN.ComponentHoverColor or Color3.fromRGB(200, 200, 200))
                            or (DESIGN.ComponentTextColor or Color3.fromRGB(230, 230, 230))
        
        TweenService:Create(titleFrame, TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { BackgroundTransparency = targetTransparency }):Play()
        TweenService:Create(titleLabel, TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { TextSize = targetTextSize, TextColor3 = targetColor }):Play()
        TweenService:Create(arrowLabel, TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { TextColor3 = targetColor }):Play()
    end

    titleFrame.MouseEnter:Connect(function() setHover(true) end)
    titleFrame.MouseLeave:Connect(function() setHover(false) end)
    
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
    
    -- Overlay de bloqueio (mantido)
    local blockOverlay = Instance.new("Frame")
    blockOverlay.BackgroundColor3 = DESIGN.ComponentBackground or Color3.fromRGB(20, 20, 20)
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
    blockLabel.TextColor3 = DESIGN.ComponentTextColor or Color3.fromRGB(255, 255, 255)
    blockLabel.TextSize = 24
    blockLabel.TextScaled = false
    blockLabel.BackgroundTransparency = 1
    blockLabel.Size = UDim2.new(1, 0, 1, 0)
    blockLabel.TextXAlignment = Enum.TextXAlignment.Center
    blockLabel.TextYAlignment = Enum.TextYAlignment.Center
    blockLabel.TextWrapped = true
    blockLabel.ZIndex = 6
    blockLabel.Parent = blockOverlay
    
    -- Conexão para atualizar tamanho do overlay (mantida)
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
        
        TweenService:Create(sectionContainer, tweenInfo, { Size = UDim2.new(1, 0, 0, targetHeight) }):Play()
        
        -- Animação da Rotação da Seta
        local targetRotation = open and 180 or 0 
        TweenService:Create(arrowLabel, tweenInfo, { Rotation = targetRotation }):Play()

        -- Atualiza o tamanho do overlay
        if blockOverlay.Visible and open then
            blockOverlay.Size = UDim2.new(1, 0, 0, contentHeight)
        elseif not open then
             TweenService:Create(blockOverlay, tweenInfo, { Size = UDim2.new(1, 0, 0, 0) }):Play()
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

    --- API APRIMORADA DE USABILIDADE
    
    -- Melhorado: Renomeado para AddComponent, focando na instância
    function publicApi:AddComponent(component)
        if component and component._instance then
            component._instance.Parent = contentContainer
            table.insert(publicApi.Components, component)
            -- Use task.spawn para garantir que a atualização de altura não bloqueie a thread principal
            task.spawn(updateHeight)
            return component
        else
            warn("[Section] Componente inválido ou faltando '_instance' para AddComponent")
        end
    end
    
    function publicApi:SetTitle(text)
        titleLabel.Text = text or ""
    end
    
    -- Adicionado: Método explícito para Abrir
    function publicApi:Open()
        if fixed or open then return end
        open = true
        blockOverlay.Visible = publicApi._blocked -- Atualiza visibilidade do bloco ao abrir
        updateHeight()
    end
    
    -- Adicionado: Método explícito para Fechar
    function publicApi:Close()
        if fixed or not open then return end
        open = false
        -- O updateHeight já trata a animação de esconder o overlay
        updateHeight()
    end

    -- Toggle (Mantido, mas usa os novos métodos)
    function publicApi:Toggle()
        if open then
            publicApi:Close()
        else
            publicApi:Open()
        end
    end
    
    -- Ajuste de Evento (Mantido, usa o novo Toggle)
    titleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            publicApi:Toggle()
        end
    end)
    
    -- Melhorado: Força a atualização de visibilidade do overlay imediatamente
    function publicApi:Block(state: boolean, message: string?)
        publicApi._blocked = state
        blockLabel.Text = message or "Bloqueado"
        
        -- Garante que o estado do overlay reflita o estado atual da seção
        blockOverlay.Visible = state and open
        
        if state and open then
            -- Se for bloquear e estiver aberta, ajusta o tamanho imediatamente
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
    box.BackgroundTransparency = DESIGN.TabContainerTransparency
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
    -- AQUI ESTÁ A MUDANÇA: Usando a transparência da aba para o componente de fundo.
    box.BackgroundTransparency = DESIGN.TabContainerTransparency
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
    -- AQUI 1: Aplica a transparência da aba ao container principal
    box.BackgroundTransparency = DESIGN.TabContainerTransparency
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
        -- AQUI 2: Aplica a transparência da aba ao container de cada item
        itemContainer.BackgroundTransparency = DESIGN.TabContainerTransparency 
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
                -- O hover deve ter uma cor ligeiramente diferente, mas ainda respeitar a transparência base.
                -- A cor de BackgroundColor3 será interpolada pelo TweenService
                TweenService:Create(itemContainer, TweenInfo.new(0.15), { BackgroundColor3 = DESIGN.ItemHoverColor or Color3.fromRGB(45, 45, 50) }):Play()
            end
        end)

        itemElements[valueInfo.Name].connections.MouseLeave = itemContainer.MouseLeave:Connect(function()
            if not table.find(selectedValues, valueInfo.Name) then
                -- Retorna para a cor de fundo original, que tem a transparência já definida.
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

function Tekscripts:CreateToggle(tab: any, options: { Text: string, Desc: string?, Callback: (state: boolean) -> (), Type: "Toggle" | "CheckBox" | nil })
    assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateToggle")
    assert(type(options) == "table" and type(options.Text) == "string", "Invalid arguments for CreateToggle")

    local TweenService = game:GetService("TweenService")
    local TextService = game:GetService("TextService")
    
    local componentType = options.Type and string.lower(options.Type) == "checkbox" and "CheckBox" or "Toggle"

    local padding = 6
    local descMinHeight = 18 -- Altura mínima por linha da descrição (para o cálculo inicial)
    local descHeight
    
    -- Calcula uma estimativa de altura para o texto da descrição
    if options.Desc then
        local textSize = TextService:GetTextSize(
            options.Desc, 
            14, -- TextSize
            Enum.Font.Roboto, 
            Vector2.new(tab.Container.AbsoluteSize.X * 0.7 - 10, 1000) -- Largura máxima
        )
        -- Altura total da descrição, arredondada para o próximo múltiplo de descMinHeight + um pequeno padding
        descHeight = math.ceil(textSize.Y / descMinHeight) * descMinHeight + padding
    else
        descHeight = 0
    end
    
    local totalHeight = DESIGN.ComponentHeight + descHeight + padding
    
    -- Se o cálculo não for preciso, garante uma altura mínima se houver descrição.
    if options.Desc and totalHeight < DESIGN.ComponentHeight + descMinHeight * 2 then
        totalHeight = DESIGN.ComponentHeight + descMinHeight * 2
    end

    -- Outer box
    local outerBox = Instance.new("Frame")
    outerBox.Size = UDim2.new(1, 0, 0, totalHeight)
    outerBox.BackgroundColor3 = DESIGN.ComponentBackground
    -- AQUI: Aplica a transparência definida no DESIGN
    outerBox.BackgroundTransparency = DESIGN.TabContainerTransparency 
    outerBox.BorderSizePixel = 0
    outerBox.Parent = tab.Container
    addRoundedCorners(outerBox, DESIGN.CornerRadius)

    -- Internal container (usa UIListLayout para empilhar Label e Desc)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -DESIGN.ComponentPadding*2, 1, 0)
    container.Position = UDim2.new(0, DESIGN.ComponentPadding, 0, 0)
    container.BackgroundTransparency = 1
    container.Parent = outerBox
    
    -- Layout para organizar Text e DescLabel
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 0)
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    listLayout.Parent = container

    -- Label
    local label = Instance.new("TextLabel")
    label.Text = options.Text
    label.Size = UDim2.new(0.7, -10, 0, DESIGN.ComponentHeight)
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
        -- Altura relativa dentro do espaço calculado
        descLabel.Size = UDim2.new(0.7, -10, 0, descHeight - padding) 
        descLabel.BackgroundTransparency = 1
        descLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
        descLabel.Font = Enum.Font.Roboto
        descLabel.TextScaled = false
        descLabel.TextSize = 14
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        -- NOVIDADE: Habilita quebra de linha
        descLabel.TextWrapped = true
        descLabel.Parent = container
    end

    -- Switch/Checkbox Control
    local controlSize = componentType == "CheckBox" and Vector2.new(24, 24) or Vector2.new(50, 24)
    local controlCornerRadius = componentType == "CheckBox" and 2 or 100 -- Canto quadrado para CheckBox

    local control = Instance.new("TextButton")
    control.Size = UDim2.new(0, controlSize.X, 0, controlSize.Y)
    -- Centraliza verticalmente
    control.Position = UDim2.new(1, -controlSize.X - DESIGN.ComponentPadding, 0.5, -controlSize.Y/2) 
    control.BackgroundColor3 = DESIGN.InactiveToggleColor
    control.Text = ""
    control.AutoButtonColor = false
    control.ClipsDescendants = true
    control.Parent = outerBox -- Colocado em outerBox para ignorar o UIListLayout
    addRoundedCorners(control, controlCornerRadius)
    
    -- Knob/Checkmark
    local knob
    if componentType == "Toggle" then
        -- Toggle Knob
        knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 20, 0, 20)
        knob.Position = UDim2.new(0, 2, 0, 2)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Parent = control
        addRoundedCorners(knob, 100)
    else 
        -- CheckBox Checkmark
        knob = Instance.new("TextLabel")
        knob.Text = "✔"
        knob.Size = UDim2.new(1, 0, 1, 0)
        knob.BackgroundTransparency = 1
        knob.TextColor3 = Color3.fromRGB(255, 255, 255)
        knob.Font = Enum.Font.Roboto
        knob.TextScaled = true
        knob.TextSize = 24 -- Apenas um valor base, TextScaled fará o trabalho
        knob.TextWrapped = true
        knob.Visible = false -- Fica visível apenas quando 'state' for true
        knob.Parent = control
    end

    -- Error indicator (Mantido no control/switch)
    local errorIndicator = Instance.new("Frame")
    errorIndicator.Size = UDim2.new(0, 8, 0, 8)
    errorIndicator.Position = UDim2.new(1, -10, 0, 2)
    errorIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    errorIndicator.Visible = false
    errorIndicator.Parent = control
    addRoundedCorners(errorIndicator, 100)

    -- Internal state
    local state = false
    local locked = false
    local inError = false
    local connections = {}

    local function animateControl(newState)
        if not control or not knob then return end
        
        local activeColor = inError and Color3.fromRGB(255,60,60) or DESIGN.ActiveToggleColor
        local inactiveColor = inError and Color3.fromRGB(255,60,60) or DESIGN.InactiveToggleColor
        
        TweenService:Create(control, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            BackgroundColor3 = newState and activeColor or inactiveColor
        }):Play()

        if componentType == "Toggle" then
            TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Position = newState and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
            }):Play()
        else
            -- CheckBox: Visibilidade e cor do fundo
            knob.Visible = newState
            if newState then
                -- CheckBox ativo usa a cor de ativo
                TweenService:Create(control, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = activeColor
                }):Play()
            else
                -- CheckBox inativo usa a cor de inativo ou background.
                -- Vou manter a cor inativa para consistência com o Toggle quando inativo.
                TweenService:Create(control, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = inactiveColor
                }):Play()
            end
        end
    end

    local function setError(state)
        inError = state
        errorIndicator.Visible = state
        animateControl(state or state)
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
        animateControl(state)
        if not skipCallback and typeof(options.Callback) == "function" then
            local ok, err = pcall(function() options.Callback(state) end)
            if not ok then
                warn("[Toggle/CheckBox Error] ", err)
                pulseError()
            end
        end
    end

    connections.Click = control.MouseButton1Click:Connect(function()
        toggle(not state)
    end)

    -- Hover logic respecting error
    connections.Enter = control.MouseEnter:Connect(function()
        if not locked then
            local hoverColor = inError and Color3.fromRGB(255,60,60) 
                            or (state and DESIGN.ActiveToggleColor or DESIGN.ComponentHoverColor)
                            
            if componentType == "CheckBox" and not state then
                -- CheckBox inativo no hover pode ter uma cor de fundo sutil
                hoverColor = DESIGN.ComponentHoverColor 
            elseif componentType == "CheckBox" and state then
                -- CheckBox ativo no hover mantém a cor ativa
                hoverColor = DESIGN.ActiveToggleColor 
            end

            TweenService:Create(control, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                BackgroundColor3 = hoverColor
            }):Play()
        end
    end)
    
    connections.Leave = control.MouseLeave:Connect(function()
        if not locked then
            animateControl(state)
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
    function publicApi:SetDesc(newDesc: string) 
        if descLabel then 
            descLabel.Text = newDesc 
            -- Note: O ajuste de altura do componente pai (outerBox) é mais complexo e 
            -- pode precisar de lógica adicional para redimensionar o outerBox após a mudança de texto.
            -- Para este escopo, a quebra de linha está habilitada, mas o redimensionamento dinâmico
            -- do componente pai (outerBox) não é automático.
        end 
    end
    function publicApi:SetCallback(newCallback)
        if typeof(newCallback) == "function" then options.Callback = newCallback end
    end
    function publicApi:SetLocked(isLocked: boolean)
        locked = isLocked
        control.AutoButtonColor = not locked
        animateControl(state)
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
--suportes a api destrói onace
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

    -- NOVO: Overlay (Fundo semi-transparente que cobre a tela)
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Fundo escuro
    -- AQUI: Usando a transparência da janela para o overlay
    overlay.BackgroundTransparency = 1 - DESIGN.WindowTransparency -- Ajusta a transparência
    overlay.ZIndex = 999 -- Fica abaixo da caixa de diálogo
    overlay.Parent = screen

    local box = Instance.new("Frame")
    box.Name = "DialogBox"
    box.Size = UDim2.new(0, 340, 0, 0)
    box.AnchorPoint = Vector2.new(0.5, 0.5)
    box.Position = UDim2.new(0.5, 0, 0.5, 0)
    box.BackgroundColor3 = DESIGN.ComponentBackground
    -- AQUI: Aplicando a transparência da janela ao DialogBox
    box.BackgroundTransparency = DESIGN.WindowTransparency 
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

function Tekscripts:CreateInput(tab, options)
	assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateInput")
	assert(type(options) == "table" and type(options.Text) == "string", "Invalid arguments for CreateInput")

	local TweenService = game:GetService("TweenService")

	local box = Instance.new("Frame")
	box.Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight + 30)
	box.BackgroundColor3 = DESIGN.ComponentBackground
	-- AQUI ESTÁ A MUDANÇA: Usando a transparência do contêiner de abas
	box.BackgroundTransparency = DESIGN.TabContainerTransparency
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
    -- AQUI ESTÁ A MUDANÇA: Aplica a transparência definida no DESIGN
    btn.BackgroundTransparency = DESIGN.TabContainerTransparency
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

function Tekscripts:CreateLabel(tab, options)
    assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateLabel")
    assert(type(options) == "table" and type(options.Title) == "string", "Invalid arguments for CreateLabel")

    local TweenService = game:GetService("TweenService")

    -- Valores padrão
    local defaultOptions = {
        Title = options.Title,
        Desc = options.Desc,
        Icon = options.Icon,
        TitleColor = DESIGN.ComponentTextColor,
        DescColor = Color3.fromRGB(200, 200, 200),
        Align = options.Align or Enum.TextXAlignment.Left,
        Highlight = options.Highlight or false
    }

    -- Box principal
    local outerBox = Instance.new("Frame")
    outerBox.Size = UDim2.new(1, 0, 0, 0)
    outerBox.BackgroundColor3 = DESIGN.ComponentBackground
    outerBox.BackgroundTransparency = DESIGN.TabContainerTransparency 
    outerBox.BorderSizePixel = 0
    outerBox.ClipsDescendants = true
    outerBox.Parent = tab.Container
    addRoundedCorners(outerBox, DESIGN.CornerRadius)

    -- Sombra (mantida)
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.Position = UDim2.new(0, 0, 0, 2)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.92
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    addRoundedCorners(shadow, DESIGN.CornerRadius)
    shadow.Parent = outerBox

    -- CONTAINER INTERNO (Vertical)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -DESIGN.ComponentPadding * 2, 1, -DESIGN.ComponentPadding * 2)
    container.Position = UDim2.new(0, DESIGN.ComponentPadding, 0, DESIGN.ComponentPadding)
    container.BackgroundTransparency = 1
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Parent = outerBox

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6) -- Padding menor para elementos verticais
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left -- Alinhamento na box
    listLayout.Parent = container

    -- NOVA LINHA DE TÍTULO (Horizontal)
    local titleRow = Instance.new("Frame")
    titleRow.Size = UDim2.new(1, 0, 0, 24) -- Altura fixa para o título/ícone
    titleRow.BackgroundTransparency = 1
    titleRow.Parent = container

    local rowLayout = Instance.new("UIListLayout")
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.Padding = UDim.new(0, 6)
    rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    rowLayout.Parent = titleRow

    -- ÍCONE (Opcional - lado a lado com o Título)
    local iconContainer
    local iconLabel
    if defaultOptions.Icon then
        iconContainer = Instance.new("Frame")
        iconContainer.Size = UDim2.new(0, 24, 0, 24)
        iconContainer.BackgroundTransparency = 1
        iconContainer.Parent = titleRow
        iconContainer.LayoutOrder = 1

        iconLabel = Instance.new("ImageLabel")
        iconLabel.Image = defaultOptions.Icon
        iconLabel.Size = UDim2.new(1, 0, 1, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Parent = iconContainer
    end

    -- TÍTULO (Lado a lado com o Ícone)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = defaultOptions.Title
    -- Ajusta o tamanho do título para preencher o restante da row
    titleLabel.Size = UDim2.new(1, iconContainer and -24 or 0, 1, 0) 
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = defaultOptions.TitleColor
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = defaultOptions.Align
    titleLabel.TextWrapped = true
    titleLabel.Parent = titleRow
    titleLabel.LayoutOrder = 2

    -- Linha de destaque (Opcional)
    local highlightLine
    if defaultOptions.Highlight then
        highlightLine = Instance.new("Frame")
        highlightLine.Size = UDim2.new(0, 40, 0, 2)
        highlightLine.BackgroundColor3 = DESIGN.AccentColor or Color3.fromRGB(100, 180, 255)
        highlightLine.Position = UDim2.new(0, 0, 1, 4)
        highlightLine.Parent = titleLabel
        addRoundedCorners(highlightLine, 1)
    end

    -- DESCRIÇÃO (Abaixo da titleRow)
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
        descLabel.LayoutOrder = 3
    end

    -- Ajuste automático de altura (Conecta ao layout VERTICAL principal)
    local layoutConnection = listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local totalHeight = listLayout.AbsoluteContentSize.Y + DESIGN.ComponentPadding * 2
        outerBox.Size = UDim2.new(1, 0, 0, totalHeight)
        if shadow then
            shadow.Size = UDim2.new(1, 0, 0, totalHeight)
        end
    end)
    
    -- Se houver ícone, ajusta a largura do label do título
    if iconContainer then
        titleLabel.Size = UDim2.new(1, -iconContainer.Size.X.Offset - rowLayout.Padding.Offset, 1, 0)
    end

    -- API pública (funções de atualização ajustadas para novos containers)
    local publicApi = {
        _instance = outerBox,
        _connections = { layoutConnection },
        _titleLabel = titleLabel,
        _descLabel = descLabel,
        _iconLabel = iconLabel
    }

    -- ... (O restante das funções de API como SetTitle, SetDesc, SetIcon, etc., não precisa de grandes mudanças
    -- desde que elas usem _titleLabel, _descLabel e _iconLabel)
    
    function publicApi.SetTitle(newTitle, color)
        if not newTitle then return end
        titleLabel.Text = newTitle
        if color then
            TweenService:Create(titleLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { TextColor3 = color }):Play()
        end
    end

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
            descLabel.LayoutOrder = 3
        end

        descLabel.Text = newDesc
        if color then
            descLabel.TextColor3 = color
        end
    end

    function publicApi.SetIcon(iconAsset)
        if iconAsset then
            if not iconLabel then
                iconContainer = Instance.new("Frame")
                iconContainer.Size = UDim2.new(0, 24, 0, 24)
                iconContainer.BackgroundTransparency = 1
                iconContainer.Parent = titleRow
                iconContainer.LayoutOrder = 1

                iconLabel = Instance.new("ImageLabel")
                iconLabel.Image = iconAsset
                iconLabel.Size = UDim2.new(1, 0, 1, 0)
                iconLabel.BackgroundTransparency = 1
                iconLabel.Parent = iconContainer
                publicApi._iconLabel = iconLabel
                
                -- Ajusta o tamanho do Título
                titleLabel.Size = UDim2.new(1, -iconContainer.Size.X.Offset - rowLayout.Padding.Offset, 1, 0)
                titleLabel.LayoutOrder = 2

            else
                iconLabel.Image = iconAsset
            end
        else
            if iconContainer and iconContainer.Parent then
                iconContainer:Destroy()
                iconContainer = nil
                iconLabel = nil
                publicApi._iconLabel = nil
                
                -- Ajusta o tamanho do Título para preencher a linha toda
                titleLabel.Size = UDim2.new(1, 0, 1, 0)
            end
        end
    end

    function publicApi.SetAlignment(align)
        if not align then return end
        titleLabel.TextXAlignment = align
        if descLabel then
            descLabel.TextXAlignment = align
        end
        -- O alinhamento do listLayout principal (container) deve ser sempre Left se houver ícone/descrição.
        -- Se não houver, podemos ajustar o HorizontalAlignment da titleRow.
        if not iconContainer then
            rowLayout.HorizontalAlignment = align == Enum.TextXAlignment.Center and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Left
        end
    end
    
    -- O resto das funções (Update e Destroy) permanecem as mesmas.

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

return Tekscripts
