require("config")
require("cocos.init")
require("framework.init")
cc.utils                = require("framework.cc.utils.init")
cc.net                  = require("framework.cc.net.init")
scheduler 				= require("framework.scheduler")

function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end
package.path = package.path .. ";src/"
    
cc.FileUtils:getInstance():addSearchPath("res/")
cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath().."download/")    

require("app.MyApp").new():run()