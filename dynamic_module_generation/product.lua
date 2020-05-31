--define productCacheKey and determine if it exists ,if the productCache is not exists or nil,then get data from backend interface
--get request_uri 
local uri_args = ngx.req.get_uri_arg()
--and get productId from request_uri
local productId = uri_args["productId"]
--get the cache from nginx which defined in nginx.conf
local cache_ngx = ngx.shared.my_cache
--define the key for productId and get nginx cache key
local productCacheKey = "product_info_"..productId
--get cache key with get function
local productCache = cache_ngx:get(productCacheKey)
--determine if cache key(productCacheKey) exists or nil
if productCacheKey == "" or productCache == nil then
    local http = require("resty.http")
    local httpc = http.new()
    local resp, err = httpc:request_uri("http://xx.xx.xx.xx:PORT",{
        method = "GET",
        path = "/product/"..productId,
        keepalive=false
    })
    productCache = resp.body
--set expireTime with random to avoid cache avalanche,its very important!!
    local expireTime = math.random(600,1200)
--set key-value pairs for cache_ngx(producCacheKey,productCache,expireTime) and set in nginx cache
    cache_ngx:set(productCacheKey, productCache, expireTime)
 end
 
 ngx.log(ngx.ERR,"json--------------1", productCache)
 
 local cjson = require("cjson")
 local productCacheJSON = cjson.decode(productCache)
 
--Analytical data
 local context = {
 productId = productCacheJSON.id,
 productName = productJSON.name.
 productPrice = productCacheJSON.price
 productStock = productCacheJSON.stock,
 productHTML = productCacheJSON.pic,
 }
 
--rendering html with lua resty.template 
 local template = require("resty.template")
 template.render("product.html", context)
