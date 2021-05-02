require "Libraries/maths"

ropes = {}

function CreateRope( xpos, ypos )
	local rope = CreateProjectile('bullets/rope1', xpos, ypos)
	if xpos > 0 then
		rope.sprite.Set('bullets/rope1f')
	end
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
			else
				if turn % 2 == 0 then
					rope.Move(0, rope.GetVar('ymovement'))
				end
				if (turn + i * 3) % 15 == 0 then
					if (turn + i * 3) % 30 == 0 then
						if rope.GetVar('facing') > 0 then
							rope.sprite.Set('bullets/rope2')
						else
							rope.sprite.Set('bullets/rope2f')
						end
					else
						if rope.GetVar('facing') > 0 then
							rope.sprite.Set('bullets/rope1')
						else
							rope.sprite.Set('bullets/rope1f')
						end
					end
				end
			end
		elseif rope.GetVar('mode') == 'attacking' then
			rope.Move(rope.GetVar('facing') * 3,0)
			if (turn + i) % 6 == 0 then
				if (turn + i) % 12 == 0 then
					if rope.GetVar('facing') > 0 then
						rope.sprite.Set('bullets/rope2')
					else
						rope.sprite.Set('bullets/rope2f')
					end
				else
					if rope.GetVar('facing') > 0 then
						rope.sprite.Set('bullets/rope1')
					else
						rope.sprite.Set('bullets/rope1f')
					end
				end
			end
		end


		if rope.GetVar('ymovement') * rope.y > Arena.height/2 or rope.GetVar('facing') * rope.x > Arena.width/1.5 then
			rope.sprite.SendToBottom()
			rope.sprite.alpha = 0 --Set to invisible rather than calling Removed() as that was causing issues with iterating over the ropes table
			rope.SetVar('mode','deactivated')
		end
	end
end
