-- [[ 191 ULTIMATE SOUND UI SYSTEM v2 ]] --
local Players = game:GetService("Players")
local TweetService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ลิงก์ยิง Remote Event ที่มึงให้มา
local PlayerToolEvent = game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("PlayerToolEvent")

-- ระบบฐานข้อมูลเก็บเพลงภายในเครื่องแยกตามไอดีผู้เล่น
local SAVE_KEY = "191_SavedSongs_" .. tostring(LocalPlayer.UserId)
local SavedSongs = {}

-- โหลดข้อมูลเพลงเก่าที่เคยเซฟไว้ (ถ้ามี)
local success, data = pcall(function() return plugin and plugin:GetSetting(SAVE_KEY) or nil end)
if success and data then
    local decoded = HttpService:JSONDecode(data)
    if type(decoded) == "table" then SavedSongs = decoded end
end

-- ฟังก์ชันเซฟข้อมูลลงเครื่อง
local function saveData()
    pcall(function()
        if plugin then
            plugin:SetSetting(SAVE_KEY, HttpService:JSONEncode(SavedSongs))
        end
    end)
end

-- ==================== [ ระบบสร้างเอฟเฟกต์เสียงปุ่ม ] ====================
local function playClickSound()
    local sound = Instance.new("Sound", workspace)
    sound.SoundId = "rbxassetid://8336214534" -- เสียง Click UI นุ่มๆ ดำ-ม่วง
    sound.Volume = 0.5
    sound.PlayOnRemove = true
    sound:Destroy()
end

-- ==================== [ หน้าต่างหลัก UI ดีไซน์ดำ-ม่วง ] ====================
if PlayerGui:FindFirstChild("System_191_SoundUI") then PlayerGui.System_191_SoundUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "System_191_SoundUI"
ScreenGui.ResetOnSpawn = false

-- ปุ่มเปิด/ปิด แบบ Ultra Smooth Rounded
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
ToggleBtn.Text = "🎵"
ToggleBtn.TextSize = 22
ToggleBtn.TextColor3 = Color3.fromRGB(180, 70, 255)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 25)
local tStroke = Instance.new("UIStroke", ToggleBtn)
tStroke.Color = Color3.fromRGB(140, 50, 220)
tStroke.Thickness = 2

-- หน้าต่างบอร์ดหลัก
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 20)
MainFrame.BackgroundTransparency = 1 -- เริ่มต้นซ่อนไว้เพื่อลื่นไหล
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local mStroke = Instance.new("UIStroke", MainFrame)
mStroke.Color = Color3.fromRGB(140, 50, 220)
mStroke.Thickness = 1.5

-- ส่วนหัวหน้าต่างลากได้
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 18, 35)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "AUDIO MUSIC STATION [CREATED BY 191]"
Title.TextColor3 = Color3.fromRGB(200, 150, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ปุ่มสลับโหมด / เมนูหมวดหมู่
local TabMenuFrame = Instance.new("Frame", MainFrame)
TabMenuFrame.Size = UDim2.new(1, -30, 0, 35)
TabMenuFrame.Position = UDim2.new(0, 15, 0, 50)
TabMenuFrame.BackgroundTransparency = 1

local Tab1Btn = Instance.new("TextButton", TabMenuFrame)
Tab1Btn.Size = UDim2.new(0.5, -5, 1, 0)
Tab1Btn.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
Tab1Btn.Text = "🎛️ เครื่องเล่นเพลง (Waveform)"
Tab1Btn.Font = Enum.Font.GothamBold
Tab1Btn.TextSize = 12
Tab1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Tab1Btn).CornerRadius = UDim.new(0, 6)

local Tab2Btn = Instance.new("TextButton", TabMenuFrame)
Tab2Btn.Size = UDim2.new(0.5, -5, 1, 0)
Tab2Btn.Position = UDim2.new(0.5, 5, 0, 0)
Tab2Btn.BackgroundColor3 = Color3.fromRGB(25, 15, 35)
Tab2Btn.Text = "📁 คลังคอลเลกชันเพลงเซฟ"
Tab2Btn.Font = Enum.Font.GothamBold
Tab2Btn.TextSize = 12
Tab2Btn.TextColor3 = Color3.fromRGB(180, 150, 200)
Instance.new("UICorner", Tab2Btn).CornerRadius = UDim.new(0, 6)

