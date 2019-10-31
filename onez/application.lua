local _M = { __VERSION = "0.0.1" }

local appname = ngx.var.APPNAME
local apppath = ngx.var.APPPATH
local appuri  = ngx.var.uri

local loop = {
    stop   = false,
    status = 200
}

local function init()
    local isInited = _cache.get("isInited", false)
    if not isInited then
        ngx.log(ngx.DEBUG, "[onez:application:run] application - " .. appname .. " init...")
        _cache.set("configs", require("conf.config"))
        _cache.set("isInited", true)
    end
end

local function before()
    ngx.log(ngx.DEBUG, "[onez:application:run] application - " .. appname .. " start...")
end

local function after()
    ngx.log(ngx.DEBUG, "[onez:application:run] application - " .. appname .. " end.")
end

local function t_sp()
    local sp = require "util.sqlparser"
    sp.test()
end

local function execute()
    ngx.say(appuri)
    ngx.say(_cache.get("configs").pageinfo.pagesize)
    t_sp()
end

function _M.run()
    init()
    before()
    execute()
    after()
end

return _M
