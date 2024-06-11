local Core = exports[Config.Framework]:GetCoreObject() lib.locale() IsLoggedIn = LocalPlayer.state.isLoggedIn


-- exports['interactionMenu']:Create {
--     position = vector3(-551.0, -202.5, 38.25),
--     maxDistance = 2.5,
--     indicator = {
--         prompt = 'E',
--         keyPress = {
--             padIndex = 0,
--             control = 38
--         }
--     },
--     options = {
--         {
--             label = locale('target_title'),
--             event = {
--                 type = 'client',
--                 name = 'xyz-cityhall:client:openMenu',
--             }
--         }
--     }
-- }


local function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', shouldShow)
end

RegisterNetEvent('xyz-cityhall:client:openMenu', function()
    local colorScheme = Config.colorScheme
    local userinfo = lib.callback.await('xyz-cityhall:server:updateCityUI', false, source)
    SendReactMessage('colorScheme', colorScheme)
    SendReactMessage('userinfo', userinfo, colorScheme)
    toggleNuiFrame(true)
end)

RegisterNetEvent('xyz-cityhall:client:sendemail', function(GetJobPlayer)
    if Config.JobTable[GetJobPlayer] and Config.JobTable[GetJobPlayer].jobcoords then
        local jobCoords = Config.JobTable[GetJobPlayer].jobcoords

        local receiverType = 'source'
        local receiver = GetPlayerServerId(PlayerId())
        local insertId, received = exports["yseries"]:SendMail({
            title = "Job Application Received",
            sender = 'cityhall@dreamscape.com',
            senderDisplayName = 'Gorvernment',
            content = 'You have now been employed as a ' .. GetJobPlayer .. '. Head to your workplace at coordinates to start your new job.',
            attachments = {
                { location = { x = jobCoords.x, y = jobCoords.y }}
            }
        }, receiverType, receiver)
    else
        print("Error: Job data or coordinates not found for " .. GetJobPlayer)
    end
end)



RegisterNUICallback('RegisterLicense', function(license, cb)
    local license = lib.callback.await('xyz-cityhall:server:registerlicense', false, source)
    SendReactMessage('RegisterLicense', license)

    cb('ok')
end)
RegisterNUICallback('Joblist', function(data, cb)
    local JobData = lib.callback.await('xyz-cityhall:server:Joblist', false, source)
    SendReactMessage('JobList', JobData)
    cb('ok')
end)
RegisterNUICallback('closeCityUI', function(_, cb)
    toggleNuiFrame(false)
    cb('ok')
end)

RegisterNUICallback('BuyLicense', function(data, cb) -- Needs to be fixed
    local data = {name = data.name, price = data.price,}

    for k, v in pairs(Config.LicenseTable) do
        if v.label == data.name then
            local license = k
            local licensePrice = v.price

            TriggerServerEvent('xyz-cityhall:server:buyLicense', license, licensePrice)
        end
    end
    cb('ok')
end)

RegisterNUICallback('RequestJob', function(data, cb) -- Needs to be fixed
    local PlayerData = Core.Functions.GetPlayerData()
    local data = {name = data.name,}

    for k, v in pairs(Config.JobTable) do
        if v.label == data.name then
            local job = k
            local jobGrade = 0
            TriggerServerEvent('xyz-cityhall:server:applyjob', job, jobGrade)

            SendReactMessage('userinfo', {
                name = PlayerData.charinfo.firstname .. ' ' .. PlayerData.charinfo.lastname,
                job = k
            })
        end
    end
    cb('ok')
end)

RegisterCommand('cityhall', function ()
    TriggerEvent('xyz-cityhall:client:openMenu')
end)