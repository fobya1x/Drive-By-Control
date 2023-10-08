if Config.Framework == 'esx' then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
end

local function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(0, 1)
end

local function DriveByControl()
    local ped = PlayerPedId()
    local p_id = PlayerId()
    local veh = GetVehiclePedIsUsing(ped)
    local v_speed = GetEntitySpeed(veh)
    local isAiming = IsPlayerFreeAiming(p_id)

    if Config.DisableOnlyWhenSpeeding and v_speed >=
        (Config.VehicleSpeedToDisable / 2.4) then
        if Config.EnablePoliceDriveBySpeeding then
            if Config.Framework == 'esx' then
                PlayerJob = ESX.PlayerData.job
            elseif Config.Framework == 'qb' then
                PlayerJob = QBCore.Functions.GetPlayerData().job
            end
            if PlayerJob and PlayerJob.name == 'police' then
                if not Config.DriverCanShoot and GetPedInVehicleSeat(veh, -1) ==
                    ped then
                    SetPlayerCanDoDriveBy(p_id, false)
                    if isAiming and Config.EnableNotify then
                        Notify('The Driver Can not shoot')
                    end
                else
                    SetPlayerCanDoDriveBy(p_id, true)
                end
            else
                SetPlayerCanDoDriveBy(p_id, false)
                if isAiming and Config.EnableNotify then
                    Notify('You Are Driving Fast,You Can not Shoot')
                end
            end
        else
            SetPlayerCanDoDriveBy(p_id, false)
            if isAiming and Config.EnableNotify then
                Notify('You Are Driving Fast,You Can not Shoot')
            end
        end
    else
        if not Config.DriverCanShoot and GetPedInVehicleSeat(veh, -1) == ped then
            SetPlayerCanDoDriveBy(p_id, false)
            if isAiming and Config.EnableNotify then
                Notify('The Driver Can not shoot')
            end
        else
            SetPlayerCanDoDriveBy(p_id, true)
        end
    end
end

CreateThread(function()
    while true do
        Wait(1500)
        if IsPedSittingInAnyVehicle(PlayerPedId()) then DriveByControl() end
    end
end)

