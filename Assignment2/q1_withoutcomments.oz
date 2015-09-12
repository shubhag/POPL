\insert 'Unify.oz'

declare
SemStack = {NewCell nil}
Program =  [localvar ident(foo)
	    [localvar ident(bar)
	     [[bind ident(foo) [record literal(person) [literal(name) ident(bar)]]]
	      [bind ident(bar) [record literal(person) [literal(name) ident(foo)]]]
	      [bind ident(foo) ident(bar)]]]]

Environment = environment()
SemStack := {Append [semStmt(Program environment)] @SemStack}

fun {Interpretor}
   % ==========================================
   % Print the execution state
   % Execution State = <semantic stack>,<SAS>
   % ==========================================
   
   {Browse [@SemStack {Dictionary.entries SAS}]}
   
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
      case Stmt of nil then done

         % ======================================
	 % If top is [nop] then do nothing and
	 % call the Interpretor again
	 % ======================================
	 
      [] nop|nil then
	 % {Browse nop}
	 {Interpretor}

	 % ======================================
	 % If top of stack is variable scope introduction
	 % ======================================

      [] [localvar ident(X) S] then
	 % ======================================
	 % Create new variable X in the store
	 % Push S with new environment and
	 % Increment SASKey
	 % ======================================
	 
	 SemStack := {Append [semStmt(S {Adjoin Env environment(X:{AddKeyToSAS})})] @SemStack}
	 
	 % ======================================
	 % Continue with interpretor
	 % ======================================
	 
	 {Interpretor}

	 % ======================================
	 % If top of the stack is bind expression
	 % ======================================
	 
      [] [bind Expression1 Expression2] then

	 % ======================================
	 % Unify given expression, trusting
	 % Unify.oz
	 % ======================================
	 
	 {Unify Expression1 Expression2 Env}
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
{Browse 'Starting Interpretor'}
{Browse {Interpretor}}
{Browse 'Program succesfully terminated'}
