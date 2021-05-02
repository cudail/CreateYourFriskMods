require "Libraries/maths"

food

function CreateFoodOnTimer()
	appearOnTurn = math.random(60,400)

	local rope = CreateProjectile('bullets/rope1', xpos, ypos)
	rope.sprite.SetAnimation({'bullets/rope1','bullets/rope2'},0.5)
	rope.SetVar('facing', - Sign(xpos))
	rope.SetVar('ymovement', - Sign(ypos))
	rope.SetVar('mode', 'searching')
	ropes[#ropes+1] = rope
end


function UpdateRope()
	for i = 1,#ropes do
		local rope = ropes[i]
		if rope.GetVar('mode') == 'searching' then
			if AbsValBiggerThan(5, rope.y - Player.y) then
				rope.SetVar('mode','attacking')
				rope.sprite.SetAnimation({'bullets/rope1','bullets/rope2'},0.2)
			else
				if turn % 2 == 0 then
					rope.Move(0, rope.GetVar('ymovement'))
				end
			end
		elseif rope.GetVar('mode') == 'attacking' then
			rope.Move(rope.GetVar('facing') * 4,0)
		end


		if rope.GetVar('ymovement') * rope.y > Arena.height/2 or rope.GetVar('facing') * rope.x > Arena.width/2 then
			rope.sprite.SendToBottom()
			rope.sprite.alpha = 0 --Set to invisible rather than calling Removed() as that was causing issues with iterating over the ropes table
			rope.SetVar('mode','deactivated')
		end

	end
end