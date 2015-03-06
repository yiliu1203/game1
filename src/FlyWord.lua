local flyword =class("FlyWord",function ()
	return cc.Node:create()
end)

function flyword:createwordFormtype(type)--提供几种选择的样式，需要其他的样式在这里加
	if type==1 then
		self.color=cc.c3b(255,0,0)
		self.fontsize=30
		self.fontstring="fonts/Marker Felt.ttf"
		self.moveup=cc.p(50,20)
		self.beginposition=cc.p(40,20)
		self.scaleto=2
		self.pertime=0.5
	end
	if type==2 then
		self.color=cc.c3b(0,0,255)
		self.fontsize=25
        self.fontstring="fonts/Marker Felt.ttf"
        self.moveup =cc.p(50,20)
        self.beginposition=cc.p(40,20)
        self.scaleto =2
	end
end

function flyword.create(type)
	local flynode=flyword.new()
    flynode:createwordFormtype(type)
	flynode:init()
	flynode:setVisible(false)
	return flynode
end

function flyword:ctor(type)
	self:createwordFormtype(type)
end
function flyword:init()
	--local lable1=cc.Label:createWithTTF("123")
	--cc.Label:createWithSystemFont(text,font,fontSize,dimensions,hAlignment,vAlignment)
    local label=cc.Label:createWithSystemFont("22",self.fontstring,self.fontsize,cc.size(200,200),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    --local label=cc.Label:createWithSystemFont("222222222222","fonts/Marker Felt.ttf",20,cc.size(200,200),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    label:setColor(self.color)
    label:setPosition(self.beginposition)
    self:addChild(label,3)
    self.label=label
    
end
function flyword:flying(dtime)
    print ("start flying")
    self:flyend()
    local moveby=cc.MoveBy:create(self.pertime,self.moveup)
	local callback=cc.CallFunc:create(function()
	self:setVisible(true)
	end)
	local delaytime=cc.DelayTime:create(dtime or 0.3)
    local scaleby=cc.ScaleBy:create(self.pertime,self.scaleto)
    local spawn=cc.Spawn:create(moveby,scaleby)
    local callback2=cc.CallFunc:create(function()
    self:flyend()
    end)
    self.label:setString(self:getxuenum())
    local seq=cc.Sequence:create(delaytime,callback,spawn,callback2)
    self:runAction(seq)
end
function flyword:getxuenum()
    math.randomseed(os.time())
    local t=math.random(10,20)
    self.xue_down=t
    return tostring(self.xue_down)
end
function flyword:flyend()
	self:setScale(1)
	self:stopAllActions()
	self:setPosition(self.beginposition)
	self:setVisible(false)
	print ("flyend------")
	
end
return flyword