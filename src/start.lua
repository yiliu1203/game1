local startLayer=class("startlayer",function ()
    return cc.Layer:create()
end)

function startLayer.create(texture)
    local scene=cc.Scene:create()
    local pause=startLayer.new()
    pause:init()
    scene:addChild(pause)
    return scene
end

function startLayer:init()
    local vsize=cc.Director:getInstance():getVisibleSize()
    local menuback=cc.Sprite:create("startback.png")
    menuback:setPosition(vsize.width/2,vsize.height/2)
    self:addChild(menuback)
    local start_button=cc.MenuItemImage:create("start.png","start.png","start.png")
    start_button:registerScriptTapHandler(function()
        cc.Director:getInstance():runWithScene(require("HelloGame").create())
    end)
    start_button:setPosition(vsize.width/2 ,vsize.height/2+30)
    local exit_button=cc.MenuItemImage:create("exit.png","exit.png","exit.png")
    exit_button:registerScriptTapHandler(function()
       
    end)
    exit_button:setPosition(vsize.width/2,vsize.height/2-20)
    local menu=cc.Menu:create(start_button,exit_button)
    self:addChild(menu)
    menu:setPosition(0,0)
end
return startLayer