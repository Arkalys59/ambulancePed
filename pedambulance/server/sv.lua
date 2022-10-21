local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

AddEventHandler("KraKss:ReviveDeadPlayer", function(source)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)    
    local xMoney = xPlayer.getAccount("cash").money
    local xBank = xPlayer.getAccount("bank").money
    if xPlayer then
        if xMoney >= utils.healCost then
            xPlayer.removeAccountMoney("cash", utils.reaCost)
            ExecuteCommand("revive ".._src)
            MySQL.Async.fetchAll("SELECT money FROM addon_account_data WHERE account_name = 'society_ambulance'", {}, function(result)
                if result[1] then
                    print("[KraKss] "..result[1].money)
                    MySQL.Async.execute("UPDATE addon_account_data SET money = @a WHERE account_name = 'society_ambulance'", {
                        ['a'] = result[1].money + utils.reaCost
                    })
                end
            end)
            TriggerClientEvent("KraKss:updateDeathStatut", _src) 
            TriggerClientEvent("esx:showAdvancedNotification", _src, "BlackOut", "MÉDECIN", "Vous avez été réanimé et vous avez payé ~g~"..utils.reaCost.."$", "CHAR_EMS")
        elseif xBank >= utils.healCost then
            xPlayer.removeAccountMoney("bank", utils.reaCost) 
            ExecuteCommand("revive ".._src)
            MySQL.Async.fetchAll("SELECT money FROM addon_account_data WHERE account_name = 'society_ambulance'", {}, function(result)
                if result[1] then
                    print("[KraKss] "..result[1].money)
                    MySQL.Async.execute("UPDATE addon_account_data SET money = @a WHERE account_name = 'society_ambulance'", {
                        ['a'] = result[1].money + utils.reaCost
                    })
                end
            end)
            TriggerClientEvent("KraKss:updateDeathStatut", _src) 
            TriggerClientEvent("esx:showAdvancedNotification", _src, "BlackOut", "MÉDECIN", "Vous avez été réanimé et vous avez payé ~g~"..utils.reaCost.."$", "CHAR_EMS")
        else
            TriggerClientEvent("esx:showNotification", _src, "~r~Vous n'avez pas assez d'argent")
        end
    else
        DropPlayer("[KraKss] Cheat | discord.gg/blackoutfr si vous pensez que c'est une erreur")
        return
    end
end)

ESX.RegisterServerCallback("KraKss:healPlayer", function(source, cb)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)    
    local xMoney = xPlayer.getAccount("cash").money
    local xBank = xPlayer.getAccount("bank").money
    local canBeHealed = false
    if xPlayer then
        if xMoney >= utils.healCost then
            xPlayer.removeAccountMoney("cash", utils.healCost)
            TriggerClientEvent("esx:showAdvancedNotification", _src, "BlackOut", "MÉDECIN", "Vous avez été soigné et vous avez payé ~g~"..utils.healCost.."$", "CHAR_EMS")
            MySQL.Async.fetchAll("SELECT money FROM addon_account_data WHERE account_name = 'society_ambulance'", {}, function(result)
                if result[1] then
                    MySQL.Async.execute("UPDATE addon_account_data SET money = @a WHERE account_name = 'society_ambulance'", {
                        ['a'] = result[1].money + utils.healCost
                    })
                end
            end)
            canBeHealed = true
        elseif xBank >= utils.healCost then 
            xPlayer.removeAccountMoney("bank", utils.healCost)
            TriggerClientEvent("esx:showAdvancedNotification", _src, "BlackOut", "MÉDECIN", "Vous avez été soigné et vous avez payé ~g~"..utils.healCost.."$", "CHAR_EMS")
            MySQL.Async.fetchAll("SELECT money FROM addon_account_data WHERE account_name = 'society_ambulance'", {}, function(result)
                if result[1] then
                    MySQL.Async.execute("UPDATE addon_account_data SET money = @a WHERE account_name = 'society_ambulance'", {
                        ['a'] = result[1].money + utils.healCost
                    })
                end
            end)
            canBeHealed = true
        else
            TriggerClientEvent("esx:showNotification", _src, "~r~Vous n'avez pas assez d'argent")
        end
    else
        return
    end
    cb(canBeHealed)
end)