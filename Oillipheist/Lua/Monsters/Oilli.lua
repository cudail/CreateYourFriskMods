comments = {"Oillipheist is hungry.", "Oillipheist's stomach rumbles."}
commands = {"Sing", "Feed", "Hint"}

sprite = "oilli" --Always PNG. Extension is added automatically.
name = "Oillipheist"
hp = 190
atk = 5
def = 2
check = "Always Hungry"
dialogbubble = "rightwide"
canspare = false
cancheck = true
hints = {"All items heal 10 HP.","The [color:00c000]food [color:ffffff]pickups will add an\ritem to your inventory.","Whenever Oillipheist eats he\rgrows longer.","Feeding him might help you.","To spare it make it collide\rwith itself several times."}

-- Happens after the slash animation but before
function HandleAttack(attackstatus)
	if attackstatus == -1 then
		-- player pressed fight but didn't press Z afterwards
	else
		-- player did actually attack
	end
end

function HandleAttack(damage)
	if damage > 0 then
		local oilli_stun = GetGlobal('oilli_stun')
		oilli_stun.Set('oilli_blank')
		Encounter.GetVar('enemies')[1].Call('SetSprite','oilli')
		if GetGlobal('collisionCount') >= GetGlobal('collisonsToWin') then
			Encounter.GetVar('enemies')[1].Call('Kill')
		end
		SetGlobal('hitCount', GetGlobal('hitCount') + 1)
	end
end

-- This handles the commands; all-caps versions of the commands list you have above.
function HandleCustomCommand(command)
	if command == "FEED" then
		if Inventory.ItemCount > 0 then
			local itemList = GetGlobal('itemList')
			Audio.PlaySound('dogsecret')
			local itemName = Inventory.GetItem(1)
			Inventory.RemoveItem(1)
			SetGlobal('snakeLength', GetGlobal('snakeLength') + 3)
			currentdialogue = {"You fed it " .. itemName..".\nOilliphest grew longer!", "" .. Inventory.ItemCount .. " item".. (Inventory.ItemCount == 1 and "" or "s") .." remaining."}
		else
			currentdialogue = {"You're out of food!"}
		end
	elseif command == "SING" then
		SetGlobal('timesSang', GetGlobal('timesSang') + 1)
		if GetGlobal('timesSang') < 4 then
			currentdialogue = {"You sing a song.\nOilliphest is angered!"}
		else
			currentdialogue = {"You're really not helping\ryourself with this."}
		end
		SetGlobal('hitCount',GetGlobal('hitCount') + 1)
	elseif command == "HINT" then
		local hintNo = 	GetGlobal('hint') + 1
				if GetGlobal('collisionCount') >= GetGlobal('collisonsToWin') then
			currentdialogue = {"You've already won!"}
		elseif hintNo <= #hints then
			currentdialogue = hints[hintNo]
		else
			currentdialogue = {"Out of hints, sorry!"}
		end
		SetGlobal('hint', hintNo)
	end
	BattleDialog(currentdialogue)
end
