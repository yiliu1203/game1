require("help")
local hero =class("Hero",function ()
	return cc.Node:create()
end)
function hero:ctor()
	self.sprite_name="hero.png"
	self.hero_sprite=nil
	self.running=false
	self.animation_run=nil
	self.animation_attack=nil
	self.isattacking=false
	self.animation_shoot=nil
	self.jiantou_sprite=nil
	self.animation_hurt=nil
	self.ishurting=false
	self.heroDierction=false
	self.isshooting=false
	self.jiantou_flying=false
end
function hero.create()
    local hero_node =hero.new()
    hero_node:init()
    return hero_node
end
function hero:init()
	self.hero_sprite=cc.Sprite:create(self.sprite_name)
	self:addChild(self.hero_sprite)
	self.hero_sprite:setFlippedX(self.heroDierction)
	self.jiantou_sprite=cc.Sprite:create("hero_jiantou.png")
	--self.jiantou_sprite:retain()
	--self:getParent():addChild(self.jiantou_sprite)
	self.jiantou_sprite:setPosition(self:getPositionX()+10,self:getPositionY())
	self.jiantou_sprite:setVisible(false)
    local temp =loadAnimation(animation_filename,animation_file_num)
    self.animation_run=temp[1]
    self.animation_attack=temp[2]
    self.animation_hurt=temp[3]
    self.animation_shoot=temp[4]
    self.animation_shoot:setDelayPerUnit(0.1)
    self.animation_run:retain()
    self.animation_attack:retain()
    self.animation_hurt:retain()
    self.animation_shoot:retain()
    self.animation_run:setLoops(-1)
end
function hero:setRunAnimation(fliped)
	self.heroDierction=fliped
	if self.running  then
		return nil
	end
	local animate=cc.Animate:create(self.animation_run)
	self.hero_sprite:runAction(animate)
	self.hero_sprite:setFlippedX(fliped)
	self.running=true
end
function hero:recover()
	self:removeChild(self.hero_sprite,true)
	self.hero_sprite =cc.Sprite:create(self.sprite_name)
	self:addChild(self.hero_sprite)
	self.hero_sprite:setFlippedX(self.heroDierction)
	self.ishurting=false
    self.running=false
    self.isattacking=false
    self.shooting_animate=false
    if not self.jiantou_flying then
    	self.isshooting=false
    end
end
function hero:stopAnimation()
    if not self.running then
    	return nil
    end
    self:recover()
    self.running=false
    return nil
end
function hero:attackAnimation()
	if self.isattacking or self.ishurting or self.isshooting then
		return nil
	end
	if self.running  then
		self:recover()
		self.running=false
	end
	local animate=cc.Animate:create(self.animation_attack)
	-- 回调动作，可以使用一个局部的函数，但是希望使用hero的成员函数，所以才用这样的办法
	local callback=cc.CallFunc:create(function()
	self:attackEnd()
	end)
	local seq=cc.Sequence:create(animate,callback)
	self.hero_sprite:runAction(seq)
	self.isattacking=true
end
function hero:attackEnd()
	if not self.isattacking then
		return nil
	end
	self:recover()
	self.isattacking=false
end
function hero:hurtAnimation()
    --print ("hurtbefore")
	if self.ishurting or self.isattacking then
		return nil
	end
	if self.running then
		self:recover()
		self.running=false
	end
	local callback=cc.CallFunc:create(
	function ()
	   self:hurtEnd()
	end)
	local animate=cc.Animate:create(self.animation_hurt)
	local delay=cc.DelayTime:create(0.3)
    local seq=cc.Sequence:create(delay,animate,callback)
	self.hero_sprite:runAction(seq)
	self.ishurting =true
end
function hero:hurtEnd()
	if not self.ishurting then
		return nil
	end
	self:recover()
	self.ishurting=false
	self.bloodpro:blooddown(10)
end
function hero:shootAnimation()
    print("startshoot is",self.isshooting)
    if self.isshooting or self.isattacking or self.ishurting then
    	return nil
    end
    if self.running or self.ishurting then
    	self:recover()
    	self.running=false
    	self.ishurting=false
    end
    local animate=cc.Animate:create(self.animation_shoot)
    local callback1=cc.CallFunc:create(function ()
    self:shootEnd()
    end)
    local seq=cc.Sequence:create(animate,callback1)
    self.hero_sprite:runAction(seq)
    local movex=self.heroDierction and -600 or 600
    --movex =movex+self:getPositionX()
    local moveby =cc.MoveBy:create(1,cc.p(movex,0))
    local callback2=cc.CallFunc:create(function()
    self:jiantouEnd()
    end)
    local seq2=cc.Sequence:create(moveby,callback2)
    self.jiantou_sprite:setPosition(self:getPositionX()+10,self:getPositionY())
    self.jiantou_sprite:runAction(seq2)
    self.jiantou_flying=true
    self.shooting_animate=true
    self.isshooting=true
    self.jiantou_sprite:setVisible(true)
end
function hero:shootEnd()
	if not self.isshooting then
		return nil   
	end
	self:recover()
	self.shooting_animate=false
	if not self.jiantou_flying then
		self.isshooting=false
	end
end
function hero:jiantouEnd()
    if not self.jiantou_flying then
    	return nil
    end
    self.jiantou_sprite:setPosition(self:getPositionX()+10,self:getPositionY())
    self.jiantou_sprite:setVisible(false)
    self.jiantou_flying =false
    --if self.isshooting then
    --	self:recover()
    --	self.isshooting=false
    --end
    if not self.shooting_animate then
    	self.isshooting=false
    end
end
function hero:shootEndFull()
	self.jiantou_sprite:stopAllActions()
    self.jiantou_sprite:setPosition(self:getPositionX()+10,self:getPositionY())
	self.jiantou_sprite:setVisible(false)
	self:recover()
	self.jiantou_flying=false
	self.isshooting=false
end
function hero:getRect()
	return cc.rect(self:getPositionX(),self:getPositionY(),
	self.hero_sprite:getContentSize().width-10,self.hero_sprite:getContentSize().height-10)
end
function hero:setbloodpro(node_bloodpro)
	self.bloodpro=node_bloodpro
end
return hero
