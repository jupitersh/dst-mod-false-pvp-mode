name = "假的PVP模式"
version = "1.3.3"
description = "版本："..version.."\n"..[[
聊天窗口输入/pvp on开启pvp模式，输入/pvp off关闭
左Ctrl+Home一个地皮范围内的玩家自动分为两组
左Ctrl+Insert添加一个地皮范围内的为好友
左Ctrl+Delete删除好友
]]

author = "辣椒小皇纸"
forumthread = ""
api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"

dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true

client_only_mod = true
all_clients_require_mod = false

----------------------
-- General settings --
----------------------

configuration_options =
{
    {
        name = "language",
        label = "Language",
        hover = "",
        options =   {
                        {description = "中文", data = "zh", hover = ""},
                        {description = "English", data = "en", hover = ""},
                    },
        default = "zh",
    },
}