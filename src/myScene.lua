local myScene2 =class("myScene3",function()
    return cc.Scene:create()
end)
-- : 和 。 在调用和定义的时候的区别,schedualID ???
function myScene2:ctor()
    self.vsize=cc.Director:getInstance():getVisibleSize()
    self.vp=cc.p(self.vsize.width,self.vsize.height)
	self.schedulerID=nil
end

function myScene2.create()
	local scene =myScene2.new()
    scene:addChild(scene:mylayer())
    return scene
end

function myScene2.onKeyPress(keycode ,event)
    print (keycode)
end

--调试的时候self中自定义的变量不能及时显示正确的值，智能提示，没有重载/ 等常用运算
function myScene2:mylayer()
   local layer =cc.Layer:create()
   local function imageitemhadle()
   	
   end
   --local function onKeyPressed(key,event)
   --    print(key)
   --end
   local menuimageitem =cc.MenuItemImage:create("CloseNormal.png","CloseSelected.png","CloseSelected.png")
   menuimageitem:setPosition(menuimageitem:getContentSize().width/2,menuimageitem:getContentSize().height/2)
   menuimageitem:registerScriptTapHandler(imageitemhadle)
   local menu=cc.Menu:create(menuimageitem)
   menu:setPosition(0,0)
   --local cache =cc.TextureCache   texturecache 这种方式不行。。
   --local sp2 =cc.Sprite:createWithTexture(cc.TextureCache:addImage('HelloWorld.png'))
   --layer:addChild(sp2)
   local sp2 =cc.Sprite:create("HelloWorld.png")
   sp2:setPosition(self.vsize.width/2,self.vsize.height/2)
   layer:addChild(sp2)
   layer:addChild(menu)
   
   local sp3 =cc.Sprite:create("icon.png")
   layer:addChild(sp3)
   sp3:setPosition(50,50)
   local points={}
   points[1]=cc.p(30,30)
   points[2]=cc.p(30,300)
   points[3]=cc.p(300,300)
   points[4]=cc.p(300,30)
   local ac1=cc.CardinalSplineBy:create(3,points,3)
   sp3:runAction(ac1)
   --local moveto=cc.MoveTo:create(4,cc.p(300,300))
   --sp3:runAction(moveto)
   local sp4 =cc.Sprite:create("BtnUC.png")
   sp4:setPosition(self.vsize.width/2,self.vsize.height/2)
   layer:addChild(sp4)
   local moveto=cc.MoveTo:create(3,self.vp) 
   local moveby=cc.MoveBy:create(3,cc.p(-self.vsize.width/2,-self.vsize.height/2))
   local animation=cc.Animation:create()
   for i=1,6 do
        local filename=string.format("%s%d.png","grossini_dance_0",i)
        animation:addSpriteFrameWithFile(filename)
   end
   animation:setLoops(1)
   animation:setDelayPerUnit(0.2)
   animation:setRestoreOriginalFrame(true)
   local animate =cc.Animate:create(animation)
   local seq =cc.Sequence:create(moveto,moveby,animate)
   sp4:runAction(seq)
   
   local sp5=cc.Sprite:create("icon.png")
   sp5:setPosition(cc.p(self.vsize.height*0.8,self.vsize.width*0.8))
   --layer:addChild(sp5)
   local progresstimer=cc.ProgressTimer:create(sp5)
   progresstimer:setPosition(cc.p(self.vsize.width*0.8,self.vsize.height*0.8))
   layer:addChild(progresstimer)
   progresstimer:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
   local progressto =cc.ProgressTo:create(2,100)
   progresstimer:runAction(progressto)
   local listen=cc.EventListenerKeyboard:create()
   listen:registerScriptHandler(myScene2.onKeyPress,cc.Handler.EVENT_KEYBOARD_PRESSED)
   local eventdis=self:getEventDispatcher()
   eventdis:addEventListenerWithSceneGraphPriority(listen,layer)
   --cc.EventDispatcher:addEventListenerWithSceneGraphPriority(listener,node)
   return layer
end
return myScene2