-- หน้าคอนเทนต์ของหมวด 1 และ 2
local PagePlayer = Instance.new("Frame", MainFrame)
PagePlayer.Size = UDim2.new(1, -30, 0, 230)
PagePlayer.Position = UDim2.new(0, 15, 0, 95)
PagePlayer.BackgroundTransparency = 1

local PageSaveSystem = Instance.new("Frame", MainFrame)
PageSaveSystem.Size = UDim2.new(1, -30, 0, 230)
PageSaveSystem.Position = UDim2.new(0, 15, 0, 95)
PageSaveSystem.BackgroundTransparency = 1
PageSaveSystem.Visible = false

-- ==================== [ หมวดหมู่ที่ 1: หน้าเครื่องเล่นตามแบบร่าง ] ====================

-- กรอบ Waveform บ็อกซ์ซ้ายมือ
local WaveformBox = Instance.new("Frame", PagePlayer)
WaveformBox.Size = UDim2.new(0.5, -10, 0.75, 0)
WaveformBox.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
Instance.new("UICorner", WaveformBox).CornerRadius = UDim.new(0, 6)
local wStroke = Instance.new("UIStroke", WaveformBox)
wStroke.Color = Color3.fromRGB(50, 30, 80)

-- ตัวอักษรแสดงเครดิต "191" ตรง waveform ตามภาพวาด
local CreditText = Instance.new("TextLabel", WaveformBox)
CreditText.Size = UDim2.new(1, 0, 0, 25)
CreditText.Position = UDim2.new(0, 0, 0, 5)
CreditText.BackgroundTransparency = 1
CreditText.Text = "191 CONTROL"
CreditText.TextColor3 = Color3.fromRGB(140, 50, 220)
CreditText.Font = Enum.Font.GothamBold
CreditText.TextSize = 14
CreditText.TextTransparency = 0.5

-- แถบเวลาใต้ Waveform
local TimeLabel = Instance.new("TextLabel", PagePlayer)
TimeLabel.Size = UDim2.new(0.5, -10, 0, 20)
TimeLabel.Position = UDim2.new(0, 0, 0.8, 0)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "เวลาเพลง: 00:00 / 00:00"
TimeLabel.TextColor3 = Color3.fromRGB(160, 140, 180)
TimeLabel.Font = Enum.Font.Code
TimeLabel.TextSize = 12

-- ช่องใส่ไอดีขวาบน
local IDInput = Instance.new("TextBox", PagePlayer)
IDInput.Size = UDim2.new(0.5, -5, 0, 40)
IDInput.Position = UDim2.new(0.5, 5, 0, 0)
IDInput.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
IDInput.Text = ""
IDInput.PlaceholderText = "วางไอดีเพลงตรงนี้มึง..."
IDInput.TextColor3 = Color3.fromRGB(255, 255, 255)
IDInput.Font = Enum.Font.Gotham
IDInput.TextSize = 13
Instance.new("UICorner", IDInput).CornerRadius = UDim.new(0, 6)
local iStroke = Instance.new("UIStroke", IDInput)
iStroke.Color = Color3.fromRGB(80, 40, 130)

-- แสดงชื่อเพลงที่ดึงมาได้อัตโนมัติ
local TrackNameLabel = Instance.new("TextLabel", PagePlayer)
TrackNameLabel.Size = UDim2.new(0.5, -5, 0, 25)
TrackNameLabel.Position = UDim2.new(0.5, 5, 0, 45)
TrackNameLabel.BackgroundTransparency = 1
TrackNameLabel.Text = "ชื่อเพลง: ไม่ได้เล่น"
TrackNameLabel.TextColor3 = Color3.fromRGB(200, 180, 220)
TrackNameLabel.Font = Enum.Font.Gotham
TrackNameLabel.TextSize = 11
TrackNameLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ปุ่มกดเล่นใหญ่ๆ ด้านขวาตามแบบ (Play)
local PlayBtn = Instance.new("TextButton", PagePlayer)
PlayBtn.Size = UDim2.new(0.5, -5, 0, 50)
PlayBtn.Position = UDim2.new(0.5, 5, 0, 80)
PlayBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 220)
PlayBtn.Text = "▶️ เริ่มเล่นไฟล์เสียง"
PlayBtn.Font = Enum.Font.GothamBold
PlayBtn.TextSize = 14
PlayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0, 6)

