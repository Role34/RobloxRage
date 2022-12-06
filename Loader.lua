repeat task.wait() until game.GameId ~= 0

if RobloxRage and RobloxRage.Game then
    RobloxRage.Utilities.UI:Notification({
        Title = "I Miss The Rage",
        Description = "Script already executed!",
        Duration = 5
    }) return
end

local PlayerService = game:GetService("Players")
repeat task.wait() until PlayerService.LocalPlayer
local LocalPlayer = PlayerService.LocalPlayer
local QueueOnTeleport = queue_on_teleport or
(syn and syn.queue_on_teleport)
local LoadArgs = {...}

local function GetSupportedGame() local Game
    for Id,Info in pairs(RobloxRage.Games) do
        if tostring(game.GameId) == Id then
            Game = Info break
        end
    end if not Game then
        return RobloxRage.Games.Universal
    end return Game
end

local function Concat(Array,Separator)
    local Output = "" for Index,Value in ipairs(Array) do
        Output = Index == #Array and Output .. tostring(Value)
        or Output .. tostring(Value) .. Separator
    end return Output
end

local function GetScript(Script)
    return RobloxRage.Debug and readfile("RobloxRage/" .. Script .. ".lua")
    or game:HttpGetAsync(("%s%s.lua"):format(RobloxRage.Domain,Script))
end

local function LoadScript(Script)
    return loadstring(RobloxRage.Debug and readfile("RobloxRage/" .. Script .. ".lua")
    or game:HttpGetAsync(("%s%s.lua"):format(RobloxRage.Domain,Script)))()
end

getgenv().RobloxRage = {Debug = LoadArgs[1],Utilities = {},
    Domain = "https://raw.githubusercontent.com/Role34/RobloxRage/main/",Games = {
        ["Universal" ] = {Name = "Universal",                       Script = "Universal"   },
        ["873703865" ] = {Name = "Westbound",                       Script = "Games/wb"    },
        ["1168263273"] = {Name = "Bad Business",                    Script = "Games/bb"    },
        ["358276974" ] = {Name = "Apocalypse Rising 2",             Script = "Games/ar2"   },
        ["1054526971"] = {Name = "Blackhawk Rescue Mission 5",      Script = "Games/brm5"  }
    }
}

--[[
getgenv().RobloxRage = {Domain = "https://raw.githubusercontent.com/Role34/RobloxRage/main",
    Debug = LoadArgs[1],Game = "None",Loaded = false,Utilities = {},Games = {
        [""          ] = {Name = "",                                Script = "Games/"      },
        ["Universal" ] = {Name = "Universal",                       Script = "Universal"   },
        ["873703865" ] = {Name = "Westbound",                       Script = "Games/wb"    },
        ["1168263273"] = {Name = "Bad Business",                    Script = "Games/bb"    },
        ["358276974" ] = {Name = "Apocalypse Rising 2",             Script = "Games/ar2"   },
        ["1054526971"] = {Name = "Blackhawk Rescue Mission 5",      Script = "Games/brm5"  }
    }
}
]]

RobloxRage.Utilities.UI = LoadScript("Utilities/UI")
RobloxRage.Utilities.Misc = LoadScript("Utilities/Misc")
RobloxRage.Utilities.Drawing = LoadScript("Utilities/Drawing")

local SupportedGame = GetSupportedGame()
LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.InProgress then
        QueueOnTeleport(([[local LoadArgs = {%s}
        loadstring(LoadArgs[1] and readfile("RobloxRage/Loader.lua") or
        game:HttpGetAsync("%sLoader.lua"))(unpack(LoadArgs))
        ]]):format(Concat(LoadArgs,","),RobloxRage.Domain))
    end
end)

if SupportedGame then
    RobloxRage.Game = SupportedGame.Name
    LoadScript(SupportedGame.Script)
    RobloxRage.Utilities.UI:Notification({
        Title = "I Miss The Rage",
        Description = RobloxRage.Game .. " loaded!",
        Duration = LoadArgs[2]
    })
end
