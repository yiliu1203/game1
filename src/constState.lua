
function createEnumTable(tb1, index)
    local startindex =index or 0
    local rtable={}
    for i, v in ipairs(tb1)  do
        rtable[v]=i+startindex
    end
	return rtable
end

hero_state_types={
"run_left",
"run_up",
"run_right",
"run_down",
"run_stay",--静止不动时候的状态
"run_stop"-- 从移动变换停止移动的状态,达到这个状态之后下一帧进入静止不动的状态
}

hero_run_state=createEnumTable(hero_state_types)
g={}
g.collisionlayer={}

