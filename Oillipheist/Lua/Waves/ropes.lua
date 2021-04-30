--import our libraries
require "Libraries/bullets/bullet_rope"

turn = 1

opts1 = {{true,false,false,false},{false,true,false,false},{false,false,true,false},{false,false,false,true}}

opts2 = {{true,true,false,false},{true,false,true,false},{true,false,false,true},{false,true,true,false},{false,true,false,true},{false,false,true,true}}

opts3 = {{false,true,true,true},{true,false,true,true},{true,true,false,true},{true,true,true,false}}

if GetGlobal('round') < 5 then
	opts = opts1
elseif GetGlobal('hitCount') > 6 or GetGlobal('collisionCount') == (GetGlobal('collisonsToWin') - 1) then
	opts = opts3
else
	opts = opts2
end

spawns = opts[math.random(#opts)]

function Update()
	if spawns[1] and (turn % 120 == 0  or turn == 1) then
		CreateRope(- Arena.width/2 - 16, 100, false)
	end
	
	if spawns[2] and  ((turn + 40) % 120 == 0 or turn == 1) then
		CreateRope(- Arena.width/2 - 16, -100, false)
	end
	
	if spawns[3] and  ((turn + 20) % 120 == 0 or turn == 10) then
		CreateRope(Arena.width/2 + 16, 100, false)
	end

	if spawns[4] and  ((turn + 60) % 120 == 0 or turn == 10) then
		CreateRope(Arena.width/2 + 16, -100, false)
	end

	
	UpdateRope()
	
	turn = turn + 1
end


function OnHit(bullet)
	if bullet.GetVar('bullet_type') == 'orange_trail' then
		if not Player.isMoving then
			Player.Hurt(2)
		end	
	elseif bullet.GetVar('bullet_type') == 'white_snake' then
		Player.Hurt(4)
	else
		Player.Hurt(3)
	end
end