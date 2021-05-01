encountertext = "Poseur slides in!"
nextwaves = {"position-slider"}
wavetimer = 4.0
arenasize = {155, 130}

SetGlobal("derivative",0)

enemies = {
"poseur"
}

enemypositions = {
{0, 0}
}

playernames = {"Alhazen","Newton","Leibniz"}

function EncounterStarting()
	Player.name = playernames[math.random(#playernames)]
end

function EnemyDialogueStarting()
end

function EnemyDialogueEnding()
end

function DefenseEnding()
	encountertext = RandomEncounterText()
end

function HandleSpare()
	 State("ENEMYDIALOGUE")
end

function HandleItem(ItemID)
	BattleDialog({"Selected item " .. ItemID .. "."})
end
