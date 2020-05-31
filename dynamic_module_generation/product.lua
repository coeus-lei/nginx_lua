--define productCacheKey and determine if it exists ,if the productCache is not exists or nil,then get data from backend interface
local productCache = cache_ngx:get(productCacheKey)
if productCacheKey == "" or productCache == nil then
    local http = require("resty.http")
    local httpc = http.new()
    local resp, err = httpc:request_uri("http://xx.xx.xx.xx:PORT",{
        method = "GET",
        path = "/product/"..productId,
        keepalive=false
    })
    productCache = resp.body
    local expireTime = math.random(600,1200)
    cache_ngx:set(productCacheKey, productCache, expireTime)
 end
 
 ngx.log(ngx.ERR,"json--------------1", productCache)
 
 local cjson = require("cjson")
 local productCacheJSON = cjson.decode(productCache)
 
 local context = {
 productId = productCacheJSON.id,
 productName = productJSON.name.
 productPrice = productCacheJSON.price
 productStock = productCacheJSON.stock,
 productHTML = productCacheJSON.pic,
 }
 
 local template = require("resty.template")
 template.render("product.html", context)
 
