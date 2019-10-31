local function onezpwd()
    local info = debug.getinfo(1, "S").source
    local pwd  = "/"
    if info ~= nil then
        pwd = info:sub(2, -1)
        pwd = pwd:match("^.*/")
    end
    return pwd
end
ngx.log(ngx.DEBUG, onezpwd())

local function init_package_path()
    local onezpwd = onezpwd()
    package.path  = package.path .. ";" .. onezpwd .. "onez/?.lua;" .. ";" .. onezpwd .. "lib/?.lua;;"
    package.cpath = package.cpath .. ";" .. onezpwd .. "lib/?.so;;"
end
init_package_path()
ngx.log(ngx.DEBUG, package.path)
ngx.log(ngx.DEBUG, package.cpath)

cjson = require "cjson"
_     = require "moses"

-- 全局配置缓存，lua_code_cache off 指令关闭后生效
_c = {
    VERSION = "0.0.1"
}

-- 全局变量缓存
_g = {
    VERSION = "0.0.1"
}

_cache = require "core.cache"
_onezf = require "util.file"
