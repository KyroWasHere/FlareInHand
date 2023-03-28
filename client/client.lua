if Config.UsingCommand then
    RegisterCommand('spawnflare', function()
        SpawnFlare()
    end)
end

RegisterNetEvent('smoke:spawnFlare', function(cData)
    SpawnFlare()
end)

local modelHash = `w_am_flare`
local isActive = false
function SpawnFlare()
    if not isActive then
        RequestFlareModel()
        local obj = CreateObject(modelHash, GetEntityCoords(PlayerPedId()), true, false, false)
        while not DoesEntityExist(obj) do
            Wait(0)
        end
        PlayAnim(PlayerPedId(), "creatures@rottweiler@tricks@", 'petting_franklin', 31, 2000)
        AttachEntityToEntity(obj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.1, 0.0, 0.0, -85.0, 22.0, 0.0, false, false, false, false, 2, true)
        isActive = true
        Wait(2000)


        RequestFlarePTFX()
        local ptfx = StartNetworkedParticleFxLoopedOnEntity('exp_grd_flare', obj, 0,0,0.1,0,0,0,1.2,0,0,0)
        UseParticleFxAssetNextCall("core")
        local ptfx2 = StartNetworkedParticleFxLoopedOnEntity('weap_heist_flare_trail', obj, 0,0,0.1,0,0,0,1.0,0,0,0)
        SetEntityProofs(PlayerPedId(), 0, 1, 0, 0, 0, 0, 0, 0)
        while isActive do
            Wait(0)
            if IsControlJustPressed(0, 38) then
                isActive = false
                SetEntityProofs(PlayerPedId(), 0, 0, 0, 0, 0, 0, 0, 0)
                StopParticleFxLooped(ptfx, 0)
                StopParticleFxLooped(ptfx2, 0)
                DeleteEntity(obj)
            end
        end
    end
end


function RequestFlareModel()
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(0)
    end

end

function PlayAnim(ped, dict, anim, flag, dur) 
    RequestAnim(dict)
    TaskPlayAnim(ped, dict, anim, 1.0,-1.0, dur, flag, 1, false, false, false)
end

function RequestAnim(anim)
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        print(anim)
        Wait(0)
    end
end


function RequestFlarePTFX()
    if not HasNamedPtfxAssetLoaded("core") then
        RequestNamedPtfxAsset("core")
        while not HasNamedPtfxAssetLoaded("core") do
            Wait(10)
        end
    end
    UseParticleFxAssetNextCall("core")
end
