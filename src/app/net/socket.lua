local Socket = class("Socket")

--协议包
local SocketPacket = require("app.net.packet")

function Socket:ctor()
    self.connected = false
    self.pack_len = 0
    self.buffer = nil
    self.handle = nil
end

function Socket:SetReceiver(handle)
    self.handle = handle
end

function Socket:connect(host, port, call_back)
    if self.connected == true then 
        return 
    end

    local function on_connect( )
        self.connected = true
        if call_back then 
            call_back() 
        end
    end
    self.buffer = SocketPacket.new()
    self.socket = cc.net.SocketTCP.new(host, port, false)
    self.socket:addEventListener(cc.net.SocketTCP.EVENT_CONNECTED, on_connect)
    self.socket:addEventListener(cc.net.SocketTCP.EVENT_CLOSE, handler(self, self._on_close))
    self.socket:addEventListener(cc.net.SocketTCP.EVENT_CLOSED, handler(self, self._on_closed))
    self.socket:addEventListener(cc.net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self, self._connect_failed))
    self.socket:addEventListener(cc.net.SocketTCP.EVENT_DATA, handler(self, self._on_data))
    self.socket:connect()
end

function Socket:_on_close()
    print("socket close")
    self.connected = false
end

function Socket:_on_closed()
    print("socket closed")
    self.connected = false
end

function Socket:_connect_failed()
    print("connect error")
end

function Socket:_on_data(event)
    local bytes = cc.utils.ByteArray.new(cc.utils.ByteArray.ENDIAN_BIG)
    bytes:writeString(event.data)
    bytes:setPos(1)
    --print("load bytes:", cc.utils.ByteArray.toString(event.data), ",size=",bytes:getLen())
    self.buffer:loadBytes(bytes)
    self:on_message()
end

function Socket:on_message()
    if 0 == self.pack_len then
        if self.buffer:Available() >= SocketPacket.HEAD_SZIE then
            self.pack_len = self.buffer:readInt()
            --print("pack size = ", self.pack_len, self.buffer:Available())
            self:on_message()
        end
    else
        if self.buffer:Available() >= self.pack_len then
            self.buffer:readBegin()
            if not self.handle then
                print("not handle cmd:", self.buffer:cmd())
            else
                print("cmd :", self.buffer:cmd())
                self.handle(self.buffer)
            end
            self.buffer:readEnd()
            self.buffer:flush()
            --发包出去
            self:on_message()
        end
    end
end


function Socket:send(pack)
    if self.connected then
        self.socket:send(pack:get_buffer())
    end
end

function Socket:close()
    if not self.connected then 
        return 
    end
    self.socket:close()
end

return Socket
