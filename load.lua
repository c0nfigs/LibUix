-- Preloader / Safe executor for LibUix (runs BEFORE your original loadstring)
-- Usage: put this script instead of direct loadstring(...) and it will
-- try multiple http methods, do basic sanity checks, sandbox the environment
-- and execute the fetched code safely.
local TARGET_URL = "https://raw.githubusercontent.com/c0nfigs/LibUix/refs/heads/main/init.lua"
local MIN_LENGTH = 200        -- minimal reasonable size for the remote script

-- Adicionamos mais padrões para capturar APIs comuns de manipulação de ambiente e IO.
local SUSPICIOUS_PATTERNS = {
	"identifyexecutor", "isexecutor", "getgenv", "setclipboard", "rconsole", 
	"debug%.", "getfenv", "setfenv", "io%.", "os%.", "loadfile", "dofile", 
	"require%s*%(", "HttpService:RequestAsync", "syn%-request", "request%(", 
	"http_request", "getrawmetatable", "setreadonly", "make_writeable"
}

-- Tenta múltiplos provedores http (em ordem). Retorna string body ou nil+err
local function try_http(url)
	local try_order = {}

	-- Funções comuns de exploit (embrulhadas em pcall a cada vez)
	-- Priorizamos game:HttpGet e syn.request
	table.insert(try_order, function(u)
		if game and game.HttpGet then
			local ok, res = pcall(function() return game:HttpGet(u) end)
			return ok and type(res) == "string" and res or nil, res
		end
		return nil, "no game:HttpGet"
	end)

	table.insert(try_order, function(u)
		if syn and syn.request then
			local ok, res = pcall(function() 
				return syn.request({Url = u, Method = "GET", Headers = {["User-Agent"] = "LuaLibUixLoader"}}).Body 
			end)
			return ok and type(res) == "string" and res or nil, res
		end
		return nil, "no syn.request"
	end)
	
	-- Fallbacks
	table.insert(try_order, function(u)
		if game and game.HttpGetAsync then
			local ok, res = pcall(function() return game:HttpGetAsync(u) end)
			return ok and type(res) == "string" and res or nil, res
		end
		return nil, "no HttpGetAsync"
	end)

	table.insert(try_order, function(u)
		if http and http.request then
			local ok, res = pcall(function() return http.request({Url = u, Method = "GET"}).Body end)
			return ok and type(res) == "string" and res or nil, res
		end
		return nil, "no http.request"
	end)

	-- Iterar
	for _, fn in ipairs(try_order) do
		local body, err = fn(url)
		if body and #body > 0 then
			return body
		end
	end
	return nil, "no http method succeeded"
end

-- Basic checksum (32-bit) for quick integrity check / simple corruption detection
local function checksum32(s)
	local sum = 0
	-- Usar bit32.band para garantir o wrap-around se disponível (Luau/Lua 5.2+)
	local band = bit32 and bit32.band or function(a, b) return a % b end
	for i = 1, #s do
		sum = (sum + string.byte(s, i))
		sum = band(sum, 0xFFFFFFFF) -- Força 32-bit wrap-around
	end
	return sum
end

-- detect suspicious tokens that might indicate unsafe code for a preloader
local function contains_suspicious(code)
	-- Use 'g' flag for global matching (mais eficiente)
	local lowered = code:lower()
	for _, pat in ipairs(SUSPICIOUS_PATTERNS) do
		if lowered:find(pat, 1, true) then -- Usar true para buscar sem mágicas (simple match)
			return true, pat
		end
	end
	return false
end

