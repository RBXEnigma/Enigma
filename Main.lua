--SETTINGS

local debugEnabled = true

UserInputService = game:GetService("UserInputService")
Players = game:GetService("Players")
RunService = game:GetService("RunService")
ContextActionService = game:GetService("ContextActionService")
TweenService = game:GetService("TweenService")
RunService = game:GetService("RunService")
function randomString(length)
	local length = math.random(5,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(65, 90))
	end
	return table.concat(array)
end
function runcmd(command, args)
    if not debugEnabled then
        pcall(function()
            command = string.lower(command)
            --print(cmds[command][1])
            cmds[command]['FUNC'](args)
        end)
    else
        command = string.lower(command)
        --print(cmds[command]['FUNC'])
        cmds[command]['FUNC'](args)
    end
end

function findcmd(command)
    CmdInfo.Text = ""
    if cmds[command[1]] then
        CmdInfo.Text = cmds[command[1]]['DESC']
        if not command[2] and cmds[command[1]]['PARAMS'] ~= {} then
            return command[1].." "..table.concat(cmds[command[1]]['PARAMS']," ")
        elseif not command[2] then
            return command[1]
        end
        local commandtable = table.clone(cmds[command[1]]['PARAMS'])
        for i = 1, #command - 1 do
            if command[i + 1] ~= "" then
                table.remove(commandtable,1)
            end
        end
        return string.sub(TextBox.Text,1,#TextBox.Text-1).." "..table.concat(commandtable," ")
    end
    if command[1] == "" then return "" end
	for i = 1, commandcount do
		local CurrentCommand = commandnametable[i]
		if string.lower(CurrentCommand):sub(1, #command[1]) == string.lower(command[1]) then
			return CurrentCommand
		end
	end
    return ""
end
cmds = {}
function addcmd(name,desc,alias,params,func)
    cmds[name] = {FUNC=func,DESC=desc,PARAMS=params}
    if alias ~= {} then
        for i,v in pairs(alias) do
            cmds[v] = {FUNC=func,DESC=desc,PARAMS=params}
        end
    end
end
main = Instance.new("ScreenGui", game.CoreGui)
main.Name = randomString()

TextBox = Instance.new("TextBox")
TextBox.Parent = main
TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundTransparency = 0.700
TextBox.Position = UDim2.new(0.499, 0, 0.859, 0)
TextBox.Size = UDim2.new(0.399, 0, 0.03, 0)
TextBox.Font = Enum.Font.Gotham
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
TextBox.TextScaled = true
TextBox.TextWrapped = true
TextBox.Visible = false
TextBox.ClearTextOnFocus = true
TextBox.TextXAlignment = Enum.TextXAlignment.Left

AutoComplete = Instance.new("TextLabel")
AutoComplete.Name = "AutoComplete"
AutoComplete.Parent = main
AutoComplete.Active = true
AutoComplete.AnchorPoint = Vector2.new(0.5, 0.5)
AutoComplete.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AutoComplete.BackgroundTransparency = 1.000
AutoComplete.Position = UDim2.new(0.499, 0, 0.859, 0)
AutoComplete.Selectable = true
AutoComplete.Size = UDim2.new(0.399, 0, 0.03, 0)
AutoComplete.Font = Enum.Font.Gotham
AutoComplete.Text = ""
AutoComplete.TextColor3 = Color3.fromRGB(0, 0, 0)
AutoComplete.TextScaled = true
AutoComplete.TextTransparency = 0.5
AutoComplete.TextWrapped = true
AutoComplete.TextXAlignment = Enum.TextXAlignment.Left
AutoComplete.Visible = false

CmdInfo = Instance.new("TextLabel")
CmdInfo.Name = "CmdInfo"
CmdInfo.Parent = main
CmdInfo.BackgroundTransparency = 1.000
CmdInfo.Position = UDim2.new(0.298, 0, 0.82, 0)
CmdInfo.Size = UDim2.new(0.399, 0, 0.02, 0)
CmdInfo.Font = Enum.Font.Gotham
CmdInfo.Text = ""
CmdInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
CmdInfo.TextScaled = true
CmdInfo.TextWrapped = true
CmdInfo.TextXAlignment = Enum.TextXAlignment.Left
CmdInfo.Visible = false
TextBox.FocusLost:Connect(function(enter)
	if enter == true then
		--print(TextBox.Text)
		TextBox.Visible = false
        CmdInfo.Visible = false
        AutoComplete.Visible = false
		local split = string.split(TextBox.Text, " ")
		local args = split
		local split = string.split(TextBox.Text, " ")
		table.remove(args,1)
		runcmd(split[1],args)
		--CMD[string.lower(split[1])](args)
	end
end)
UserInputService.InputBegan:Connect(function(input)
	if (UserInputService:GetFocusedTextBox()) then
		return
	end
	if input.KeyCode == Enum.KeyCode.Period then
		TextBox.Visible = true
		TextBox:CaptureFocus()
		spawn(function()
			repeat task.wait()
				TextBox.Text = ''
			until TextBox.Text == ''
            AutoComplete.Visible = true
            CmdInfo.Visible = true
		end)
	end	

end)
TextBox:GetPropertyChangedSignal("Text"):Connect(function()
    AutoComplete.Text = findcmd(string.split(TextBox.Text, " "))
end)
function quickFind(name)
	local Players = game.Players:GetPlayers()
	for i = 1, #Players do
		local CurrentPlayer = Players[i]
		if string.lower(CurrentPlayer.Name):sub(1, #name) == string.lower(name) then
			return CurrentPlayer.Name
		end
	end
end
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)

function createMenu()
    local Menu = Instance.new("Folder")
    local Frame = Instance.new("Frame")
    local Close = Instance.new("TextButton")
    local Title = Instance.new("TextLabel")
    local UICorner = Instance.new("UICorner")
    local Frame_2 = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local NoCorner = Instance.new("Frame")

    Menu.Name = "Menu"
    Menu.Parent = main

    Frame.Parent = Menu
    Frame.BackgroundColor3 = Color3.fromRGB(17, 18, 25)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.355569512, 0, 0.112318836, 0)
    Frame.Size = UDim2.new(0.154078051, 0, 0.628342271, 0)

    Close.Name = "Close"
    Close.Parent = Frame
    Close.BackgroundColor3 = Color3.fromRGB(17, 18, 25)
    Close.BackgroundTransparency = 1.000
    Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Close.BorderSizePixel = 0
    Close.Position = UDim2.new(0.798913062, 0, 0, 0)
    Close.Size = UDim2.new(0.201235682, 0, 0.131205678, 0)
    Close.Font = Enum.Font.GothamBold
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextScaled = true
    Close.TextSize = 14.000
    Close.TextWrapped = true

    Title.Name = "Title"
    Title.Parent = Frame
    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.BackgroundColor3 = Color3.fromRGB(17, 18, 25)
    Title.BackgroundTransparency = 1.000
    Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Title.BorderSizePixel = 0
    Title.Position = UDim2.new(0.391593754, 0, 0.0638297871, 0)
    Title.Size = UDim2.new(0.794065118, 0, 0.131205678, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Title"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.TextSize = 14.000
    Title.TextWrapped = true

    UICorner.CornerRadius = UDim.new(0.0500000007, 0)
    UICorner.Parent = Frame

    Frame_2.Parent = Frame
    Frame_2.BackgroundColor3 = Color3.fromRGB(34, 32, 48)
    Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame_2.BorderSizePixel = 0
    Frame_2.Position = UDim2.new(0, 0, 0.131205678, 0)
    Frame_2.Size = UDim2.new(0.999997497, 0, 0.868794322, 0)

    UICorner_2.CornerRadius = UDim.new(0.0500000007, 0)
    UICorner_2.Parent = Frame_2

    NoCorner.Name = "NoCorner"
    NoCorner.Parent = Frame_2
    NoCorner.BackgroundColor3 = Color3.fromRGB(34, 32, 48)
    NoCorner.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NoCorner.BorderSizePixel = 0
    NoCorner.Position = UDim2.new(-1.65856406e-07, 0, -0.00115745713, 0)
    NoCorner.Size = UDim2.new(0.999997675, 0, 0.0479409993, 0)
    local gui = Frame

    local dragging
    local dragInput
    local dragStart
    local startPos

    function Lerp(a, b, m)
        return a + (b - a) * m
    end;

    local lastMousePos
    local lastGoalPos
    local DRAG_SPEED = (8); -- // The speed of the UI darg.
    function Update(dt)
        if not (startPos) then return end;
        if not (dragging) and (lastGoalPos) then
            gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
            return 
        end;

        local delta = (lastMousePos - UserInputService:GetMouseLocation())
        local xGoal = (startPos.X.Offset - delta.X);
        local yGoal = (startPos.Y.Offset - delta.Y);
        lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
        gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
    end;

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            lastMousePos = UserInputService:GetMouseLocation()

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    RunService.Heartbeat:Connect(Update)

end
--createMenu()
CMD = {}
--[[
cmds = {
["walkspeed"] = {"walkspeed",{"[Speed]"},"Changes your walkspeed"},
["ws"] = {"walkspeed",{"[Speed]"},"Changes your walkspeed"},
["jumppower"] = {"jumppower",{"[Jump Power]"},"Changes your jump power"},
["jp"] = {"jumppower",{"[Jump Power]"},"Changes your jump power"},
["nameprotect"] = {"nameprotect",{"(Name)"},"Hides everyone's name, Useful for recording"},
["gravity"] = {"gravity",{"[Gravity]"},"Changes your gravity"},
["grav"] = {"gravity",{"[Gravity]"},"Changes your gravity"},
["infjump"] = {"infjump","Lets you jump in the air"},
["removezoomlimit"] = {"removezoomlimit","Lets you zoom out infinitely"},
["zoom"] = {"removezoomlimit","Lets you zoom out infinitely"},
["freeze"] = {"freeze","Freezes your character"},
["fr"] = {"freeze","Freezes your character"},
["unfreeze"] = {"unfreeze","Unfreezes your character"},
["unfr"] = {"unfreeze","Unfreezes your character"},
["sit"] = {"sit","Makes your character sit"},
["spin"] ={"spin",{"[Spin Speed]"},"Makes your character spin"},
["unspin"] = {"unspin","Stops spinning"},
["xray"] = {"xray",{"(Transparency)"},"Allows you to see through blocks"},
["noxray"] = {"noxray","disables xray"},
["unxray"] = {"noxray","disables xray"},
["view"] = {"view",{"[Username]"},"Allows you to spectate a player"},
["unview"] = {"unview","Stops viewing/spectating"},
["spectate"] = {"view",{"[Username]"},"Allows you to spectate a player"},
["equiptools"] = {"equiptools","Makes you equip all the tools you have in your backpack"},
["btools"] = {"btools","Gives you clientsided builder tools"},
["fov"] = {"fov",{"[Fov]"},"Changes your field of view"},
["print"] = {"print",{"[Text]"},"Prints text in the console"},
["warn"] = {"warn",{"[Text]"},"Sends a warning in the console"},
["disable"] = {"disable","Disables Enigma"},
["noclip"] = {"noclip","Allows you to walk through walls"},
["unnoclip"] = {"unnoclip","Stops noclipping"},
["clip"] = {"unnoclip","Stops noclipping"},
["fly"] = {"fly",{"[Speed]"},"Lets your character fly"},
["unfly"] = {"unfly","Stops flying"},
["nodecals"] = {"nodecals","Deletes all decals"},
["render"] = {"render","Enables 3d rendering"},
["norender"] = {"norender","Disables 3d rendering"},
["unfocusedcpu"] = {"unfocusedcpu","Caps your fps and disables rendering when your window isn't focused"},
["ununfocusedcpu"] = {"ununfocusedcpu","Disables unfocusedcpu"},
["hitbox"] = {"hitbox",{"[Player]","[Size]"},"Changes other player's hitboxes"},
["reach"] = {"reach",{"[Size]"},"Gives your equipped tool reach"},
["commands"] = {"commands","Lists all commands"},
}
--]]
commandnametable = {}
commandcount = 0 
addcmd("walkspeed", "Changes your walkspeed", {"ws"}, {"[Speed]"},function(args)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = args[1]
end)
addcmd("jumppower", "Changes your jump power", {"jp"}, {"[Jump power]"},function(args)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = args[1]
end)

addcmd("nameprotect", "Hides everyone's username", {}, {"(Name)"},function(args)
	for i,v in ipairs(Players:GetPlayers()) do
        if args[1] == nil then
		    v.Name = randomString()
        else
            v.Name = args[1]
        end
	end
	local CoreGui_Players = game:GetService("CoreGui").PlayerList.PlayerListMaster.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame
	for i,v in ipairs(CoreGui_Players:GetDescendants()) do
    	if v:IsA("TextLabel") and v.Name == "PlayerName" then
    		print("yo")
        	pcall(function()
                if args[1] == nil then
            	    v.Text = randomString()
                else
                    v.Text = args[1]
                end
       		end)
       	end
	end
	CoreGui_Players.DescendantAdded:Connect(function(v)
    	if v:IsA("TextLabel") and v.Name == "PlayerName" then
        	pcall(function()
                if args[1] == nil then
            	    v.Text = randomString()
                else
                    v.Text = args[1]
                end
            end)
        end
    end)
	for i,v in ipairs(Players:GetPlayers()) do
		pcall(function()
            if args[1] == nil then
			    v.Character:FindFirstChildOfClass("Humanoid").DisplayName = randomString()
            else
                v.Character:FindFirstChildOfClass("Humanoid").DisplayName = args[1]
            end
			v.CharacterAdded:Connect(function(char)
				task.wait(0.2)
				if args[1] == nil then
                    v.Character:FindFirstChildOfClass("Humanoid").DisplayName = randomString()
                else
                    v.Character:FindFirstChildOfClass("Humanoid").DisplayName = args[1]
                end
			end)
		end)
	end
	Players.PlayerAdded:Connect(function(plr)
		plr.CharacterAdded:Connect(function(char)
			task.wait(0.2)
			if args[1] == nil then
			    v.Character:FindFirstChildOfClass("Humanoid").DisplayName = randomString()
            else
                v.Character:FindFirstChildOfClass("Humanoid").DisplayName = args[1]
            end
		end)
	end)
end)

addcmd("gravity", "Changes your gravity", {"grav"}, {"[Gravity]"},function(args)
	workspace.Gravity = args[1]
end)

addcmd("infinitejump", "Lets you jump in the air", {"infjump"}, {},function(args)
	UserInputService.InputBegan:Connect(function(input)
		if (UserInputService:GetFocusedTextBox()) then
			return
		end
		if input.KeyCode == Enum.KeyCode.Space then
			Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
		end
	end)
end)

addcmd("removezoomlimit", "Lets you zoom out infinitely", {}, {},function(args)
	Players.LocalPlayer.CameraMaxZoomDistance = math.huge
	Players.LocalPlayer.CameraMinZoomDistance = 0
end)

addcmd("freeze", "Freezes your character", {"fr"}, {},function(args)
	for i,v in ipairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("BasePart") then
			v.Anchored = true
		end
	end
end)

addcmd("unfreeze", "Unfreezes your character", {"unfr"}, {},function(args)
	for i,v in ipairs(Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("BasePart") then
			v.Anchored = false
		end
	end
end)
addcmd("sit", "Makes you sit", {}, {},function(args)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = true
end)

addcmd("spin", "Makes you spin", {}, {"[Speed]"},function(args)
	if Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Spin") then
		Players.LocalPlayer.Character.HumanoidRootPart.Spin:Destroy()
	end
	local Spin = Instance.new("BodyAngularVelocity")
	Spin.Name = "Spin"
	Spin.Parent = Players.LocalPlayer.Character.HumanoidRootPart
	Spin.MaxTorque = Vector3.new(0, math.huge, 0)
	Spin.AngularVelocity = Vector3.new(0,args[1],0)
end)

addcmd("unspin", "Stops spinning", {}, {},function(args)
	if Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Spin") then
		Players.LocalPlayer.Character.HumanoidRootPart.Spin:Destroy()
	end
end)

addcmd("reset", "Kills you", {"respawn"}, {},function(args)
    game.Players.LocalPlayer.Character:BreakJoints()
end)

addcmd("xray", "Lets you see through walls", {}, {"(Transparency)"},function(args)
    for i,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChildOfClass('Humanoid') then
        	if args[1] then
            	v.LocalTransparencyModifier = tonumber(args[1])
            else
            	v.LocalTransparencyModifier = 0.5
            end
        end
    end
end)

addcmd("unxray", "Disables xray", {"noxray"}, {},function(args)
    for i,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChildOfClass('Humanoid') then
            v.LocalTransparencyModifier = 0
        end
    end
end)

addcmd("view", "Views another player", {"spectate","watch"}, {"[Player]"},function(args)
    workspace.CurrentCamera.CameraSubject = Players[quickFind(args[1])].Character
end)

addcmd("unview", "Unviews a player", {"unspectate","unwatch"}, {},function(args)
    workspace.CurrentCamera.CameraSubject = Players.LocalPlayer.Character
end)

addcmd("equiptools", "Equips all your tools", {}, {},function(args)
    for i,v in ipairs(Players.LocalPlayer:FindFirstChildOfClass("Backpack"):GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = Players.LocalPlayer.Character
		end
	end
end)

addcmd("buildertools", "Gives you clientsided builder tools", {"btools"}, {},function(args)
    local CloneTool = Instance.new("HopperBin", Players.LocalPlayer.Backpack)
	CloneTool.BinType = "Clone"
	local HammerTool = Instance.new("HopperBin", Players.LocalPlayer.Backpack)
	HammerTool.BinType = "Hammer"
	local GrabTool = Instance.new("HopperBin", Players.LocalPlayer.Backpack)
	GrabTool.BinType = "Grab"
end)

addcmd("fov", "Changes your fov", {}, {"[Fov]"},function(args)
    workspace.Camera.FieldOfView = args[1]
end)

addcmd("print", "Prints text in the console", {}, {"[Text]"},function(args)
    print(table.concat(args," "))
end)

addcmd("warn", "Puts a warning in the console", {}, {"[Text]"},function(args)
    warn(table.concat(args," "))
end)

addcmd("disable", "Disables Enigma", {}, {},function(args)
    main:Destroy()
    script:Destroy()
end)

local Noclipping
addcmd("noclip", "Lets you walk through walls", {}, {},function(args)
	local function NoclipLoop()
		if Players.LocalPlayer.Character ~= nil then
			for i, v in pairs(Players.LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") and v.CanCollide == true then
					v.CanCollide = false
				end
			end
		end
	end
	Noclipping = RunService.Stepped:Connect(NoclipLoop)
end)

addcmd("clip", "Undoes noclip", {}, {},function(args)
	if Noclipping then
		Noclipping:Disconnect()
        for i, v in pairs(Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == false then
                v.CanCollide = true
            end
        end
	end
end)
theflything = nil
addcmd("fly", "Makes you fly", {}, {"(Speed)"},function(args)
    if not theflything then
        theflything = true
        local camera = game:GetService("Workspace").CurrentCamera

        local character = Players.LocalPlayer.Character
        local hrp = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 10^6
        bodyGyro.P = 10^6

        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(1, 1, 1) * 10^6
        bodyVel.P = 10^4

        local isFlying = true
        local movement = {forward = 0, backward = 0, right = 0, left = 0}

        function setFlying(flying)
            isFlying = flying
            bodyGyro.Parent = isFlying and hrp or nil
            bodyVel.Parent = isFlying and hrp or nil
            bodyGyro.CFrame = hrp.CFrame
            bodyVel.Velocity = Vector3.new()
            character:WaitForChild("Animate").Disabled = isFlying
        end

        local function onUpdate(dt)
            if isFlying then
                local cf = camera.CFrame
                local direction = cf.RightVector * (movement.right - movement.left) + cf.LookVector * (movement.forward - movement.backward)
                if direction:Dot(direction) > 0 then
                    direction = direction.Unit
                end
                bodyGyro.CFrame = cf
                bodyVel.Velocity = direction * humanoid.WalkSpeed * 3
            end
        end
        --[[
        local function onKeyPress(input, gameProcessedEvent)
            if not gameProcessedEvent and input.KeyCode == flyKey then
                if not humanoid or humanoid:GetState() == Enum.HumanoidStateType.Dead then
                    return
                end
                for _, v in pairs(humanoid:FindFirstChildOfClass("Animator"):GetPlayingAnimationTracks()) do
                    v:Stop()
                end
                setFlying(not isFlying)
            end
        end
        --]]
        local function movementBind(actionName, inputState, inputObject)
            if inputState == Enum.UserInputState.Begin then
                if not args[1] then
                    movement[actionName] = 1
                else
                    movement[actionName] = tonumber(args[1])
                end
            elseif inputState == Enum.UserInputState.End then
                movement[actionName] = 0
            end
            if isFlying then
                local isMoving = movement.right + movement.left + movement.forward + movement.backward > 0
            end
            return Enum.ContextActionResult.Pass
        end

        --UserInputService.InputBegan:Connect(onKeyPress)
        ContextActionService:BindAction("forward", movementBind, false, Enum.PlayerActions.CharacterForward)
        ContextActionService:BindAction("backward", movementBind, false, Enum.PlayerActions.CharacterBackward)
        ContextActionService:BindAction("left", movementBind, false, Enum.PlayerActions.CharacterLeft)
        ContextActionService:BindAction("right", movementBind, false, Enum.PlayerActions.CharacterRight)
        game:GetService("RunService").RenderStepped:Connect(onUpdate)
        setFlying(true)
        local toggler = Players.LocalPlayer.CharacterAdded:Connect(function()
            theflything = false
            toggler:Disconnect()
        end)
    else
        setFlying(true)
    end
end)

addcmd("unfly", "Stops flying", {}, {},function(args)
    setFlying(false)
end)

addcmd("nodecals", "Deletes all decals", {"removedecals"}, {},function(args)
    for i,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Decal") then
            v:Destroy()
        end
    end
end)

addcmd("norender", "Disables rendering", {}, {},function(args)
    RunService:Set3dRenderingEnabled(false)
end)

addcmd("render", "Enables rendering", {}, {},function(args)
    RunService:Set3dRenderingEnabled(true)
end)

addcmd("unfocusedcpu", "Disables rendering and caps fps when window isn't focused", {}, {},function(args)
    unfocusedcpuexists = true
    notwindow = UserInputService.WindowFocusReleased:Connect(function()
        RunService:Set3dRenderingEnabled(false)
        setfpscap(5)
    end)
    
    yeswindow = UserInputService.WindowFocused:Connect(function()
        RunService:Set3dRenderingEnabled(true)
        setfpscap(60)
    end)
end)

addcmd("ununfocusedcpu", "Disables unfocusedcpu", {}, {},function(args)
    if unfocusedcpuexists then
        unfocusedcpuexists = nil
        yeswindow:Disconnect()
        notwindow:Disconnect()
    end
end)

addcmd("hitbox", "Changes a character's hitbox", {}, {"[Player]","[Size]"},function(args)
    if args[1] == "others" or args[1] == "all" then
        for i,v in pairs(Players:GetPlayers()) do
            if v ~= Players.LocalPlayer and v.Character:FindFirstChild('HumanoidRootPart') then
                local hrp = v.Character:FindFirstChild('HumanoidRootPart')
                if hrp:IsA("BasePart") then
                    hrp.CanCollide = false
                    hrp.CastShadow = false
                    hrp.Size = Vector3.new(args[2],args[2],args[2])
                    hrp.Transparency = 0.6
                end
            end
        end
    else
        local hrp = Players[quickFind(args[1])].Character:FindFirstChild('HumanoidRootPart')
        hrp.CanCollide = false
        hrp.CastShadow = false
        hrp.Size = Vector3.new(args[2],args[2],args[2])
        hrp.Transparency = 0.6
    end
end)

addcmd("reach", "Gives your equipped tool reach", {}, {"[Distance]"},function(args)
    for i,v in pairs(Players.LocalPlayer.Character:GetDescendants()) do
		if v:IsA("Tool") then
            if not v:FindFirstChild("toolSB") then
                local a = Instance.new("SelectionBox")
			    a.Name = "toolSB"
			    a.Parent = v.Handle
			    a.Adornee = v.Handle
            end
			v.Handle.Massless = true
            v.Handle.CanCollide = false
			v.Handle.Size = Vector3.new(args[1],args[1],args[1])
			v.GripPos = Vector3.new(0,0,0)
		end
	end
end)

addcmd("commands", "lists all commands", {}, {},function(args)
    local Folder = Instance.new("Folder")
    local Frame = Instance.new("Frame")
    local Close = Instance.new("TextButton")
    local Title = Instance.new("TextLabel")
    local Frame_2 = Instance.new("ScrollingFrame")
    local AntiList = Instance.new("Folder")
    local UIListLayout = Instance.new("UIListLayout")

    Folder.Parent = main
    Folder.Name = "CommandsList"

    Frame.Parent = Folder
    Frame.BackgroundColor3 = Color3.fromRGB(17, 18, 25)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.355569512, 0, 0.280797094, 0)
    Frame.Size = UDim2.new(0, 358, 0, 133)

    Close.Name = "Close"
    Close.Parent = Frame
    Close.BackgroundColor3 = Color3.fromRGB(17, 18, 25)
    Close.BackgroundTransparency = 1.000
    Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Close.BorderSizePixel = 0
    Close.Position = UDim2.new(0.935784519, 0, 0, 0)
    Close.Size = UDim2.new(0.0643641427, 0, 0.131205678, 0)
    Close.Font = Enum.Font.GothamBold
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextScaled = true
    Close.TextSize = 14.000
    Close.TextWrapped = true

    Title.Name = "Title"
    Title.Parent = Frame
    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.BackgroundColor3 = Color3.fromRGB(17, 18, 25)
    Title.BackgroundTransparency = 1.000
    Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Title.BorderSizePixel = 0
    Title.Position = UDim2.new(0.465172976, 0, 0.0638298392, 0)
    Title.Size = UDim2.new(0.941223323, 0, 0.131205678, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Commands"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.TextSize = 14.000
    Title.TextWrapped = true

    Frame_2.Name = "Frame"
    Frame_2.Parent = Frame
    Frame_2.BackgroundColor3 = Color3.fromRGB(34, 32, 48)
    Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame_2.BorderSizePixel = 0
    Frame_2.ClipsDescendants = false
    Frame_2.Position = UDim2.new(8.52446291e-08, 0, 0.131205618, 0)
    Frame_2.Selectable = false
    Frame_2.Size = UDim2.new(0.999997437, 0, 1.7334559, 0)
    Frame_2.BottomImage = ""
    Frame_2.CanvasSize = UDim2.new(0, 0, 10, 0)
    Frame_2.MidImage = ""
    Frame_2.ScrollBarThickness = 0
    Frame_2.TopImage = ""
    Frame_2.ClipsDescendants = true

    UIListLayout.Parent = Frame_2
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local gui = Frame

    local dragging
    local dragInput
    local dragStart
    local startPos

    function Lerp(a, b, m)
        return a + (b - a) * m
    end;

    local lastMousePos
    local lastGoalPos
    local DRAG_SPEED = (8); -- // The speed of the UI darg.
    function Update(dt)
        if not (startPos) then return end;
        if not (dragging) and (lastGoalPos) then
            gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
            return 
        end;

        local delta = (lastMousePos - UserInputService:GetMouseLocation())
        local xGoal = (startPos.X.Offset - delta.X);
        local yGoal = (startPos.Y.Offset - delta.Y);
        lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
        gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
    end;

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            lastMousePos = UserInputService:GetMouseLocation()

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    RunService.Heartbeat:Connect(Update)

    Close.MouseButton1Down:Connect(function()
        Frame:Destroy()
    end)
    for i,v in pairs(cmds) do
        local Command = Instance.new("TextLabel")
        Command.Name = i
        Command.Parent = Frame_2
        Command.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Command.BackgroundTransparency = 1.000
        Command.Size = UDim2.new(0.996999979, 0, 0.0120000001, 0)
        Command.Font = Enum.Font.Gotham
        Command.Text = i
        Command.TextColor3 = Color3.fromRGB(255, 255, 255)
        Command.TextSize = 14.000
        Command.TextXAlignment = Enum.TextXAlignment.Left
        task.wait()
    end
end)
for i, v in pairs(cmds) do
	commandcount += 1
    table.insert(commandnametable,i)
end
