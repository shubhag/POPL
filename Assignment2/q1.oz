declare

SemStack = {NewCell nil}
Program = [[nop][nop][nop]]
Env = {Dictionary.new}
SemStack := {Append [semStmt(Program Env)] @SemStack}

fun {Interpretor}
   local Stmt Env in
      % =======================================
      % Pop top of the semantic stack
      % =======================================
      
      case @SemStack of nil then
	 Stmt = nil
	 Env = nil
      else
	 Stmt = @SemStack.1.1
	 Env = @SemStack.1.2
	 SemStack := @SemStack.2
      end

      % ======================================
      % Check the popped statement
      % ======================================
      
      case Stmt of nil then nil

	 % ======================================
	 % If top is [nop] then do nothing and
	 % call the Interpretor again
	 % ======================================
	 
      [] nop|nil then
	 {Browse nop}
	 {Interpretor}

	 % ======================================
	 % If stack is of the form <S1> <S2> then
	 % ======================================
	 
      [] S1|S2 then
	 % ======================================
	 % Push S2 on stack
	 % ======================================
	 
	 case S2 of nil then skip
	 else
	    SemStack := {Append [semStmt(S2 Env)] @SemStack}
	 end

	 % ======================================
	 % Push S1 on stack
	 % ======================================
	 SemStack := {Append [semStmt(S1 Env)] @SemStack}

	 % ======================================
	 % Call the interpretor again
	 % ======================================
	 {Interpretor}
      end
   end
end
{Browse {Interpretor}}
