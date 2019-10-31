--[[
    表常用方法
]]
local _M = { VERSION = "0.01" }

function _M.readonly(t)
    local nt = {}
    local mt = {
        __index = t,
        __newIndex = function(t, k, v)
            ngx.log(ngx.ALERT, "试图修改一个只读的表!")
        end
    }
    setmetatable(nt, mt)
    return nt
end

return _M
