-- maths functions
function AbsValBiggerThan ( this, that )
	return ( this * this ) > ( that * that )
end

function Sign( n )
	if n < 0 then
		return -1
	else
		return  1
	end
end

-- vector functions
function VAdd( v1, v2 ) --Vector addition
	local result = {}
	for i = 1, #v1 do
		result[i] = v1[i] + v2[i]
	end
	return result
end

function VSub( v1, v2 ) --Vector subtraction
	local result = {}
	for i = 1, #v1 do
		result[i] = v1[i] - v2[i]
	end
	return result
end

function SMul(v, s) --Multiple vector by scalar
	local result = {}
	for i = 1,#v do
		result[i] = v[i] * s
	end
	return result
end

function VHad( v1, v2 ) --Hadamard product of two vectors
	local result = {}
	for i = 1, #v1 do
		result[i] = v1[i] * v2[i]
	end
	return result
end

function VEq( v1, v2 ) --are two vectors equal?
	local result = true
	for i = 1, #v1 do
		result = result and v1[i] == v2[i]
	end
	return result
end

function GetSurroundings( v ) --one vector
	return {{v[1]+moveDis,v[2]},{v[1],v[2]-moveDis},{v[1]-moveDis,v[2]},{v[1],v[2]+moveDis}}
end

function SqrAbs( v ) --absolute value of a vector squared
	local result = 0
	for i = 1, #v do
		result = result + v[i] * v[i]
	end
	return result
end