-- สร้างแท่งคลื่นเสียงสมจริงจำลอง 15 แท่งข้างในบล็อก Waveform
local waveBars = {}
local barWidth = 1 / 15
for i = 1, 15 do
    local bar = Instance.new("Frame", WaveformBox)
    bar.Size = UDim2.new(barWidth, -3, 0.1, 0)
    bar.Position = UDim2.new(barWidth * (i - 1), 2, 0.85, 0)
    bar.AnchorPoint = Vector2.new(0, 1)
    bar.BackgroundColor3 = Color3.fromRGB(180, 70, 255)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)
    table.insert(waveBars, bar)
end

-- ==================== [ หมวดหมู่ที่ 2: หน้าระบบเซฟเพลงขั้นสูง ] ====================
local SaveNameInput = Instance.new("TextBox", PageSaveSystem)
SaveNameInput.Size = UDim2.new(0.45, -5, 0, 35)
SaveNameInput.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
SaveNameInput.Text = ""
SaveNameInput.PlaceholderText = "ใส่ชื่อเพลงเพื่อบันทึก..."
SaveNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveNameInput.TextSize = 12
Instance.new("UICorner", SaveNameInput).CornerRadius = UDim.new(0, 6)

local SaveIDInput = Instance.new("TextBox", PageSaveSystem)
SaveIDInput.Size = UDim2.new(0.35, -5, 0, 35)
SaveIDInput.Position = UDim2.new(0.45, 0, 0, 0)
SaveIDInput.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
SaveIDInput.Text = ""
SaveIDInput.PlaceholderText = "ไอดีเพลงที่จะบันทึก..."
SaveIDInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveIDInput.TextSize = 12
Instance.new("UICorner", SaveIDInput).CornerRadius = UDim.new(0, 6)

local FinalSaveBtn = Instance.new("TextButton", PageSaveSystem)
FinalSaveBtn.Size = UDim2.new(0.2, 0, 0, 35)
FinalSaveBtn.Position = UDim2.new(0.8, 0, 0, 0)
FinalSaveBtn.BackgroundColor3 = Color3.fromRGB(50, 160, 90)
FinalSaveBtn.Text = "➕ บันทึก"
FinalSaveBtn.Font = Enum.Font.GothamBold
FinalSaveBtn.TextSize = 12
FinalSaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", FinalSaveBtn).CornerRadius = UDim.new(0, 6)

-- ลิสต์แสดงรายการเพลงที่บันทึกแบบเลื่อนได้
local SongScroll = Instance.new("ScrollingFrame", PageSaveSystem)
SongScroll.Size = UDim2.new(1, 0, 0, 180)
SongScroll.Position = UDim2.new(0, 0, 0, 45)
SongScroll.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
SongScroll.BorderSizePixel = 0
SongScroll.ScrollBarThickness = 4
SongScroll.ScrollBarImageColor3 = Color3.fromRGB(140, 50, 220)
Instance.new("UICorner", SongScroll).CornerRadius = UDim.new(0, 6)

local ScrollLayout = Instance.new("UIListLayout", SongScroll)
ScrollLayout.Padding = UDim.new(0, 5)

-- ==================== [ ระบบประมวลผลเพลงและการควบคุมชั้นสูง ] ====================
local activeSound = nil
local waveConnection = nil
local isPlaying = false

