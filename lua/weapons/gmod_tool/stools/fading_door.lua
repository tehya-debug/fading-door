TOOL.Category = "FD"
TOOL.Name = "Fading Door"

function TOOL:LeftClick(trace)
    if (CLIENT) then return end

    local tr = trace.Entity
    
    local owner = tr:CPPIGetOwner()
    local ply = self:GetOwner()

    if (owner ~= ply) then
        return
    end

    tr:SetFade()
end

function TOOL:RightClick(trace)
    if (CLIENT) then return end

    local tr = trace.Entity
    
    local owner = tr:CPPIGetOwner()
    local ply = self:GetOwner()

    if (owner ~= ply) then
        return
    end

    tr:RemoveFade()
end

if (CLIENT) then
    language.Add("tool.fading_door.name", "Fading Door")
    language.Add("tool.fading_door.desc", "")
    language.Add("tool.fading_door.0", "Left Click: Set Fading Door / Right Click: Remove Fading Door")
end

