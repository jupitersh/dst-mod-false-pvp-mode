local lang = GetModConfigData("language")
local TheNet = GLOBAL.TheNet
local STRINGS = GLOBAL.STRINGS

AddUserCommand("pvp", {
    prettyname = nil,
    desc = nil,
    permission = GLOBAL.COMMAND_PERMISSION.USER,
    slash = true,   
    usermenu = false,
    servermenu = false,
    params = {"status"} ,
    localfn = function(params, caller)
        if params.status == "on" then
            GLOBAL.getmetatable(GLOBAL.TheNet).__index["GetPVPEnabled"] = function() return true end
            if lang == "zh" then
                caller.HUD.controls.networkchatqueue:DisplaySystemMessage("假的PVP模式已开启！")
            else
                caller.HUD.controls.networkchatqueue:DisplaySystemMessage("False PVP Mod Is On!")
            end
        elseif params.status == "off" then
            GLOBAL.getmetatable(GLOBAL.TheNet).__index["GetPVPEnabled"] = function() return false end
            if lang == "zh" then
                caller.HUD.controls.networkchatqueue:DisplaySystemMessage("假的PVP模式已关闭！")
            else
                caller.HUD.controls.networkchatqueue:DisplaySystemMessage("False PVP Mod Is Off!")
            end
        else
            if lang == "zh" then
                caller.HUD.controls.networkchatqueue:DisplaySystemMessage("输入错误！")
            else
                caller.HUD.controls.networkchatqueue:DisplaySystemMessage("Wrong Input!")
            end
        end
    end,
})

local friends = {}
GLOBAL.rawset(GLOBAL,"friends",friends)
local comb_rep = GLOBAL.require "components/combat_replica"
local old_IsAlly = comb_rep.IsAlly
function comb_rep:IsAlly(guy,...)
    if guy.userid and guy.userid ~= "" and friends[guy.userid] then
        return true
    end
    return old_IsAlly(self,guy,...)
end

--此段代码来源于封锁 感谢封锁大佬
local function AddComboKeyUpHandler(key_control_list, key_flag, fn)
    --检查是否在游戏画面内
    local function IsInGameScreen()
        if not GLOBAL.ThePlayer then return false end
        if not GLOBAL.ThePlayer.HUD then return false end
        local EndScreen = GLOBAL.TheFrontEnd:GetActiveScreen()
        if not EndScreen then return false end
        if not EndScreen.name then return false end
        if EndScreen.name ~= "HUD" then return false end
        return true
    end
    
    local function CheckKeyCombination(keycode)
        --检查功能键
        for index,each in pairs(key_control_list) do
            if not GLOBAL.TheInput:IsKeyDown(each) then return end
        end
        --检查是否在游戏画面内
        if not IsInGameScreen() then return end
        fn()
    end
    GLOBAL.TheInput:AddKeyUpHandler(key_flag, CheckKeyCombination)
end

AddComboKeyUpHandler({GLOBAL.KEY_LCTRL}, GLOBAL.KEY_INSERT, function()
    local max_dist = 16
    local list = " "
    for k,v in ipairs(GLOBAL.AllPlayers) do
        local dist = GLOBAL.ThePlayer:GetDistanceSqToInst(v)
        print(v.name or nil, dist)
        if v ~= GLOBAL.ThePlayer and dist < max_dist and v.userid and v.userid ~= "" then
            friends[v.userid] = true
            list = list..v.name.." "
        end
    end
    if list ~= " " then
        if lang == "zh" then
            GLOBAL.ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage("已添加"..list.."为好友！")
        else
            GLOBAL.ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage("Added"..list.."As Your Friends!")
        end
    else
        if lang == "zh" then
            GLOBAL.ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage("附近没有玩家！")
        else
            GLOBAL.ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage("No Player Nearby!")
        end
    end
end)

AddComboKeyUpHandler({GLOBAL.KEY_LCTRL}, GLOBAL.KEY_DELETE, function()
    for k,v in pairs(friends) do
        friends[k] = false
    end
    if lang == "zh" then
        GLOBAL.ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage("成功移除所有朋友！")
    else
        GLOBAL.ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage("All friends removal done!")
    end
end)

AddComboKeyUpHandler({GLOBAL.KEY_LCTRL}, GLOBAL.KEY_HOME, function()
    local players = {}
    local max_dist = 16
    local list = " "
    for k,v in ipairs(GLOBAL.AllPlayers) do
        local dist = GLOBAL.ThePlayer:GetDistanceSqToInst(v)
        if dist < max_dist and v.name and v.name ~= "" then
            table.insert(players, v.name)
        end
    end
    math.randomseed(GLOBAL.os.time())
    local num_players = #players
    --奇数取消分组
    if num_players % 2 == 1 then
        if lang == "zh" then
            TheNet:Say(STRINGS.LMB.." 附近玩家数为奇数，无法分组！", true)
        else
            TheNet:Say(STRINGS.LMB.." The number of nearby players is odd and cannot be grouped!", true)
        end
        return
    end
    --随机分组
    local half_num_players = num_players / 2
    local groupA, groupB = {}, {}

    while #groupA < half_num_players do
        local num = math.random(1, #players)
        table.insert(groupA, players[num])
        table.remove(players, num)
    end

    local stringA, stringB = "", ""
    for k,v in pairs(groupA) do
        stringA = stringA.." "..v
    end
    for k,v in pairs(players) do
        stringB = stringB.." "..v
    end
    if lang == "zh" then
        TheNet:Say(STRINGS.LMB.." A组： "..stringA.." B组： "..stringB, true)
    else
        TheNet:Say(STRINGS.LMB.." Group A: "..stringA.." Group B: "..stringB, true)
    end
end)