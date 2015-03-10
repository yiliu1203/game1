local denemy=class("enemyt",function ()
    return require("enemy").new()
end
)
function denemy:ctor(parameters)
    print (self.name)
	self.name="222222222"
	print (self.name)
end 

function denemy.create()
	local de=denemy.new()
	de:init()
	return de
end 

function denemy:init()
    self.init="222222"
    self:fun2()
end

function denemy:fun2()
    print("this is n dclass func2")
end
return denemy


