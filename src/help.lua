
-- 对应的动画文件名和文件的数目
animation_filename={"hero_run_","hero_attack_","hero_hurt_","hero_shoot_"}
animation_file_num={8,6,2,6}
function loadAnimation(tb_filename,tb_fileNum)
    local num=#tb_filename
    retable={}
    for i=1,num  do
        filename=tb_filename[i]
        filenum=tb_fileNum[i]
        local animation=cc.Animation:create()
        for j=1,filenum  do
            local filen=string.format("%s%d.png",filename,j)
            animation:addSpriteFrameWithFile(filen)
        end
        animation:setLoops(1)
        animation:setDelayPerUnit(0.2)
        animation:setRestoreOriginalFrame(true)
        table.insert(retable,animation)
    end
    return retable
end

function getTileCoorFromPostion(x,y)
	local xx=x/g.tileMap:getTileSize().width
	local yy=(g.tileMap:getMapSize().height *g.tileMap:getTileSize().height-y)/g.tileMap:getTileSize().height
    --print ("tiledCoorFromPos x,y ",x,y,math.ceil(xx),math.ceil(yy))
	return math.ceil(xx),math.ceil(yy)
end

function checkCollision(x,y)
	local x1,y1=getTileCoorFromPostion(x,y)
	local gid= g.collisionlayer:getTileGIDAt(cc.p(x1,y1))
	local gid2=g.collisionlayer:getTileGIDAt(cc.p(x1-1,y1))
    local gid3=g.collisionlayer:getTileGIDAt(cc.p(x1-3,y1))
	--print("gid  ",gid)
	if  gid>0 or gid2>0 or gid3>0 then
		return true
	end
	return false
end
function Max(num1,num2)
	return (num1>num2 and num1) or num2
end
function  Min(num1,num2)
    return (num1<num2 and num1) or num2
end
