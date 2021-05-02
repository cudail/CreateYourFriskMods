--import our libraries
require "Libraries/bullets/bullet_spiral"

turn = 1

function Update()
	UpdateSpiral()

	turn = turn + 1
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
		local itemList = GetGlobal("itemList")
		Inventory.AddItem(itemList[math.random(#itemList)])
		SetGlobal("foodActive",false)
		bullet.Remove()
	else
		Player.Hurt(3)
	end
end
