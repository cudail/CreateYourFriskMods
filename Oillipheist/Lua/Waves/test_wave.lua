--import our libraries
require "Libraries/bullets/bullet_snake"
require "Libraries/bullets/bullet_rope"
require "Libraries/bullets/bullet_spiral"


--first some global variables
turn = 1

--TODO: make food bullets?
						



--CreateSnake({ - Arena.width/2.2 ,  Arena.width/2.8 }, {1,0})

--CreateRope(- Arena.width/2 - 16, -120)
function Update()
	--if turn % 90 == 0 then
	--	CreateRope(- Arena.width/2 - 16, 100)
	--end
	
	--if (turn + 10) % 105 == 0 then
	--	CreateRope(- Arena.width/2 - 16, -100)
	--end

	--UpdateSnake()
	--UpdateRope()
	
	
	
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
	else
		Player.Hurt(3)
	end
end