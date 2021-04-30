require "Libraries/maths"

function CreateSnake() -- call this near the top of the wave script or whenever the snake should spawn
	
	foodAppearsOnTurn = math.random(60,400)
	SetGlobal('foodActive', false)
	snakeDiedOnTurn = -1				--used for the snake's death animation
	headings = {{1,0},{0,-1},{-1,0},{0,1}} --vector representations of four cardinal directions
	directionsToAxes = {1,2,1,2} 	--maps our four cardinal directions to their appropriate axes
									--{right, down, left, up} -> x,y
									--should be read as {x,y,x,y}
    directionsToSign = {1,-1,-1,1}

	--now let's make our snake
	snakeStartPositions = {{ -Arena.width/2 + 5 ,  Arena.height/2 - 5 },{ Arena.width/2 - 5 ,  Arena.height/2 - 5 },{ Arena.width/2 - 5 , - Arena.height/2 + 5 },{ - Arena.width/2 + 5 , - Arena.height/2 + 5 }}
	local startPos = math.random(4)
	head = CreateProjectile('bullets/square', snakeStartPositions[startPos][1] ,  snakeStartPositions[startPos][2] )
	head.SetVar('bullet_type', 'white_snake')
	head.sprite.SendToBottom()
	snakeHeading = headings[startPos] --snake starts off heading right - TODO: make this random?
	body = {}
	local snakeLength = GetGlobal('snakeLength')
	if snakeLength > 0 then
		for i = 1, snakeLength do
			local section = CreateProjectile('bullets/square', snakeStartPositions[startPos][1] ,  snakeStartPositions[startPos][2] )
			section.sprite.SendToBottom()
			section.SetVar('bullet_type', 'white_snake')
			body[i] = section
		end
	end
	
	
	trail = {}
	
	moveDis = head.sprite.height	--width/height of each section of the snake
	arenaLimits = {Arena.width/2.2,Arena.height/2.2}
	voluntaryTurningEvery = math.random (1,5)
end



