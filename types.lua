Stack = {}
function Stack:new(o)
    o = o or {} 
    setmetatable(o, self)
    o.pop = Stack.pop 
    o.push = Stack.push
    return o 
end 

function Stack:push(x) 
    self[#self + 1] = x 
end 

function Stack:pop() 
    local x = self[#self]
    table.remove(self, #self)
    return x 
end 

State = { 
    token = "", 
    out1 = -1, 
    out2 = -1,
    lastList = -1
}

function State:new(token, out1, out2, lastList)
    o = {} 
    setmetatable(o, self)
    o.token = token
    o.out1 = out1 or -1
    o.out2 = out2 or -1
    o.lastList = lastList or -1
    return o
end 

Fragment = {
    start = nil, -- a state 
    out_list = {}
}
function Fragment:new(start, out_list)
    o = {} 
    setmetatable(o, self)
    o.start = start 
    o.out_list = out_list or {}
    return o
end 

types = {}
types.Stack = Stack 
types.State = State
types.Fragment = Fragment

return types 