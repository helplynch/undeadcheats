local isenabled = false
local LocalPlayer = game:GetService("Players").LocalPlayer
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Undead Cheats", IntroEnabled = false, HidePremium = false, SaveConfig = true, ConfigFolder = "UndeadExploits"})

local Tab = Window:MakeTab({
	Name = "Parry",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Section = Tab:AddSection({
	Name = "Autoblock"
})
Tab:AddButton({
	Name = "Enable/Disable AutoBlock",
	Callback = function()
        if isenabled == false then
            isenabled = true
            print("Autoblock: " .. tostring(isenabled))
            OrionLib:MakeNotification({
                Name = "Autoblock",
                Content = "Autoblock is enabled.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            isenabled = false
            print("Autoblock: " .. tostring(isenabled))
            OrionLib:MakeNotification({
                Name = "Autoblock",
                Content = "Autoblock is disabled.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
  	end    
})
Tab:AddParagraph("Autoblock Notice","Please note that the autoblock is still a workinprocess and im not entirely complete with it yet.")


getgenv().ScriptConfig = {
DistanceBeforeParry = 25,
}

local Tab2 = Window:MakeTab({
	Name = "Credits",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
Tab2:AddParagraph("The menace of a creator","Sh4dyy (i did it myself)")


OrionLib:MakeNotification({
    Name = "Undead Exploits",
    Content = "This peace of work was made by sh4dyy <3",
    Image = "rbxassetid://4483345998",
    Time = 3
})
OrionLib:Init()


game:GetService("Workspace").Balls.ChildAdded:Connect(function(child)
    local trackTask = task.spawn(function()
        local ball = child
        while isenabled == true do 
            while task.wait() do
                if string.find(ball.BrickColor.Name:lower(), "red") then
                    print("FOUND BALL")
                    while LocalPlayer:DistanceFromCharacter(ball.CFrame.Position)
    > getgenv().ScriptConfig.DistanceBeforeParry do
                            task.wait()
                    end
    
                    print("PARRYING")
    
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    ReplicatedStorage.Remotes.ParryButtonPress:Fire()
                    print("DONE")
                end
            end
        end
    end)
    child.Destroying:Connect(function()
        task.cancel(trackTask)
    end)
end)
