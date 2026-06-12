-- [[ 191 ULTIMATE SOUND UI SYSTEM v5 ]] --
local Players = game:GetService("Players")
local TweetService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ลิงก์ยิง Remote Event ของมึง
local PlayerToolEvent = game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("PlayerToolEvent")

-- ระบบฐานข้อมูลเก็บเพลงภายในเครื่องแยกตามไอดีผู้เล่น
local SAVE_KEY = "191_SavedSongs_" .. tostring(LocalPlayer.UserId)
local SavedSongs = {}

-- โหลดข้อมูลเพลงเก่า
local success, data = pcall(function() return plugin and plugin:GetSetting(SAVE_KEY) or nil end)
if success and data then
    local decoded = HttpService:JSONDecode(data)
    if type(decoded) == "table" then SavedSongs = decoded end
end

local function saveData()
    pcall(function()
        if plugin then
            plugin:SetSetting(SAVE_KEY, HttpService:JSONEncode(SavedSongs))
        end
    end)
end

-- เอฟเฟกต์เสียงปุ่ม UI
local function playClickSound()
    local sound = Instance.new("Sound", workspace)
    sound.SoundId = "rbxassetid://8336214534"
    sound.Volume = 0.3
    sound.PlayOnRemove = true
    sound:Destroy()
end

-- ==================== [ หน้าต่างหลัก UI ดีไซน์ดำ-ม่วง ] ====================
if PlayerGui:FindFirstChild("System_191_SoundUI") then PlayerGui.System_191_SoundUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "System_191_SoundUI"
ScreenGui.ResetOnSpawn = false

-- 🔮 ปุ่มวงกลมเปิด/ปิด UI (เริ่มต้นอยู่กลางจอซ้ายบน สำหรับแนวนอนมือถือ และลากได้อิสระ)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 20, 0.35, 0) -- 📍 ตั้งค่าเริ่มต้นตรงกลางจอซ้ายบนตามสั่ง
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
ToggleBtn.Text = "🔮"
ToggleBtn.TextSize = 20
ToggleBtn.TextColor3 = Color3.fromRGB(180, 70, 255)
ToggleBtn.Visible = false -- เริ่มแรกซ่อนไว้ เพราะหน้าต่างหลักเปิดอยู่
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 22)
local tStroke = Instance.new("UIStroke", ToggleBtn)
tStroke.Color = Color3.fromRGB(140, 50, 220)
tStroke.Thickness = 1.5

-- หน้าต่างบอร์ดหลัก
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160) -- เริ่มต้นกลางจอพอดีเป๊ะ
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 20)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local mStroke = Instance.new("UIStroke", MainFrame)
mStroke.Color = Color3.fromRGB(140, 50, 220)
mStroke.Thickness = 2

