local Core = exports[Config.Framework]:GetCoreObject() local ox_inventory = exports.ox_inventory lib.locale()

-- ox_lib callback
lib.callback.register('xyz-cityhall:server:updateCityUI', function(source)
    local Player = Core.Functions.GetPlayer(source)

    local userinfo = {
        name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
        job = Player.PlayerData.job.label,
    }
    return userinfo
end)

lib.callback.register('xyz-cityhall:server:registerlicense', function(source)
    local license = {}

    local Player = Core.Functions.GetPlayer(source)
    local licenseTable = Player.PlayerData.metadata["licences"]

    licenseTable["id"] = true

    for k, v in pairs(Config.LicenseTable) do
        local name = v.label
        local price = tonumber(v.price)

        
        if licenseTable[k] then
            table.insert(license, {
                name = name, price = price,
            })
        end

        table.sort(license, function(a, b)
            return a.name < b.name
        end)
    end return license
end)

lib.callback.register('xyz-cityhall:server:Joblist', function(source)
    local JobData = {}
    for k, v in pairs(Config.JobTable) do
        local name = v.label
        local whitelisted = v.whitelisted
        
        table.insert(JobData, {
          name = name, whitelisted = whitelisted,
        })

        table.sort(JobData, function(a, b)
            return a.name < b.name
        end)

    end return JobData
end)


RegisterNetEvent('xyz-cityhall:server:buyLicense', function(license)
    local src = source
    local Player = Core.Functions.GetPlayer(src)
    local licenseTable = Player.PlayerData.metadata["licences"]
    local licensePrice = Config.LicenseTable[license].price
    local expireDate = os.date("%d/%m/%Y", os.time() + 2592000)
    
    licenseTable[license] = true

    local gender = "Man"

    if Player.PlayerData.charinfo.gender == 1 then
        gender = "Woman"
    end


    local infocard = {
        type = string.format(Player.PlayerData.citizenid),
        description = string.format('First name: %s  \nLast name: %s  \nBirth date: %s  \nSex: %s  \nNationality: %s  \nIssued: %s',
        Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname, Player.PlayerData.charinfo.birthdate, gender, Player.PlayerData.charinfo.nationality, os.date("%d/%m/%Y"))
    }

    if Player.PlayerData.money.cash >= licensePrice then
        for k, v in pairs(Config.LicenseTable) do 
            if k == license then
                local licenseName = v.label
                local licenseItem = v.item
                local licensePrice = v.price

                if Player.Functions.GetItemByName(licenseItem) then
                    local grandinfo = { title = locale('already_item', v.label), duration = 10000, position = 'top', type = 'error', icon = 'id-card' }
                    TriggerClientEvent('ox_lib:notify', src, grandinfo)
                    return
                end
                
                Player.Functions.RemoveMoney('cash', licensePrice, "bought-license")
                Player.Functions.AddItem(licenseItem, 1, false, infocard)
                -- exports['um-idcard']:CreateMetaLicense(source, licenseItem)
                Player.Functions.SetMetaData("licences", licenseTable)

                local grandinfo = { title = locale('grant_title'), duration = 10000, position = 'top', type = 'success', icon = 'id-card' }
                TriggerClientEvent('ox_lib:notify', src, grandinfo)
            end
        end
    else
        return
    end

end)

-- // JOB SYSTEM // --
RegisterNetEvent('xyz-cityhall:server:applyjob', function(GetJobPlayer)
    local src = source
    local Player = Core.Functions.GetPlayer(src)

    if Player.PlayerData.job.name == GetJobPlayer then
        local grandinfo = { title = locale('job_info_fail', GetJobPlayer), duration = 10000, position = 'top', type = 'error', icon = 'id-card' }
        TriggerClientEvent('ox_lib:notify', src, grandinfo)
        return
    end

    Player.Functions.SetJob(GetJobPlayer, 0)
    local grantinfo = { title = locale('job_info', GetJobPlayer), duration = 10000, position = 'top', type = 'success', icon = 'id-card' }
    TriggerClientEvent('ox_lib:notify', src, grantinfo)
    TriggerClientEvent('xyz-cityhall:client:sendemail', src, GetJobPlayer)
end)

if Config.Debug then
    lib.addCommand('revokeall', {
        help = locale('revoke_help'),
        restricted = 'group.admin'
    },function(source)
        local Player = Core.Functions.GetPlayer(source)
        local licenseTable = Player.PlayerData.metadata["licences"]
        for k, v in pairs(licenseTable) do
            licenseTable[k] = false
        end
        licenseTable["id"] = true


        Player.Functions.SetMetaData("licences", licenseTable)
        local grandinfo = { title = locale('revoke_title'), description = locale('revokeall'), duration = 10000, position = 'top', type = 'error', icon = 'id-card' }
        TriggerClientEvent('ox_lib:notify', source, grandinfo)
    end)
    
    lib.addCommand('grantall', {
        help = locale('grand_help'), 
        restricted = 'group.admin'
    },function(source)
        local Player = Core.Functions.GetPlayer(source)
        local licenseTable = Player.PlayerData.metadata["licences"]
        for k, v in pairs(licenseTable) do
            licenseTable[k] = true
        end
    
        Player.Functions.SetMetaData("licences", licenseTable)

        local grandinfo = { title = locale('grant_title'), description = locale('grantall'), duration = 10000, position = 'top', type = 'success', icon = 'id-card' }
        TriggerClientEvent('ox_lib:notify', source, grandinfo)
    end)
end


AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
      print("^XYZ-Cityhall -^2Started Successfully^3") 
   end
end)