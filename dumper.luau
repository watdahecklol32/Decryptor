local hasmetamethod = function(target: any, method: string): boolean
    return (getrawmetatable(target) and rawget(getrawmetatable(target), method) ~= nil)
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
