sprlNextPlacement = { - Arena.width/2 + 3 ,  Arena.height/2 - 3 }
sprlDirection = 'r'
spiral = {}
sprlXupperbound = 32
sprlXlowerbound = 1
sprlYupperbound = 25
sprlYlowerbound = 1

sprlXpos = sprlXlowerbound
sprlYpos = 26

moveDis = 5



function UpdateSpiral()

	if turn % 3 ~= 0 or GetGlobal('round') > 8 then

		local newBrick = CreateProjectile('bullets/square', sprlNextPlacement[1] ,  sprlNextPlacement[2] )
		newBrick.sprite.SendToBottom()

		if sprlDirection == 'r' then
			if sprlXpos == sprlXupperbound then
				sprlXupperbound = sprlXupperbound - 1
				sprlDirection = 'd'
			end
		elseif sprlDirection == 'd' then
			if sprlYpos == sprlYlowerbound then
				sprlYlowerbound = sprlYlowerbound + 1
				sprlDirection = 'l'
			end
		elseif sprlDirection == 'l' then
			if sprlXpos == sprlXlowerbound then
				sprlXlowerbound = sprlXlowerbound + 1
				sprlDirection = 'u'
			end
		elseif sprlDirection == 'u' then
			if sprlYpos == sprlYupperbound then
				sprlYupperbound = sprlYupperbound - 1
				sprlDirection = 'r'
			end
		end



		if sprlDirection == 'r' then
			sprlXpos = sprlXpos + 1
			sprlNextPlacement = {newBrick.x + moveDis, newBrick.y}
		elseif sprlDirection == 'd' then
			sprlYpos = sprlYpos - 1
			sprlNextPlacement = {newBrick.x, newBrick.y - moveDis}
		elseif sprlDirection == 'l' then
			sprlXpos = sprlXpos - 1
			sprlNextPlacement = {newBrick.x - moveDis, newBrick.y}
		elseif sprlDirection == 'u' then
			sprlYpos = sprlYpos + 1
			sprlNextPlacement = {newBrick.x, newBrick.y + moveDis}
		end

	end
end