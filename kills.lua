local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Backpack = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack")
local Heartbeat = RunService.Heartbeat

local REvents = ReplicatedStorage:FindFirstChild("rEvents") or ReplicatedStorage:WaitForChild("rEvents")
local ChangeSpeedRemote = REvents:FindFirstChild("changeSpeedSizeRemote") or REvents:WaitForChild("changeSpeedSizeRemote")
local MuscleEvent = LocalPlayer:FindFirstChild("muscleEvent") or LocalPlayer:WaitForChild("muscleEvent")
local BrawlEvent = REvents:FindFirstChild("brawlEvent") or REvents:WaitForChild("brawlEvent")
local EquipPetEvent = REvents:FindFirstChild("equipPetEvent") or REvents:WaitForChild("equipPetEvent")

local K1LL = loadstring(game:HttpGet("https://raw.githubusercontent.com/sxazyhub-ai/librery-kill/refs/heads/main/kill.lua", true))():AddWindow("SERAPH KILL", {
    min_size = Vector2.new(500, 870),
    can_resize = false,
    main_color = Color3.fromRGB(0, 0, 0)
})

local function firetouch(p1, p2, s) firetouchinterest(p1, p2, s) end

local function formatNumber(num)
    if type(num) ~= "number" then return "0" end
    if num >= 1e15 then return string.format("%.1fqa", num / 1e15)
    elseif num >= 1e12 then return string.format("%.1ft", num / 1e12)
    elseif num >= 1e9 then return string.format("%.1fb", num / 1e9)
    elseif num >= 1e6 then return string.format("%.1fm", num / 1e6)
    else return tostring(math.floor(num)):gsub("(%d)(%d%d%d)", "%1,%2") end
end

local function limpiarDropdown(d)
    if d then
        pcall(function()
            if d.Clear then d:Clear() return end
            if d.clear then d:clear() return end
            if d.RemoveAll then d:RemoveAll() return end
            if d.SetItems then d:SetItems({}) return end
            if d.Remove then
                local items = d:GetItems() or {}
                for i = #items, 1, -1 do d:Remove(i) end
            end
        end)
    end
end

local function isAnyActive() return false end

_G.whitelistedPlayers = _G.whitelistedPlayers or {}
_G.blacklistedPlayers = _G.blacklistedPlayers or {}
_G.killAll = false
_G.killBlacklistedOnly = false
_G.showDeathRing = false
_G.deathRingRange = 20
_G.fastHitActive = false
_G.AutoSpeed = false
_G.AutoSize = false
_G.selectedPlayerName = nil
_G.targetPlayerName = nil
_G.viewTargetName = nil
_G.whitelistFriends = false
_G.lastWhitelistSelected = nil
_G.killAllConnection = nil
_G.blacklistKillConnection = nil
_G.deathRingConnection = nil
_G.posLock = nil
_G.AdRemovalConnection = nil
_G.AnimBlockConnection = nil
_G.BackpackAddedConnection = nil
_G.CharacterToolAddedConnection = nil
_G.AnimMonitorConnection = nil
_G.CharacterAddedConnection = nil

local Credits = K1LL:AddTab("CREDITS")
local lbl1 = Credits:AddLabel("MERCY")
lbl1.TextSize = 30
lbl1.TextColor3 = Color3.fromRGB(255, 215, 0)
local lbl2 = Credits:AddLabel("EZ GG")
lbl2.TextSize = 26
lbl2.TextColor3 = Color3.fromRGB(0, 255, 0)
local lbl3 = Credits:AddLabel("KOD ON TOP")
lbl3.TextSize = 26
lbl3.TextColor3 = Color3.fromRGB(255, 0, 0)
Credits:AddLabel(" ")

local Main = K1LL:AddTab("Main")
local Killing = K1LL:AddTab("Killing")
local GodMode = K1LL:AddTab("GodMode")
local Specs = K1LL:AddTab("Specs")
local BetterKilling = K1LL:AddTab("Better Killing")
Main:Show()

Main:AddLabel("Settings").TextSize = 30
Main:AddTextBox("Speed", function(text)
    local speed = tonumber(text)
    if speed and Character and Character:FindFirstChild("Humanoid") then
        Character.Humanoid.WalkSpeed = speed
        _G.AutoSpeed = true
    end
end)
Main:AddTextBox("Size", function(text)
    local size = tonumber(text)
    if size then
        ChangeSpeedRemote:InvokeServer("changeSize", size)
        _G.AutoSize = true
    end
end)
Main:AddLabel("Essentials:").TextSize = 30
Main:AddButton("Load Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)
Main:AddButton("Load Anti Lag", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/juywvm/-Roblox-Projects-/main/____Anti_Afk_Remastered_______"))()
end)

_G.AdRemovalConnection = game.DescendantAdded:Connect(function(desc)
    if desc.Name == "RobloxForwardPortals" then desc:Destroy() end
end)

local waterParts = {}
Main:AddSwitch("Walk on Water", function(enabled)
    if enabled then
        local pos = Character.HumanoidRootPart.Position
        local size = 2048
        local step = 2048
        local y = -2
        for x = -3, 3 do
            for z = -3, 3 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(size, 1, size)
                part.Position = Vector3.new(pos.X + x * step, y, pos.Z + z * step)
                part.Anchored = true
                part.Transparency = 1
                part.CanCollide = true
                part.Name = "WaterPart"
                part.Parent = Workspace
                table.insert(waterParts, part)
            end
        end
    else
        for _, part in ipairs(waterParts) do part:Destroy() end
        waterParts = {}
    end
end):Set(false)

Main:AddSwitch("Anti Fling", function(enabled)
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    if enabled then
        if hrp then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5, 0, 1e5)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.P = 1250
            bv.Parent = hrp
        end
    else
        if hrp then
            local bv = hrp:FindFirstChild("BodyVelocity")
            if bv then bv:Destroy() end
        end
    end
end):Set(true)

