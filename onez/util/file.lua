--[[
    文件操作工具类
]]

local _M = { __VERSION = "0.0.1" }

function _M.read_jsonfile(path)
    local file = io.open(path, "r")
    local json = file:read("*a")
    file:close()
    return cjson.decode(json);
end

return _M
