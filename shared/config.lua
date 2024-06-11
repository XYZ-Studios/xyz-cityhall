Config = {}

Config.Framework = 'qb-core' -- qb-core, qb-core

Config.colorScheme = 'yellow' -- Color scheme of the UI, options: red, blue, green, yellow, purple, pink, orange, white, black

Config.Model = "a_f_y_business_01" -- Model of the ped
Config.PedSpawn = vec4(-543.91, -194.647, 37.227, 98.731)

---@param metadata: string, label: title, price: $$, item: item name
Config.LicenseTable = {
    ["id"] = { label = "ID Card", price = 0, item = "id_card"},

    ["driver"] = { label = "Driver's License", price = 500, item = "driver_license",},
    ["weapon"] = { label = "Weapon License", price = 1000, item = "weaponlicense"},

    -- Add more licenses here if you want to add more licenses
    ["hunting"] = { label = "Hunting License", price = 1000, item = "huntinglicense", },
    ["fishing"] = { label = "Fishing License", price = 1000, item = "fishinglicense", },
    ["pilot"] = { label = "Pilot License", price = 1000, item = "pilotlicense", },
    ["boat"] = { label = "Boating License", price = 1000, item = "boatlicense", },
    ["certificate"] = { label = "Certificate", price = 1000, item = "certificate", },
}

---@param Job: string, label: title, description: description,
Config.JobTable = {
    ["turbine"] = {
        label = "Turbine Inc.",
        description = "Work at the wind farm, maintaining and repairing the turbines.",
        jobcoords = { x = 2474.676, y = 1573.895 } -- Define coordinates as a table
    },
    ["salvage"] = {
        label = "Salvage Inc.",
        description = "Work at the scrapyard, salvaging and recycling materials.",
        jobcoords = { x = -469.967, y = -1718.03 } -- Define coordinates as a table
    },
}

Config.Debug = false

-- If you want to replace the Card themes go to web/build/assets
-- You will see 1, and 2, must be in jpeg and
-- 1 = Job ThemeCard Main Screen
-- 2 = License ThemeCard Main Screen