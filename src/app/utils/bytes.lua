local ByteArray = class("ByteArray")

ByteArray.DEF_ENDIAN = cc.utils.ByteArray.ENDIAN_BIG


function ByteArray:init(bits, endian)
	self.endian = endian
	if not endian then
		self.endian = ByteArray.DEF_ENDIAN
	end
	self.bytes = bits
    if not bits then
        self.bytes = cc.utils.ByteArray.new(self.endian)
    else
        self.bytes:setEndian(self.endian)
    end
    --self.size = self.bytes:getLen()
    --self.pos = getPos()
end

function ByteArray:clear()
    self.bytes = cc.utils.ByteArray.new(self.endian)
end

function ByteArray:Available()
    return self.bytes:getAvailable()
end

function ByteArray:setPos(val)
	--self.pos = val
	self.bytes:setPos(val)
end

function ByteArray:getPos()
	return self.bytes:getPos()
end

function ByteArray:flush_pos(len)
    --self.pos = self.pos + len
end

function ByteArray:flush_size(sub)
    -- local len = self.size + sub
    -- if len > self.size then
    --     self.size = len
    -- end
end

--writes
function ByteArray:writeUInt(val)
    self:flush_size(4)
    self.bytes:writeUInt(val)
end

function ByteArray:writeInt(val)
    self:flush_size(4)
    self.bytes:writeInt(val)
end

function ByteArray:writeInt64(val)
    self:flush_size(8)
    self.bytes:writeInt64(val)
end

function ByteArray:writeShort(val)
    self:flush_size(2)
    self.bytes:writeShort(val)
end

function ByteArray:writeByte(val)
    self:flush_size(1)
    self.bytes:writeByte(val)
end

--特需
function ByteArray:writeBytes(byte)
    self:flush_size(byte:getLen())
    self.bytes:writeBytes(byte)
end

function ByteArray:writeString(val)
    local str = cc.utils.ByteArray.new(self.endian)
    str:writeStringBytes(val)
    local len = str:getLen() + 1
    self:writeUInt(len)
    self:flush_size(len)
    self.bytes:writeBytes(str)
    self.bytes:writeByte(string.byte("\0"))
    str = nil
end

--reads
function ByteArray:readInt()
    self:flush_pos(4)
    return self.bytes:readInt()
end

function ByteArray:readInt64()
    self:flush_pos(8)
    return self.bytes:readInt64()
end

function ByteArray:readUInt()
    self:flush_pos(4)
    return self.bytes:readUInt()
end

function ByteArray:readShort()
    self:flush_pos(2)
    return self.bytes:readShort()
end

function ByteArray:readByte()
    self:flush_pos(1)
    return self.bytes:readByte()
end

function ByteArray:readBytes(byte)
    self:flush_pos(byte:getLen())
    self.bytes:readBytes(byte)
end

function ByteArray:readString()
    local len = self:readUInt()
    self:flush_pos(len)
    local str = self.bytes:readString(len)
    str = string.sub(str, 1, string.len(str)-1)
    return str
end 

--gets
function ByteArray:get_buffer()
    return self.bytes:getPack()
end

function ByteArray:length()
    return self.bytes:getLen()
end

return ByteArray