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

function Tekscripts:CreateTitlebar(tab, options)
	assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateTitlebar")
	assert(type(options) == "table" and type(options.Text) == "string", "Invalid arguments for CreateTitlebar")

	local title = options.Text or "Title"

	-- CRIAÇÃO DO FRAME
	local box = Instance.new("Frame")
	box.Name = "Titlebar"
	box.BackgroundTransparency = 1
	box.Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight)
	box.ClipsDescendants = true

	local holder = Instance.new("Frame")
	holder.BackgroundTransparency = 1
	holder.Size = UDim2.new(1, 0, 1, 0)
	holder.Parent = box

	-- LABEL DO TÍTULO
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Text = title
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = DESIGN.ComponentTextColor
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Size = UDim2.new(1, -DESIGN.ComponentPadding, 1, 0)
	label.Parent = holder

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, DESIGN.ComponentPadding)
	padding.PaddingRight = UDim.new(0, DESIGN.ComponentPadding)
	padding.PaddingTop = UDim.new(0, 0)
	padding.PaddingBottom = UDim.new(0, 0)
	padding.Parent = holder

	-- ESTILO OPCIONAL: LINHA ABAIXO DO TÍTULO
	if options.line then
		local line = Instance.new("Frame")
		line.Name = "line"
		line.Size = UDim2.new(1, 0, 0, 2)
		line.Position = UDim2.new(0, 0, 1, -2)
		line.BackgroundColor3 = DESIGN.HRColor
		line.Parent = box
	end

	-- ESTADO DESTRUIDO
	local destroyed = false
	local connections = {}

	-- FUNÇÃO SEGURA DE CONEXÃO
	local function safeConnect(signal, func)
		local conn = signal:Connect(function(...)
			if destroyed then return end
			local ok, err = pcall(func, ...)
			if not ok then
				warn("[TitlebarCallbackError]:", err)
			end
		end)
		table.insert(connections, conn)
		return conn
	end

	-- API PÚBLICA
	local publicApi = {
		_instance = box,
		_connections = connections,
	}

	function publicApi:SetText(newText)
		if destroyed then return end
		if typeof(newText) == "string" then
			pcall(function() label.Text = newText end)
		end
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

