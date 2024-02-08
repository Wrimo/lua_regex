local NAME = "shunting_yard"
local M = {}

function M.postfix(str)
    operators = {["."] = 2, ["|"] = 1, ["*"] = 3}

    output_queue = {}
    output_queue.insert = table.insert
    output_queue.remove = table.remove

    operator_stack = {}
    operator_stack.insert = table.insert
    operator_stack.remove = table.remove

    repeat
        token = str:sub(0, 1)
        str = str:sub(2)
        function postfix(str)
            operators = {["+"] = 2, ["|"] = 1, ["*"] = 3}

            output_queue = {}
            output_queue.insert = table.insert
            output_queue.remove = table.remove

            operator_stack = {}
            operator_stack.insert = table.insert
            operator_stack.remove = table.remove

            repeat
                token = str:sub(0, 1)
                str = str:sub(2)

                if token:byte() >= 65 and token:byte() <= 122 then
                    output_queue:insert(token)
                elseif token == "(" then
                    operator_stack:insert(token)
                elseif token == ")" then
                    o2 = operator_stack[#operator_stack]

                    while o2 ~= "(" do
                        assert(#operator_stack ~= 0)
                        output_queue:insert(o2)
                        operator_stack:remove(#operator_stack)
                        o2 = operator_stack[#operator_stack]
                    end

                    assert(operator_stack[#operator_stack] == "(")
                    operator_stack:remove(#operator_stack)
                else
                    o2 = operator_stack[#operator_stack]
                    while o2 ~= nil and o2 ~= "(" and operators[o2] >
                        operators[token] do
                        output_queue:insert(o2)
                        operator_stack:remove(#operator_stack)
                        o2 = operator_stack[#operator_stack]
                    end
                    operator_stack:insert(token)
                end
            until #str == 0

            repeat
                token = operator_stack[#operator_stack]
                output_queue:insert(token)
                operator_stack:remove(#operator_stack)

            until #operator_stack == 0

            return table.concat(output_queue, " ")
        end
        if token:byte() >= 65 and token:byte() <= 122 then
            output_queue:insert(token)
        elseif token == "(" then
            operator_stack:insert(token)
        elseif token == ")" then
            o2 = operator_stack[#operator_stack]

            while o2 ~= "(" do
                assert(#operator_stack ~= 0)
                output_queue:insert(o2)
                operator_stack:remove(#operator_stack)
                o2 = operator_stack[#operator_stack]
            end

            assert(operator_stack[#operator_stack] == "(")
            operator_stack:remove(#operator_stack)
        else
            o2 = operator_stack[#operator_stack]
            while o2 ~= nil and o2 ~= "(" and operators[o2] > operators[token] do
                output_queue:insert(o2)
                operator_stack:remove(#operator_stack)
                o2 = operator_stack[#operator_stack]
            end
            operator_stack:insert(token)
        end
    until #str == 0

    repeat
        token = operator_stack[#operator_stack]
        output_queue:insert(token)
        operator_stack:remove(#operator_stack)

    until #operator_stack == 0

    return table.concat(output_queue, " ")
end

return M
