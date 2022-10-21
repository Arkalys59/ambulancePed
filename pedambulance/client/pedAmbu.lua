local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local pedCreated, deadPlayer

AddEventHandler('esx:onPlayerDeath', function()
    deadPlayer = true
end)

RegisterNetEvent("KraKss:updateDeathStatut")
AddEventHandler("KraKss:updateDeathStatut", function()
    deadPlayer = false
end)

Citizen.CreateThread(function() 
    for i = 1, #utils.pedPos do 
        RequestModel(utils.pedModel)    
        while not HasModelLoaded(utils.pedModel) do
            Citizen.Wait(100)
        end    
        pedCreated = CreatePed(0, utils.pedModel, utils.pedPos[i], false, false) 
        SetBlockingOfNonTemporaryEvents(pedCreated, true)
        SetEntityInvincible(pedCreated, true)
        FreezeEntityPosition(pedCreated, true)
    end
end) 

Citizen.CreateThread(function()
    while true do
    local wait = 1000        
        for k,v in pairs(utils.pedPos) do                   
            local co = GetEntityCoords(PlayerPedId())
            local dist = Vdist(co.x, co.y, co.z, v.x, v.y, v.z)            
            if dist <= 2.3 then               
                wait = 0  
                if deadPlayer then
                    Visual.Subtitle(("Appuyez sur [~b~E~s~] pour vous faire réanimer ~s~[~b~%s$~s~]"):format(utils.healCost), 0)   
                else
                    Visual.Subtitle(("Appuyez sur [~b~E~s~] pour vous faire soigner ~s~[~b~%s$~s~]"):format(utils.healCost), 0)                                         
                end
                if IsControlJustPressed(1, 51) then                       
                    if deadPlayer then
                        TriggerServerEvent("KraKss:ReviveDeadPlayer")
                    else                                                
                        ESX.TriggerServerCallback("KraKss:healPlayer", function(canBeHealed)
                            if canBeHealed then
                                SetEntityHealth(PlayerPedId(), 200)                                    
                            end   
                        end)                                                       
                    end
                end           
            end                                 
        end                     
        Citizen.Wait(wait)
    end
end) 