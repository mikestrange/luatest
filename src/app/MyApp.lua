local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:run()
   local pack = require("app.net.packet").new()
   pack:writeBegin(301)
   pack:writeInt(1002)
   pack:writeString("123")
   pack:writeEnd()
   local socket = require("app.net.socket").new()
   socket:connect("127.0.0.1", 8081, function ()
   		print("连接成功")
   		socket:send(pack)
   end)
end

return MyApp