-- ส่วนหัวหน้าต่างลากได้
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 18, 35)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "AUDIO STATION [191]"
Title.TextColor3 = Color3.fromRGB(200, 150, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ปุ่มย่อหน้าต่างหลัก (Minimize) อยู่มุมขวาบนในกรอบ
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
CloseBtn.Text = "➖"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- ส่วนสลับหมวดหมู่แบบไอคอนรูปย่อย
local TabMenuFrame = Instance.new("Frame", MainFrame)
TabMenuFrame.Size = UDim2.new(1, -30, 0, 35)
TabMenuFrame.Position = UDim2.new(0, 15, 0, 50)
TabMenuFrame.BackgroundTransparency = 1

local Tab1Btn = Instance.new("TextButton", TabMenuFrame)
Tab1Btn.Size = UDim2.new(0, 50, 1, 0)
Tab1Btn.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
Tab1Btn.Text = "🎵"
Tab1Btn.TextSize = 18
Instance.new("UICorner", Tab1Btn).CornerRadius = UDim.new(0, 6)

local Tab2Btn = Instance.new("TextButton", TabMenuFrame)
Tab2Btn.Size = UDim2.new(0, 50, 1, 0)
Tab2Btn.Position = UDim2.new(0, 55, 0, 0)
Tab2Btn.BackgroundColor3 = Color3.fromRGB(25, 15, 35)
Tab2Btn.Text = "💾"
Tab2Btn.TextSize = 18
Instance.new("UICorner", Tab2Btn).CornerRadius = UDim.new(0, 6)

-- หน้าคอนเทนต์
local PagePlayer = Instance.new("Frame", MainFrame)
PagePlayer.Size = UDim2.new(1, -30, 0, 210)
PagePlayer.Position = UDim2.new(0, 15, 0, 95)
PagePlayer.BackgroundTransparency = 1

local PageSaveSystem = Instance.new("Frame", MainFrame)
PageSaveSystem.Size = UDim2.new(1, -30, 0, 210)
PageSaveSystem.Position = UDim2.new(0, 15, 0, 95)
PageSaveSystem.BackgroundTransparency = 1
PageSaveSystem.Visible = false

-- ==================== [ หมวดหมู่ 🎵: หน้าเครื่องเล่น Waveform ] ====================
local WaveformBox = Instance.new("Frame", PagePlayer)
WaveformBox.Size = UDim2.new(0.5, -10, 0.75, 0)
WaveformBox.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
Instance.new("UICorner", WaveformBox).CornerRadius = UDim.new(0, 6)
local wStroke = Instance.new("UIStroke", WaveformBox)
wStroke.Color = Color3.fromRGB(60, 35, 95)

local CreditText = Instance.new("TextLabel", WaveformBox)
CreditText.Size = UDim2.new(1, 0, 0, 20)
CreditText.Position = UDim2.new(0, 0, 0, 5)
CreditText.BackgroundTransparency = 1
CreditText.Text = "191 SYSTEM"
CreditText.TextColor3 = Color3.fromRGB(140, 50, 220)
CreditText.Font = Enum.Font.GothamBold
CreditText.TextSize = 12
CreditText.TextTransparency = 0.4

local TimeLabel = Instance.new("TextLabel", PagePlayer)
TimeLabel.Size = UDim2.new(0.5, -10, 0, 20)
TimeLabel.Position = UDim2.new(0, 0, 0.8, 0)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "STATUS: IDLE"
TimeLabel.TextColor3 = Color3.fromRGB(160, 140, 180)
TimeLabel.Font = Enum.Font.Code
TimeLabel.TextSize = 11

local IDInput = Instance.new("TextBox", PagePlayer)
IDInput.Size = UDim2.new(0.5, -5, 0, 35)
IDInput.Position = UDim2.new(0.5, 5, 0, 0)
IDInput.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
IDInput.Text = ""
IDInput.PlaceholderText = "กรอกหรือวางไอดีเพลง..."
IDInput.TextColor3 = Color3.fromRGB(255, 255, 255)
IDInput.Font = Enum.Font.Gotham
IDInput.TextSize = 13
Instance.new("UICorner", IDInput).CornerRadius = UDim.new(0, 6)
local iStroke = Instance.new("UIStroke", IDInput)
iStroke.Color = Color3.fromRGB(90, 45, 145)

local TrackNameLabel = Instance.new("TextLabel", PagePlayer)
TrackNameLabel.Size = UDim2.new(0.5, -5, 0, 30)
TrackNameLabel.Position = UDim2.new(0.5, 5, 0, 40)
TrackNameLabel.BackgroundTransparency = 1
TrackNameLabel.Text = "SONG: ไม่ได้เปิดเพลง"
TrackNameLabel.TextColor3 = Color3.fromRGB(220, 100, 255)
TrackNameLabel.Font = Enum.Font.GothamBold
TrackNameLabel.TextSize = 13
TrackNameLabel.TextXAlignment = Enum.TextXAlignment.Left
TrackNameLabel.TextWrapped = true

local PlayBtn = Instance.new("TextButton", PagePlayer)
PlayBtn.Size = UDim2.new(0.5, -5, 0, 45)
PlayBtn.Position = UDim2.new(0.5, 5, 0, 75)
PlayBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 220)
PlayBtn.Text = "▶️ FIRE REMOTE"
PlayBtn.Font = Enum.Font.GothamBold
PlayBtn.TextSize = 13
PlayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0, 6)

-- แท่งคลื่นเสียงจำลอง
local waveBars = {}
local barWidth = 1 / 18
for i = 1, 18 do
    local bar = Instance.new("Frame", WaveformBox)
    bar.Size = UDim2.new(barWidth, -2, 0.05, 0)
    bar.Position = UDim2.new(barWidth * (i - 1), 1, 0.85, 0)
    bar.AnchorPoint = Vector2.new(0, 1)
    bar.BackgroundColor3 = Color3.fromRGB(180, 70, 255)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 1)
    table.insert(waveBars, bar)
end

-- ==================== [ หมวดหมู่ 💾: หน้าระบบเซฟเพลงแยกไอดีเครื่อง ] ====================
local SaveNameInput = Instance.new("TextBox", PageSaveSystem)
SaveNameInput.Size = UDim2.new(0.42, -5, 0, 32)
SaveNameInput.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
SaveNameInput.Text = ""
SaveNameInput.PlaceholderText = "ตั้งชื่อเพลง..."
SaveNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveNameInput.TextSize = 12
Instance.new("UICorner", SaveNameInput).CornerRadius = UDim.new(0, 5)