function Tekscripts:CreateLabel(tab, options)
    assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateLabel")
    assert(type(options) == "table" and type(options.Title) == "string", "Invalid arguments for CreateLabel")

    local TweenService = game:GetService("TweenService")

    local defaultOptions = {
        Title = options.Title,
        Desc = options.Desc,
        Icon = options.Icon,
        TitleColor = DESIGN.ComponentTextColor,
        DescColor = Color3.fromRGB(200, 200, 200),
        Align = Enum.TextXAlignment.Left,
        Highlight = false
    }

    -- Box principal
    local outerBox = Instance.new("Frame")
    outerBox.Size = UDim2.new(1, 0, 0, 0)
    outerBox.BackgroundColor3 = DESIGN.ComponentBackground
    outerBox.BorderSizePixel = 0
    outerBox.ClipsDescendants = true
    outerBox.Parent = tab.Container
    addRoundedCorners(outerBox, DESIGN.CornerRadius)

    -- Sombra
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
    container.Size = UDim2.new(1, -DESIGN.ComponentPadding*2, 1, -DESIGN.ComponentPadding*2)
    container.Position = UDim2.new(0, DESIGN.ComponentPadding, 0, DESIGN.ComponentPadding)
    container.BackgroundTransparency = 1
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Parent = outerBox

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.HorizontalAlignment = defaultOptions.Align == Enum.TextXAlignment.Center and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Left
    listLayout.Parent = container

    -- Ícone opcional
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

    -- Linha de destaque opcional
    if defaultOptions.Highlight then
        local highlightLine = Instance.new("Frame")
        highlightLine.Size = UDim2.new(0, 40, 0, 2)
        highlightLine.BackgroundColor3 = DESIGN.AccentColor or Color3.fromRGB(100,180,255)
        highlightLine.Position = UDim2.new(0,0,1,4)
        addRoundedCorners(highlightLine, 1)
        highlightLine.Parent = titleLabel
    end

    -- Descrição opcional
    local descLabel
    if defaultOptions.Desc then
        descLabel = Instance.new("TextLabel")
        descLabel.Text = defaultOptions.Desc
        descLabel.Size = UDim2.new(1,0,0,0)
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

    -- Conexão de layout otimizada (evita atualizar mil vezes por segundo)
    local updateScheduled = false
    local function updateSize()
        if updateScheduled then return end
        updateScheduled = true
        task.defer(function()
            local totalHeight = listLayout.AbsoluteContentSize.Y + DESIGN.ComponentPadding*2
            outerBox.Size = UDim2.new(1,0,0,totalHeight)
            if shadow then
                shadow.Size = UDim2.new(1,0,0,totalHeight)
            end
            updateScheduled = false
        end)
    end
    local layoutConnection = listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

    -- API pública
    local publicApi = {
        _instance = outerBox,
        _connections = { layoutConnection },
        _titleLabel = titleLabel,
        _descLabel = descLabel,
        _iconLabel = iconLabel
    }

    function publicApi.SetTitle(newTitle, color)
        if not newTitle then return end
        titleLabel.Text = newTitle
        if color then
            TweenService:Create(titleLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {TextColor3=color}):Play()
        end
        updateSize()
    end

    function publicApi.SetDesc(newDesc, color)
        if newDesc == nil then
            if descLabel then
                descLabel:Destroy()
                descLabel = nil
                publicApi._descLabel = nil
                updateSize()
            end
            return
        end

        if not descLabel then
            descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(1,0,0,0)
            descLabel.AutomaticSize = Enum.AutomaticSize.Y
            descLabel.BackgroundTransparency = 1
            descLabel.Font = Enum.Font.GothamMedium
            descLabel.TextSize = 15
            descLabel.TextXAlignment = defaultOptions.Align
            descLabel.TextWrapped = true
            descLabel.LineHeight = 1.15
            descLabel.Parent = container
            publicApi._descLabel = descLabel
        end

        descLabel.Text = newDesc
        if color then
            descLabel.TextColor3 = color
        end
        updateSize()
    end

    function publicApi.SetIcon(iconAsset)
        if iconAsset then
            if not iconLabel then
                local iconContainer = Instance.new("Frame")
                iconContainer.Size = UDim2.new(0,24,0,24)
                iconContainer.BackgroundTransparency = 1
                iconContainer.Parent = container

                iconLabel = Instance.new("ImageLabel")
                iconLabel.Size = UDim2.new(1,0,1,0)
                iconLabel.BackgroundTransparency = 1
                iconLabel.Parent = iconContainer
                publicApi._iconLabel = iconLabel
            end
            iconLabel.Image = iconAsset
        elseif iconLabel then
            iconLabel.Parent:Destroy()
            iconLabel = nil
            publicApi._iconLabel = nil
        end
        updateSize()
    end

    function publicApi.SetAlignment(align)
        if not align then return end
        titleLabel.TextXAlignment = align
        if descLabel then
            descLabel.TextXAlignment = align
        end
        listLayout.HorizontalAlignment = align == Enum.TextXAlignment.Center and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Left
        updateSize()
    end

    function publicApi.Update(opts)
        if opts.Title ~= nil then publicApi.SetTitle(opts.Title, opts.TitleColor) end
        if opts.Desc ~= nil then publicApi.SetDesc(opts.Desc, opts.DescColor) end
        if opts.Icon ~= nil then publicApi.SetIcon(opts.Icon) end
        if opts.Align then publicApi.SetAlignment(opts.Align) end
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
            publicApi._titleLabel = nil
            publicApi._descLabel = nil
            publicApi._iconLabel = nil
        end
        table.clear(publicApi)
    end

    table.insert(tab.Components, publicApi)
    updateSize()
    return publicApi
end

