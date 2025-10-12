# 🎯 Tekscripts uix - Documentação Completa  
  
## 📋 Visão Geral  
  
A **Tekscripts uix** é uma biblioteca especializada para scripters, projetada para criar interfaces gráficas intuitivas e funcionais em jogos Roblox. Esta documentação fornece todas as informações necessárias para implementar e utilizar a biblioteca de forma eficaz.  
  
---  
  
## 🚀 Começando  
  

> ⚠️ **Importante**: Esta linha deve ser executada antes de qualquer utilização da biblioteca.  
  
### 🔧 Instalação  
  
Para utilizar a Tekscripts uix, você precisa carregar o módulo em seu script de exploit:  
  
```lua  
local Tekscripts = loadstring(game:HttpGet("https://raw.githubusercontent.com/c0nfigs/LibUix/refs/heads/main/init.lua"))()  
```  


  
---  
  
## 🏗️ Estrutura Básica  
  
### 💡 Criando a Janela Principal  
  
```lua  
local gui = Tekscripts.new({  
    Name = "Meu Painel de Exploit",  
    FloatText = "Abrir Painel",  
    startTab = "Principal"  
})  
```  
  
### 📁 Criando Abas  
  
```lua  
local tabPrincipal = gui:CreateTab({ Title = "Principal" })  
local tabConfig = gui:CreateTab({ Title = "Configurações" })  
local tabPlayer = gui:CreateTab({ Title = "Player" })  
```  
  
---  
  
## 🛠️ Componentes Disponíveis  

![](./assets/imagem.png)
  
### 1. 🎮 Botões (Buttons)  
  
Componentes clicáveis para executar ações específicas:  
  
```lua  
gui:CreateButton(tabPrincipal, {  
    Text = "ESP Players",  
    Callback = function()  
        print("ESP ativado!")  
        -- Seu código de ESP aqui  
    end  
})  
```  
  
### 2. 🔁 Interruptores (Toggles)  
  
Componentes que alternam entre estados ON/OFF:  
  
```lua  
gui:CreateToggle(tabPrincipal, {  
    Text = "Fly",  
    Callback = function(estado)  
        if estado then  
            print("Fly ativado!")  
        else  
            print("Fly desativado.")  
        end  
    end  
})  
```  
  
### 3. 📋 Menu Suspenso (Dropdown)  
  
Seleção múltipla de opções:  
  
```lua  
gui:CreateDropdown(tabPrincipal, {  
    Title = "Modo de Velocidade",  
    Values = { "Normal", "Rápido", "Super Rápido" },  
    SelectedValue = "Normal",  
    Callback = function(valorSelecionado)  
        print("Velocidade: " .. valorSelecionado)  
    end  
})  
```  
  
### 4. 📝 Rótulos (Labels)  
  
Texto informativo para orientações:  
  
```lua  
gui:CreateLabel(tabConfig, {  
    Title = "Informação Importante",  
    Desc = "Este painel foi desenvolvido para exploiters usarem de forma simples e prática."  
})  
```  
  
### 5. 🏷️ Etiquetas (Tags)  
  
Indicadores visuais de status:  
  
```lua  
gui:CreateTag(tabConfig, {  
    Text = "VERSÃO 1.0",  
    Color = Color3.fromRGB(90, 140, 200)  
})  
```  
  
### 6. ✍️ Campos de Entrada (Inputs)  
  
Entrada de texto ou números:  
  
```lua  
-- Para texto  
gui:CreateInput(tabPlayer, {  
    Text = "Nome do Jogador",  
    Placeholder = "Digite o username...",  
    Callback = function(texto)  
        print("Teleportar para: " .. texto)  
    end  
})  
  
-- Para números  
gui:CreateInput(tabPlayer, {  
    Text = "Walkspeed",  
    Placeholder = "16",  
    Type = "number",  
    Callback = function(numero)  
        if type(numero) == "number" then  
            print("Velocidade: " .. numero)  
        end  
    end  
})  
```  
  
### 7. 📏 Linhas Divisoras (HR)  
  
Separação visual entre componentes:  
  
```lua  
-- Linha simples  
gui:CreateHR(tabPrincipal, {})  
  
-- Linha com texto  
gui:CreateHR(tabPrincipal, {  
    Text = "Funções de Combate"  
})  
```  
  