Main:AddSwitch("Lock Position", function(enabled)
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    if enabled and hrp then
        _G.posLock = Heartbeat:Connect(function()
            if hrp and hrp.Parent then hrp.CFrame = hrp.CFrame end
        end)
    else
        if _G.posLock then _G.posLock:Disconnect() _G.posLock = nil end
    end
end)

Main:AddButton("Rejoin", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

Killing:AddSwitch("Kill while dead (needs Protein Egg)", function(enabled)
    task.spawn(function()
        while enabled do
            local protein = Backpack:FindFirstChild("Protein Egg")
            if protein and protein.Parent == Backpack then protein.Parent = Character end
            local punch = Character:FindFirstChild("Punch")
            if not punch then
                punch = Backpack:FindFirstChild("Punch")
                if punch then punch.Parent = Character end
            end
            task.wait(0.2)
        end
    end)
end)

Killing:AddSwitch("Safe Spot For Killing", function(enabled)
    task.spawn(function()
        while enabled do
            local hrp = Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(-12510.5, -1.6538, 28019.1) end
            task.wait(0.1)
        end
    end)
end)

Killing:AddButton("Size nan", function()
    ChangeSpeedRemote:InvokeServer("changeSize", nan)
end)

local whitelistDropdown = Killing:AddDropdown("Add to Whitelist", function(selected)
    local name = selected:match("| (.+)$")
    if name then
        name = name:gsub("^%s*(.-)%s*$", "%1")
        if not table.find(_G.whitelistedPlayers, name) then
            table.insert(_G.whitelistedPlayers, name)
        end
        actualizarEtiquetasListas()
    end
end)

local blacklistDropdown = Killing:AddDropdown("Add to Blacklist", function(selected)
    local name = selected:match("| (.+)$")
    if name then
        name = name:gsub("^%s*(.-)%s*$", "%1")
        if not table.find(_G.blacklistedPlayers, name) then
            table.insert(_G.blacklistedPlayers, name)
        end
        actualizarEtiquetasListas()
    end
end)

local whitelistLabel = Killing:AddLabel("Whitelist: None")
local blacklistLabel = Killing:AddLabel("Blacklist: None")

local function actualizarEtiquetasListas()
    local wl = #_G.whitelistedPlayers > 0 and table.concat(_G.whitelistedPlayers, ", ") or "None"
    local bl = #_G.blacklistedPlayers > 0 and table.concat(_G.blacklistedPlayers, ", ") or "None"
    whitelistLabel.Text = "Whitelist: " .. wl
    blacklistLabel.Text = "Blacklist: " .. bl
end
actualizarEtiquetasListas()

Killing:AddButton("Clear", function()
    _G.whitelistedPlayers = {}
    _G.blacklistedPlayers = {}
    actualizarEtiquetasListas()
end)

Killing:AddButton("Clear", function()
    -- segundo botón Clear (original tenía dos)
    _G.whitelistedPlayers = {}
    _G.blacklistedPlayers = {}
    actualizarEtiquetasListas()
end)

local function updateDropdowns()
    limpiarDropdown(whitelistDropdown)
    limpiarDropdown(blacklistDropdown)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local entry = player.DisplayName .. " | " .. player.Name
            whitelistDropdown:Add(entry)
            blacklistDropdown:Add(entry)
        end
    end
end
updateDropdowns()

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        local entry = player.DisplayName .. " | " .. player.Name
        whitelistDropdown:Add(entry)
        blacklistDropdown:Add(entry)
    end
end)
Players.PlayerRemoving:Connect(updateDropdowns)

Killing:AddSwitch("Auto Kill", function(enabled)
    _G.killAll = enabled
    if enabled then
        _G.killAllConnection = Heartbeat:Connect(function()
            if tick() % 0.225 < 0.01 then
                local leftHand = Character:FindFirstChild("LeftHand")
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local target = player.Character.HumanoidRootPart
                        if leftHand then
                            firetouch(target, leftHand, 0)
                            firetouch(target, leftHand, 1)
                        end
                        MuscleEvent:FireServer("punch", "leftHand")
                        MuscleEvent:FireServer("punch", "rightHand")
                    end
                end
            end
        end)
    else
        if _G.killAllConnection then
            _G.killAllConnection:Disconnect()
            _G.killAllConnection = nil
        end
    end
end)

