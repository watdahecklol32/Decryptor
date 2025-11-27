-- m just bec im lazy
local hasmetamethod = function(target: any, method: string): boolean
    return (getrawmetatable(target) and rawget(getrawmetatable(target), method) ~= nil)
end;
local getmetamethod = function(target: any, method: string): any
    local metatable = getrawmetatable(target);
    local method = rawget(metatable, method);
    return method;
end;
local listmetamethods = function(target: any): string
    local methods = "";
    local metatable = getrawmetatable(target);
    if (rawget(metatable, "__iter")) then
        for i: any, _: unknown in next, (metatable) do
            methods = methods..` {i}`;
        end;
    else
        for i: any, _: unknown in (metatable) do
            methods = methods..` {i}`;
        end;
    end;
    return methods;
end;
local dump = function(closure: (...any) -> (...any)): {constants: {any}, protos: {any}, upvalues: {any}}    
  if (type(closure) ~= "function" or iscclosure(closure)) then
     warn(`Illegal closure passed {type(closure)}.`);
     return coroutine.yield(coroutine.running());
  end;
  local result = {
        upvalues = {};
        constants = {};
        protos = {};
   } :: { constants: {any}, protos: {any}, upvalues: {any} };

    result.upvalues = debug.getupvalues(closure);
    result.constants = debug.getconstants(closure);

    result.protos = debug.getprotos(closure);
    return result;
end;
