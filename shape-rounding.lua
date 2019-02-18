-- shape rounding

local tr = aegisub.gettext

script_name = tr"shape rounding"
script_description = tr"四舍五入取整矢量图形代码中的小数"
script_author = "haiyang"
script_version = "1"

function round_numbers(subs, sel)
    for _, i in ipairs(sel) do
        local line = subs[i]
        -- aegisub.debug.out(i..": "..line.text.."\n")
        local newText = cleanStr(line.text)
        line.text = newText
        subs[i] = line
    end
    aegisub.set_undo_point(tr"round_numbers")
end

function cleanStr(str)
	local newStr = str
    for drawStr in string.gmatch(newStr,"m ([%-%d%.mnlbspc ]+)") do
		local Str_table = {}
		local i = 1
		for numStr in string.gmatch(drawStr,"([%-%d%.mnlbspc]+)") do
			Str_table[i] = tonumber(numStr) or numStr
			i = i + 1
		end
		for k,numStr in ipairs(Str_table) do
			if type(numStr) == "number" then
				local resNum = round(numStr)
				Str_table[k] = resNum
			end
		end
		drawStr = drawStr:gsub("%-","%%%-")
		newStr=newStr:gsub(drawStr,table.concat(Str_table," "))
    end
    return newStr
end

function round(x)
    return math.ceil(x-0.5)
end

aegisub.register_macro(script_name, script_description, round_numbers)
