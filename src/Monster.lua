require("help")
local monster=class("Monster",function ()
	return cc.Node:create()
end)
local mon_animation_file={"monster_run","monster_attack","monster_hurt","monster_dead"}
local mon_animation_file_nam={6,5,2,2}
function monster:ctor()
	self.sprite_name="Monster.png"
	self.sprite_name_dead="monster_dead2.png"
	self.monster_sprite=nil
	self.running=false
	self.isattacking=false
	self.ishurting=false
	self.isdeaded=false
	self.animation_run=nil
	self.animation_attack=nil
	self.animation_hurt=nil
	self.animation_dead=nil
	self.monterDierction=false
	self.dis=nil
end
function monster.create(attackhero)
	local node=monster.new()
	node:setattackHero(attackhero)
	node:init()
	return node
end
function monster:setattackHero(hero)
    self.m_hero=hero
     local x=self.m_hero:getPositionX()-self:getPositionX()
    local y=self.m_hero:getPositionY()-self:getPositionY()
    -- dis是每4 s 才计算一次的，近距离的时候才每帧计算
    self.dis= math.sqrt(x*x+y*y)
end
function monster:init()
	local animation_t=loadAnimation(mon_animation_file,mon_animation_file_nam)
	self.animation_run=animation_t[1]
	self.animation_attack=animation_t[2]
	self.animation_hurt=animation_t[3]
	self.animation_dead=animation_t[4]
	self.animation_run:retain()
	self.animation_dead:retain()
	self.animation_hurt:retain()
	self.animation_attack:retain()
	self.monster_sprite=cc.Sprite:create(self.sprite_name)
	self:addChild(self.monster_sprite)
	self.monster_sprite:setPosition(0,0)
	local bloodpro=require("BloodProgress")
	self.bloodpro=bloodpro.create(false)
	self:addChild(self.bloodpro)
	self.bloodpro:setPosition(20,55)
	local flyword=require("FlyWord")
	self.flyBlood=flyword.create(1)
	self:addChild(self.flyBlood)
    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(
    function ()
    	self:update_0second()
    end
    , 0, false)
    self.schedulerID2=cc.Director:getInstance():getScheduler():scheduleScriptFunc(
        function ()
            self:update_4second()
        end
        , 4, false)
end
function monster:recover()
    self:removeChild(self.monster_sprite,true)
    self.monster_sprite=cc.Sprite:create(self.sprite_name)
    self:addChild(self.monster_sprite)
    self.monster_sprite:setPosition(0,0)
    self.monster_sprite:setFlippedX(self.monsterDirection)
    self.ishurting=false
    self.running=false
    self.isattacking=false
    --self.isdeaded=false
end
function monster:runAnimaton()
    if self.running or self.ishurting or self.isattacking or self.isdeaded then
    	return nil
    end
    local animate=cc.Animate:create(self.animation_run)
    local callback_run=cc.CallFunc:create(
    function ()
    	self:runEnd()
    end)
    local seq=cc.Sequence:create(animate,callback_run)
    self.monster_sprite:runAction(seq)
    self.monster_sprite:setFlippedX(self.monsterDirection)
    self.running=true
end
function monster:attackAnimation()
    
     if  self.ishurting or self.isattacking or self.isdeaded or self.m_hero.isattacking then
        return nil
    end
    if self.running then
    	self:recover()
    	self.running=false
    end
    local animate=cc.Animate:create(self.animation_attack)
    local callback_attack=cc.CallFunc:create(
    function ()
    	self:attackEnd()
    end)
    local seq=cc.Sequence:create(animate,callback_attack)
    self.monster_sprite:runAction(seq)
    self.monster_sprite:setFlippedX(self.monsterDirection)
    self.isattacking=true
    local r1=self:getRect()
    local r2=self.m_hero:getRect()
    if cc.rectIntersectsRect(self:getRect(),self.m_hero:getRect()) then
    	self.m_hero.heroDierction= not self.monsterDirection
    	self.m_hero:hurtAnimation()
    end
end
function monster:attackEnd()
	if not self.isattacking then
		return nil
	end
	self:recover()
    self.isattacking=false
	
