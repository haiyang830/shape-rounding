local tr = aegisub.gettext

script_name = tr"shape rounding"
script_description = tr"四舍五入取整矢量图形代码中的小数"
script_author = "haiyang"
script_version = "1"

function shape_rounding(subs, sel)
    for _, i in ipairs(sel) do
        local line = subs[i]
        -- aegisub.debug.out(i..": "..line.text.."\n")
        local newText = cleanStr(line.text)
        line.text = newText
        subs[i] = line
    end
    aegisub.set_undo_point(tr"shape_rounding")
end

function cleanStr(str)
	local newStr
	newStr = matchStr(
		str,
		"m ([%-%d%.mnlbspc ]+)", -- re_str
		"([%-%d%.mnlbspc]+)",	 -- re_str_split
		" " -- concat_sep
	)
	newStr = matchStr(
		newStr,
		"clip%(([%-%d%.%,]+)%)",
		"([%-%d%.]+)",
		","
	)	
    return newStr
end

function matchStr(str, re_str, re_str_split, concat_sep)
	local newStr = str
    for drawStr in string.gmatch(newStr, re_str) do
		local Str_table = {}
		local i = 1
		for numStr in string.gmatch(drawStr, re_str_split) do
			Str_table[i] = tonumber(numStr) or numStr
			i = i + 1
		end
		for k,numStr in ipairs(Str_table) do
			if type(numStr) == "number" then
				local resNum = round(numStr)
				Str_table[k] = resNum
			end
		end
		drawStr = drawStr:gsub("%-", "%%%-")
		newStr = newStr:gsub(drawStr, table.concat(Str_table,concat_sep))
	end
	return newStr
end

function round(x)
	return math.floor(x + 0.5)
end

aegisub.register_macro(script_name, script_description, shape_rounding)