-- ฟังก์ชันดึงชื่อข้อมูลเพลงอัตโนมัติเมื่อกรอกไอดี
IDInput.FocusLost:Connect(function()
    local id = string.match(IDInput.Text, "%d+")
    if id then
        pcall(function()
            local assetInfo = MarketplaceService:GetProductInfo(tonumber(id))
            if assetInfo and assetInfo.AssetTypeId == 3 then
                TrackNameLabel.Text = "ชื่อเพลง: " .. assetInfo.Name
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

-- ฟังก์ชันหยุดเพลงทั้งหมด คืนค่าสถานะป้องกันบัคค้าง
local function stopEverything()
    isPlaying = false
    PlayBtn.Text = "▶️ เริ่มเล่นไฟล์เสียง"
    PlayBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 220)
    
    if waveConnection then waveConnection:Disconnect() waveConnection = nil end
    if activeSound then activeSound:Destroy() activeSound = nil end
    
    -- คืนรูปทรงคลื่นสงบนิ่ง
    for _, bar in ipairs(waveBars) do
        TweetService:Create(bar, TweenInfo.new(0.2), {Size = UDim2.new(barWidth, -3, 0.05, 0)}):Play()
    end
    TimeLabel.Text = "เวลาเพลง: 00:00 / 00:00"
end

-- ฟังก์ชันจัดรูปแบบการแปลงเวลาวินาที -> นาทีคลาสสิก
local function formatTime(seconds)
    local mins = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d", mins, secs)
end

-- ระบบสั่งเล่นเสียงและคำนวณ Waveform
local function startPlayingMusic(targetID)
    stopEverything()
    playClickSound()
    
    local cleanID = string.match(tostring(targetID), "%d+")
    if not cleanID then return end
    
    -- ยิง Event เข้าเซิร์ฟเวอร์ตามคำสั่งรีเควสของมึง
    local args = { "ToolMusicText", cleanID, [4] = true }
    PlayerToolEvent:FireServer(unpack(args))
    
    -- สร้าง Object ตรวจสอบสถานะและเวลาแบบเรียลไทม์จำลองในเครื่องผู้รัน
    activeSound = Instance.new("Sound", workspace)
    activeSound.SoundId = "rbxassetid://" .. cleanID
    activeSound.Volume = 0 -- ให้เสียงจริงไปดังที่เครื่องมือเซิร์ฟเวอร์ ตัวนี้ใช้ดึงค่าตรวจสอบวิเคราะห์
    activeSound:Play()
    
    isPlaying = true
    PlayBtn.Text = "⏹️ สั่งหยุดเพลง"
    PlayBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    
    -- รอตรวจสอบความยาวของวิทยุเพลงจริง
    while activeSound and activeSound.TimeLength == 0 do task.wait() end
    if not activeSound then return end
    
    local totalLength = activeSound.TimeLength
    
    -- การจำลองแกนคลื่นระดับ Advance คลื่นจะเต้นผกผันตามกาลเวลาจริงของเพลง
    waveConnection = RunService.RenderStepped:Connect(function()
        if not activeSound or not isPlaying then stopEverything() return end
        
        local currentPos = activeSound.TimePosition
        TimeLabel.Text = "เวลาเพลง: " .. formatTime(currentPos) .. " / " .. formatTime(totalLength)
        
        -- เพลงเล่นจบสมบูรณ์ บังคับสั่งตัดระบบทั้งหมดทันทีเพื่อความเสถียร
        if currentPos >= totalLength - 0.1 or not activeSound.IsPlaying then
            stopEverything()
        else
            -- สร้างระลอกคลื่นสมูทด้วยตรีโกณมิติผสมตำแหน่งปัจจุบัน
            for i, bar in ipairs(waveBars) do
                local frequency = (i * 0.5) + (currentPos * 8)
                local amplitude = math.sin(frequency) * 0.4 + math.cos(frequency * 0.5) * 0.3
                amplitude = math.abs(amplitude)
                if amplitude < 0.05 then amplitude = 0.05 end
                
                bar.Size = UDim2.new(barWidth, -3, amplitude * 0.8, 0)
                bar.BackgroundColor3 = Color3.fromHSV(0.78 + (amplitude * 0.1), 0.8, 0.9)
            end
        end
    end)
end

-- เชื่อมปุ่มเริ่มเล่น
PlayBtn.MouseButton1Click:Connect(function()
    if isPlaying then
        stopEverything()
    else
        startPlayingMusic(IDInput.Text)
    end
end)

-- ==================== [ การจัดการลิสต์คลังคอลเลกชันเซฟเพลง ] ====================
local renderSavedList -- ประกาศล่วงหน้า

renderSavedList = function()
    for _, item in pairs(SongScroll:GetChildren()) do if item:IsA("Frame") then item:Destroy() end end
    
    for index, itemData in ipairs(SavedSongs) do
        local ItemFrame = Instance.new("Frame", SongScroll)
        ItemFrame.Size = UDim2.new(1, -6, 0, 40)
        ItemFrame.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
        Instance.new("UICorner", ItemFrame).CornerRadius = UDim.new(0, 5)
        
        local SongTitle = Instance.new("TextLabel", ItemFrame)
        SongTitle.Size = UDim2.new(0.5, -10, 1, 0)
        SongTitle.Position = UDim2.new(0, 10, 0, 0)
        SongTitle.BackgroundTransparency = 1
        SongTitle.Text = itemData.name .. " (" .. itemData.id .. ")"
        SongTitle.TextColor3 = Color3.fromRGB(220, 200, 255)
        SongTitle.Font = Enum.Font.Gotham
        SongTitle.TextSize = 12
        SongTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        -- ปุ่มกดส่งเล่นทันที
        local LPlay = Instance.new("TextButton", ItemFrame)
        LPlay.Size = UDim2.new(0.15, -5, 0, 28)
        LPlay.Position = UDim2.new(0.55, 0, 0.5, -14)
        LPlay.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
        LPlay.Text = "▶️ เล่น"
        LPlay.TextColor3 = Color3.fromRGB(255, 255, 255)
        LPlay.Font = Enum.Font.GothamBold
        LPlay.TextSize = 11
        Instance.new("UICorner", LPlay).CornerRadius = UDim.new(0, 4)
        
        -- ปุ่มแก้ไขข้อมูล
        local LEdit = Instance.new("TextButton", ItemFrame)
        LEdit.Size = UDim2.new(0.15, -5, 0, 28)
        LEdit.Position = UDim2.new(0.7, 5, 0.5, -14)
        LEdit.BackgroundColor3 = Color3.fromRGB(40, 80, 160)
        LEdit.Text = "📝 แก้ไข"
        LEdit.TextColor3 = Color3.fromRGB(255, 255, 255)
        LEdit.Font = Enum.Font.GothamBold
        LEdit.TextSize = 11
        Instance.new("UICorner", LEdit).CornerRadius = UDim.new(0, 4)
        
        -- ปุ่มลบออกจากคลัง
        local LDel = Instance.new("TextButton", ItemFrame)
        LDel.Size = UDim2.new(0.12, 0, 0, 28)
        LDel.Position = UDim2.new(0.86, 4, 0.5, -14)
        LDel.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
        LDel.Text = "❌"
        LDel.TextSize = 11
        Instance.new("UICorner", LDel).CornerRadius = UDim.new(0, 4)
        
        -- ทำงานของปุ่มลิสต์
        LPlay.MouseButton1Click:Connect(function()
            IDInput.Text = itemData.id
            TrackNameLabel.Text = "ชื่อเพลง: " .. itemData.name
            startPlayingMusic(itemData.id)
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

-- ปุ่มกดเซฟเพิ่ม
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

-- โหลดลิสต์ครั้งแรก
renderSavedList()

-- ==================== [ ระบบสลับหน้าต่างและเปิดปิด Ultra Smooth ] ====================
Tab1Btn.MouseButton1Click:Connect(function()
    playClickSound()
    Tab1Btn.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
    Tab1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab2Btn.BackgroundColor3 = Color3.fromRGB(25, 15, 35)
    Tab2Btn.TextColor3 = Color3.fromRGB(180, 150, 200)
    PagePlayer.Visible = true
    PageSaveSystem.Visible = false
end)

Tab2Btn.MouseButton1Click:Connect(function()
    playClickSound()
    Tab2Btn.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
    Tab2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab1Btn.BackgroundColor3 = Color3.fromRGB(25, 15, 35)
    Tab1Btn.TextColor3 = Color3.fromRGB(180, 150, 200)
    PagePlayer.Visible = false
    PageSaveSystem.Visible = true
    renderSavedList()
end)

-- การจัดการลากหน้าต่าง (Drag Window System)
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
TopBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- อนิเมชันสวิตช์เปิดปิดแบบ Ultra Smooth 
local isUIVisible = false
ToggleBtn.MouseButton1Click:Connect(function()
    playClickSound()
    isUIVisible = not isUIVisible
    if isUIVisible then
        MainFrame.Visible = true
        TweetService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
        for _, child in pairs(MainFrame:GetDescendants()) do
            if child:IsA("Frame") and child ~= TopBar and child ~= WaveformBox and child ~= TabMenuFrame and child ~= PagePlayer and child ~= PageSaveSystem then
                TweetService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            elseif child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                if not child:IsA("TextBox") and child ~= Title and child ~= CreditText then
                    TweetService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
                else
                    TweetService:Create(child, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
                end
            end
        end
    else
        TweetService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        for _, child in pairs(MainFrame:GetDescendants()) do
            if child:IsA("Frame") and child ~= TopBar then
                TweetService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            elseif child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                TweetService:Create(child, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
            end
        end
        task.wait(0.25)
        if not isUIVisible then MainFrame.Visible = false end
    end
end)