local SaveIDInput = Instance.new("TextBox", PageSaveSystem)
SaveIDInput.Size = UDim2.new(0.35, -5, 0, 32)
SaveIDInput.Position = UDim2.new(0.42, 0, 0, 0)
SaveIDInput.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
SaveIDInput.Text = ""
SaveIDInput.PlaceholderText = "ไอดีเพลง..."
SaveIDInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveIDInput.TextSize = 12
Instance.new("UICorner", SaveIDInput).CornerRadius = UDim.new(0, 5)

local FinalSaveBtn = Instance.new("TextButton", PageSaveSystem)
FinalSaveBtn.Size = UDim2.new(0.23, 0, 0, 32)
FinalSaveBtn.Position = UDim2.new(0.77, 0, 0, 0)
FinalSaveBtn.BackgroundColor3 = Color3.fromRGB(45, 140, 85)
FinalSaveBtn.Text = "💾 บันทึกลงเครื่อง"
FinalSaveBtn.Font = Enum.Font.GothamBold
FinalSaveBtn.TextSize = 11
FinalSaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", FinalSaveBtn).CornerRadius = UDim.new(0, 5)

local SongScroll = Instance.new("ScrollingFrame", PageSaveSystem)
SongScroll.Size = UDim2.new(1, 0, 0, 165)
SongScroll.Position = UDim2.new(0, 0, 0, 40)
SongScroll.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
SongScroll.BorderSizePixel = 0
SongScroll.ScrollBarThickness = 4
SongScroll.ScrollBarImageColor3 = Color3.fromRGB(140, 50, 220)
Instance.new("UICorner", SongScroll).CornerRadius = UDim.new(0, 5)

local ScrollLayout = Instance.new("UIListLayout", SongScroll)
ScrollLayout.Padding = UDim.new(0, 4)

-- ==================== [ ระบบยิงข้อมูลรีโมทและอนิเมชันคลื่นเสียง ] ====================
local waveConnection = nil
local isPlaying = false
local startTime = 0

IDInput.FocusLost:Connect(function()
    local id = string.match(IDInput.Text, "%d+")
    if id then
        pcall(function()
            local assetInfo = MarketplaceService:GetProductInfo(tonumber(id))
            if assetInfo and assetInfo.AssetTypeId == 3 then
                TrackNameLabel.Text = "SONG: " .. assetInfo.Name
            end
        end)
    end
end)

SaveIDInput.FocusLost:Connect(function()
    local id = string.match(SaveIDInput.Text, "%d+")
    if id and SaveNameInput.Text == "" then
        pcall(function()
            local assetInfo = MarketplaceService:GetProductInfo(tonumber(id))
            if assetInfo and assetInfo.AssetTypeId == 3 then
                SaveNameInput.Text = assetInfo.Name
            end
        end)
    end
end)

local function stopWaveformAnimation()
    isPlaying = false
    PlayBtn.Text = "▶️ FIRE REMOTE"
    PlayBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 220)
    if waveConnection then waveConnection:Disconnect() waveConnection = nil end
    for _, bar in ipairs(waveBars) do
        TweetService:Create(bar, TweenInfo.new(0.3), {Size = UDim2.new(barWidth, -2, 0.05, 0)}):Play()
    end
    TimeLabel.Text = "STATUS: IDLE"
end

local function fireRemoteMusic(targetID)
    stopWaveformAnimation()
    playClickSound()
    
    local cleanID = string.match(tostring(targetID), "%d+")
    if not cleanID then return end
    
    local args = { "ToolMusicText", cleanID, [4] = true }
    PlayerToolEvent:FireServer(unpack(args))
    
    isPlaying = true
    startTime = tick()
    PlayBtn.Text = "⏹️ STOP WAVEFORM"
    PlayBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    TimeLabel.Text = "STATUS: PLAYING SERVER"
    
    waveConnection = RunService.RenderStepped:Connect(function()
        if not isPlaying then stopWaveformAnimation() return end
        local elapsedTime = tick() - startTime
        for i, bar in ipairs(waveBars) do
            local pulse = math.sin((i * 0.5) + (elapsedTime * 12)) * 0.35 
            local subPulse = math.cos((i * 0.2) - (elapsedTime * 6)) * 0.2
            local finalHeight = math.clamp(math.abs(pulse + subPulse) + 0.1, 0.05, 0.85)
            bar.Size = UDim2.new(barWidth, -2, finalHeight, 0)
            bar.BackgroundColor3 = Color3.fromHSV(0.78 + (finalHeight * 0.08), 0.8, 0.9)
        end
    end)
end

PlayBtn.MouseButton1Click:Connect(function()
    if isPlaying then stopWaveformAnimation() else fireRemoteMusic(IDInput.Text) end
end)

