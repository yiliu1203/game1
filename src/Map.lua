local myMap=class("Map",function ()
	return cc.Node:create()
end)

function checkInrange(num, start ,endnum)--    
	if num>=start and num <=endnum then
		return true
	end
	return false
end

function myMap:ctor()
	myMap.m_map=nil
end

function myMap.create()
    local map = myMap.new()
    map:addChild(map:initMap("12.png"))
    return map
end

function myMap:initMap(filename)
    --self.m_map=cc.Sprite:create(filename)
    --self.m_map:setAnchorPoint(cc.p(0,0))
    --self.m_map:setPosition(cc.p(0,0))
    --cc.TMXTiledMap.getLayer(self,layerName)
    self.tilemap=cc.TMXTiledMap:create("mymap.tmx")
    g.collisionlayer=self.tilemap:getLayer("collisionlayer")
    --self:addChild(self.tilemap)
    self.m_map=self.tilemap
    
    local siz=cc.Director:getInstance():getVisibleSize()
    local siz2=self.m_map:getContentSize()
    return self.m_map
end
function myMap:moveMap(node_hero,node_monster )
    local siz=cc.Director:getInstance():getVisibleSize()
    local mapmove=node_hero.heroDierction
    local runmove=1.2
    local tempmove=1
    if not mapmove then
    	tempmove=-1
    	runmove=-1.3
    end
    -- 到达右边界
    --if (node_hero:getPositionX()<siz.width/2+10) and (node_hero:getPositionX()>siz.width/2-10) then
    --print (node_hero:getPositionX(),siz.width/2-10,siz.width/2+10)
    --end
    local x=node_hero:getPositionX()
    if not mapmove and (self:getPositionX()==self:getContentSize().width- siz.width) then
        if node_hero:getPositionX()==(siz.width-10) then
            node_hero:setPositionX(node_hero:getPositionX()-1)
        end
        return nil
    elseif mapmove and self:getPositionX()==0 then
        if node_hero:getPositionX()==10 then
        	node_hero:setPositionX(node_hero:getPositionX()+1)
        end
        return nil 
    elseif mapmove and x>siz.width/2-100 then
        return nil
    elseif not mapmove and x<siz.width/2+100 then
        return nil
    elseif (node_hero:getPositionX()<(siz.width/2+200)) and (node_hero:getPositionX()>(siz.width/2-200)) then
        node_hero:setPositionX(node_hero:getPositionX() + tempmove )
        if node_monster.running then
            node_monster:setPositionX(node_monster:getPositionX()+runmove )
        else node_monster:setPositionX(node_monster:getPositionX()+tempmove)
        end
        self:setPositionX(self:getPositionX()+tempmove)
    end
end
return myMap