local gc: {[number]: (thread | (...any) -> (...any))} = getgc(false);
local isluafunction: ((...any) -> (...any)) -> boolean = islclosure;

local network = {} :: {["FireServer"]: (...any) -> (...any), ["InvokeServer"]: (...any) -> (...any)};
for _: unknown, v: (thread | (...any) -> (...any)) in (gc) do
	if (type(v) == "function" and isluafunction(v)) then
		local closure_name: string = debug.info(v, "n");
		if (closure_name == "FireServer" and not network.FireServer) then
			network.FireServer = v;
		elseif (closure_name == "InvokeServer" and not network.InvokeServer) then
			network.InvokeServer = v;
		end;
		if (network.FireServer and network.InvokeServer) then
			break;
		end;
	end;
end;

local http_service: HttpService = cloneref(game:GetService("HttpService"));
local fireserver_upvalues = debug.getupvalues(network.FireServer);

local security_code: string = fireserver_upvalues[4];
local key_table: {[number]: number} = http_service:JSONDecode(fireserver_upvalues[5]);

local encrypt;
do
	local encrypt_func: (...any) -> (...any) = fireserver_upvalues[2];
	encrypt = @native function(...: any): string
		local env: {[string]: any} = getfenv(encrypt_func);
		local arugments: {[number]: any} = {...};
        local setthreadidentity: (number) -> () = setthreadidentity;
		local _unpack = unpack;
		local setfenv = setfenv;
		return coroutine.wrap(@native function(): string 
			setfenv(1, env);
			setfenv(0, env);

			setthreadidentity(2);
			return encrypt_func(_unpack(arugments), key_table);
		end)();
	end;
end;

local decrypt = @native function(chiper: string, key: {[number]: number}): string
	local decoded: string = "";
	local cut_off: number = #chiper;
	for i: number = 1, cut_off do
		for meow: number = 0, 3 do
			if (i % 4 == meow) then
				local char: string = string.sub(chiper, i, i);
				local off_set: number = key[meow + 1];
				local code: number = string.byte(char) - 32;
				local original: number = (code - off_set) % 95 + 32;
				decoded = decoded .. string.char(original);
				break;
			end;
		end;
	end;
	return decoded;
end;
local plain_text: string = "Hi guys omg fireserver untouchable real encryption n os cam 2025";
local chiper: string = encrypt(plain_text, key_table);

print("chiper",chiper);
local decrypted: string = decrypt(chiper, key_table);

print("decrypted", decrypted);
