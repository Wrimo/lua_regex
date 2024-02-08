local shunting_yard = require("shunting_yard")
local types = require("types")
function patch(out_list, state) -- given a list of out nodes, sets them to a a new state
    for i = 1, #out_list do 
        out_list[i].out1 = state 
    end
end

function append(t1, t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end 

function create_nfa(str)
    local stack = types.Stack:new()
    local i = 1
    repeat
        local token = str:sub(i, i)

        if token == " " then
            i = i + 1
            token = str:sub(i, i)
        end

        if token:byte() >= 65 and token:byte() <= 122 then
            local s = types.State:new(token, nil, nil, nil)
            stack:push(types.Fragment:new(s, {s})) -- add the statement to list of unfinished states 

        elseif token == "." then
            local e2 = stack:pop() -- pop fragments 
            local e1 = stack:pop()

            patch(e1.out_list, e2.start) -- connect fragments 
            stack:push(types.Fragment:new(e1.start, e2.out_list))

        elseif token == "|" then
            local e2 = stack:pop() 
            local e1 = stack:pop()
            s = State:new(token, e1.start, e2.start)
            stack:push(Fragment:new(s, append(e1.out_list, e2.out_list)))

        elseif token == "*" then
            local e = stack:pop() 
            s = State:new(token, nil, e.start)
            patch(e.out_list, s)
            stack:push(Fragment:new(s, {s}))
        end

        i = i + 1
    until i >= #str

    e = stack:pop()
    match_state = types.State:new("\0")
    patch(e.out_list, match_state)
    return e.start
end

listid = 0
function match(start, str)
    local nlist = {}
    local clist = start_list(start)
    for i = 1, #str do
        step(clist, str:sub(i, i), nlist)
        clist = nlist 
        nlist = {}
    end
    return is_match(clist)
end

function is_match(list) -- takes a list of States  
    for i = 1, #list do 
        if list[i].token == "\0" then 
            return true
        end 
    end
    return false
end

function start_list(state)
    listid = listid + 1
    local list = {}
    add_state(list, state)
    return list
end

function add_state(list, state)
    if state == nil or state.lastList == listid then return end
    state.lastList = listid
    if state.token == "|" or state.token == "*" then -- two paths from this nodes 
        add_state(list, state.out1)
        add_state(list, state.out2)
        return
    end
    list[#list + 1] = state
end

function step(clist, token, nlist)
    listid = listid + 1

    for i = 1, #clist do
        s = clist[i]
        if s.token == token then 
            add_state(nlist, s.out1) 
        end
    end
end

post = shunting_yard.postfix("(a.b)*|(h.e.l.l.o)")
print(post)
start = create_nfa(post)
print(match(start, "abababab"))
print(match(start, "hello"))
print(match(start, "abba"))
print(match(start, "ab"))
print(match(start, "b"))
print(match(start, ""))