function UpdateSnake() -- call this in the update function whenever the snake should move (probably not every frame)
	--local oilli = Encounter.GetVar('enemies')[1].sprite
	--DEBUG(oilli.Call('Move',{1,1}))
	Encounter.SetVar('enemypositions',{{100, 0}})
	
	
	--Control when the wave ends
	if GetGlobal('round') == 1 then
		wavet = 6
	elseif GetGlobal('round') < 5 then
		wavet = 9
	else
		wavet = 12
	end
		
	if snakeDiedOnTurn < 0 and (waveStartTime + wavet) < Time.time then
		--If we've gotten the snake to hit itself then we'll end when it has fully undrawn, whether that's before or after the normal end time
		EndWave()
	end
	
	local nextMoveInto = {head.x, head.y}
	if GetGlobal('foodActive') then
		local foodPosition = {food.x, food.y}
		local snakePosition = {head.x, head.y}
		local diff = VSub(snakePosition,foodPosition)
		if SqrAbs(diff) < 20 then
			Audio.PlaySound('dogsecret')
			SetGlobal('snakeLength', GetGlobal('snakeLength') + 3)
			SetGlobal('foodActive', false)
			food.Remove()

			local currentLenth = #body
			local tailsection = body[currentLenth]
			
			for i = currentLenth + 1, currentLenth + 3 do
				local section = CreateProjectile('bullets/square', tailsection.x, tailsection.y )
				section.SetVar('bullet_type', 'white_snake')
				body[i] = section
			end
		end
	end
	
	if turn == foodAppearsOnTurn and GetGlobal('foodActive') == false then
		local foodSprites = {'food/apple','food/cherry','food/peach','food/strawberry'}
		
		if head.x > 0 then
			foodx = - Arena.width/2.8
		else
			foodx = Arena.width/2.5
		end
		
		if head.y > 0 then
			foody = - Arena.height/2.60
		else
			foody = Arena.height/3
		end
		
		food = CreateProjectile(foodSprites[math.random(#foodSprites)], foodx, foody)
		food.SetVar('bullet_type', 'food')
		SetGlobal('foodActive',true)
	end

	if snakeDiedOnTurn < 0 then 
	
		if GetGlobal('hitCount') >= GetGlobal('collisionCount') then
			everyXturns = 10 - math.floor(GetGlobal('hitCount') / 1.5)
		else
			everyXturns = 10 - math.floor(GetGlobal('collisionCount') / 1.5)
		end
		
		if everyXturns < 4 then
			everyXturns = 4
		end
		
	
		if turn % (voluntaryTurningEvery * everyXturns) == 0 then--see if snake wants to turn
			SeekFood()
			voluntaryTurningEvery = math.random (1,5)
		end
	
		if turn % everyXturns == 0 then --use this to control how fast the snek moves
			--check if head is going to collide with anything
			CheckForCollisionAndReact()
			--now that direction is all decided move the head
			local moveVector = SMul(snakeHeading, moveDis)
			head.Move(moveVector[1],moveVector[2])
			
			for i = 1,#body do
				local moveInto = nextMoveInto
				nextMoveInto = {body[i].x,body[i].y}
				body[i].MoveTo(moveInto[1],moveInto[2])
			end
			
			if GetGlobal('hitCount') > 6 then
				local lastPiece = body[#body]
				local trailPiece = CreateProjectile('bullets/square', lastPiece.x ,  lastPiece.y )
				trailPiece.SetVar('bullet_type', 'orange_trail')
				trailPiece.sprite.SendToBottom()
				trailPiece.sprite.color = {248/255,162/255,67/255}
				trailPiece.SendToBottom()
				trail[#trail+1] = trailPiece
			end
		end
		
	
	else
		if turn == snakeDiedOnTurn + 1 then
			head.Remove()
		elseif turn == snakeDiedOnTurn + (#body + 2) * 7 then
			EndWave()
		else
			for i = 1, #body do
				if turn == snakeDiedOnTurn + 7 * i then
					body[i].Remove()
				end
			end
		end
		
		
		local oilli_stun = GetGlobal('oilli_stun')
		if turn == snakeDiedOnTurn + 1 then
			oilli_stun.Set('oilli_stun')
			Encounter.GetVar('enemies')[1].Call('SetSprite','oilli_blank')
			oilli_stun.x = 332
		elseif turn == snakeDiedOnTurn + 10 then
			oilli_stun.x = 320
		elseif turn == snakeDiedOnTurn + 20 then
			oilli_stun.x = 327
		elseif turn == snakeDiedOnTurn + 30 then
			oilli_stun.x = 320
		elseif turn == snakeDiedOnTurn + 40 then
			oilli_stun.x = 323
		elseif turn == snakeDiedOnTurn + 40 then
			oilli_stun.x = 320
		elseif turn == snakeDiedOnTurn + 50 then
			oilli_stun.x = 321
		elseif turn == snakeDiedOnTurn + 60 then
			oilli_stun.x = 320
			if GetGlobal('collisionCount') < GetGlobal('collisonsToWin') then
				oilli_stun.Set('oilli_blank')
				Encounter.GetVar('enemies')[1].Call('SetSprite','oilli')
			end
		end
	end
end



--Everything below here is internal functions and shouldn't need to be called outside of this script
function HeadingToDirection( heading ) --translates heading vector to thingy
	for i = 1,4 do
		if VEq( heading, headings[i]) then
			return i
		end
	end
end


function SeekFood()	
	local snakePosition = {head.x, head.y}
	local diff  = {0,0}
	local blockedDirections = GetBlockedDirections()
	
	if GetGlobal('foodActive') then
		local foodPosition = {food.x, food.y}
		diff = VSub(snakePosition,foodPosition)
	else
		local playerPosition = {Player.x, Player.y}
		diff = VSub(snakePosition,playerPosition)
	end
	
	if AbsValBiggerThan(diff[1], diff[2]) then
		if diff[1] > 0 and blockedDirections[3] == 0 then
			snakeHeading = headings[3]
		elseif blockedDirections[1] == 0 then
			snakeHeading = headings[1]
		end
	else
		if diff[2] > 0 and blockedDirections[2] == 0 then
			snakeHeading = headings[2]
		elseif blockedDirections[4] == 0 then
			snakeHeading = headings[4]
		end
	end
end

function GetBlockedDirections()
	local headCoords = {head.x, head.y}
	local surroundings = GetSurroundings(headCoords) 
	local blockedDirections = {0,0,0,0}
	
	--we need to check for collisions around
	for i = 1,4 do 
		--check if advancing in each direction would collide with the edge of the arena
		if AbsValBiggerThan( surroundings[i][directionsToAxes[i]] , arenaLimits[directionsToAxes[i]] ) then
			blockedDirections[i] = 1
		end
		--if not check if advancing in each direction would collide with with a body section
		if blockedDirections[i] == 0 then
			for j = 1,#body do
				if VEq( surroundings[i] , {body[j].x,body[j].y} ) then
					blockedDirections[i] = 1
				end
			end
		end
	end
	return blockedDirections
end

function CheckForCollisionAndReact()
	--TODO: this isn't always working correctly, investigate!
	
	local blockedDirections = GetBlockedDirections()
	
	--check if the way ahead of us is blocked
	if blockedDirections[HeadingToDirection(snakeHeading)] != 0 then
	
		if GetGlobal('collisionCount') < GetGlobal('collisionsToCar') then
			SetGlobal('collisionCount', GetGlobal('collisionCount') + 1)
			Audio.PlaySound('hitsound')
			snakeDiedOnTurn = turn
		else
			--if all directions are blocked the snek is ded and we need to do something about that :(
			if blockedDirections[1] != 0 and blockedDirections[2] != 0 and blockedDirections[3] != 0 and blockedDirections[4] != 0 then
				SetGlobal('collisionCount', GetGlobal('collisionCount') + 1)
				Audio.PlaySound('hitsound')
				snakeDiedOnTurn = turn
			else
				--ok so we now we need to decide which way to turn
				local closestApproach = {10000,10000,10000,10000}
				local headPosition = {head.x, head.y}
				for d = 1,4 do
					if blockedDirections[d] > 0 then
						closestApproach[d] = 0
					end
				end
				
				for i = 1, #body do
					local section = body[i]
					if section.x == head.x then
						if section.y > head.y then
							if section.y - head.y < closestApproach[4] then
								closestApproach[4] = section.y - head.y
							end
						else
							if head.y - section.y < closestApproach[2] then
								closestApproach[2] = head.y - section.y
							end
						end
					elseif section.y == head.y then
						if section.x > head.x then
							if section.x - head.x < closestApproach[1] then
								closestApproach[1] = section.x - head.x
							end
						else
							if head.x - section.x < closestApproach[3] then
								closestApproach[3] = head.x - section.x
							end
						end
					end
				end
				
				-- want to turn in the direction with the most room
				local directionToTurn = 1
				for d = 1,4 do
					if closestApproach[d] >= closestApproach[1] and closestApproach[d] >= closestApproach[2] and closestApproach[d] >= closestApproach[3] and closestApproach[d] >= closestApproach[4] then
						directionToTurn = d
					end
				end
				snakeHeading = headings[directionToTurn]
			end	
		end
	end
end
