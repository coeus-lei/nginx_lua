local delay = 10
local new_timer = ngx.timer.at
function put_log_into_mysql(premature)      
        local mysql = require "resty.mysql"
        local db, err = mysql:new()
        if not db then
            ngx.log(ngx.ERR,"failed to instantiate mysql: ", err)
            return
        end

        db:set_timeout(1000)
        local ok, err, errcode, sqlstate = db:connect{
            host = "127.0.0.1",
            port = 3306,
            database = "nginx_log",
            user = "root",
            password = "devops",
            charset = "utf8",
        }

        if not ok then
            ngx.log(ngx.ERR,"failed to connect: ", err, ": ", errcode, " ", sqlstate)
            return
        end

        local key = "logs"
        local vals = ""
        local temp_val = ngx.shared.logs:lpop(key)
        while (temp_val ~= nil)
        do
            vals = vals .. ",".. temp_val
            temp_val = ngx.shared.logs:lpop(key)
        end

        if vals ~= "" then
            vals = string.sub(vals, 2,-1)
            local command = ("insert into es_visit_record(access_ip,http_host,access_time,run_status,req_url,http_agent) values "..vals)
            ngx.log(ngx.ERR,"command is ",command)
            local res, err, errcode, sqlstate = db:query(command)
            if not res then
                ngx.log(ngx.ERR,"insert error: ", err, ": ", errcode, ": ", sqlstate, ".")
                return
            end
        end

        local ok, err = db:close()
        if not ok then
            ngx.log(ngx.ERR,"failed to close: ", err)
            return
        end
        local ok, err = new_timer(delay, put_log_into_mysql);
        if not ok then
            ngx.log(ngx.ERR, "failed to create timer: ", err)
            return
        end
end

local ok, err = new_timer(delay, put_log_into_mysql)
if not ok then
    ngx.log(ngx.ERR, "failed to create timer: ", err)
    return
end