---  
  
### 8. 🔄 Float Button (Botão Flutuante)  
  
Componente avançado que pode ser movido pela tela:  
  
```lua  
-- Criar o float button  
local button = Tekscripts:CreateFloatingButton({  
    Text = "Ativar Kill Aura",  
    Title = "Ferramenta",  
    BorderRadius = 12,  
    Value = false,  
    Visible = true,  
    Drag = true,  
    Block = false,  
    Callback = function(state)  
        if state then  
            print("Kill Aura ativado!")  
            -- Código para ativar a Kill Aura  
        else  
            print("Kill Aura desativado!")  
            -- Código para desativar a Kill Aura  
        end  
    end  
})  
  
-- Atualizar propriedades  
button.Update({  
    Text = "Desativar Kill Aura",  
    BorderRadius = 20  
})  
  
-- Verificar estado atual  
print(button.State().Value) -- true ou false  
  
-- Destruir o botão  
-- button.Destroy()  
```  
  
### 9. 📊 Slider (Controle Deslizante)  
  
Controle de valores numéricos com intervalos:  
  
```lua  
-- Criar o slider  
local slider = Tekscripts:CreateSlider(tabPrincipal, {  
    Text = "Velocidade do Player",  
    Min = 10,  
    Max = 100,  
    Step = 5,  
    Value = 50,  
    Callback = function(val)  
        print("Velocidade atual:", val)  
        -- game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val  
    end  
})  
  
-- Alterar valor programaticamente  
slider.Set(75)  
  
-- Pegar valor atual  
print("Valor atual do slider:", slider.Get())  
  
-- Atualizar opções do slider  
slider.Update({  
    Text = "Nova Velocidade",  
    Min = 20,  
    Max = 200,  
    Step = 10  
})  
  
-- Destruir slider  
-- slider.Destroy()  
```  
  
---  
  
## 10. 📢 Notificações  
  
**em Correção**

### 11. 🧩 Section (Seção de Componentes)

Agrupa elementos relacionados dentro de uma aba, permitindo abrir/fechar e bloquear o conteúdo dinamicamente.

```lua
-- Criar uma Section dentro da aba principal
local section = Tekscripts:CreateSection(tabPrincipal, {
    Title = "Configurações do Player",
    Open = true,   -- começa aberta
    Fixed = false  -- pode ser recolhida manualmente
})

-- Adicionar componentes dentro da Section
local slider = Tekscripts:CreateSlider(tabPrincipal, {
    Text = "Velocidade",
    Min = 10,
    Max = 100,
    Step = 5,
    Value = 25
})

section:AddComponent(slider)  -- adiciona o slider dentro da section

-- Alterar o título da Section dinamicamente
section:SetTitle("⚙️ Ajustes do Player")

-- Bloquear e desbloquear a Section
section:Block(true, "Função bloqueada")
task.wait(2)
section:Block(false)

-- Alternar abertura manualmente
section:Toggle()

-- Destruir a Section e seus componentes
-- section:Destroy()

✅ Principais métodos disponíveis:

section:AddComponent(component) → adiciona um componente interno

section:SetTitle(text) → muda o título exibido

section:Toggle() → alterna entre aberto/fechado

section:Block(state, message?) → ativa/desativa o bloqueio visual

section:Destroy() → remove completamente a seção
```

### 12. ⌨️ Bind (Atalho de Tecla)

Permite associar uma tecla do teclado a uma função personalizada, possibilitando que o usuário altere a tecla dinamicamente pela interface.

