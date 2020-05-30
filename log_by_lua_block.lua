local currentTime = os.date("%Y-%m-%d %H:%M:%S", os.time())
currentTime = "\"" .. currentTime .. "\""
local http_host = "\"" .. ngx.var.http_host .. "\""
local req_status = "\"" .. ngx.var.status .. "\""
local remote_addr = "\"" .. ngx.var.remote_addr .. "\""
local req_uri = "\"" .. ngx.var.request_uri .. "\""
local http_agent = "\"" .. ngx.var.http_user_agent .. "\""
--if req_status ~= 200 then
if (ngx.status ~= 200) then
    --local myparams = ("("..ngx.var.remote_addr..","..ngx.var.http_host..","..currentTime..","..ngx.var.status..","..ngx.var.request_uri..","..ngx.var.http_user_agent..")")
    local myparams = ("("..remote_addr..","..http_host..","..currentTime..","..req_status..","..req_uri..","..http_agent..")")
    local key = "logs"
    local len,err = ngx.shared.logs:rpush(key, myparams)
    if err then
       ngx.log(ngx.ERR,"failed to put log vals into shared dict")
       return
    end
end
