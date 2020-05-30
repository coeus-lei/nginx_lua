local currentTime = os.date("%Y-%m-%d %H:%M:%S", os.time())
currentTime = "\"" .. currentTime .. "\""
--[[local req_status = 0
if ngx.var.status then
    req_status = ngx.var.status
end
--]]
local http_host = "\"" .. ngx.var.http_host .. "\""
local remote_addr = "\"" .. ngx.var.remote_addr .. "\""
local req_uri = "\"" .. ngx.var.request_uri .. "\""
local http_agent = "\"" .. ngx.var.http_user_agent .. "\""
--if ngx.var.status ~= 200 then
    local myparams = ("("..remote_addr..","..http_host..","..currentTime..","..ngx.var.status..","..req_uri..","..http_agent..")")
--if ngx.var.status ~= 200 then
    local key = "logs"
    local len,err = ngx.shared.logs:rpush(key, myparams)
    if err then
        ngx.log(ngx.ERR,"failed to put log vals into shared dict")
        return
    end
--end    
