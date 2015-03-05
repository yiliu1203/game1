local bloodprog = class("BloodProgress",function ()
	return cc.Node:create()        --这里是：create
end)

function bloodprog:ctor()
    self.blood_backimg=cc.Sprite:create("xue_back.png")
    self.blood_foreimg=cc.Sprite:create("xue_fore.png")
    self.m_scale=1
    self.blood_total=300
    self.blood_curent=300
end
function bloodprog.create(bool_show_kuang)
	local blood=bloodprog.new()
	blood:init(bool_show_kuang)
	return blood
end
function bloodprog:init(bool_show_kuang)
	if bool_show_kuang then
        self.blood_kuang=cc.Sprite:create("xuekuang.png")
        self.blood_touxiang_name=cc.Sprite:create("touxiang.png")
        self.blood_kuang:setScale(1/2.2)
        self.blood_touxiang_name:setScale(1/2.2)
        self:addChild(self.blood_kuang)
        self:addChild(self.blood_touxiang_name)
        self.blood_kuang:setPosition(0,0)
        self.blood_touxiang_name:setPosition(-55,0)
	end
	self:addChild(self.blood_backimg)
	self.blood_backimg:setPosition(0,0)
	self:addChild(self.blood_foreimg)
	self.blood_foreimg:setPosition(0,0)
	self.blood_foreimg:setAnchorPoint(0,0.5)
	self.blood_foreimg:setPosition(-self.blood_foreimg:getContentSize().width*0.5,0)
    local sze=self.blood_foreimg:getContentSize()
    --local temp=self.blood_total
	self.m_scale = self.blood_foreimg:getContentSize().width/self.blood_total
	self.blood_curent=self.blood_total
	
end

function bloodprog:setTotalBlood(total)
	self.blood_total=total
end
function bloodprog:setCurentBlood(curent)
    if curent<0 or curent >self.blood_total then
        return false
    end
    self.blood_curent =curent
    local locarect=self.blood_foreimg:getTextureRect()
    local wid=self.blood_curent *self.m_scale
    local rect=cc.rect(locarect.x,locarect.y,wid,self.blood_foreimg:getTextureRect().height)
    -- 这里和锚点也有关系，锚点设置在中间不行、、纹理和点的对应关系？
    self.blood_foreimg:setTextureRect(rect)

end
function bloodprog:blooddown (blood_num)
	self:setCurentBlood(self.blood_curent-blood_num)
end
function bloodprog:getCurentBlood()
    return self.blood_curent
end
return bloodprog