function Tekscripts:CreateToggle(tab, options)
    assert(tab and typeof(tab) == "table", "CreateToggle: Tab inválida.")
    assert(typeof(options) == "table", "CreateToggle: 'options' deve ser uma tabela.")
    assert(typeof(options.Text) == "string", "CreateToggle: 'Text' deve ser uma string.")

    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")

    local descHeight = typeof(options.Desc) == "string" and 16 or 0
    local totalHeight = (DESIGN and DESIGN.ComponentHeight or 24) + descHeight + 6
    local callback = typeof(options.Callback) == "function" and options.Callback or function() end

    local bgColor = DESIGN and DESIGN.ComponentBackground or Color3.fromRGB(25, 25, 25)
    local textColor = DESIGN and DESIGN.ComponentTextColor or Color3.fromRGB(255, 255, 255)
    local hoverColor = DESIGN and DESIGN.ComponentHoverColor or Color3.fromRGB(60, 60, 60)
    local activeColor = DESIGN and DESIGN.ActiveToggleColor or Color3.fromRGB(0, 200, 0)
    local inactiveColor = DESIGN and DESIGN.InactiveToggleColor or Color3.fromRGB(80, 80, 80)
    local errorColor = Color3.fromRGB(255, 60, 60)
    local descColor = Color3.fromRGB(160, 160, 160)

    local container = tab.Container  -- Pode ser nil se lazy

    local outer = Instance.new("Frame")
    outer.Size = UDim2.new(1, 0, 0, totalHeight)
    outer.BackgroundColor3 = bgColor
    outer.BorderSizePixel = 0
    -- Não parentear ainda se container nil

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, (DESIGN and DESIGN.CornerRadius) or 6)
    corner.Parent = outer

    local inner = Instance.new("Frame")
    inner.Size = UDim2.new(1, -(DESIGN and DESIGN.ComponentPadding or 8) * 2, 1, 0)
    inner.Position = UDim2.new(0, (DESIGN and DESIGN.ComponentPadding) or 8, 0, 0)
    inner.BackgroundTransparency = 1
    inner.Parent = outer

    local label = Instance.new("TextLabel")
    label.Text = options.Text
    label.Size = UDim2.new(0.7, -10, 0, (DESIGN and DESIGN.ComponentHeight) or 24)
    label.BackgroundTransparency = 1
    label.TextColor3 = textColor
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = inner

    local desc
    if typeof(options.Desc) == "string" then
        desc = Instance.new("TextLabel")
        desc.Text = options.Desc
        desc.Size = UDim2.new(0.7, -10, 0, descHeight)
        desc.Position = UDim2.new(0, 0, 0, (DESIGN and DESIGN.ComponentHeight) or 24)
        desc.BackgroundTransparency = 1
        desc.TextColor3 = descColor
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 14
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = inner
    end

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 50, 0, 24)
    switch.Position = UDim2.new(0.85, 0, 0, (totalHeight - 24) / 2)
    switch.BackgroundColor3 = inactiveColor
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.ClipsDescendants = true
    switch.Parent = inner

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 2, 0, 2)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = switch

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local state = false
    local locked = false
    local inError = false
    local destroyed = false
    local hover = false
    local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local activeTweens = {}

    local function stopTween(obj)
        local tw = activeTweens[obj]
        if tw then
            tw:Cancel()
            activeTweens[obj] = nil
        end
    end

    local function safeTween(obj, props)
        if not obj or not obj.Parent then return end
        stopTween(obj)
        local ok, tween = pcall(function() return TweenService:Create(obj, tweenInfo, props) end)
        if ok and tween then
            activeTweens[obj] = tween
            tween.Completed:Connect(function() activeTweens[obj] = nil end)
            tween:Play()
        end
    end

    local function animateToggle(newState)
        if destroyed then return end
        local color
        if inError then
            color = errorColor
        elseif hover and not locked then
            color = hoverColor
        else
            color = newState and activeColor or inactiveColor
        end
        local targetPos = newState and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
        safeTween(switch, { BackgroundColor3 = color })
        safeTween(knob, { Position = targetPos })
    end

    local function setError(v)
        if destroyed then return end
        inError = v
        animateToggle(state)
    end

    local function pulseError()
        if destroyed then return end
        setError(true)
        task.delay(0.25, function()
            if not destroyed then setError(false) end
        end)
    end

    local function toggle(newState, skipCallback)
        if locked or destroyed then return end
        if state == newState then return end
        state = newState
        animateToggle(state)
        if not skipCallback then
            task.spawn(function()
                local ok, err = pcall(callback, state)
                if not ok then
                    warn("[Toggle Error]:", err)
                    pulseError()
                end
            end)
        end
    end

    switch.MouseButton1Click:Connect(function()
        if not locked and not destroyed then toggle(not state) end
    end)

    switch.MouseEnter:Connect(function()
        if not locked and not destroyed then
            hover = true
            animateToggle(state)
        end
    end)

    switch.MouseLeave:Connect(function()
        if not locked and not destroyed then
            hover = false
            animateToggle(state)
        end
    end)

    -- Atualização leve automática de hover sem recriar tweens constantemente
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if destroyed or not outer.Parent then
            connection:Disconnect()
            return
        end
        if hover and not locked and not inError then
            switch.BackgroundColor3 = switch.BackgroundColor3:Lerp(activeColor, 0.05)
        end
    end)
    table.insert(tab._connections, connection)  -- Para limpeza na destruição da aba

    local PublicApi = {}

    function PublicApi:SetState(v)
        if destroyed then return end
        toggle(v, true)
    end

    function PublicApi:GetState()
        return state
    end

    function PublicApi:Toggle()
        if destroyed then return end
        toggle(not state)
    end

    function PublicApi:SetText(t)
        if destroyed or typeof(t) ~= "string" or not label then return end
        label.Text = t
    end

    function PublicApi:SetDesc(t)
        if destroyed or not desc or typeof(t) ~= "string" then return end
        desc.Text = t
    end

    function PublicApi:SetCallback(fn)
        if destroyed or typeof(fn) ~= "function" then return end
        callback = fn
    end

    function PublicApi:SetLocked(v)
        if destroyed then return end
        locked = v and true or false
        switch.Active = not locked
        animateToggle(state)
    end

    function PublicApi:Update(opt)
        if destroyed or typeof(opt) ~= "table" then return end
        if opt.Text then self:SetText(opt.Text) end
        if opt.Desc then self:SetDesc(opt.Desc) end
        if opt.State ~= nil then toggle(opt.State, true) end
    end

    function PublicApi:Destroy()
        if destroyed then return end
        destroyed = true
        for _, tw in pairs(activeTweens) do pcall(function() tw:Cancel() end) end
        activeTweens = {}
        pcall(function() outer:Destroy() end)
        table.clear(self)
    end

    -- Adiciona à lista de components (como Instance, para lazy parent)
    table.insert(tab.Components, outer)

    -- Se container já existe, parentea e atualiza estado
    if container then
        outer.Parent = container
        -- Update direto (como no fix anterior, sem :Fire())
        task.defer(function()
            if tab.ListLayout and tab.Container then
                local hasComponents = #tab.Components > 0
                if tab._overlay then
                    tab._overlay.Visible = not hasComponents
                end
                local totalContentHeight = tab.ListLayout.AbsoluteContentSize.Y + (DESIGN.ContainerPadding * 2)
                local containerHeight = tab.Container.AbsoluteSize.Y
                tab.Container.ScrollBarImageTransparency = totalContentHeight > containerHeight and 0 or 1
            end
        end)
    end

    PublicApi._instance = outer
    return PublicApi
