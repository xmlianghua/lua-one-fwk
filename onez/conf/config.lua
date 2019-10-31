--[[
    配置文件模板
]]

local oneztbl = require "util.table"

local configs = {
    __VERSION = "0.0.1",

    debug = true,
    title = "LUA APPLICATION",
    appname = "onez",
    webroot = "web",
    tplroot = "web/tpl",
    locale  = "zh",

    controller = {
        prefix = "web.ctrl"
    },

    pageinfo = {
        pagesize = 20
    },

    databases = {
        tpl = {
            host = "localhost",
            port = 3306,
            database = "",
            user = "",
            password = "",
            charset = "utf8",
            timeout = 30000,
            max_idle_timeout = 60000,
            pool_size = 50,
            max_packet_size = 1024 * 1024
        },
        dbs = {
            {
                host = "localhost",
                port = 3366,
                database = "onez_users",
                user = "root",
                password = "root",
                tables = {
                    users = "b_user"
                }
            },
            {
                host = "localhost",
                port = 3366,
                database = "onez_questionbank",
                user = "root",
                password = "root",
                tables = {
                    tags = "k_tag",
                    papers = "p_paper"
                }
            }
        }
    },

    message = {
        zh = {
            module_not_found = "功能模块 %s 不存在.",
            method_not_found = "方法 %s 不存在于模块 %s 中.",
            where_not_exist_when_delete = "删除数据时必须有where条件.",
            where_not_exist_when_update = "更新数据时必须有where条件和set子句."
        },
        en = {

        }
    }
}

return oneztbl.readonly(configs)
