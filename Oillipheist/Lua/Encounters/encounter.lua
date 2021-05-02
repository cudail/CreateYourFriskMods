
music = "soliel_boss_fight"
encountertext = "Oillipheist blocks the way."
nextwaves = {"test_wave"}
wavetimer = 5
arenasize = {160, 130}

enemies = {
	"Oilli",
	"inactive_ghost"
}

enemypositions = {
	{0, 0}, {20,20}
}

generalWaves = { {'spiral','ropes'},{'snake','ropes'} , {'snake','ropes'} }


--TODOs:
--add another attack?
---Make top and bottom ropes separate attacks
---Add right hand side ropes
--other actions?
--slow down fight progression (rate of snake speed growth)
--lower music volume
--add flavour text to various interactions
---hints for how to spare
function EncounterStarting()
	--Global variables for fight:
	enemies[2].Call('SetActive',false)
	--enemies[1].SetVar('canspare', true)
	SetGlobal('snakeLength', 6) --Lenght of snake bullet
	SetGlobal('round', 0) --Progression of the encounter
	SetGlobal('items', 5)
	SetGlobal('itemList', {"a sandwich","a burger","a bag of crisps","the pumpkin rings","some rock candy","an onion","something blue","some taco chips"})
	SetGlobal('sparable', false)
	SetGlobal('spared', false)
	SetGlobal('hint', 0)
	Audio.Volume(0.07)
	--Audio.Stop()

	SetGlobal('hitCount', 0) --Number of times the player has dealt damage
	SetGlobal('collisionCount', 0)	--Number of times you've managed to make the snake collide with itself - win condition
	SetGlobal('collisonsToWin', 6)	--Number of times you need to make it collide with itself before it's spareable
	SetGlobal('collisionsToCar', 2)	--Number of times you need to make it collide with itself before it's careful
	SetGlobal('timesSang', 0)	--Number of times you need to make it collide with itself before it's careful

	oilli_stun = CreateSprite('oilli_blank')
	oilli_stun.MoveTo(320,315)
	SetGlobal('oilli_stun',oilli_stun)
end

function EnemyDialogueStarting()

end

function EnemyDialogueEnding()
		-- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.
		-- This example line below takes a random attack from 'possible_attacks'.


end

function HandleSpare()
	--DEBUG('~~~~~~~')
	--DEBUG(GetGlobal('collisionCount'))
	--DEBUG(GetGlobal('collisonsToWin'))
	--TODO - REMOVE STUNNED SPRITE, THEN
	if GetGlobal('collisionCount') >= GetGlobal('collisonsToWin') then
		---DEBUG('++++++')
		oilli_stun.Set('oilli_blank')
		enemies[1].Call('SetSprite','oilli')
		SetGlobal('spared', true)
	end

	State("ENEMYDIALOGUE")
end


function EnteringState(newstate, oldstate)

	if oldstate == 'MERCYMENU' and GetGlobal('spared') then
		--DEBUG('kkkkkkkk')
		BattleDialog({"YOU WON!\nYou earned 0 XP and 4 gold."})
	elseif newstate == "ENEMYDIALOGUE" then
		if GetGlobal('collisionCount') <= GetGlobal('collisionsToCar') and GetGlobal('snakeLength') > 15 then
			generalDialogue = {"You can't stop me.","Don't try to\ntie me in knots."}
		elseif GetGlobal('hitCount') > 4 then
			generalDialogue = {'Just die!','...','*growl*'}
		elseif GetGlobal('collisionCount') == GetGlobal('collisionsToCar') then
			generalDialogue = {"You won't trick me\nlike that again."}
		elseif GetGlobal('collisionCount') >= GetGlobal('collisonsToWin') then
			generalDialogue = {"That's enough,\nyou can pass.","Just leave me be."}
		else
			generalDialogue = {"*stomach growling*","I'm hungry...","You look tasty."}
		end
		enemies[2].Call('SetActive',false)
		enemies[1].SetVar('currentdialogue', {generalDialogue[math.random(#generalDialogue)]})
	elseif newstate ~= "ENEMYDIALOGUE" and oldstate == "ENEMYDIALOGUE" then
		if GetGlobal('spared') then
			State("DONE")
		end
				local round = GetGlobal('round')
		if round == 0 then
			nextwaves = { 'snake' }
			wavetimer = math.huge --wave is manually ended from inside script
		elseif round == 1 then
			nextwaves = { 'ropes' }
			wavetimer = 8
		elseif round % 4 == 0 then
			nextwaves = {'spiral','ropes'}
			wavetimer = 10
		else
			nextwaves = {'snake','ropes'}
			wavetimer = math.huge --wave is manually ended from inside script
		end
		--nextwaves = { 'spiral' }
		--wavetimer = 200

		SetGlobal('round', GetGlobal('round') + 1)

		if GetGlobal('collisionCount') >= GetGlobal('collisonsToWin') then
			State("ACTIONSELECT")
		end
	elseif newstate ~= "DEFENDING" and oldstate == "DEFENDING" then
		if GetGlobal('collisionCount') >= GetGlobal('collisonsToWin') then
			--DEBUG('you can spare now')
			enemies[1].SetVar('canspare', true)
			oilli_stun.Set('oilli_stun')
			encountertext = "Oillipheist is sparing you."
		else
			enemies[1].Call('SetSprite','oilli')
			oilli_stun.Set('oilli_blank')
			encountertext = RandomEncounterText()
		end
	elseif newstate == 'MERCYMENU' then
		enemies[2].Call('SetActive',true)
	elseif newstate == 'ACTIONSELECT' then
		enemies[2].Call('SetActive',false)
	end
end


--Stolen from Underfell Muffet 0.2.2
function HandleItem(ItemID)
	if GetGlobal("items") > 0 then
	local itemList = GetGlobal('itemList')
		SetGlobal("items", GetGlobal('items')-1)
		Player.Heal(10)
		BattleDialog({"You ate " .. itemList[math.random(#itemList)] ..".\nYou recovered 10 HP!", "" .. GetGlobal("items") .. " items remaining."})
	else
		BattleDialog({"You're out of food!"})
	end
end
