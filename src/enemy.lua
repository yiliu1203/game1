require("help")
local enemy=class("enemy",function ()
	return cc.Node:create()
end)
function enemy:ctor()
	self.sprite_name="1_1.png"
    self.sprite_name_dead="318_1.png"
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

function enemy.create( )
	local enemymodel=enemy.new()
	enemymodel:init()
	enemymodel:retain()          --?? 
	return enemymodel
end

function enemy:init()
    self:setScale(0.5)
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
    self.schedulerID2=cc.Director:getInstance():getScheduler():scheduleScriptFunc(
        function ()
            self:update_4second()
        end
        , 4, false)
end
function enemy:recover()
    self:removeChild(self.monster_sprite,true)
    self.monster_sprite=cc.Sprite:create(self.sprite_name)
    self:addChild(self.monster_sprite)
    self.monster_sprite:setPosition(0,0)
    --self.monster_sprite:setFlippedX(self.monsterDirection)
    self.ishurting=false
    self.running=false
    self.isattacking=false
end
function enemy:runAnimaton()
    print ("start running")
    --if self.running or self.ishurting or self.isattacking or self.isdeaded then
    --    return nil
    --end
    --local animate=cc.Animate:create(self.animation_run)
    local animation=self:generAnimation(self.direction,enemy_state.run)  
    local animate =cc.Animate:create(animation)
    local move =self:generMove(self.direction)
    local seq=cc.Sequence:create(cc.DelayTime:create(0.5),move)
    local callback_run=cc.CallFunc:create(
        function ()
            self:runEnd()
        end)
    --local spawn =cc.Spawn:create(animate,move)
    self.monster_sprite:runAction(animate)
    self:runAction(seq)
    --local seq=cc.Sequence:create(spawn, callback_run)
    --self.monster_sprite:runAction(seq)
    --self.monster_sprite:setFlippedX(self.monsterDirection)
    self.running=true
    print ("run ---end")
end

function enemy:attackAnimation()
    if  self.ishurting or self.isattacking or self.isdeaded or self.m_hero.isattacking then
        return nil
    end
    if self.running then
        self:recover()
        self.running=false
    end
    local animate=self:generAnimation(self.direction,enemy_state.attack)
    local callback_attack=cc.CallFunc:create(
        function ()
            self:attackEnd()
        end)
    local seq=cc.Sequence:create(animate,callback_attack)
    self.monster_sprite:runAction(seq)
    --self.monster_sprite:setFlippedX(self.monsterDirection)
    self.isattacking=true
    --local r1=self:getRect()
    --local r2=self.m_hero:getRect()
    --if cc.rectIntersectsRect(self:getRect(),self.m_hero:getRect()) then
    --    self.m_hero.heroDierction= not self.monsterDirection
    --   self.m_hero:hurtAnimation()
    --end
end
function enemy:attackEnd()
    if not self.isattacking then
        return nil
    end
    self:recover()
    self.isattacking=false
end

function enemy:hurtAnimation(delaytime)
    if self.ishurting or self.isdeaded then
        return nil
    end
    print ("monster is hurting")
    if self.isattacking or self.ishurting then
        self:recover()
    end
    local animate =self:generAnimation(self.direction,enemy_state.hurt)
    local delay =cc.DelayTime:create(delaytime or 0.1)
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
function enemy:hurtEnd()
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
function enemy:runEnd()
    if not self.running  then
        return nil
    end
    self:recover()
    self.running=false
end

function enemy:deadAnimation()
    if self.isdeaded then
        return nil
    end
    local animate=self:generAnimation(self.direction,enemy_state.dead)
    --self.animation_dead:setRestoreOriginalFrame(false)
    local callback_dead=cc.CallFunc:create(function ()
        self:deadedEnd()
    end)
    local seq =cc.Sequence:create(animate,callback_dead)
    self.monster_sprite:runAction(seq)
    self.isdeaded=true
end
function enemy:deadedEnd()
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
function enemy:update_4second()
	local a=math.random(1,8.9)
	self.direction=math.ceil(a)
	self:runAnimaton()
	
end
-- direction 1 2 3 4 5 6 7 8
function enemy:generAnimation(direction , state)
    local cache = cc.SpriteFrameCache:getInstance()
    cache:addSpriteFrames("pp.plist", "pp.png")
    local animationFrames = {}
    local startindex= (direction-1)*53+1
    local endindex =direction*53
    if state==enemy_state.run then
    	endindex =startindex+21
    elseif state ==enemy_state.attack then
        startindex =startindex +22
        endindex =startindex +14
    elseif state ==enemy_state.hurt then
        startindex =startindex +37
        endindex =startindex +6
    elseif state ==enemy_state.dead then
        startindex =startindex +44
        endindex =startindex +7
    end
    print ("start end ",startindex,endindex)
    local j=1
    for i = startindex,endindex  do
        local frame = cache:getSpriteFrame(string.format("%d_1.png", i))
        animationFrames[j] = frame
        j=j+1
    end
    local animation = cc.Animation:createWithSpriteFrames(animationFrames, 0.1)
    return animation 
end
function enemy:generMove(direction)
    if direction==1 then
    	return cc.MoveBy:create(1,cc.p(30,0))
    elseif direction==2 then
        return cc.MoveBy:create(1,cc.p(20,-20))
    elseif direction==3 then
        return cc.MoveBy:create(1,cc.p(0,-30))
    elseif direction==4 then
       return cc.MoveBy:create(1,cc.p(-20,-20))
    elseif direction==5 then
       return cc.MoveBy:create(1,cc.p(-30,0))
    elseif direction==6 then
       return cc.MoveBy:create(1,cc.p(-20,20))
    elseif direction==7 then
       return cc.MoveBy:create(1,cc.p(0,30))
    elseif direction==8 then
       return cc.MoveBy:create(1,cc.p(20,20))
    end
end
return enemy