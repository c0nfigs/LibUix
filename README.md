# Tekscripts UIX: Documentação Oficial

<p align="center">
  <img src="./assets/7213904856678237190_avatar.png.jpg" alt="Tekscripts UIX" width="500"/>
</p>

## Visão Geral

A **Tekscripts UIX** é uma biblioteca de interface gráfica (GUI) robusta e de alto desempenho, projetada especificamente para o ambiente de *scripting* do [Roblox](https://www.roblox.com/). Seu objetivo principal é capacitar desenvolvedores a construir menus e painéis de controle complexos de forma **rápida, intuitiva e profissional**.

Com uma API simplificada e um conjunto abrangente de componentes prontos para uso, a biblioteca abstrai a complexidade do gerenciamento de UI no Roblox, permitindo que os criadores de scripts se concentrem na lógica do jogo. Esta documentação serve como um guia completo, detalhando todos os recursos, componentes e métodos disponíveis para desenvolvedores de todos os níveis.

---

## 🚀 Começando

Para começar a utilizar a Tekscripts UIX, o primeiro passo é carregar a biblioteca em seu ambiente de execução. Este processo é realizado através da execução de uma única linha de código que busca e inicializa o módulo mais recente.

> **⚠️ Importante**: A linha de código de instalação deve ser executada no topo do seu script, **antes** de qualquer outra chamada à biblioteca, para garantir que todas as funções sejam carregadas e inicializadas corretamente.

### Instalação

Copie e cole o código a seguir em seu script para carregar e obter a instância principal da biblioteca:

```lua
local Tekscripts = loadstring(game:HttpGet("https://raw.githubusercontent.com/c0nfigs/LibUix/refs/heads/main/load.lua"))()
```

---

## 🏗️ Estrutura Fundamental

A arquitetura da Tekscripts UIX é baseada em uma hierarquia clara e modular: uma **Janela Principal** (`gui`) que contém múltiplas **Abas** (`tab`), e cada aba abriga os **Componentes** da interface.

### 1. Criando a Janela Principal

A janela é o contêiner raiz de toda a sua interface. A função `Tekscripts.new()` retorna o objeto principal (`gui`) que será usado para criar abas e componentes.

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| `Name` | `string` | Título principal exibido na janela. |
| `FloatText` | `string` | Texto flutuante que o usuário clica para abrir/fechar a GUI. |
| `startTab` | `string` | O título da aba que será exibida por padrão ao abrir a janela. |

```lua
local gui = Tekscripts.new({
    Name = "Meu Painel de Controle",
    FloatText = "Abrir Painel",
    startTab = "Principal"
})
```

### 2. Criando Abas (`Tab`)

As abas são essenciais para organizar os componentes em seções lógicas, como "Principal", "Configurações" ou "Jogador".

```lua
local tabPrincipal = gui:CreateTab({ Title = "Principal" })
local tabConfig = gui:CreateTab({ Title = "Configurações" })
local tabPlayer = gui:CreateTab({ Title = "Jogador" })
```

---

## 🧩 Componentes da Interface

A biblioteca oferece uma vasta gama de componentes para construir interações ricas. A criação da maioria dos componentes é feita através da instância da janela (`gui`) ou da própria biblioteca (`Tekscripts`), passando a aba (`tab`) como primeiro argumento.

### 1. Botões (`Button`)

Componentes clicáveis que disparam uma função de *callback* imediata.

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| `Text` | `string` | O rótulo exibido no botão. |
| `Callback` | `function()` | Função executada ao clicar no botão. |

```lua
gui:CreateButton(tabPrincipal, {
    Text = "Ativar ESP",
    Callback = function()
        print("Função ESP ativada!")
        -- Insira seu código aqui
    end
})
```

### 2. Interruptores (`Toggle`)

Permitem alternar uma funcionalidade entre os estados **ligado** (`true`) e **desligado** (`false`).

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| `Text` | `string` | Rótulo principal. |
| `Desc` | `string?` | Texto explicativo menor sob o rótulo. |
| `Callback` | `function(state: boolean)` | Executada sempre que o estado mudar, recebendo o novo estado. |

#### Uso Básico

```lua
local vooToggle = Tekscripts:CreateToggle(tabPrincipal, {
    Text   = "Modo Voo",
    Desc   = "Ativa a capacidade de voar no mapa.",
    Callback = function(estado)
        print("Modo Voo", estado and "ativado" or "desativado")
        -- Implemente a lógica de voo aqui
    end
})
```

#### API de Controle (`Toggle`)

| Método | Assinatura | Descrição |
| :--- | :--- | :--- |
| `SetState` | `(state: boolean)` | Altera o estado visual/lógico **sem** disparar o `Callback`. |
| `GetState` | `() → boolean` | Retorna o estado atual (`true` ou `false`). |
| `Toggle` | `()` | Inverte o estado atual (simula um clique). |
| `SetText` | `(text: string)` | Atualiza o rótulo principal. |
| `SetDesc` | `(desc: string)` | Atualiza a descrição. |
| `SetLocked` | `(locked: boolean)` | Bloqueia/desbloqueia a interação do usuário. |
| `Update` | `{Text?, Desc?, State?}` | Atualiza múltiplas propriedades simultaneamente. |
| `Destroy` | `()` | Remove o componente e desconecta eventos. |

### 3. Menu Suspenso (`Dropdown`)

Permite a seleção de uma ou múltiplas opções a partir de uma lista. Suporta imagens e seleção múltipla.

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| `Title` | `string` | Título exibido acima do dropdown. |
| `Values` | `table` | Lista de itens: `{ {Name = "...", Image = "..."} }`. |
| `Callback` | `function(value)` | Chamada ao mudar a seleção. Recebe `string` (seleção única) ou `table` (multiseleção). |
| `MultiSelect` | `boolean?` | Se `true`, permite selecionar vários itens. Padrão: `false`. |
| `InitialValues` | `table?` | Itens pré-selecionados ao iniciar. |

#### Uso Básico

```lua
local dropdown = Tekscripts:CreateDropdown(tabPrincipal, {
    Title = "Modo de Velocidade",
    Values = {
        { Name = "Normal" },
        { Name = "Rápido" },
        { Name = "Super Rápido" }
    },
    SelectedValue = "Normal",
    Callback = function(valorSelecionado)
        print("Velocidade definida para: " .. tostring(valorSelecionado))
    end
})
```

#### API de Controle (`Dropdown`)

| Método | Descrição |
| :--- | :--- |
| `AddItem(valueInfo, position?)` | Adiciona um novo item à lista. |
| `RemoveItem(valueName)` | Remove um item pelo nome. |
| `GetSelected()` | Retorna o item selecionado (ou tabela em multiseleção). |
| `SetSelected(values)` | Define os itens selecionados (string ou tabela de strings). |
| `Toggle()` | Abre ou fecha o dropdown. |
| `Destroy()` | Remove o dropdown e desconecta todos os eventos. |

### 4. Campos de Entrada (`Input`)

Permite a inserção de texto ou números pelo usuário.

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| `Text` | `string` | Rótulo do campo. |
| `Placeholder` | `string` | Texto exibido quando o campo está vazio. |
| `Type` | `string?` | Tipo de entrada: `"text"` (padrão) ou `"number"`. |
| `Callback` | `function(valor)` | Executada ao perder o foco ou pressionar Enter. |

```lua
-- Campo para números
gui:CreateInput(tabPlayer, {
    Text = "Walkspeed",
    Placeholder = "16",
    Type = "number",
    Callback = function(numero)
        print("Nova Walkspeed:", tonumber(numero))
    end
})
```

### 5. Controle Deslizante (`Slider`)

Permite a seleção de um valor numérico dentro de um intervalo definido.

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| `Text` | `string` | Rótulo do slider. |
| `Min` | `number` | Valor mínimo. |
| `Max` | `number` | Valor máximo. |
| `Step` | `number` | Incremento/decremento do valor. |
| `Value` | `number` | Valor inicial. |
| `Callback` | `function(value: number)` | Chamada quando o valor é alterado pelo usuário. |

```lua
local slider = Tekscripts:CreateSlider(tabPrincipal, {
    Text = "Força do Ataque",
    Min = 10,
    Max = 300,
    Step = 5,
    Value = 50,
    Callback = function(v)
        print("Força atual:", v)
    end
})
```

#### API de Controle (`Slider`)

O slider oferece métodos avançados para controle programático:

| Método | Assinatura | Descrição |
| :--- | :--- | :--- |
| `SetValue` | `(value: number)` | Altera o valor e a posição do *thumb* **sem** disparar o `Callback`. |
| `GetValue` | `() → number` | Retorna o valor numérico atual. |
| `AnimateTo` | `(value: number, duration?: number)` | Altera o valor de forma suave e animada. |
| `Lock` | `(locked: boolean)` | Bloqueia a interação do usuário. |
| `OnChanged` | `(fn: function(value: number))` | Adiciona um *listener* secundário para mudanças de valor. |
| `Destroy` | `()` | Remove o componente. |

### 6. Seções (`Section`)

Agrupam visualmente componentes dentro de uma aba e permitem que o conteúdo seja recolhido (colapsado) para otimizar o espaço.

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| `Title` | `string` | Título da seção. |
| `Open` | `boolean?` | Se `true`, a seção começa aberta. Padrão: `false`. |

```lua
local section = Tekscripts:CreateSection(tabPrincipal, {
    Title = "Configurações do Player",
    Open = true
})

-- Componentes criados na aba principal podem ser movidos para a seção
local slider = Tekscripts:CreateSlider(tabPrincipal, { Text = "Velocidade" })
section:AddComponent(slider) 
```

### 7. Atalhos de Tecla (`Bind`)

Permite que o usuário defina uma tecla de atalho para executar uma função.

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| `Text` | `string` | Rótulo do atalho. |
| `Default` | `Enum.KeyCode` | Tecla padrão inicial (ex: `Enum.KeyCode.F`). |
| `Callback` | `function(key: Enum.KeyCode)` | Executada ao pressionar a tecla. |

```lua
local espBind = Tekscripts:CreateBind(tabPrincipal, {
    Text = "Ativar ESP",
    Default = Enum.KeyCode.F,
    Callback = function(key)
        print("ESP alternado com a tecla:", key.Name)
    end
})
```

### 8. Rótulos (`Label`) e Etiquetas (`Tag`)

Componentes estáticos para exibição de informações.

| Componente | Uso | Exemplo |
| :--- | :--- | :--- |
| `Label` | Exibe textos informativos ou descrições longas. | `gui:CreateLabel(tabConfig, { Title = "Info", Desc = "Texto longo..." })` |
| `Tag` | Pequenos indicadores visuais para status ou versão. | `gui:CreateTag(tabConfig, { Text = "VERSÃO 1.0", Color = Color3.fromRGB(90, 140, 200) })` |
| `HR` | Linha divisória horizontal para separar visualmente componentes. | `gui:CreateHR(tabConfig)` |

---

## 💡 Dicas de Uso e Boas Práticas

*   **Tratamento de Erros:** O `Callback` dos componentes é executado dentro de uma chamada protegida (`pcall`). Em caso de erro, o componente (como o `Toggle`) exibe um pulso visual vermelho e o erro é logado no console, garantindo a estabilidade da GUI.
*   **Controle de Interação:** Use o método `SetLocked(true)` (disponível em `Toggle`, `Slider`, etc.) durante operações assíncronas ou validações para prevenir cliques duplos ou interações indesejadas.
*   **Persistência de Dados:** Integre a API de estado (`GetState`, `SetValue`, `SetSelected`) com seu sistema de configuração (ex: `DataStore` ou `Settings` local) para salvar e carregar as preferências do usuário.

```lua
-- Exemplo de integração com sistema de configuração (Toggle)
-- Ao iniciar:
vooToggle:SetState(lerConfig("modVoo") or false)

-- Ao salvar:
salvarConfig("modVoo", vooToggle:GetState())
```

---

## 📚 Referência Completa da API

| Método | Categoria | Descrição |
| :--- | :--- | :--- |
| `Tekscripts.new(options)` | Inicialização | Cria e retorna a instância principal da janela (`gui`). |
| `gui:CreateTab(options)` | Estrutura | Adiciona uma nova aba à janela. |
| `gui:CreateButton(tab, options)` | Componente | Cria um botão clicável. |
| `Tekscripts:CreateToggle(tab, options)` | Componente | Cria um interruptor (on/off). |
| `Tekscripts:CreateDropdown(tab, options)` | Componente | Cria um menu de seleção. |
| `gui:CreateInput(tab, options)` | Componente | Cria um campo de entrada de texto ou número. |
| `Tekscripts:CreateSlider(tab, options)` | Componente | Cria um controle deslizante. |
| `Tekscripts:CreateSection(tab, options)` | Componente | Cria uma seção colapsável para agrupar outros componentes. |
| `Tekscripts:CreateBind(tab, options)` | Componente | Cria um atalho de teclado personalizável. |
| `gui:CreateLabel(tab, options)` | Estático | Exibe um texto informativo. |
| `gui:CreateTag(tab, options)` | Estático | Adiciona uma etiqueta colorida. |
| `gui:CreateHR(tab, options)` | Estático | Insere uma linha divisória horizontal. |
| `gui:Notify(options)` | Utilidade | Mostra uma notificação temporária na tela. |
| `Tekscripts:CreateFloatingButton(...)` | Utilidade | Cria um botão flutuante. |

---

## 📞 Suporte e Contribuições

Em caso de dúvidas, sugestões, ou para reportar problemas técnicos, encorajamos a comunidade a interagir através dos canais oficiais.

*   **Repositório Oficial:** [GitHub](https://github.com/c0nfigs/LibUix)
*   **Contato:** Entre em contato com a equipe de desenvolvimento através do GitHub ou canais de comunicação associados.

### Considerações Legais

Esta biblioteca foi desenvolvida com fins educacionais e de demonstração. O desenvolvedor não endossa e se isenta de qualquer responsabilidade pelo uso indevido da ferramenta em violação dos Termos de Serviço de qualquer plataforma de jogo.

---

*Documentação atualizada em: 25 de Outubro de 2025*