```lua
-- Criar um Bind dentro da aba principal
local bind = Tekscripts:CreateBind(tabPrincipal, {
    Text = "Ativar ESP",
    Desc = "Pressione a tecla para alternar o ESP",
    Default = Enum.KeyCode.F,
    Callback = function(key)
        print("ESP alternado com a tecla:", key.Name)
    end
})

-- Obter a tecla atual
print("Tecla atual:", bind:GetKey().Name)

-- Alterar a tecla programaticamente
bind:SetKey(Enum.KeyCode.G)

-- Forçar o modo de escuta (espera por uma nova tecla)
bind:Listen()

-- Atualizar propriedades do bind
bind:Update({
    Text = "Nova Função",
    Desc = "Troque a tecla para redefinir",
    Default = Enum.KeyCode.H
})

-- Destruir o bind
-- bind:Destroy()

✅ Principais métodos disponíveis:

bind:GetKey() → retorna a tecla atualmente configurada

bind:SetKey(key) → define uma nova tecla manualmente

bind:Listen() → entra em modo de escuta aguardando o usuário pressionar uma nova tecla

bind:Update(options) → atualiza texto, descrição ou tecla padrão

bind:Destroy() → remove completamente o bind e desconecta eventos
```

  
## 📝 Exemplo Completo  

  
```lua  
-- Carregar a biblioteca  
local UIManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/kauam73/tkrs/refs/heads/main/labory/data.lua"))()  
  
-- Criar painel  
local gui = UIManager.new({  
    Name = "Meu Painel de Exploit",  
    FloatText = "Abrir",  
    startTab = "Principal"  
})  
  
-- Criar abas  
local tabMain = gui:CreateTab({ Title = "Principal" })  
local tabSettings = gui:CreateTab({ Title = "Configurações" })  
  
-- Adicionar componentes  
gui:CreateToggle(tabMain, {  
    Text = "Fly",  
    Callback = function(state)  
        if state then  
            print("Fly ON")  
        else  
            print("Fly OFF")  
        end  
    end  
})  
  
gui:CreateButton(tabMain, {  
    Text = "Ativar ESP",  
    Callback = function()  
        gui:Notify({  
            Title = "ESP Ativado",  
            Desc = "Todos os players estão visíveis",  
            Duration = 3  
        })  
    end  
})  
  
gui:CreateInput(tabMain, {  
    Text = "WalkSpeed",  
    Placeholder = "16",  
    Type = "number",  
    Callback = function(num)  
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = num  
    end  
})  
  
-- Componente novo: Slider  
local speedSlider = Tekscripts:CreateSlider(tabSettings, {  
    Text = "Velocidade do Player",  
    Min = 10,  
    Max = 100,  
    Step = 5,  
    Value = 50,  
    Callback = function(val)  
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val  
    end  
})  
```  
  
---  
  
## 📊 API Referência  
  
### Métodos Principais  
  
| Método | Descrição |  
|--------|-----------|  
| `Tekscripts.new(options)` | Cria nova instância do painel |  
| `gui:CreateTab(options)` | Cria nova aba |  
| `gui:CreateButton(tab, options)` | Cria botão |  
| `gui:CreateToggle(tab, options)` | Cria interruptor |  
| `gui:CreateDropdown(tab, options)` | Cria dropdown |  
| `gui:CreateInput(tab, options)` | Cria campo de entrada |  
| `gui:CreateLabel(tab, options)` | Cria rótulo |  
| `gui:CreateTag(tab, options)` | Cria etiqueta |  
| `gui:CreateHR(tab, options)` | Cria linha divisória |  
| `gui:Notify(options)` | Exibe notificação |  
  
### Propriedades dos Componentes  
  
| Propriedade | Tipo | Descrição |  
|-------------|------|-----------|  
| `Text` | string | Texto exibido |  
| `Title` | string | Título do componente |  
| `Callback` | function | Função de callback |  
| `Values` | table | Lista de opções |  
| `Placeholder` | string | Texto de placeholder |  
| `Type` | string | Tipo de entrada ("text" ou "number") |  
| `Min/Max/Step` | number | Valores para sliders |  
| `Value` | any | Valor inicial |  
| `Visible` | boolean | Visibilidade |  
| `Drag` | boolean | Permitir arrastar |  
  
---  
  
## ⚠️ Considerações Finais  
  
⚠️ **Uso Responsável**: Esta ferramenta foi desenvolvida exclusivamente para fins educacionais e de desenvolvimento de scripts. Use com responsabilidade e respeite os termos de serviço das plataformas, NÃO ME RESPONSABILIZO PELOS SCRIPTS USADOS POR TRÁS DA FERRAMENTA.  
  
📝 **Documentação Atualizada**: Esta documentação será mantida atualizada com novas funcionalidades e melhorias.  
  
---  
  
## 📞 Suporte  
  
Para dúvidas ou problemas técnicos, consulte o repositório oficial no GitHub ou entre em contato com a equipe de desenvolvimento.  
  
---  
*Documentação atualizada em: [02/10/2025]*

