--import our libraries
require "Libraries/bullets/bullet_snake"

turn = 1

CreateSnake()
waveStartTime = Time.time


function Update()
	UpdateSnake()
	turn = turn + 1

	Player.sprite.SendToTop()
end

function OnHit(bullet)
	if bullet.GetVar('bullet_type') == 'orange_trail' then
		if not Player.isMoving then
			Player.Hurt(2)
		end
	elseif bullet.GetVar('bullet_type') == 'white_snake' then
		Player.Hurt(4)
	elseif bullet.GetVar('bullet_type') == 'food' then
		Audio.PlaySound('healsound')
		SetGlobal("items", GetGlobal("items")+1)
		SetGlobal("foodActive",false)
		bullet.Remove()
	else
		Player.Hurt(3)
	end
end