end
function monster:hurtAnimation(delaytime)
	if self.ishurting or self.isdeaded then
		return nil
	end
	print ("monster is hurting")
	if self.isattacking or self.ishurting then
		self:recover()
	end
	local animate =cc.Animate:create(self.animation_hurt)
	local delay =cc.DelayTime:create(delaytime or 0.4)
	local callback_hurt=cc.CallFunc:create(
	function ()
		self:hurtEnd()
	end)
	local seq =cc.Sequence:create(delay,animate,callback_hurt)
	self.monster_sprite:runAction(seq)
	self.monster_sprite:setFlippedX(self.monsterDirection)
    self.flyBlood:flying(0.5)
    self.xue_down=self.flyBlood.xue_down
end
function monster:hurtEnd()
	if self.ishurting then
		return nil
	end
	self:recover()
	self.ishurting=false
	self.bloodpro:setCurentBlood(self.bloodpro:getCurentBlood()-self.xue_down)
    print ("cruentblood　",self.bloodpro:getCurentBlood())
	if self.bloodpro:getCurentBlood()<=0 then
		self:deadAnimation()
	end
end
function monster:runEnd()
    if not self.running  then
    	return nil
    end
    self:recover()
    self.running=false
end

function monster:deadAnimation()
	if self.isdeaded then
		return nil
	end
	local animate=cc.Animate:create(self.animation_dead)
	self.animation_dead:setRestoreOriginalFrame(false)
	local callback_dead=cc.CallFunc:create(function ()
	self:deadedEnd()
	end)
	local seq =cc.Sequence:create(animate,callback_dead)
	self.monster_sprite:runAction(seq)
	self.isdeaded=true
end
function monster:deadedEnd()
	if not self.isdeaded  then
		return nil
	end
	local ac1=cc.Blink:create(3,3)
	local ac2=cc.CallFunc:create(
	function ()
		--self:removeChild(self.monster_sprite,true)
		self:setVisible(false)
		--self.isdeaded=true
	end)
	local seq=cc.Sequence:create(ac1,ac2)
	self.monster_sprite:runAction(seq)
end

function monster:followRun()
	local x=self.m_hero:getPositionX()-self:getPositionX()
	local y=self.m_hero:getPositionY()-self:getPositionY()
	self.dis= math.sqrt(x*x+y*y)
	self.monsterDirection=x<0 or false
	if self.dis>300 then
		return nil
	elseif self.isattacking then
	   return nil
	elseif self.dis<=100 then
	   self:judgeAttack()
	   return nil
	end
    -- 
	-- 判断是该移动X还是移动Y
	if x>100 or x<-100 then
		if self.monsterDirection then
			self:setPositionX(self:getPositionX()-1)
		else self:setPositionX(self:getPositionX()+1)
		end
		--print (math.abs(x))
	else
	   if y>0 then
	   	self:setPositionY(self:getPositionY()+1)
	   else self:setPositionY(self:getPositionY()-1)
	   end
	end
	self:runAnimaton()
end

-- 左右移动
function monster:seeRun()
    if self.dis<300 then
    	return nil
    end
    local moveby=nil
    if self.monsterDidrection then
    	moveby =cc.MoveBy:create(2,cc.p(100,0))-----这里应该是反的啊?????
    else moveby =cc.MoveBy:create(2,cc.p(-100,0))
    end
    local animate=cc.Animate:create(self.animation_run)
    --local spawn=cc.Spawn:create(moveby,animate)
    local callfun=cc.CallFunc:create(
    function ()
        self:runEnd()
    end)
    local seq =cc.Sequence:create(moveby,callfun)
    self:runAction(seq)
    self:runAnimaton()
    self.monster_sprite:setFlippedX(self.monsterDirection)
end

function monster:judgeAttack()
    math.randomseed(os.time())
    local t=math.random(1,150)
    if t>100 then
    	self:attackAnimation()
    end    
end


function monster:update_0second()
	if self.dis<300 and not self.isdeaded then
		self:followRun()
	end
end

function monster:update_4second()
    local x=self.m_hero:getPositionX()-self:getPositionX()
    local y=self.m_hero:getPositionY()-self:getPositionY()
    -- dis是每4 s 才计算一次的，近距离的时候才每帧计算
    print ("hero-monster xy",x,y)
    self.dis= math.sqrt(x*x+y*y)
    self.monsterDirection=x<0
    if not self.running then
    	self:seeRun()
    end
end
function monster:getRect()
    return cc.rect(self:getPositionX(),self:getPositionY(),
    self.monster_sprite:getContentSize().width-10 ,self.monster_sprite:getContentSize().height-10)
end
return monster