-- Create a conservative sandbox environment
local function make_sandbox()
	local sandbox = {}

	-- safe libraries
	sandbox.math = math
	sandbox.string = string
	sandbox.table = table
	sandbox.pairs = pairs
	sandbox.ipairs = ipairs
	sandbox.next = next
	sandbox.tonumber = tonumber
	sandbox.tostring = tostring
	sandbox.type = type
	sandbox.select = select
	sandbox.unpack = table.unpack or unpack
	sandbox.assert = assert
	sandbox.error = error
	sandbox.pcall = pcall
	sandbox.xpcall = xpcall
	sandbox.coroutine = coroutine
    sandbox.print = print -- Adiciona print para debug básico

	-- limited os/time access: only os.time if available (non-destructive)
	if os and os.time then sandbox.os = { time = os.time } end

	-- protect metatable changes
	local safe_setmetatable = function(t, mt)
		if type(t) ~= "table" then error("bad argument #1 to 'setmetatable' (table expected)") end
		return setmetatable(t, mt)
	end
	sandbox.setmetatable = safe_setmetatable
	sandbox.getmetatable = getmetatable

	-- do NOT include dangerous APIs (io, debug, require, game, workspace, services, syn, http, getrawmetatable etc.)
	return sandbox
end

-- attempt to compile code using available loaders (loadstring, load)
local function compile_code(code)
	local loader_errs = {}
	
	-- 1. Prefer 'load' with environment (Luau/Lua 5.2+ standard and secure)
	if load then
		local ok, fn_or_err = pcall(function()
			-- Usar "t" (texto) como modo. O último argumento é o ambiente (sandbox)
			return load(code, "LibUixLoader", "t", make_sandbox())
		end)
		if ok and type(fn_or_err) == "function" then
			return fn_or_err
		else
			table.insert(loader_errs, "load(t, env) failed: "..tostring(fn_or_err))
		end
	end

	-- 2. Fallback to loadstring and setfenv
	if loadstring then
		local ok, fn_or_err = pcall(function() return loadstring(code) end)
		if ok and type(fn_or_err) == "function" then
			-- Tentar setfenv para aplicar o sandbox
			if setfenv then
				pcall(function() setfenv(fn_or_err, make_sandbox()) end)
			end
			return fn_or_err
		else
			table.insert(loader_errs, "loadstring failed: "..tostring(fn_or_err))
		end
	end

	-- 3. Last resort: load without env (Less safe, but better than nothing if no loadstring/setfenv)
	if load and not (loader_errs[1] or ""):find("load%(t, env%)") then -- Evita tentar de novo se o load(env) falhou
		local ok, fn_or_err = pcall(function() return load(code, "LibUixLoader") end)
		if ok and type(fn_or_err) == "function" then
			-- NENHUMA tentativa de sandbox, mas permite execução se for o único método
			return fn_or_err
		else
			table.insert(loader_errs, "load fallback failed: "..tostring(fn_or_err))
		end
	end

	return nil, "compile failed: "..table.concat(loader_errs, " | ")
end

-- run the remote code in a protected call
local function run_remote(url)
	-- fetch
	local code, ferr = try_http(url)
	if not code then
		return false, ("fetch failed: %s"):format(tostring(ferr))
	end

	-- sanity check length
	if #code < MIN_LENGTH then
		return false, ("fetched too small (%d bytes)"):format(#code)
	end

	-- suspicious tokens detection - BLOQUEIO CRÍTICO
	local suspicious, token = contains_suspicious(code)
	if suspicious then
		return false, ("SUSPICIOUS TOKEN FOUND: %s - ABORTING"):format(tostring(token))
	end

	-- checksum info (informational)
	local cs = checksum32(code)

	-- compile
	local fn, ckerr = compile_code(code)
	if not fn then
		return false, ("compile error: %s"):format(tostring(ckerr))
	end

	-- execute in pcall
	local ok, res = pcall(fn)
	if not ok then
		return false, ("execution error: %s"):format(tostring(res))
	end

	-- success
	return true, { checksum = cs, size = #code }
end

-- Tenta execução: Apenas a versão protegida
local ok, info = run_remote(TARGET_URL)

if not ok then
	-- Apenas diagnóstico em caso de falha, sem fallback inseguro.
	-- O usuário precisa resolver o problema (fetch falhou, token suspeito, erro de compilação/execução).
	warn("[Preloader] FAILED TO LOAD LibUix SAFELY. Execution ABORTED. Reason:", info)
else
	-- success: you can print minimal success info for debugging
	print("[Preloader] LibUix loaded successfully. size:", info.size, "checksum:", info.checksum)
end
