declare
Program = [localvar ident(x) s]
local Interpreter X  in
	fun {Interpreter}
		case Program
		of nil then nil
		[] [localvar ident(X) T]  then X
		end
	end
	{Browse {Interpreter}}
end