Killing:AddSwitch("Whitelist Friends", function(enabled)
    _G.whitelistFriends = enabled
    if enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player:IsFriendsWith(LocalPlayer.UserId) then
                local name = player.Name
                if not table.find(_G.whitelistedPlayers, name) then
                    table.insert(_G.whitelistedPlayers, name)
                end
            end
        end
        actualizarEtiquetasListas()
        Players.PlayerAdded:Connect(function(player)
            if enabled and player ~= LocalPlayer and player:IsFriendsWith(LocalPlayer.UserId) then
                local name = player.Name
                if not table.find(_G.whitelistedPlayers, name) then
                    table.insert(_G.whitelistedPlayers, name)
                end
                actualizarEtiquetasListas()
            end
        end)
    end
end)

Killing:AddSwitch("Auto Kill Players", function(enabled)
    _G.killBlacklistedOnly = enabled
    if enabled then
        _G.blacklistKillConnection = Heartbeat:Connect(function()
            if tick() % 0.225 < 0.01 then
                local leftHand = Character:FindFirstChild("LeftHand")
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        if table.find(_G.blacklistedPlayers, player.Name) then
                            local target = player.Character.HumanoidRootPart
                            if leftHand then
                                firetouch(target, leftHand, 0)
                                firetouch(target, leftHand, 1)
                            end
                            MuscleEvent:FireServer("punch", "leftHand")
                            MuscleEvent:FireServer("punch", "rightHand")
                        end
                    end
                end
            end
        end)
    else
        if _G.blacklistKillConnection then
            _G.blacklistKillConnection:Disconnect()
            _G.blacklistKillConnection = nil
        end
    end
end)

local choosePlayerDropdown = Killing:AddDropdown("Choose Player", function(selected)
    local name = selected:match("| (.+)$")
    if name then _G.selectedPlayerName = name end
end)
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        choosePlayerDropdown:Add(player.DisplayName .. " | " .. player.Name)
    end
end
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        choosePlayerDropdown:Add(player.DisplayName .. " | " .. player.Name)
    end
end)
Players.PlayerRemoving:Connect(function()
    limpiarDropdown(choosePlayerDropdown)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            choosePlayerDropdown:Add(p.DisplayName .. " | " .. p.Name)
        end
    end
end)

Killing:AddSwitch("Spectate", function(enabled)
    if enabled and _G.selectedPlayerName then
        local player = Players:FindFirstChild(_G.selectedPlayerName)
        if player and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then Workspace.CurrentCamera.CameraSubject = hum end
        end
    else
        Workspace.CurrentCamera.CameraSubject = Character:FindFirstChildOfClass("Humanoid")
    end
end):Set(false)

Killing:AddTextBox("Range 1-140", function(text)
    local r = tonumber(text)
    if r then _G.deathRingRange = math.clamp(r, 1, 140) end
end)

local ringPart = nil
Killing:AddSwitch("Death Ring", function(enabled)
    if enabled then
        _G.deathRingConnection = Heartbeat:Connect(function()
            local hrp = Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local pos = hrp.Position
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local target = player.Character.HumanoidRootPart
                    if (pos - target.Position).Magnitude <= _G.deathRingRange then
                        local leftHand = Character:FindFirstChild("LeftHand")
                        if leftHand then
                            firetouch(target, leftHand, 0)
                            firetouch(target, leftHand, 1)
                        end
                        MuscleEvent:FireServer("punch", "leftHand")
                        MuscleEvent:FireServer("punch", "rightHand")
                    end
                end
            end
        end)
    else
        if _G.deathRingConnection then
            _G.deathRingConnection:Disconnect()
            _G.deathRingConnection = nil
        end
    end
end):Set(false)

Killing:AddSwitch("Show Ring", function(enabled)
    if enabled then
        ringPart = Instance.new("Part")
        ringPart.Shape = Enum.PartType.Cylinder
        ringPart.Material = Enum.Material.Neon
        ringPart.Color = Color3.fromRGB(50, 163, 255)
        ringPart.Transparency = 0.6
        ringPart.Anchored = true
        ringPart.CanCollide = false
        ringPart.CastShadow = false
        ringPart.Size = Vector3.new(0.2, _G.deathRingRange * 2, _G.deathRingRange * 2)
        ringPart.Parent = Workspace
        Heartbeat:Connect(function()
            if ringPart and Character and Character:FindFirstChild("HumanoidRootPart") then
                ringPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.Angles(0, 0, math.pi / 2)
            end
        end)
    else
        if ringPart then ringPart:Destroy() ringPart = nil end
    end
end):Set(false)

