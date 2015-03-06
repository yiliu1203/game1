require("constState")
flyword=require("FlyWord")
local HelloGame=class("hellogame",function ()
	return cc.Layer:create()
end)
local hero_state =hero_run_state.run_stay

function HelloGame:ctor()
	HelloGame.map =nil
	HelloGame.schedulID=nil
	HelloGame.m_hero=nil
end

function HelloGame.create()
    
    local scene=cc.Scene:create()
    local layer =HelloGame.new()
    layer:init()
    scene:addChild(layer)   
	return scene
end

function HelloGame:init()
    local label=cc.Label:createWithSystemFont("222222222222","fonts/Marker Felt.ttf",20,cc.size(200,200),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    self:addChild(label,3)
    label:setPosition(200,100)
   -- local scene=cc.Scene:create()
    local Map =require("Map")
    local map=Map.create()
    self:addChild(map)
    local Hero=require("Hero")
    local hero=Hero.create()
    self:addChild(hero,2)
    hero:setPosition(100,100)
    self.m_hero=hero
    self:addChild(hero.jiantou_sprite)
    local Monster=require("Monster")
    local monster=Monster.create(hero)
    self:addChild(monster)
    self.monster=monster
    --self.monster:setScale(0.5)
    monster:setPosition(400,200)
    local bloodProgress=require("BloodProgress")
    local bloodprogress=bloodProgress.create(true)
    self:addChild(bloodprogress)
    bloodprogress:setPosition(150,450)
    bloodprogress:setScale(2.2)
    --bloodprogress:setCurentBlood(30)
    -- 这里始终不能调用bloodpro的成员函数.......P ->p
    self.m_hero.bloodpro=bloodprogress
    local listener=cc.EventListenerKeyboard:create()
    -- 为了使键盘的响应事件是成员函数，所以才这样使用一个匿名函数
    listener:registerScriptHandler(
    function(keycode,event)
        self:onKeyPressed(keycode,event)
    end,cc.Handler.EVENT_KEYBOARD_PRESSED)
    listener:registerScriptHandler(
    function (keycode,event)
    	self:onKeyReleased(keycode,event)
    end
    ,cc.Handler.EVENT_KEYBOARD_RELEASED) 
    -- 没有keyboard_released ?  其实有，只是没有代码提示出来而已
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener,self)
    -- update 每一帧都执行
    local function updateHandle()
        if hero.isattacking or hero.isshooting or hero.ishurting   then
            if hero.isshooting and  hero.jiantou_flying then
        		local r1=monster:getRect()
        		r1.height=r1.height-60
        		r1.y=r1.y-20
        		local x,y=hero.jiantou_sprite:getPosition()
        		if cc.rectContainsPoint(r1,cc.p(x,y)) then
                  hero:jiantouEnd()                
        		  monster:hurtAnimation(0.01)
        		end
        	end
        end
        if hero_state==hero_run_state.run_stay then
            hero:stopAnimation()
            hero_state=hero_run_state.hero_stay
            return nil
        elseif hero_state==hero_run_state.run_left then
            self.m_hero:setRunAnimation(true)
            if checkCollision(self.m_hero:getPositionX()-1,self.m_hero:getPositionY()) then
                return nil
            end
            if self.m_hero.running then
                self.m_hero:setPositionX(self.m_hero:getPositionX()-1)
            end
            map:moveMap(self.m_hero,monster)
        elseif hero_state==hero_run_state.run_right then
            self.m_hero:setRunAnimation(false)
            if checkCollision(self.m_hero:getPositionX()+1,self.m_hero:getPositionY()) then
            	return nil
            end
            if self.m_hero.running then
                self.m_hero:setPositionX(self.m_hero:getPositionX()+1)
            end            
            map:moveMap(self.m_hero,monster)
        elseif hero_state ==hero_run_state.run_up then
            if checkCollision(self.m_hero:getPositionX(),self.m_hero:getPositionY()+1) then
            	return nil
            end
            self.m_hero:setPositionY(self.m_hero:getPositionY()+1)
            self.m_hero:setRunAnimation(self.m_hero.heroDierction)
        elseif hero_state ==hero_run_state.run_down then
            if checkCollision(self.m_hero:getPositionX(),self.m_hero:getPositionY()-1) then
            	return nil
            end
            self.m_hero:setPositionY(self.m_hero:getPositionY()-1)
            self.m_hero:setRunAnimation(self.m_hero.heroDierction)
        end
    end
    self.schedulID=cc.Director:getInstance():getScheduler():scheduleScriptFunc(updateHandle,0,false)
    
end

function HelloGame:onKeyPressed(keycode, event)
	--print (keycode)--26 28 27 29 -->23 25 24 26
    if keycode==cc.KeyCode.KEY_LEFT_ARROW+3 then
    	hero_state=hero_run_state.run_left
    elseif keycode==cc.KeyCode.KEY_UP_ARROW+3 then
        hero_state=hero_run_state.run_up
    elseif  keycode ==cc.KeyCode.KEY_RIGHT_ARROW+3 then
        hero_state=hero_run_state.run_right
    elseif keycode ==cc.KeyCode.KEY_DOWN_ARROW+3 then
        hero_state=hero_run_state.run_down
    elseif keycode ==124 then   --a
        --self.m_hero:stopAnimation()
        --self.m_hero:attackAnimation()
        heroattack_monsterHurt(self.m_hero,self.monster,1)
    elseif keycode ==127 then ---d
        heroattack_monsterHurt(self.m_hero,self.monster,2)
        --self.m_hero:stopAnimation()
        --self.m_hero:hurtAnimation()
    end
    print (keycode)
end
function HelloGame:onKeyReleased(keycode, event)
	--print (keycode)
	if keycode==cc.KeyCode.KEY_LEFT_ARROW+3 then
        hero_state=hero_run_state.run_stay
    elseif keycode==cc.KeyCode.KEY_UP_ARROW+3 then
        hero_state=hero_run_state.run_stay
    elseif  keycode ==cc.KeyCode.KEY_RIGHT_ARROW+3 then
        hero_state=hero_run_state.run_stay
    elseif keycode ==cc.KeyCode.KEY_DOWN_ARROW+3 then
        hero_state=hero_run_state.run_stay
    end
    
end
function heroattack_monsterHurt(node_hero,node_monster,attack_style)
	if node_hero.isattacking or node_hero.isshooting or node_monster.isdeaded or node_monster.isattacking then
		return nil
	end
	if attack_style ==1 then
		node_hero:attackAnimation()
		if math.abs(node_hero:getPositionY()-node_monster:getPositionY())<30 then
			if cc.rectIntersectsRect(node_hero:getRect(),node_monster:getRect()) then
				node_monster:hurtAnimation()
			end
		end
	else node_hero:shootAnimation()
	end
	
end
return HelloGame

-- 使用HelloGame。 name  和self。name  不是一个同一个