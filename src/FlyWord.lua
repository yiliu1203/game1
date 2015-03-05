local flyword =class("FlyWord",function ()
	return cc.node.create()
end)

function flyword:createwordFormtype(type)--提供几种选择的样式，需要其他的样式在这里加
	if type==1 then
		self.color=cc.c3b(255,0,0)
		self.fontsize=30
		self.fontstring="fonts/Marker Felt.ttf"
		self.moveup=cc.p(0,20)
		self.beginposition=cc.p(10,0)
		self.scaleto=2
	end
	if type==2 then
		self.color=cc.c3b(0,0,255)
		self.fontsize=25
        self.fontstring="fonts/Marker Felt.ttf"
        self.moveup =cc.p(0,20)
        self.beginposition=cc.p(10,0)
        self.scaleto =2
	end
end

function flyword.create(type)
	local flynode=flyword.new()
	flynode:init()
	return flynode
end

function flyword:ctor(type)
	self:createwordFormtype(type)
end
function flyword:init()
	--local lable1=cc.Label:createWithTTF("123")
    local label=cc.Label:createWithSystemFont("",self.fontstring,self.fontsize,cc.size(200,200),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    label:setColor(self.color)
    label:setPosition(self.beginposition)
    self:addChild(la,3)
    self.label=la
    label:setVisible(false)
end
function flyword:flying(dtime)
	local moveby=cc.MoveBy:create(1,self.moveup)
	local callback=cc.CallFunc.create(function()
	self.label:setVisible(true)
	end)
	local delaytime=cc.DelayTime:create(dtime or 0.3)
    local scaleto=cc.ScaleTo:create(1,self.scaleto)
    local spawn=cc.Spawn:create(moveby,scaleto)
    local callback2=cc.CallFunc:create(function()
    self:flyend()
    end)
    local seq=cc.Sequence:create(delaytime,callback,spawn,callback2)
    cc.label:runAction(seq)
end
function flyword:getxuenum()
    math.randomseed(os.time())
    local t=math.random(10,20)
    self.xue_down=t
    return tostring(self.xue_down)
end
function flyword:flyend()
	self.label:setScale(1)
	self.label:setPosition(self.beginposition)
	self.label:setVsisible(false)
end