-- ==================== [ คลังเซฟเพลงแยกไอดีเครื่อง ] ====================
local renderSavedList
renderSavedList = function()
    for _, item in pairs(SongScroll:GetChildren()) do if item:IsA("Frame") then item:Destroy() end end
    for index, itemData in ipairs(SavedSongs) do
        local ItemFrame = Instance.new("Frame", SongScroll)
        ItemFrame.Size = UDim2.new(1, -6, 0, 36)
        ItemFrame.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
        Instance.new("UICorner", ItemFrame).CornerRadius = UDim.new(0, 5)
        
        local SongTitle = Instance.new("TextLabel", ItemFrame)
        SongTitle.Size = UDim2.new(0.5, -10, 1, 0)
        SongTitle.Position = UDim2.new(0, 8, 0, 0)
        SongTitle.BackgroundTransparency = 1
        SongTitle.Text = itemData.name
        SongTitle.TextColor3 = Color3.fromRGB(220, 200, 255)
        SongTitle.Font = Enum.Font.Gotham
        SongTitle.TextSize = 11
        SongTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local LPlay = Instance.new("TextButton", ItemFrame)
        LPlay.Size = UDim2.new(0.14, 0, 0, 24)
        LPlay.Position = UDim2.new(0.55, 0, 0.5, -12)
        LPlay.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
        LPlay.Text = "▶️"
        LPlay.TextSize = 11
        Instance.new("UICorner", LPlay).CornerRadius = UDim.new(0, 4)
        
        local LEdit = Instance.new("TextButton", ItemFrame)
        LEdit.Size = UDim2.new(0.14, 0, 0, 24)
        LEdit.Position = UDim2.new(0.70, 2, 0.5, -12)
        LEdit.BackgroundColor3 = Color3.fromRGB(40, 80, 160)
        LEdit.Text = "📝"
        LEdit.TextSize = 11
        Instance.new("UICorner", LEdit).CornerRadius = UDim.new(0, 4)
        
        local LDel = Instance.new("TextButton", ItemFrame)
        LDel.Size = UDim2.new(0.12, 0, 0, 24)
        LDel.Position = UDim2.new(0.85, 4, 0.5, -12)
        LDel.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
        LDel.Text = "❌"
        LDel.TextSize = 10
        Instance.new("UICorner", LDel).CornerRadius = UDim.new(0, 4)
        
        LPlay.MouseButton1Click:Connect(function()
            IDInput.Text = itemData.id
            TrackNameLabel.Text = "SONG: " .. itemData.name
            fireRemoteMusic(itemData.id)
        end)
        LEdit.MouseButton1Click:Connect(function()
            playClickSound()
            SaveNameInput.Text = itemData.name
            SaveIDInput.Text = itemData.id
            table.remove(SavedSongs, index)
            saveData()
            renderSavedList()
        end)
        LDel.MouseButton1Click:Connect(function()
            playClickSound()
            table.remove(SavedSongs, index)
            saveData()
            renderSavedList()
        end)
    end
    SongScroll.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y)
end

FinalSaveBtn.MouseButton1Click:Connect(function()
    local name = SaveNameInput.Text
    local id = string.match(SaveIDInput.Text, "%d+")
    if name ~= "" and id then
        playClickSound()
        table.insert(SavedSongs, {name = name, id = id})
        saveData()
        SaveNameInput.Text = ""
        SaveIDInput.Text = ""
        renderSavedList()
    end
end)
renderSavedList()

-- ==================== [ ระบบลากและเปิดปิดอินเทอร์เฟซแบบเสถียร ] ====================
Tab1Btn.MouseButton1Click:Connect(function()
    playClickSound()
    Tab1Btn.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
    Tab2Btn.BackgroundColor3 = Color3.fromRGB(25, 15, 35)
    PagePlayer.Visible = false
    PageSaveSystem.Visible = true
    renderSavedList()
end)

-- 🛠️ ฟังก์ชันสากลสำหรับทำให้ Object ลากได้อิสระบนหน้าจอ (รองรับทั้งเมาส์และนิ้วถูมือถือ)
local function makeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- สั่งเปิดระบบลากให้กับ: หน้าต่างหลัก และ ปุ่มไอวงกลมเปิดปิด
makeDraggable(MainFrame)
makeDraggable(ToggleBtn)

-- ย่อหน้าต่างลง (Minimize)
CloseBtn.MouseButton1Click:Connect(function()
    playClickSound()
    stopWaveformAnimation()
    TweetService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    task.wait(0.25)
    MainFrame.Visible = false
    ToggleBtn.Visible = true -- แสดงผลปุ่มวงกลมตรงพิกัดเดิมหรือจุดที่มึงลากค้างไว้
end)

-- ขยายหน้าต่างคืนชีพขึ้นมา
ToggleBtn.MouseButton1Click:Connect(function()
    playClickSound()
    ToggleBtn.Visible = false
    MainFrame.Visible = true
    TweetService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 320), BackgroundTransparency = 0}):Play()
end)

