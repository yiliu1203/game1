
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
