--[[
    字符串工具类
]]

local _M = { VERSION = "0.0.1" }

function string:split(sep)
    local result = {}
    local iter, err = ngx.re.gmatch(self, ("([^%s]+)"):format(sep), "jo")
    if not iter then
        return table.insert(result, self)
    else
        while true do
            local it, err = iter()
            if it then
                table.insert(result, it[0])
            else
                break
            end
        end
    end
    return result, err
end

function string:trim()
    return ngx.re.gsub(self, "^\\s*|\\s*$", "", "jo")
end

function string:equalsex(str)
    if self and str then
        return string.upper(self:trim()) == string.upper(str:trim())
    else
        return false
    end
end

function string:startsWith(str)
    if self ~= nil and str ~= nil then
        -- local from, to, err = ngx.re.find(self, str, "jo")
        -- return form == 1
        return (self:sub(1, #str) == str)
    else
        return false
    end
end

function string:endsWith(str)
    if str ~= nil and self ~= nil then
        -- local from, to, err = ngx.re.find(self:reverse(), str:reverse(), "jo")
        -- return from == 1
        return self:reverse():startsWith(str:reverse())
    else
        return false
    end
end

function string:indexOf(str)
    return ngx.re.find(self, str, "jo")
end

function string:lastIndexOf(str)
    return string.find(self, '.*()' .. str)
end

function string:fmtstring(data)
    local result, n = ngx.re.gsub(self, "[$]{[\\w_]+}",
        function(words)
            var  = words[0]:sub(3, #words[0] - 1)
            ngx.log(ngx.ALERT, var .. " - " .. data[var])
            return data[var]
        end,
        "jo"
    )
    return result
end

function string:encode_url()
    local str = self
    if (str) then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            --str = string.gsub (str, "([^%w %-%_%.%!%~%*%'%(%,%)])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

function string:decode_url()
    local str = self
    str = string.gsub(str, "+", " ")
    str = string.gsub(str, "%%(%x%x)",
        function(h) return string.char(tonumber(h, 16)) end)
    str = string.gsub(str, "\r\n", "\n")
    return str
end

-- encode base64  
function string:encode_base64()
    return ngx.encode_base64(self)
end

-- decode base64  
function string:decode_base64()
    return ngx.decode_base64(self)
end

-- md5 
function string:md5()
    return ngx.md5(self)
end

-- sha1
function string:sha1()
    local resty_str = require("resty.string")
    return resty_str.to_hex(ngx.sha1_bin(self))
end

-- hmac_sha1
function string:hmac_sha1(secret_key)
    local resty_str = require("resty.string")
    return resty_str.to_hex(ngx.hmac_sha1(secret_key, self))
end

return _M