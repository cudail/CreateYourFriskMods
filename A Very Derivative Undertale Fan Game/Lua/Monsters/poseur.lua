comments = {
	"Smells like calculus.",
	"Poseur is deriving like his\rlife depends on it.",
	"Please write down the make\rand model of your calculator.",
	"This round left as an excercise\rfor the player."}
commands = {"Differentiate", "Integrate"}
randomdialogue = {
	"An infinite number of\nmathematicians walk\ninto a bar...",
	"Why did the chicken\ncross the Mobius\nstrip?",
	"What do you get\nwhen you cross a\nmosquito and a\nmountain climber?"}

sprite = "poseur"
name = "Poseur"
hp = 100
atk = 1
def = 1
check = " [Insert maths joke here]"
dialogbubble = "rightwide"
canspare = false
cancheck = true

differentiate_jokes = {
	"Never, ever drink and derive.",
	"Some find these jokes derivative.",
	"Let's not go off on a tangent.",
	"She can't differentiate between\rright and wrong."}
integral_jokes = {
	"What is the integral of one\rover cabin?",
	"Why was log(x) fired from her\rjob? She just couldn't integrate.",
	"This will be integral to your\rvictory.",
	"...plus C"}

-- Happens after the slash animation but before
function HandleAttack(attackstatus)
	if attackstatus == -1 then
		-- player pressed fight but didn't press Z afterwards
	else
		-- player did actually attack
		next_stage()
	end
end

function HandleCustomCommand(command)
	if command == "DIFFERENTIATE" then
		if GetGlobal("derivative") > 3 then
			BattleDialog("This is getting a bit too\rderivative...")
		else
			differentiate(1)
			BattleDialog(differentiate_jokes[math.random(#differentiate_jokes)])
		end
	elseif command == "INTEGRATE" then
		if GetGlobal("derivative") < -4 then
			BattleDialog("You need to learn your limits.")
		else
			differentiate(-1)
			BattleDialog(integral_jokes[math.random(#integral_jokes)])
		end
	end
end

function next_stage()
	if GetGlobal("derivative") < 0 then
		differentiate(-1)
	else
		differentiate(1)
	end
end

function differentiate(num)
	local d = GetGlobal("derivative")
	d = d+num
	if d > 4 then
		d = 4
	elseif d < -5 then
		d = -5
	end
	SetGlobal("derivative",d)
end
