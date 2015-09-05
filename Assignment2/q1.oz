declare

SemStack = {NewCell nil}
Program = [localvar ident(x)
	   [localvar ident(y)
	    [localvar ident(x)
	     [nop]]]]
NilEnv = {Dictionary.new}
SemStack := {Append [semStmt(Program NilEnv)] @SemStack}
SAS = {Dictionary.new}
SASKey = {NewCell 0}

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
	 
      [] (S1|S1_2)|S2 then
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
	 SemStack := {Append [semStmt((S1|S1_2) Env)] @SemStack}

	 % ======================================
	 % Call the interpretor again
	 % ======================================
	 {Interpretor}

      [] [localvar ident(X) S] then
	 {Browse X}
	 % ======================================
	 % Create new variable X in the store
	 % ======================================
	 {Dictionary.put SAS @SASKey nil}

	 % ======================================
	 % Map X in environment to SASKey
	 % ======================================
	 {Dictionary.put Env X @SASKey}
	 SASKey := @SASKey + 1

	 % ======================================
	 % Push S with new environment
	 % ======================================
	 SemStack := {Append [semStmt(S Env)] @SemStack}

	 % ======================================
	 % Continue with interpretor
	 % ======================================
	 {Interpretor}
      end
   end
end
{Browse {Interpretor}}


   