end

function Tekscripts:CreateFloatingButton(options: {
	Text: string?,
	Title: string?,
	Value: boolean?,
	Visible: boolean?,
	Drag: boolean?,
	Block: boolean?,
	Callback: ((boolean) -> ())?
})
	options = options or {}

	local width, height = 100, 100
	local borderRadius = 8 -- fixo, sem parâmetro externo
	local text = tostring(options.Text or "Clique Aqui")
	local title = tostring(options.Title or "Cabeçote")
	local value = options.Value == nil and false or options.Value
	local visible = options.Visible == nil and false or options.Visible
	local drag = options.Drag == nil and true or options.Drag
	local block = options.Block == nil and false or options.Block
	local callback = options.Callback

	local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	local UIS = game:GetService("UserInputService")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FloatingButtonGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	local container = Instance.new("Frame")
	container.Size = UDim2.new(0, width, 0, height + 25)
	container.Position = UDim2.new(0.5, -width / 2, 0.5, -(height + 25) / 2)
	container.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	container.Visible = visible
	container.Parent = screenGui

	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, borderRadius)
	containerCorner.Parent = container

	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, 0, 0, 25)
	header.BackgroundTransparency = 1
	header.Text = title
	header.TextColor3 = Color3.fromRGB(255, 255, 255)
	header.TextSize = 16
	header.Font = Enum.Font.GothamBold
	header.TextScaled = true
	header.TextWrapped = true
	header.ClipsDescendants = true
	header.Parent = container

	local divider = Instance.new("Frame")
	divider.Size = UDim2.new(1, 0, 0, 1)
	divider.Position = UDim2.new(0, 0, 0, 25)
	divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	divider.BorderSizePixel = 0
	divider.Parent = container

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 1, -25)
	button.Position = UDim2.new(0, 0, 0, 25)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextScaled = true
	button.TextWrapped = true
	button.AutoButtonColor = not block
	button.Parent = container

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, borderRadius)
	buttonCorner.Parent = button

	local dragging = false
	local dragInput, dragStart, startPos

	local function updateVisuals()
		header.Text = title
		button.Text = text
		container.Visible = visible
		button.AutoButtonColor = not block
	end

	button.MouseButton1Click:Connect(function()
		if block then return end
		value = not value
		if callback then task.spawn(callback, value) end
	end)

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
			if input == dragInput then dragInput = input end
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

	-- Public API
	local PublicApi = {
		_instance = container,

		SetTitle = function(newTitle: string)
			title = tostring(newTitle)
			updateVisuals()
		end,

		SetText = function(newText: string)
			text = tostring(newText)
			updateVisuals()
		end,

		SetVisible = function(state: boolean)
			visible = state and true or false
			updateVisuals()
		end,

		SetBlock = function(state: boolean)
			block = state and true or false
			updateVisuals()
		end,

		SetCallback = function(fn)
			if typeof(fn) == "function" then
				callback = fn
			end
		end,

		State = function()
			return {
				Title = title,
				Text = text,
				Value = value,
				Visible = visible,
				Drag = drag,
				Block = block
			}
		end,

		Destroy = function()
			if screenGui then
				screenGui:Destroy()
				screenGui = nil
			end
		end,
	}

	updateVisuals()
	return PublicApi
end