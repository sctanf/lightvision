function Initialize()
	show = false
	governor = false
	timer = {}
end
function Update()
	if table.maxn(timer) > 0 then
		local t = os.clock()
		local j = 1
		local transparency = 0
		for i=1,table.maxn(timer) do
			if timer[j][4] > t then
				if timer[j][1] < t then
					if timer[j][2] > t then
						transparency = math.max(math.min((t-timer[j][1])/(timer[j][2]-timer[j][1]),1),transparency)
					elseif timer[j][3] < t then
						transparency = math.max(math.min((timer[j][4]-t)/(timer[j][4]-timer[j][3]),1),transparency)
					else
						transparency = 1
					end
				end
				j = j + 1
			else
				table.remove(timer,j)
			end
		end
		SKIN:Bang('!SetTransparency', transparency * 255)
		if transparency > 0 then
			if transparency < 1 then
				if (not governor) then
					governor = true
					SKIN:Bang('!EnableMeasure', 'Governor')
					SKIN:Bang('!UpdateMeasure', 'Governor')
				end
			else
				if (governor) then
					governor = false
					SKIN:Bang('!DisableMeasure', 'Governor')
				end
			end
			if (not show) then
				SKIN:Bang('!Redraw')
				SKIN:Bang('!Show')
				show = true
			end
		elseif ((transparency == 0) and show) then
			if (governor) then
				governor = false
				SKIN:Bang('!DisableMeasure', 'Governor')
			end
			SKIN:Bang('!Hide')
			show = false
		end
	end
end
function setRamp(a,b,c,d)
	local t = os.clock()
	table.insert(timer,{t+a,t+b,t+c,t+d})
end
function redraw()
	if show then SKIN:Bang('!Redraw') end
end
function OSDStateChange()
	redraw()
	setRamp(0,0,2.5,3)
	Update()
end
function SongChange()
	redraw()
	setRamp(2.5,2.75,7.5,8)
end