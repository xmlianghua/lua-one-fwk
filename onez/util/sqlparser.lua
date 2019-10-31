--[[
    SQL语句生成，主要用于MYSQL
    table：表名
    fields: select 时的列名列表，以,(逗号)分隔
    where: where条件，用 colname-oper 的变量传入, 变量之间用,(逗号)分隔时为 and 关系，以;(分号)分隔时为 or 关系
           oper: lt(<),gt(>),nt(!),isn(is null),notn(is not null)
    limit: 分页查询，由传入的 page, size 参数进行构造
    orderby: 排序，colname[+](升序)，colname-(降序)
    groupby: 暂不实现
    having: 暂不实现
]]

local _M = {
    VERSION = "0.0.1",
    SELECT = [[select ${fields} from ${tablename} ${where} ${limit} ${orderby};select count(1) as rc from ${tablename} ${where}]],
    UPDATE = [[update ${tablename} set ${setlist} ${where}]],
    DELETE = [[delete from ${tablename} where ${where}]],
    oper = {
        lt  = "<",
        gt  = ">",
        nt  = "!=",
        lte = "<=",
        gte = ">=",
        isn = "is null",
        notn= "is not null"
    }
}

local strU = require("util.str")

local function limit( ... )
    local args = select(1, ... )
    local pageinfo = {}
    if args then
        if args.page then
            pageinfo.page = args.page
            if args.pagesize then
                pageinfo.pagesize = args.pagesize
            else
                pageinfo.pagesize = _cache.get("configs").pageinfo.pagesize
            end
            pageinfo.limit = "limit " .. (pageinfo.page - 1) * pageinfo.pagesize .. "," .. pageinfo.pagesize
        end
    end
    return pageinfo
end

local function whereexpression(field)
    local m, err = field:split("-")
    if not m then return "" end
    local result = ""
    if (field:startsWith("(")) then result = "(" end
    if (m[1]:startsWith("(")) then m[1] = m[1]:sub(2, #m[1] - 1) end
    if (m[1]:endsWith(")")) then m[1] = m[1]:sub(1, #m[1] - 1) end
    if #m <= 1 then
        result = result .. m[1] .. " = #{" .. m[1] .. "}"
    else
        if m[2] == "notn" or m[2] == "isn" then return m[1] .. _M.oper[m[2]] end
        result = result .. m[1] .. " " .. _M.oper[m[2]] .. " #{" .. m[1] .. "}"
    end
    if (field:endsWith(")")) then
        result = result .. ")"
    end
    return result
end

local function where(fields)
    if not _.isEmpty(fields) then
        local m, err = fields:split(",")
        local result = ""
        _.each(m, function(i, v)
            if (#result > 0) then result = result .. " and " end
            local m1, error = v:split(";")
            if (#m1 > 1) then
                _.each(m1, function(i, v1)
                    if (i > 1) then result = result .. " or " end
                    result = result .. whereexpression(v1)
                end)
            else
                result = result .. whereexpression(v)
            end
        end)
        if (#result > 0) then return "where " .. result end
    end
    return ""
end

local function orderby(orders)
    if not _.isEmpty(orders) then
        local result, n, err = ngx.re.gsub(orders, "\\-", " desc", "joi")
        if result then
            result, n, err = ngx.re.gsub(result, "\\+", "", "joi")
            if result then
                return "order by " .. result
            end
        end
    end
    return "" 
end

function _M.getselect( ... )
    local args = select(1, ...)
    if not args.tablename then return "" end
    if not args.fields then args.fields = "*" end
    if args.page then args.limit = limit(args).limit end
    if args.where then args.where = where(args.where) end
    if args.orderby then args.orderby = orderby(args.orderby) end
    return _M.SELECT:fmtstring(args)
end

function _M.test()
    ngx.say(cjson.encode(limit()))
    ngx.say(cjson.encode(limit({page=1})))
    ngx.say(cjson.encode(limit({page=2,pagesize=10})))
    ngx.say(where("uuid,user_name-lt-or;user_code"))
    ngx.say(where("(uuid,user_name-lt-or);user_code"))
    ngx.say(where("uuid,(user_name-lt-or;user_code)"))
    ngx.say(orderby("uuid+, user_name-, user_code+"))
    ngx.say(_M.getselect({
        where     = "uuid,(user_name-lt;user_code)",
        page      = 2,
        tablename = "b_user",
        orderby   = "uuid+, user_name-, user_code+"
    }))
end

return _M