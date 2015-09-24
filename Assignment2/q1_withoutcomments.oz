\insert 'Unify.oz'
\insert 'ProcessRecords.oz'
declare
SemStack = {NewCell nil}
Program =  [localvar ident(foo)
	    [localvar ident(result)
	     [[bind ident(foo) [record literal(bar)
				[[literal(xbaz) literal(42)]
				 [literal(quux) literal(314)]]
			       ]]
	      [match ident(foo) [record literal(bar)
				 [[literal(xbaz) ident(fortytwo)]
				  [literal(quux) ident(pitimes100)]]
				]
	       [bind ident(result) ident(fortytwo)] %% if matched
	       [bind ident(result) literal(314)]] %% if not matched
	     %% This will raise an exception if result is not 42
	      [bind ident(result) literal(42)]
	     ]
	    ]
	   ]
	   
Environment = environment()
SemStack := {Append [semStmt(Program environment)] @SemStack}

fun {SortRecord Record}
   case Record of [record Label Flist] then
      [record  Label {Map {Canonize {Map Flist fun{$ X} X.1#X.2 end}} fun{$ X} [X.1 X.2] end}
      ]
   else
      raise recordSort(Record) end
   end
end

fun {CreatePEnv Env  FList PFList}
   %{Browse 'Entered CreatePEnv'}
   %{Browse FList}
   %{Browse PFList}
   case FList of nil then
      case PFList of nil then Env end
   [] HFList|TFList then case PFList of HPFList|TPFList then
			    if (HFList.1 == HPFList.1) then
			       local EnvTemp in
				  %{Browse HPFList.2.1#Env}
				  case HPFList.2.1 of [ident(X)] then
				     EnvTemp = {Adjoin Env environment(X:{AddKeyToSAS})}
				     %{Browse EnvTemp}
				  else
				     skip
				  end
				  %{Browse 'Unifying'#HFList.2.1.1#HPFList.2.1.1}
				  {Unify HFList.2.1.1 HPFList.2.1.1 EnvTemp} 
				  {CreatePEnv EnvTemp TFList TPFList}
			       end
			    else
			       raise patternFeature(FList PFList) end
			    end
			 end
   end
end

fun {Interpretor}
   % ==========================================
   % Print the execution state
   % Execution State = <semantic stack>,<SAS>
   % ==========================================
   
%   {Browse [@SemStack {Dictionary.entries SAS}]}
   
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
      {Browse [Stmt  Env {Dictionary.entries SAS}]}
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
	 %{Browse Expression1#Expression2}
	 % ======================================
	 % Unify given expression, trusting
	 % Unify.oz
	 % ======================================
	 case Expression2 of [record Label FList] then
	    {Unify Expression1 {SortRecord Expression2} Env}
	 else
	    {Unify Expression1 Expression2 Env}
	 end
	 {Interpretor}

	 % ======================================
	 % If top of stack is a conditional
	 % ======================================
	 
      [] [conditional ident(X) S1 S2] then
	 local CondVarVal in
	    % ===================================
	    % Retrieve value from store
	    % ===================================
	    CondVarVal = {RetrieveFromSAS Env.X}
	    %{Browse CondVarVal}
	    
	    % ===================================
	    % If value of variable is equivalence(_)
	    % it means that it is unbound.
	    % ===================================
	    case CondVarVal of equivalence(_) then
	       raise unboundCondVar(X) end
	    [] literal(t) then
	       SemStack := {Append [semStmt(S1 Env)] @SemStack}
	    [] literal(f) then
	       SemStack := {Append [semStmt(S2 Env)] @SemStack}
	    else
	       raise illegalCondVar(X) end
	    end
	    {Interpretor}
	 end

	 % ======================================
	 % If top of stack is case stmt
	 % ======================================
	 
      [] [match ident(X) P S1 S2] then
	 local MatchVar in
	    MatchVar = {RetrieveFromSAS Env.X}
	    
	    case MatchVar of equivalence(_) then
	       raise unboundMatch(X) end
	       
	    [] [record Label FeatureList] then
	       case P of [record PLabel PFeatureList] then
		  if {And Label==PLabel {Length FeatureList}=={Length PFeatureList}} then
		     local PEnv in
			PEnv = {CreatePEnv Env FeatureList {Nth {SortRecord [record PLabel PFeatureList]} 3}}
			{Browse 'PEnv ======== '#PEnv}
			SemStack := {Append [semStmt(S1 PEnv)] @SemStack}
		     end
		  else
		     SemStack := {Append [semStmt(S2 Env)] @SemStack}
		  end
	       else
		  SemStack := {Append [semStmt(S2 Env)] @SemStack}
	       end
	    else
	       {Browse {Length MatchVar}}
	    end
	 end
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
%catch Error then
%   case Error of unboundCondVar(X) then {Browse X}{Browse "Unbound variable in conditional statement."}
%  else {Browse "Unknown Exception"}
%   end
%   {Browse "Quitting program. Bye"}
%end
{Browse 'Starting Interpretor'}
{Browse {Interpretor}}
{Browse 'Program succesfully terminated'}