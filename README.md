# Tekscripts UIX: Documentação Oficial

<p align="center">
  <img src="./assets/imagem.png" alt="Tekscripts UIX" width="500"/>
</p>

## 🎯 Visão Geral

A **Tekscripts UIX** é uma biblioteca de interface gráfica (GUI) para [Roblox](https://www.roblox.com/), desenvolvida para criadores de scripts que buscam construir menus e painéis de controle de forma rápida e intuitiva. Com uma API simplificada e um conjunto robusto de componentes, a biblioteca permite a criação de interfaces funcionais e visualmente agradáveis com poucas linhas de código.

Esta documentação detalha todos os recursos, componentes e métodos disponíveis, oferecendo um guia completo para desenvolvedores de todos os níveis.

---

## 🚀 Começando

Para integrar a Tekscripts UIX em seu projeto, o primeiro passo é carregar a biblioteca em seu ambiente de script. Este processo é feito executando uma única linha de código que busca e inicializa o módulo mais recente.

> ⚠️ **Importante**: A linha de código abaixo deve ser executada antes de qualquer outra chamada à biblioteca para garantir que todas as funções sejam carregadas corretamente.

### 🔧 Instalação

Copie e cole o código a seguir em seu script para carregar a biblioteca:

```lua
local Tekscripts = loadstring(game:HttpGet("https://raw.githubusercontent.com/c0nfigs/LibUix/refs/heads/main/init.lua"))()
```

---

## 🏗️ Estrutura Fundamental

A estrutura da Tekscripts UIX é baseada em uma janela principal que contém abas, e cada aba pode abrigar múltiplos componentes. Esta organização modular facilita a criação de interfaces complexas e bem segmentadas.

### 💡 Criando a Janela Principal

A janela é o contêiner principal da sua interface. Você pode personalizá-la com um título, um texto flutuante para abri-la e definir qual aba será exibida inicialmente.

```lua
local gui = Tekscripts.new({
    Name = "Meu Painel de Controle",
    FloatText = "Abrir Painel",
    startTab = "Principal"
})
```

### 📁 Criando Abas

As abas (tabs) são usadas para organizar os componentes em diferentes seções, como "Principal", "Configurações" ou "Jogador".

```lua
local tabPrincipal = gui:CreateTab({ Title = "Principal" })
local tabConfig = gui:CreateTab({ Title = "Configurações" })
local tabPlayer = gui:CreateTab({ Title = "Jogador" })
```

---

## 🛠️ Componentes Disponíveis

A Tekscripts UIX oferece uma vasta gama de componentes para construir sua interface. Abaixo estão detalhados os principais componentes e como utilizá-los.

### 1. Botões (Buttons)

Botões são componentes clicáveis que executam uma ação definida por uma função de *callback*.

```lua
gui:CreateButton(tabPrincipal, {
    Text = "Ativar ESP",
    Callback = function()
        print("Função ESP ativada!")
        -- Insira seu código aqui
    end
})
```

### 2. Interruptores (Toggles)

Interruptores permitem ao usuário alternar uma funcionalidade entre os estados ligado (true) e desligado (false).

```lua
gui:CreateToggle(tabPrincipal, {
    Text = "Modo Voo",
    Callback = function(estado)
        if estado then
            print("Modo Voo ativado!")
        else
            print("Modo Voo desativado.")
        end
    end
})
```

### 3. Menu Suspenso (Dropdown)

O menu suspenso (ou dropdown) oferece uma lista de opções para o usuário selecionar.

```lua
gui:CreateDropdown(tabPrincipal, {
    Title = "Modo de Velocidade",
    Values = { "Normal", "Rápido", "Super Rápido" },
    SelectedValue = "Normal",
    Callback = function(valorSelecionado)
        print("Velocidade definida para: " .. valorSelecionado)
    end
})
```

### 4. Rótulos (Labels)

Rótulos são usados para exibir textos informativos ou descrições na interface.

```lua
gui:CreateLabel(tabConfig, {
    Title = "Informação Importante",
    Desc = "Este painel foi desenvolvido para ser simples e prático."
})
```

### 5. Etiquetas (Tags)

Etiquetas (ou tags) são pequenos indicadores visuais, ideais para exibir informações como a versão do script ou um status específico.

```lua
gui:CreateTag(tabConfig, {
    Text = "VERSÃO 1.0",
    Color = Color3.fromRGB(90, 140, 200)
})
```

### 6. Campos de Entrada (Inputs)

Campos de entrada permitem que o usuário insira texto ou números.

```lua
-- Campo para texto
gui:CreateInput(tabPlayer, {
    Text = "Nome do Jogador",
    Placeholder = "Digite o nome...",
    Callback = function(texto)
        print("Teleportar para: " .. texto)
    end
})

-- Campo para números
gui:CreateInput(tabPlayer, {
    Text = "Walkspeed",
    Placeholder = "16",
    Type = "number",
    Callback = function(numero)
        if type(numero) == "number" then
            print("Velocidade definida para: " .. numero)
        end
    end
})
```

### 7. Linhas Divisoras (HR)

Linhas divisórias são usadas para separar visualmente os componentes, com ou sem um texto central.

```lua
-- Linha simples
gui:CreateHR(tabPrincipal, {})

-- Linha com texto
gui:CreateHR(tabPrincipal, {
    Text = "Funções de Combate"
})
```

### 8. Botão Flutuante (Float Button)

Um botão que pode ser movido livremente pela tela, ideal para ações rápidas.

```lua
local floatButton = Tekscripts:CreateFloatingButton({
    Text = "Ativar Kill Aura",
    Title = "Ferramenta",
    Callback = function(state)
        print("Kill Aura:", state)
    end
})

-- Para destruir o botão, chame: floatButton.Destroy()
```

### 9. Controle Deslizante (Slider)

Sliders permitem que o usuário selecione um valor numérico dentro de um intervalo definido.

```lua
local speedSlider = Tekscripts:CreateSlider(tabPrincipal, {
    Text = "Velocidade do Player",
    Min = 16,
    Max = 100,
    Value = 16,
    Callback = function(valor)
        print("Velocidade atual:", valor)
    end
})

-- Para destruir o slider, chame: speedSlider.Destroy()
```

### 10. Seções (Sections)

Seções agrupam componentes dentro de uma aba, permitindo que o conteúdo seja recolhido (abrir/fechar) para melhor organização.

```lua
local section = Tekscripts:CreateSection(tabPrincipal, {
    Title = "Configurações do Player",
    Open = true
})

local slider = Tekscripts:CreateSlider(tabPrincipal, { Text = "Velocidade" })
section:AddComponent(slider)

-- Para destruir a seção, chame: section:Destroy()
```

### 11. Atalhos de Tecla (Binds)

Associa uma tecla do teclado a uma função, permitindo que o usuário personalize o atalho.

```lua
local espBind = Tekscripts:CreateBind(tabPrincipal, {
    Text = "Ativar ESP",
    Default = Enum.KeyCode.F,
    Callback = function(key)
        print("ESP alternado com a tecla:", key.Name)
    end
})

-- Para destruir o bind, chame: espBind.Destroy()
```

### 12. Notificações

Exibe notificações temporárias na tela para informar o usuário sobre ações concluídas ou eventos importantes.

```lua
gui:Notify({
    Title = "Ação Concluída",
    Desc = "A função foi executada com sucesso.",
    Duration = 5 -- em segundos
})
```

---

## 📝 Exemplo Completo

Este exemplo demonstra como criar uma interface simples com uma janela, duas abas e alguns componentes básicos.

```lua
-- 1. Carregar a biblioteca
local Tekscripts = loadstring(game:HttpGet("https://raw.githubusercontent.com/c0nfigs/LibUix/refs/heads/main/init.lua"))()

-- 2. Criar a janela principal
local gui = Tekscripts.new({
    Name = "Painel de Controle",
    FloatText = "Abrir",
    startTab = "Principal"
})

-- 3. Criar abas
local tabMain = gui:CreateTab({ Title = "Principal" })
local tabSettings = gui:CreateTab({ Title = "Configurações" })

-- 4. Adicionar componentes

-- Aba Principal
gui:CreateToggle(tabMain, {
    Text = "Modo Voo",
    Callback = function(state)
        print("Modo Voo:", state and "ON" or "OFF")
    end
})

gui:CreateButton(tabMain, {
    Text = "Ativar ESP",
    Callback = function()
        gui:Notify({
            Title = "ESP Ativado",
            Desc = "Todos os jogadores estão visíveis.",
            Duration = 3
        })
    end
})

-- Aba de Configurações
gui:CreateInput(tabSettings, {
    Text = "WalkSpeed",
    Placeholder = "16",
    Type = "number",
    Callback = function(num)
        if type(num) == "number" then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = num
        end
    end
})

Tekscripts:CreateSlider(tabSettings, {
    Text = "Campo de Visão (FOV)",
    Min = 70,
    Max = 120,
    Value = 90,
    Callback = function(val)
        game.workspace.CurrentCamera.FieldOfView = val
    end
})
```

---

## 📊 Referência da API

A tabela abaixo resume os principais métodos disponíveis na Tekscripts UIX.

| Método | Descrição |
| :--- | :--- |
| `Tekscripts.new(options)` | Cria uma nova instância da janela principal. |
| `gui:CreateTab(options)` | Adiciona uma nova aba à janela. |
| `gui:CreateButton(tab, options)` | Cria um botão clicável. |
| `gui:CreateToggle(tab, options)` | Cria um interruptor (on/off). |
| `gui:CreateDropdown(tab, options)` | Cria um menu de seleção. |
| `gui:CreateInput(tab, options)` | Cria um campo de entrada de texto ou número. |
| `gui:CreateLabel(tab, options)` | Exibe um texto informativo. |
| `gui:CreateTag(tab, options)` | Adiciona uma etiqueta colorida. |
| `gui:CreateHR(tab, options)` | Insere uma linha divisória. |
| `gui:Notify(options)` | Mostra uma notificação na tela. |
| `Tekscripts:CreateSlider(...)` | Cria um controle deslizante. |
| `Tekscripts:CreateSection(...)` | Cria uma seção que agrupa componentes. |
| `Tekscripts:CreateBind(...)` | Cria um atalho de teclado personalizável. |
| `Tekscripts:CreateFloatingButton(...)` | Cria um botão flutuante. |

---

## ⚠️ Considerações Finais

- **Uso Responsável**: Esta biblioteca foi desenvolvida para fins educacionais e de aprendizado. A utilização de scripts em jogos deve respeitar os termos de serviço de cada plataforma. O desenvolvedor não se responsabiliza pelo uso indevido da ferramenta.
- **Documentação Viva**: Este documento será atualizado continuamente para refletir novas funcionalidades e melhorias na biblioteca.

---

## 📞 Suporte

Em caso de dúvidas, sugestões ou problemas técnicos, visite o repositório oficial no [GitHub](https://github.com/c0nfigs/LibUix) ou entre em contato com a equipe de desenvolvimento.

---

*Documentação atualizada em: 12 de outubro de 2025*