Killing:AddSwitch("Auto Kill Evil Karma", function(enabled)
    task.spawn(function()
        while enabled do
            local right = Character:FindFirstChild("RightHand")
            local left = Character:FindFirstChild("LeftHand")
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local evil = player:FindFirstChild("evilKarma")
                    local good = player:FindFirstChild("goodKarma")
                    if evil and good and evil:IsA("IntValue") and good:IsA("IntValue") then
                        if good.Value > evil.Value then
                            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                if right then firetouch(right, hrp, 1) firetouch(right, hrp, 0) end
                                if left then firetouch(left, hrp, 1) firetouch(left, hrp, 0) end
                            end
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end)

Killing:AddSwitch("Auto Kill Good Karma", function(enabled)
    task.spawn(function()
        while enabled do
            local right = Character:FindFirstChild("RightHand")
            local left = Character:FindFirstChild("LeftHand")
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local evil = player:FindFirstChild("evilKarma")
                    local good = player:FindFirstChild("goodKarma")
                    if evil and good and evil:IsA("IntValue") and good:IsA("IntValue") then
                        if evil.Value > good.Value then
                            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                if right then firetouch(right, hrp, 1) firetouch(right, hrp, 0) end
                                if left then firetouch(left, hrp, 1) firetouch(left, hrp, 0) end
                            end
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end)

GodMode:AddLabel("PACK SPAM & PETS").TextSize = 30

local packSpamRunning = false
GodMode:AddButton("Start Pack Spam", function()
    if packSpamRunning then return end
    packSpamRunning = true
    task.spawn(function()
        while packSpamRunning do
            local pets = LocalPlayer:FindFirstChild("petsFolder")
            if pets then
                local unique = pets:FindFirstChild("Unique")
                if unique then
                    for _, folder in ipairs(unique:GetChildren()) do
                        if folder:IsA("Folder") then
                            for _, pet in ipairs(folder:GetChildren()) do
                                EquipPetEvent:FireServer("equipPet", pet)
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end)

GodMode:AddButton("Stop Pack Spam", function()
    packSpamRunning = false
    print("[PackSpam] Detenido")
end)

local function equipPetByName(petName)
    local pets = LocalPlayer:FindFirstChild("petsFolder")
    if not pets then return end
    local unique = pets:FindFirstChild("Unique")
    if not unique then return end
    for _, folder in ipairs(unique:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in ipairs(folder:GetChildren()) do
                EquipPetEvent:FireServer("unequipPet", pet)
            end
        end
    end
    task.wait(0.2)
    for _, folder in ipairs(unique:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in ipairs(folder:GetChildren()) do
                if pet.Name == petName then
                    EquipPetEvent:FireServer("equipPet", pet)
                end
            end
        end
    end
end

GodMode:AddButton("Equip Wild Wizard", function() equipPetByName("Wild Wizard") end)
GodMode:AddButton("Equip Mighty Monster", function() equipPetByName("Mighty Monster") end)

Specs:AddLabel("Player Stats:").TextSize = 24

local specDropdown = Specs:AddDropdown("Choose Player", function(selected)
    local name = selected:match("| (.+)$")
    if name then
        local player = Players:FindFirstChild(name)
        if player then updateSpecs(player) end
    end
end)
for _, player in ipairs(Players:GetPlayers()) do
    specDropdown:Add(player.DisplayName .. " | " .. player.Name)
end
Players.PlayerAdded:Connect(function(player)
    specDropdown:Add(player.DisplayName .. " | " .. player.Name)
end)
Players.PlayerRemoving:Connect(function()
    limpiarDropdown(specDropdown)
    for _, p in ipairs(Players:GetPlayers()) do
        specDropdown:Add(p.DisplayName .. " | " .. p.Name)
    end
end)

local nameLabel = Specs:AddLabel("Name: N/A")
nameLabel.TextSize = 20
local userLabel = Specs:AddLabel("Username: N/A")
userLabel.TextSize = 20
local strLabel = Specs:AddLabel("Strength: 0")
strLabel.TextSize = 20
local rebLabel = Specs:AddLabel("Rebirths: 0")
rebLabel.TextSize = 20
local durLabel = Specs:AddLabel("Durability: 0")
durLabel.TextSize = 20
local agiLabel = Specs:AddLabel("Agility: 0")
agiLabel.TextSize = 20
local killLabel = Specs:AddLabel("Kills: 0")
killLabel.TextSize = 20
local evilLabel = Specs:AddLabel("Evil Karma: 0")
evilLabel.TextSize = 20
local goodLabel = Specs:AddLabel("Good Karma: 0")
goodLabel.TextSize = 20
local brawlLabel = Specs:AddLabel("Brawls: 0")
brawlLabel.TextSize = 20

function updateSpecs(player)
    if not player then return end
    nameLabel.Text = "Name: " .. player.DisplayName
    userLabel.Text = "Username: " .. player.Name
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        local s = ls:FindFirstChild("Strength")
        if s and type(s.Value) == "number" then strLabel.Text = "Strength: " .. formatNumber(s.Value) end
        local r = ls:FindFirstChild("Rebirths")
        if r and type(r.Value) == "number" then rebLabel.Text = "Rebirths: " .. formatNumber(r.Value) end
        local k = ls:FindFirstChild("Kills")
        if k and type(k.Value) == "number" then killLabel.Text = "Kills: " .. formatNumber(k.Value) end
    end
    local dur = player:FindFirstChild("Durability")
    if dur and type(dur.Value) == "number" then durLabel.Text = "Durability: " .. formatNumber(dur.Value) end
    local evil = player:FindFirstChild("evilKarma")
    if evil and type(evil.Value) == "number" then evilLabel.Text = "Evil Karma: " .. formatNumber(evil.Value) end
    local good = player:FindFirstChild("goodKarma")
    if good and type(good.Value) == "number" then goodLabel.Text = "Good Karma: " .. formatNumber(good.Value) end
    local brawl = player:FindFirstChild("brawls")
    if brawl and type(brawl.Value) == "number" then brawlLabel.Text = "Brawls: " .. formatNumber(brawl.Value) end
    local agi = player:FindFirstChild("Agility")
    if agi and type(agi.Value) == "number" then agiLabel.Text = "Agility: " .. formatNumber(agi.Value) end
end

Specs:AddLabel("────────────────────────────")
Specs:AddLabel("Advanced Stats:").TextSize = 24
local enemyHealthLabel = Specs:AddLabel("Enemy Health: N/A")
enemyHealthLabel.TextSize = 20
enemyHealthLabel.TextColor3 = Color3.fromRGB(0, 140, 255)
local yourDamageLabel = Specs:AddLabel("Your Damage: N/A")
yourDamageLabel.TextSize = 20
yourDamageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
local hitsToKillLabel = Specs:AddLabel("Hits to Kill: N/A")
hitsToKillLabel.TextSize = 20
hitsToKillLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

task.spawn(function()
    while true do
        local sel = _G.selectedPlayerName
        if sel then
            local player = Players:FindFirstChild(sel)
            if player then
                local dur = player:FindFirstChild("Durability")
                local inf = player:FindFirstChild("ultimatesFolder") and player.ultimatesFolder:FindFirstChild("Infernal Health")
                if dur and inf and type(dur.Value) == "number" and type(inf.Value) == "number" then
                    local enemyHP = dur.Value * (1 + 0.15 * inf.Value + 0.5)
                    enemyHealthLabel.Text = "Enemy Health: " .. formatNumber(enemyHP)
                end
                local ls = LocalPlayer:FindFirstChild("leaderstats")
                local str = ls and ls:FindFirstChild("Strength")
                local demon = LocalPlayer:FindFirstChild("ultimatesFolder") and LocalPlayer.ultimatesFolder:FindFirstChild("Demon Damage")
                if str and type(str.Value) == "number" then
                    local dmg = str.Value * 0.0667 * (1 + 0.1 * (demon and type(demon.Value) == "number" and demon.Value or 0) + 0.5)
                    yourDamageLabel.Text = "Your Damage: " .. formatNumber(dmg)
                    if dur and inf and type(dur.Value) == "number" and type(inf.Value) == "number" then
                        local enemyHP = dur.Value * (1 + 0.15 * inf.Value + 0.5)
                        hitsToKillLabel.Text = "Hits to Kill: " .. math.ceil(enemyHP / dmg)
                    end
                end
            end
        end
        task.wait(1)
    end
end)

BetterKilling:AddLabel("Select damage or durability pet").TextSize = 18
BetterKilling:AddLabel("(Auto-equip up to 8 of the chosen pet)").TextSize = 14

local petDropdown = BetterKilling:AddDropdown("Select Pet", function(selected)
    local pets = LocalPlayer:FindFirstChild("petsFolder")
    if not pets then return end
    local unique = pets:FindFirstChild("Unique")
    if not unique then return end
    local targets = {}
    for _, folder in ipairs(unique:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in ipairs(folder:GetChildren()) do
                if pet.Name == selected then
                    table.insert(targets, pet)
                end
            end
        end
    end
    for i = 1, math.min(#targets, 8) do
        EquipPetEvent:FireServer("equipPet", targets[i])
        task.wait(0.1)
    end
end)

local function refreshPetList()
    limpiarDropdown(petDropdown)
    local pets = LocalPlayer:FindFirstChild("petsFolder")
    if pets then
        local unique = pets:FindFirstChild("Unique")
        if unique then
            for _, folder in ipairs(unique:GetChildren()) do
                if folder:IsA("Folder") then
                    for _, pet in ipairs(folder:GetChildren()) do
                        petDropdown:Add(pet.Name)
                    end
                end
            end
        end
    end
end
refreshPetList()

BetterKilling:AddSwitch("Auto Good Karma", function(enabled)
    task.spawn(function()
        while enabled do
            local right = Character:FindFirstChild("RightHand")
            local left = Character:FindFirstChild("LeftHand")
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local evil = player:FindFirstChild("evilKarma")
                    local good = player:FindFirstChild("goodKarma")
                    if evil and good and evil:IsA("IntValue") and good:IsA("IntValue") then
                        if evil.Value > good.Value then
                            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                if right then firetouch(right, hrp, 1) firetouch(right, hrp, 0) end
                                if left then firetouch(left, hrp, 1) firetouch(left, hrp, 0) end
                            end
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end)

BetterKilling:AddSwitch("Auto Bad Karma", function(enabled)
    task.spawn(function()
        while enabled do
            local right = Character:FindFirstChild("RightHand")
            local left = Character:FindFirstChild("LeftHand")
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local evil = player:FindFirstChild("evilKarma")
                    local good = player:FindFirstChild("goodKarma")
                    if evil and good and evil:IsA("IntValue") and good:IsA("IntValue") then
                        if good.Value > evil.Value then
                            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                if right then firetouch(right, hrp, 1) firetouch(right, hrp, 0) end
                                if left then firetouch(left, hrp, 1) firetouch(left, hrp, 0) end
                            end
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end)

BetterKilling:AddSwitch("Auto Whitelist Friends", function(enabled)
    if enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player:IsFriendsWith(LocalPlayer.UserId) then
                local name = player.Name
                if not table.find(_G.whitelistedPlayers, name) then
                    table.insert(_G.whitelistedPlayers, name)
                end
            end
        end
        actualizarEtiquetasListas()
        Players.PlayerAdded:Connect(function(player)
            if enabled and player ~= LocalPlayer and player:IsFriendsWith(LocalPlayer.UserId) then
                local name = player.Name
                if not table.find(_G.whitelistedPlayers, name) then
                    table.insert(_G.whitelistedPlayers, name)
                end
                actualizarEtiquetasListas()
            end
        end)
    end
end)

local whitelistBetter = BetterKilling:AddDropdown("Add to Whitelist", function(selected)
    local name = selected:match("| (.+)$")
    if name then
        name = name:gsub("^%s*(.-)%s*$", "%1")
        if not table.find(_G.whitelistedPlayers, name) then
            table.insert(_G.whitelistedPlayers, name)
        end
        _G.lastWhitelistSelected = name
        actualizarEtiquetasListas()
        print(name .. " añadido a Whitelist")
    end
end)
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        whitelistBetter:Add(player.DisplayName)
    end
end
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        whitelistBetter:Add(player.DisplayName)
    end
end)
Players.PlayerRemoving:Connect(function()
    limpiarDropdown(whitelistBetter)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            whitelistBetter:Add(p.DisplayName)
        end
    end
end)

BetterKilling:AddButton("Remove Selected Whitelist", function()
    if _G.lastWhitelistSelected then
        for i, name in ipairs(_G.whitelistedPlayers) do
            if name == _G.lastWhitelistSelected then
                table.remove(_G.whitelistedPlayers, i)
                print(_G.lastWhitelistSelected .. " eliminado de Whitelist")
                _G.lastWhitelistSelected = nil
                actualizarEtiquetasListas()
                break
            end
        end
    end
end)

BetterKilling:AddSwitch("Auto Kill", function(enabled)
    task.spawn(function()
        while enabled do
            local right = Character:FindFirstChild("RightHand")
            local left = Character:FindFirstChild("LeftHand")
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    if not table.find(_G.whitelistedPlayers, player.Name) then
                        local hrp = player.Character.HumanoidRootPart
                        if right then firetouch(right, hrp, 1) firetouch(right, hrp, 0) end
                        if left then firetouch(left, hrp, 1) firetouch(left, hrp, 0) end
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end)

local targetDropdown = BetterKilling:AddDropdown("Select Target", function(selected)
    local name = selected:match("| (.+)$")
    if name then _G.targetPlayerName = name end
end)
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        targetDropdown:Add(player.DisplayName)
    end
end
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        targetDropdown:Add(player.DisplayName)
    end
end)
Players.PlayerRemoving:Connect(function()
    limpiarDropdown(targetDropdown)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            targetDropdown:Add(p.DisplayName)
        end
    end
end)

BetterKilling:AddButton("Remove Selected Target", function()
    _G.targetPlayerName = nil
    print("Objetivo eliminado")
end)

BetterKilling:AddSwitch("Start Kill Target", function(enabled)
    task.spawn(function()
        while enabled and _G.targetPlayerName do
            local target = Players:FindFirstChild(_G.targetPlayerName)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = target.Character.HumanoidRootPart
                local right = Character:FindFirstChild("RightHand")
                local left = Character:FindFirstChild("LeftHand")
                if right then firetouch(right, hrp, 1) firetouch(right, hrp, 0) end
                if left then firetouch(left, hrp, 1) firetouch(left, hrp, 0) end
            end
            task.wait(0.1)
        end
    end)
end)

local viewDropdown = BetterKilling:AddDropdown("Select View Target", function(selected)
    local name = selected:match("| (.+)$")
    if name then _G.viewTargetName = name end
end)
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        viewDropdown:Add(player.DisplayName)
    end
end
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        viewDropdown:Add(player.DisplayName)
    end
end)
Players.PlayerRemoving:Connect(function()
    limpiarDropdown(viewDropdown)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            viewDropdown:Add(p.DisplayName)
        end
    end
end)

BetterKilling:AddSwitch("View Player", function(enabled)
    task.spawn(function()
        while enabled and _G.viewTargetName do
            local target = Players:FindFirstChild(_G.viewTargetName)
            if target and target.Character then
                local hum = target.Character:FindFirstChildOfClass("Humanoid")
                if hum then Workspace.CurrentCamera.CameraSubject = hum end
            end
            task.wait(0.1)
        end
        if not enabled then
            Workspace.CurrentCamera.CameraSubject = Character:FindFirstChildOfClass("Humanoid")
        end
    end)
end)

BetterKilling:AddButton("Remove Punch Anim", function()
    local humanoid = Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        if track.Animation and track.Animation.AnimationId then
            local id = track.Animation.AnimationId
            if id == "rbxassetid://3638729053" or id == "rbxassetid://3638767427" then
                track:Stop()
            end
        end
    end
    if not _G.AnimBlockConnection then
        _G.AnimBlockConnection = humanoid.AnimationPlayed:Connect(function(anim)
            if anim.Animation and anim.Animation.AnimationId then
                local id = anim.Animation.AnimationId
                if id == "rbxassetid://3638729053" or id == "rbxassetid://3638767427" then
                    anim:Stop()
                end
            end
        end)
    end
    if not _G.CharacterToolAddedConnection then
        _G.CharacterToolAddedConnection = Character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and child.Name:match("Punch") then
                task.wait(0.1)
                local h = Character:FindFirstChild("Humanoid")
                if h then
                    for _, track in ipairs(h:GetPlayingAnimationTracks()) do
                        if track.Animation and track.Animation.AnimationId then
                            local id = track.Animation.AnimationId
                            if id == "rbxassetid://3638729053" or id == "rbxassetid://3638767427" then
                                track:Stop()
                            end
                        end
                    end
                end
            end
        end)
    end
end)

BetterKilling:AddButton("Recover Punch Anim", function()
    if _G.AnimBlockConnection then
        _G.AnimBlockConnection:Disconnect()
        _G.AnimBlockConnection = nil
    end
    if _G.CharacterToolAddedConnection then
        _G.CharacterToolAddedConnection:Disconnect()
        _G.CharacterToolAddedConnection = nil
    end
    print("Animaciones de golpe restauradas")
end)

BetterKilling:AddSwitch("Auto Punch [without animation]", function(enabled)
    task.spawn(function()
        while enabled do
            local punch = Character:FindFirstChild("Punch")
            if not punch then
                punch = Backpack:FindFirstChild("Punch")
                if punch then punch.Parent = Character end
            end
            if punch then
                if punch:FindFirstChild("attackTime") then
                    punch.attackTime.Value = 0
                end
                punch:Activate()
            end
            task.wait(0.1)
        end
    end)
end)

BetterKilling:AddSwitch("Auto Punch", function(enabled)
    _G.fastHitActive = enabled
    task.spawn(function()
        while enabled do
            local punch = Character:FindFirstChild("Punch")
            if not punch then
                punch = Backpack:FindFirstChild("Punch")
                if punch then punch.Parent = Character end
            end
            if punch then
                if punch:FindFirstChild("attackTime") then
                    punch.attackTime.Value = 0
                end
                punch:Activate()
            end
            task.wait(0.1)
        end
    end)
end)

BetterKilling:AddSwitch("God mode", function(enabled)
    task.spawn(function()
        while enabled do
            BrawlEvent:FireServer("joinBrawl")
            task.wait(0.5)
        end
    end)
end)

BetterKilling:AddButton("Size 30", function()
    ChangeSpeedRemote:InvokeServer("changeSize", 30)
end)
BetterKilling:AddButton("Size 2", function()
    ChangeSpeedRemote:InvokeServer("changeSize", 2)
end)

local teleportDropdown = BetterKilling:AddDropdown("Teleport player", function(selected)
    local name = selected:match("| (.+)$")
    if name then
        local player = Players:FindFirstChild(name)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local target = player.Character.HumanoidRootPart
            local myHRP = Character:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = CFrame.new(target.Position - target.CFrame.LookVector * 3, target.Position)
            end
            print("Teletransportado a " .. player.Name)
        end
    end
end)
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        teleportDropdown:Add(player.DisplayName)
    end
end
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        teleportDropdown:Add(player.DisplayName)
    end
end)
Players.PlayerRemoving:Connect(function()
    limpiarDropdown(teleportDropdown)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            teleportDropdown:Add(p.DisplayName)
        end
    end
end)

BetterKilling:AddButton("Dejar de Seguir", function()
    print("Dejó de seguir")
end)

BetterKilling:AddSwitch("auto slams", function(enabled)
    task.spawn(function()
        while enabled do
            local slam = Backpack:FindFirstChild("Ground Slam")
            if slam then
                if slam:FindFirstChild("attackTime") then
                    slam.attackTime.Value = 0
                end
                MuscleEvent:FireServer("slam")
                slam:Activate()
            end
            task.wait(0.1)
        end
    end)
end)

BetterKilling:AddLabel("Dead Ring:").TextSize = 22
BetterKilling:AddTextBox("Range 1-150", function(text)
    local r = tonumber(text)
    if r then _G.deathRingRange = math.clamp(r, 1, 150) end
end)

BetterKilling:AddSwitch("Death Ring", function(enabled)
    if enabled then
        _G.deathRingConnection = Heartbeat:Connect(function()
            local hrp = Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local pos = hrp.Position
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local target = player.Character.HumanoidRootPart
                    if (pos - target.Position).Magnitude <= _G.deathRingRange then
                        local left = Character:FindFirstChild("LeftHand")
                        if left then
                            firetouch(target, left, 0)
                            firetouch(target, left, 1)
                        end
                        MuscleEvent:FireServer("punch", "leftHand")
                        MuscleEvent:FireServer("punch", "rightHand")
                    end
                end
            end
        end)
    else
        if _G.deathRingConnection then
            _G.deathRingConnection:Disconnect()
            _G.deathRingConnection = nil
        end
    end
end)

BetterKilling:AddSwitch("Show Ring", function(enabled)
    if enabled then
        if not ringPart then
            ringPart = Instance.new("Part")
            ringPart.Shape = Enum.PartType.Cylinder
            ringPart.Material = Enum.Material.Neon
            ringPart.Color = Color3.fromRGB(50, 163, 255)
            ringPart.Transparency = 0.6
            ringPart.Anchored = true
            ringPart.CanCollide = false
            ringPart.CastShadow = false
            ringPart.Size = Vector3.new(0.2, _G.deathRingRange * 2, _G.deathRingRange * 2)
            ringPart.Parent = Workspace
        end
        Heartbeat:Connect(function()
            if ringPart and Character and Character:FindFirstChild("HumanoidRootPart") then
                ringPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.Angles(0, 0, math.pi / 2)
            end
        end)
    else
        if ringPart then ringPart:Destroy() ringPart = nil end
    end
end)

local timeDropdown = BetterKilling:AddDropdown("change time", function(selected)
    local times = {Morning = 6, Noon = 12, Afternoon = 15, Sunset = 18, Night = 21, Midnight = 0, Dawn = 5, ["Early Morning"] = 7}
    if times[selected] then
        Lighting.ClockTime = times[selected]
        Lighting.Brightness = 2
        Lighting.FogEnd = 1e5
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        if selected == "Morning" then
            Lighting.Ambient = Color3.fromRGB(200, 200, 255)
        end
    end
end)
timeDropdown:Add("Morning")
timeDropdown:Add("Noon")
timeDropdown:Add("Afternoon")
timeDropdown:Add("Sunset")
timeDropdown:Add("Night")
timeDropdown:Add("Midnight")
timeDropdown:Add("Dawn")
timeDropdown:Add("Early Morning")

local blacklistFile = "GenesisBlacklist_" .. LocalPlayer.Name .. ".txt"
if not isfile(blacklistFile) then
    writefile(blacklistFile, "")
end

BetterKilling:AddLabel("Add the display name or initials of his clan").TextSize = 14
local blacklistLabelBK = BetterKilling:AddLabel("Blacklist: (empty)")

local function updateBlacklistLabelBK()
    local content = readfile(blacklistFile)
    if content == "" then
        blacklistLabelBK.Text = "Blacklist: (empty)"
    else
        blacklistLabelBK.Text = "Blacklist: " .. content
    end
end
updateBlacklistLabelBK()

BetterKilling:AddTextBox("Add to Blacklist", function(text)
    local newEntries = {}
    for entry in string.gmatch(text, "[^,]+") do
        local trimmed = entry:match("^%s*(.-)%s*$"):lower()
        if trimmed ~= "" then
            table.insert(newEntries, trimmed)
        end
    end
    local existing = readfile(blacklistFile)
    local currentList = {}
    if existing ~= "" then
        for entry in string.gmatch(existing, "[^,]+") do
            local trimmed = entry:match("^%s*(.-)%s*$"):lower()
            if trimmed ~= "" then
                table.insert(currentList, trimmed)
            end
        end
    end
    for _, entry in ipairs(newEntries) do
        if not table.find(currentList, entry) then
            table.insert(currentList, entry)
        end
    end
    writefile(blacklistFile, table.concat(currentList, ","))
    updateBlacklistLabelBK()
    _G.blacklistedPlayers = currentList
    actualizarEtiquetasListas()
end, {placeholder = "Ej: MVX, Sigma, Juan"})

BetterKilling:AddTextBox("Remove from Blacklist", function(text)
    local toRemove = {}
    for entry in string.gmatch(text, "[^,]+") do
        local trimmed = entry:match("^%s*(.-)%s*$"):lower()
        if trimmed ~= "" then
            table.insert(toRemove, trimmed)
        end
    end
    local existing = readfile(blacklistFile)
    local currentList = {}
    if existing ~= "" then
        for entry in string.gmatch(existing, "[^,]+") do
            local trimmed = entry:match("^%s*(.-)%s*$"):lower()
            if trimmed ~= "" then
                table.insert(currentList, trimmed)
            end
        end
    end
    for _, entry in ipairs(toRemove) do
        for i = #currentList, 1, -1 do
            if currentList[i] == entry then
                table.remove(currentList, i)
                break
            end
        end
    end
    writefile(blacklistFile, table.concat(currentList, ","))
    updateBlacklistLabelBK()
    _G.blacklistedPlayers = currentList
    actualizarEtiquetasListas()
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Backpack = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack")
    MuscleEvent = LocalPlayer:FindFirstChild("muscleEvent") or LocalPlayer:WaitForChild("muscleEvent")
end)

if not Character then
    Character = LocalPlayer.CharacterAdded:Wait()
end
Backpack = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack")

local existingBL = readfile(blacklistFile)
if existingBL ~= "" then
    for entry in string.gmatch(existingBL, "[^,]+") do
        local trimmed = entry:match("^%s*(.-)%s*$"):lower()
        if trimmed ~= "" and not table.find(_G.blacklistedPlayers, trimmed) then
            table.insert(_G.blacklistedPlayers, trimmed)
        end
    end
end
actualizarEtiquetasListas()
print("K1LL Script cargado completamente.")
