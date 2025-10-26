-- 🟩 API COPY

-- 🔹 Copiar texto universalmente
function Tekscripts:Copy(text: string)
	assert(type(text) == "string", "O texto precisa ser uma string")

	local success, msg = false, ""

	-- 1️⃣ Exploits comuns
	if typeof(setclipboard) == "function" then
		pcall(setclipboard, text)
		success, msg = true, "[Clipboard] Copiado com setclipboard."

	elseif typeof(toclipboard) == "function" then
		pcall(toclipboard, text)
		success, msg = true, "[Clipboard] Copiado com toclipboard."

	-- 2️⃣ Roblox Studio (plugin dev)
	elseif plugin and typeof(plugin.SetClipboard) == "function" then
		pcall(function()
			plugin:SetClipboard(text)
			success = true
			msg = "[Clipboard] Copiado com plugin:SetClipboard."
		end)

	-- 3️⃣ getgenv() fallback
	elseif rawget(getgenv and getgenv() or {}, "setclipboard") then
		pcall(getgenv().setclipboard, text)
		success, msg = true, "[Clipboard] Copiado via getgenv().setclipboard."

	else
		msg = "[Clipboard] Nenhuma API de cópia disponível neste ambiente."
	end

	if success then
		print(msg)
	else
		warn(msg .. " Texto: " .. text)
	end

	return success
end


-- 🔹 Copiar path de instância automaticamente
function Tekscripts:CopyInstancePath(instance: Instance)
	assert(typeof(instance) == "Instance", "O argumento precisa ser uma instância válida")
	local path = instance:GetFullName()
	return self:Copy(path)
end
-- 🟩 FIM API COPY

-- 🟩 API DIRECTORY
function Tekscripts:WriteFile(path: string, content: string)
	assert(type(path) == "string", "Caminho inválido")
	assert(type(content) == "string", "Conteúdo inválido")

	local writeFunc =
		writefile
		or (fluxus and fluxus.writefile)
		or (trigon and trigon.writeFile)
		or (codex and codex.writefile)
		or (syn and syn.write_file)
		or (KRNL and KRNL.WriteFile)

	if not writeFunc then
		warn("[FS] Executor não suporta escrita de arquivos")
		return false
	end

	local ok, err = pcall(writeFunc, path, content)
	if not ok then warn("[FS] Erro ao escrever arquivo:", err) end
	return ok
end

function Tekscripts:ReadFile(path: string)
	assert(type(path) == "string", "Caminho inválido")

	local readFunc =
		readfile
		or (fluxus and fluxus.readFile)
		or (trigon and trigon.readFile)
		or (codex and codex.readFile)
		or (syn and syn.read_file)
		or (KRNL and KRNL.ReadFile)

	local existsFunc =
		isfile
		or (fluxus and fluxus.isfile)
		or (trigon and trigon.isfile)
		or (codex and codex.isfile)
		or (syn and syn.file_exists)
		or (KRNL and KRNL.IsFile)
		or function() return false end

	if not readFunc or not existsFunc(path) then
		warn("[FS] Arquivo não existe ou leitura não suportada")
		return nil
	end

	local ok, result = pcall(readFunc, path)
	if ok then
		return result
	else
		warn("[FS] Erro ao ler arquivo:", result)
		return nil
	end
end

function Tekscripts:IsFile(path: string)
	assert(type(path) == "string", "Caminho inválido")

	local existsFunc =
		isfile
		or (fluxus and fluxus.isfile)
		or (trigon and trigon.isfile)
		or (codex and codex.isfile)
		or (syn and syn.file_exists)
		or (KRNL and KRNL.IsFile)
		or function() return false end

	return existsFunc(path)
end

-- 🟩 FIM API DIRECTORY

-- 🟩 API REQUEST
function Tekscripts:RequestAsync(options, callback)
	assert(type(options) == "table", "As opções precisam ser uma tabela.")

	local HttpService = game:GetService("HttpService")

	-- 🔹 Funções de request suportadas
	local requestFunc =
		(syn and syn.request)
		or (fluxus and fluxus.request)
		or (http and http.request)
		or (krnl and krnl.request)
		or (getgenv().request)
		or request

	if not requestFunc then
		warn("[HTTP] Nenhuma função de request disponível neste executor.")
		if callback then callback(nil) end
		return
	end

	task.spawn(function()
		-- 🔹 Conversão automática de Body para JSON
		if options.Body and type(options.Body) == "table" then
			options.Headers = options.Headers or {}
			if not options.Headers["Content-Type"] then
				options.Headers["Content-Type"] = "application/json"
			end

			local ok, encoded = pcall(HttpService.JSONEncode, HttpService, options.Body)
			if ok then
				options.Body = encoded
			else
				warn("[HTTP] Falha ao converter Body para JSON:", encoded)
				if callback then callback(nil) end
				return
			end
		end

		-- 🔹 Executa a requisição
		local ok, response = pcall(requestFunc, options)
		if not ok then
			warn("[HTTP] Erro na requisição:", response)
			if callback then callback(nil) end
			return
		end

		if callback then
			callback(response)
		end
	end)
end

-- 🟩 FIM DA API REQUEST
