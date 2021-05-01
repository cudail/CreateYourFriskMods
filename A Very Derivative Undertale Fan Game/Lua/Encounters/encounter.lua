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
	Inventory.AddCustomItems({
		"Fibonachos",
		"Apple Tau",
		"Frosted Mug",
		"Fig Leibniz",
		"Tangerine",
		"Onion Torus"},
		{0,0,0,0,0,0})
	Inventory.AddItem("Fibonachos")
	Inventory.AddItem("Apple Tau")
	Inventory.AddItem("Frosted Mug")
	Inventory.AddItem("Fig Leibniz")
	Inventory.AddItem("Tangerine")
	Inventory.AddItem("Onion Torus")
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
	Player.Heal(20)
	if ItemID == "FIBONACHOS" then
		BattleDialog({"Each one is as big as the\rprevious two combined."})
	elseif ItemID == "APPLE TAU" then
		BattleDialog({"Twice as good as apple pi."})
	elseif ItemID == "FROSTED MUG" then
		BattleDialog({"Indistinguishable from a\rfrosted doughnut."})
	elseif ItemID == "FIG LEIBNIZ" then
		BattleDialog({"I prefer Hasan Fig al-Haytham."})
	elseif ItemID == "TANGERINE" then
		BattleDialog({"Equal to singerine over\rcosgerine."})
	elseif ItemID == "ONION TORUS" then
		BattleDialog({"Not sure if vegetarian."})
	else
		BattleDialog({"You ate "..ItemID.."."})
	end
end
