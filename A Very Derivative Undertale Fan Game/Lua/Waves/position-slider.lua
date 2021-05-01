Encounter.SetVar("wavetimer", 10)

spawntimer = 0
bullets = {}

local derivative = GetGlobal("derivative")

Arena.ResizeImmediate(200, 200)
Arena.MoveTo(Arena.x, Arena.y)

x, y = Arena.x, Arena.y + Arena.height/2
vx, vy = 0,0
ax, ay = 0,0
bx, by = 0,0
cx, xy = 0,0

xaxis = CreateSprite("xslider","BelowBullet")
xaxis.MoveTo(Arena.x, Arena.y+Arena.height+24)
xcontrol = CreateSprite("circle","Top")
xcontrol.MoveTo(x, Arena.y+Arena.height+24)

xlabel = CreateSprite("x"..derivative,"Top")
xlabel.MoveTo(Arena.x, Arena.y+Arena.height+40+xlabel.height/2)

yaxis = CreateSprite("yslider","BelowBullet")
yaxis.MoveTo(Arena.x+Arena.width/2+20, Arena.y+Arena.height/2+4)
ycontrol = CreateSprite("circle","Top")
ycontrol.MoveTo(Arena.x+Arena.width/2+20, y)

ylabel = CreateSprite("y"..derivative,"Top")
ylabel.MoveTo(Arena.x+Arena.width/2+40, Arena.y + Arena.height/2)

mousecon = ""

function Update()
	--controls
	Player.SetControlOverride(true)
	if Input.GetKey("Mouse0") == 1 then
		if mousecon == "" then
			if (Input.MousePosX - xcontrol.x)*(Input.MousePosX - xcontrol.x) +
			(Input.MousePosY - xcontrol.y)*(Input.MousePosY - xcontrol.y) < 225 then
				mousecon = "x"
			elseif (Input.MousePosX - ycontrol.x)*(Input.MousePosX - ycontrol.x) +
			(Input.MousePosY - ycontrol.y)*(Input.MousePosY - ycontrol.y) < 225 then
				mousecon = "y"
			end
		end
	elseif Input.GetKey("Mouse0") == 2 then
		if mousecon == "x" then
			x = Input.MousePosX
		elseif mousecon == "y" then
			y = Input.MousePosY
		end
	else
		mousecon = ""
	end

	if x < Arena.x - Arena.width/2 then
		x = Arena.x - Arena.width/2
	elseif x > Arena.x + Arena.width/2 then
		x = Arena.x + Arena.width/2
	end

	if y < Arena.y then
		y = Arena.y
	elseif y > Arena.y + Arena.height then
		y = Arena.y + Arena.height
	end

	xcontrol.MoveTo(x, Arena.y+Arena.height+24)
	ycontrol.MoveTo(Arena.x+Arena.width/2+20, y)

	if derivative == 0 then
		Player.MoveToAbs(x, y, false)
	elseif derivative > 0 then
		xd, yd = x - Arena.x, y - Arena.y - Arena.height/2
		if derivative == 1 then
			vx, vy = xd/50, yd/50
		elseif derivative == 2 then
			ax, ay = xd/400, yd/400
			vx, vy = vx+ax, vy+ay
		elseif derivative == 3 then
			bx, by = xd/5000, yd/5000
			ax, ay = ax+bx, ay+by
			vx, vy = vx+ax, vy+ay
		elseif derivative == 4 then
			cx, cy = xd/10000, yd/10000
			bx, by = bx+cx, by+cy
			ax, ay = ax+bx, ay+by
			vx, vy = vx+ax, vy+ay
		end
		Player.Move(vx, vy, false)
	else
		xd, yd = x - Arena.x, y - Arena.y - Arena.height/2
		xr = scaledroot(xd, derivative-1)
		yr = scaledroot(yd, derivative-1)
		Player.MoveTo(xr, yr, false)
	end

	--reset stuff so that reversing direction isn't impossible as velocities race off exponentionally
	if Player.absx <= 228 or Player.absx >= 412 then
		vx = 0
		ax = 0
		bx = 0
		cx = 0
	end

	if Player.absy <= 103 or Player.absy >= 287 then
		vy = 0
		ay = 0
		by = 0
		cy = 0
	end

	--bullets
	spawntimer = spawntimer + 1
	if spawntimer%30 == 0 then
			local posx = 30 - math.random(60)
			local posy = Arena.height/2
			local bullet = CreateProjectile('bullet', posx, posy)
			bullet.SetVar('velx', 1 - 2*math.random())
			bullet.SetVar('vely', 0)
			table.insert(bullets, bullet)
	end

	for i=1,#bullets do
		local bullet = bullets[i]
		local velx = bullet.GetVar('velx')
		local vely = bullet.GetVar('vely')
		local newposx = bullet.x + velx
		local newposy = bullet.y + vely
		if(bullet.x > -Arena.width/2 and bullet.x < Arena.width/2) then
			if(bullet.y < -Arena.height/2 + 8) then
				newposy = -Arena.height/2 + 8
				vely = 4
			end
		end
		vely = vely - 0.04
		bullet.MoveTo(newposx, newposy)
		bullet.SetVar('vely', vely)
	end
end

function EndingWave()
	xaxis.remove()
	xcontrol.remove()
	xlabel.remove()
	yaxis.remove()
	ycontrol.remove()
	ylabel.remove()

	if derivative > 3 or derivative < -4 then
		Encounter["enemies"][1]["canspare"] = true
	end
end

function sign(num)
	if num < 0 then
		return -1
	end
	return 1
end

function root(num, d)
	if d == 2 then
		return math.sqrt(num)
	else
		return num ^ (1/d)
	end
end

function scaledroot(num, d)
	local abs = math.abs(num)
	local pow = math.abs(d)
	local val = sign(num) * root(abs, pow)
	local scale = 88
	return val * scale / root(scale, pow)
end
