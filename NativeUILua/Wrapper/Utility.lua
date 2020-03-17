-------- ARRETE D'ESSAYEZ DE DUMP POUR BYPASS MON ANTICHEAT TU REUSSIRA PAS ^^ --------
_print = print
_TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

---GetResolution
---@return table
function GetResolution()
	local W, H = GetActiveScreenResolution()
	if (W / H) > 3.5 then
		return GetScreenResolution()
	else
		return W, H
	end
end

---FormatXWYH
---@param Value number
---@param Value2 number
---@return table
function FormatXWYH(Value, Value2)
	return Value / 1920, Value2 / 1080
end

---round
---@param num number
---@param numDecimalPlaces number
---@return number
function math.round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

---tobool
---@param input boolean
---@return boolean
function tobool(input)
	if input == "true" or tonumber(input) == 1 or input == true then
		return true
	else
		return false
	end
end

---split
---@param inputstr string
---@param sep string
---@return string
function string.split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {};
	i = 1
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

---starts
---@param String string
---@param Start string
---@return string
function string.starts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

---IsMouseInBounds
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@return number
function IsMouseInBounds(X, Y, Width, Height)
	local MX, MY = math.round(GetControlNormal(0, 239) * 1920), math.round(GetControlNormal(0, 240) * 1080)
	MX, MY = FormatXWYH(MX, MY)
	X, Y = FormatXWYH(X, Y)
	Width, Height = FormatXWYH(Width, Height)
	return (MX >= X and MX <= X + Width) and (MY > Y and MY < Y + Height)
end

---GetSafeZoneBounds
---@return table
function GetSafeZoneBounds()
	local SafeSize = GetSafeZoneSize()
	SafeSize = math.round(SafeSize, 2)
	SafeSize = (SafeSize * 100) - 90
	SafeSize = 10 - SafeSize

	local W, H = 1920, 1080

	return { X = math.round(SafeSize * ((W / H) * 5.4)), Y = math.round(SafeSize * 5.4) }
end

---Controller
---@return nil
function Controller()
	return not IsInputDisabled(2)
end

---RenderText
---@param Text string
---@param X number
---@param Y number
---@param Font number
---@param Scale number
---@param R number
---@param G number
---@param B number
---@param A number
---@param Alignment number
---@param DropShadow number
---@param Outline number
---@param WordWrap number
---@return nil
function RenderText(Text, X, Y, Font, Scale, R, G, B, A, Alignment, DropShadow, Outline, WordWrap)
	Text = tostring(Text)
	X, Y = FormatXWYH(X, Y)
	SetTextFont(Font or 0)
	SetTextScale(1.0, Scale or 0)
	SetTextColour(R or 255, G or 255, B or 255, A or 255)

	if DropShadow then
		SetTextDropShadow()
	end
	if Outline then
		SetTextOutline()
	end

	if Alignment ~= nil then
		if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
			SetTextCentre(true)
		elseif Alignment == 2 or Alignment == "Right" then
			SetTextRightJustify(true)
			SetTextWrap(0, X)
		end
	end

	if tonumber(WordWrap) then
		if tonumber(WordWrap) ~= 0 then
			WordWrap, _ = FormatXWYH(WordWrap, 0)
			SetTextWrap(WordWrap, X - WordWrap)
		end
	end

	BeginTextCommandDisplayText("STRING")
	AddLongString(Text)
	EndTextCommandDisplayText(X, Y)
end

---DrawRectangle
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@param R number
---@param G number
---@param B number
---@param A number
---@return nil
function DrawRectangle(X, Y, Width, Height, R, G, B, A)
	X, Y, Width, Height = X or 0, Y or 0, Width or 0, Height or 0
	X, Y = FormatXWYH(X, Y)
	Width, Height = FormatXWYH(Width, Height)
	DrawRect(X + Width * 0.5, Y + Height * 0.5, Width, Height, tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)
end

---DrawTexture
---@param TxtDictionary string
---@param TxtName string
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
---@return nil
function DrawTexture(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)
	if not HasStreamedTextureDictLoaded(tostring(TxtDictionary) or "") then
		RequestStreamedTextureDict(tostring(TxtDictionary) or "", true)
	end
	X, Y, Width, Height = X or 0, Y or 0, Width or 0, Height or 0
	X, Y = FormatXWYH(X, Y)
	Width, Height = FormatXWYH(Width, Height)
	DrawSprite(tostring(TxtDictionary) or "", tostring(TxtName) or "", X + Width * 0.5, Y + Height * 0.5, Width, Height, tonumber(Heading) or 0, tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)
end