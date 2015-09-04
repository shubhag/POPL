declare
SemStack = {NewCell nil}
Program = [[nop][nop][nop]]
Env = {Dictionary.new}
SemStack := {Append [semStmt(Program Env)] @SemStack}

fun {Interpretor}
   local Stmt Env in
      case @SemStack of nil then
	 Stmt = nil
	 Env = nil
      else
	 Stmt = @SemStack.1.1
	 Env = @SemStack.1.2
	 SemStack := @SemStack.2
      end
      case Stmt of nil then nil
      [] nop|nil then
	 {Show nop}
	 {Interpretor}
      [] S1|S2 then
	 % Push S2 on stack
	 case S2 of nil then skip
	 else
	    SemStack := {Append semStmt(S2 Env) @SemStack}
	 end
	 %Push S1 on stack
	 SemStack := {Append semStmt(S1 Env) @SemStack}
	 {Interpretor}
      end
   end
end
