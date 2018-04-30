local SocketPacket = class("SocketPacket", require("app.utils.bytes"))

SocketPacket.HEAD_SZIE = 4

function SocketPacket:ctor()
    self.super.ctor(self)
	self.m_packet_len = 0
    self.m_cmd = 0
    self:init()
end

function SocketPacket:loadBytes(bits)
    local pos = self:getPos()
    self:writeBytes(bits)
    self:setPos(pos)
end

function SocketPacket:writeBegin(cmd, topic, ver, format)
    --header
    --self.m_cmd = cmd
    cmd = cmd or 0
    topic = topic or 0
    ver = ver or 0
    format = format or 0
    --write
    self:writeInt(0)  --packet size
    self:writeInt(cmd)
    self:writeByte(topic)
    self:writeByte(ver)
    self:writeByte(format)
end


function SocketPacket:writeEnd()
    self:setPos(1)
    self:writeInt(self:length() - SocketPacket.HEAD_SZIE)
    self:setPos(self:length()+1)
end


function SocketPacket:readBegin()
    self:setPos(1)
    self.m_packet_len = self:readInt()
    self.m_cmd = self:readInt()
    local topic = self:readByte()
    local ver = self:readByte()
    local format = self:readByte()
end

function SocketPacket:readEnd()

end

function SocketPacket:cmd()
    return self.m_cmd
end

function SocketPacket:flush()
    if self:Available() == 0 then
        self:init()
    end
end

return SocketPacket
