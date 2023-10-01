local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local parryon = false
local autoparrydistance = 12
local Window = Rayfield:CreateWindow({
    Name = "Undead Exploits | Paid",
    LoadingTitle = "Thank you for purchasing Undead Exploits!",
    LoadingSubtitle = "Enjoy the script!",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "Undead Exploits",
       FileName = "Main"
    },
    Discord = {
       Enabled = true,
       Invite = "GvwYhvP7ap", 
       RememberJoins = true 
    },
    KeySystem = false,
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided",
       FileName = "Key",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = {"Hello"}
    }
 })
 Rayfield:Notify({
    Title = "Undead Exploits",
    Content = "Thank you for your purchase!",
    Duration = 3,
    Image = 4483362458,
    Actions = {
       Ignore = {
          Name = "Okay!",
          Callback = function()
          print("OOH HE CHEATIN")
       end
    },
 },
 })
 local Tab = Window:CreateTab("Main", 4483362458)
 local Section = Tab:CreateSection("Autoparry")
 local Toggle = Tab:CreateToggle({
    Name = "Autoparry",
    CurrentValue = false,
    Flag = "autoparryflag", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        parryon = Value
    end
 })
 local Slider = Tab:CreateSlider({
    Name = "Distance",
    Range = {5, 100},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = 12,
    Flag = "DistFlag", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        autoparrydistance = Value
    end,
 })
 local Section = Tab:CreateSection("Universal")
 local Slider = Tab:CreateSlider({
    Name = "Walkspeed",
    Range = {16, 300},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed,
    Flag = "walkspeedslider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = Value
    end,
 })



local Debug = false -- Set this to true if you want my debug output.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9) -- A second argument in waitforchild what could it mean?
local Balls = workspace:WaitForChild("Balls", 9e9)

-- Functions

local function print(...) -- Debug print.
    if Debug then
        warn(...)
    end
end

local function VerifyBall(Ball) -- Returns nil if the ball isn't a valid projectile; true if it's the right ball.
    if typeof(Ball) == "Instance" and Ball:IsA("BasePart") and Ball:IsDescendantOf(Balls) and Ball:GetAttribute("realBall") == true then
        return true
    end
end

local function IsTarget() -- Returns true if we are the current target.
    return (Player.Character and Player.Character:FindFirstChild("Highlight"))
end

local function Parry() -- Parries.
    Remotes:WaitForChild("ParryButtonPress"):Fire()
end
-- The actual code

Balls.ChildAdded:Connect(function(Ball)
    if not VerifyBall(Ball) then
        return
    end
    
    print(`Ball Spawned: {Ball}`)
    
    local OldPosition = Ball.Position
    local OldTick = tick()
    
    Ball:GetPropertyChangedSignal("Position"):Connect(function()
        if IsTarget() then
            local Distance = (Ball.Position - workspace.CurrentCamera.Focus.Position).Magnitude
            local Velocity = (OldPosition - Ball.Position).Magnitude 
            
            print(`Distance: {Distance}\nVelocity: {Velocity}\nTime: {Distance / Velocity}`)
        
            if (Distance / Velocity) <= autoparrydistance then
                if parryon == true then
                    Parry()
                end
            end
        end
        
        if (tick() - OldTick >= 1/60) then
            OldTick = tick()
            OldPosition = Ball.Position
        end
    end)
end)
