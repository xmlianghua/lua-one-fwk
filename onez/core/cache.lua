--[[
配置缓存操作模块，使用全局变量 _c 存储；
_c 在 ngx_lua 的 init_by_lua_file 指令执行文件 init.lua 中进行初始化
为支持多应用, 缓存存储在 _c[appname]中, appname 取自 ngx.var.APPNAME
--]]

local _M = {}

function _M.get(key, defaultvalue)
	local appname = ngx.var.APPNAME or "onez"
	if not _c[appname] then
		return defaultvalue
	end
	return _c[appname][key] or defaultvalue
end

function _M.set(key, value)
	local appname = ngx.var.APPNAME or "onez"
	if not _c[appname] then
		_c[appname] = {}
	end
	_c[appname][key] = value
end

function _M.setg(key, value)
    _g[key] = value
end

return _M