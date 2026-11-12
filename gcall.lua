-- @@@@@@@@@@@@@@@@@@
-- @                @
-- @    GabzCALL    @
-- @                @
-- @@@@@@@@@@@@@@@@@@
--
--  get pinged from having your name
--  mentioned on chat!
--

local alias = "cyn" -- what should trigger the mention (your name, probably-)
local caseSensitive = false
local minimumPingTime = 10 -- cooldown in seconds (cooldown is applied every time your name appears in chat, by you, or others)

local textColor = "#c562ff"
local backgroundColor = "#ffff00" -- only shows when ping sound is played



local function onceMentioned(callerName) -- what happens when you get mentioned (with sound!)
    if not player:isLoaded() then return end

    sounds:playSound("minecraft:entity.cat.ambient", player:getPos())


end


local callTimer = minimumPingTime * 20

if not host:isHost() then return end
function events.tick() -- increase timer

    callTimer = callTimer + 1
end

function events.chat_receive_message(msg, jsonText)

    if not player:isLoaded() then return end

    local data = parseJson(jsonText)
    local setBackgroundCol


    if data.with then
        local text = data.with[2]
        local senderName

        if type(data.with[1]) == "table" then
            senderName = data.with[1].insertion
        elseif type(data.with[1]) == "string" then
            senderName = data.with[1]
        end
        
        
        local foundAlias

        -- search for the alias in the message content

        if type(text) == "string" then
        if caseSensitive then
            foundAlias = text:find(alias)
        else
            foundAlias = string.lower(text):find(alias)
        end
        
        
        if foundAlias then

            if senderName ~= player:getName() then -- if someone else calls my name

                -- only play sound if no cooldown

                if callTimer > minimumPingTime * 20 then
                    
                    onceMentioned(senderName)

                    setBackgroundCol = vectors.hexToRGB(backgroundColor) -- only change background if it pings me
                end

                -- changes the message color for highlight

                data.color = textColor
            end

            -- resets timer (independently if i called myself or someone else called)

            callTimer = 0
        end
        
    end
    end


    return toJson(data), setBackgroundCol
end