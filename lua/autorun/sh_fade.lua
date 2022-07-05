
local ENT = FindMetaTable("Entity")

function ENT:GetFade()
    return self:GetNWBool("TFade", false)
end

function ENT:GetFadeStage()
    return self:GetNWBool("TFadeStage", true)
end

if (SERVER) then
    local ENT = FindMetaTable("Entity")

    function ENT:SetFade()
        if (self:GetFade()) then return end
        
        self:SetNWBool("TFade", true)
    end

    function ENT:SetFadeStage(val)
        self:SetNWBool("TFadeStage", val)
    end

    function ENT:RemoveFade()
        if (not self:GetFade()) then return end

        local oldMaterial = self.oldMaterial or ""

        self:SetNWBool("TFade", false)
    
        if (not self:GetFadeStage()) then
            self:SetCollisionGroup(COLLISION_GROUP_NONE)
            self:SetMaterial(oldMaterial)

            self:SetFadeStage(true)
        end

        self.oldMaterial = nil
    end

    function ENT:FadeActivate()
        if (self:GetFadeStage()) then
            self.oldMaterial = self:GetMaterial()

            self:SetCollisionGroup(COLLISION_GROUP_WORLD)
            self:SetMaterial("models/props_combine/stasisshield_sheet")

            self:SetFadeStage(false)
        else
            self:SetCollisionGroup(COLLISION_GROUP_NONE)
            self:SetMaterial(self.oldMaterial)

            self:SetFadeStage(true)
        end
    end

    hook.Add("PlayerUse", "TFade", function(ply, ent) 
        if (ent:GetFade()) then
            if (CurTime() < (ent.TFadeTimeout or 0)) then return end

            local ownerFade = ent:CPPIGetOwner() 

            if (ownerFade == ply) then
                ent:FadeActivate()
            end

            ent.TFadeTimeout = CurTime() + 2
        end
    end)
else
    local TFadeLock = Material("icon16/lock.png")
    local TFadeUnLock = Material("icon16/lock_open.png")

    hook.Add("HUDPaint", "TFadeHUD", function()
        local w, h = ScrW(), ScrH()
        local ent = LocalPlayer():GetEyeTrace().Entity
        
        if (ent:GetFade()) then
            local TFadeMaterial = (ent:GetFadeStage() and TFadeLock) or TFadeUnLock

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(TFadeMaterial)
            surface.DrawTexturedRect((w / 2) - 8, (h / 2) + 16, 16, 16)
        end
    end)
end