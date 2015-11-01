local WaitForBound CheckAll CheckAllUnbound Nselect AllFalse GetTrueList in
   fun {CheckAllUnbound Xs N}
      if N == 1 then true
      else
	 case Xs.1 of
	    A#B then if {Value.isDet A} then false
		     else {CheckAllUnbound Xs.2 N-1}
		     end
	 end
      end
   end
   
   fun {CheckAll Xs}
      if {CheckAllUnbound Xs {List.length Xs}} == false  then true
      else {CheckAll Xs}
      end
   end
   
   fun {WaitForBound Xs}
      local S in
	 thread S = {CheckAll Xs} end
      end
   end

   % fun {Lucky Xs}
   %    if {WaitForBound Xs} == true
   %    then true
   %    else false
   %    end
   % end

   fun {AllFalse Xs N}
      if N == 1 then true
      else
	 case Xs.1 of
	    C#D then
	    if C == true then false
	    else {AllFalse Xs.2 N-1}
	    end
	 end
      end
   end

   fun {GetTrueList Xs N}
      if N == 1 then nil
      else
	 case Xs.1 of
	    C#D then
	    if {Value.isDet C} == true then
	       if C == true then Xs.1 | {GetTrueList Xs.2 N-1}
	       else {GetTrueList Xs.2 N-1}
	       end
	    else
	       {GetTrueList Xs.2 N-1}
	    end
	 end
      end
   end
   
   % fun {NSelect Xs}
   %    if {WaitForBound Xs} == true then
   % 	 local Y B in
   % 	    if {AllFalse Xs {List.length Xs}} == true then
   % 	       Y = {List.nth Xs {List.length Xs}}
   % 	       case Y
   % 	       of C#D then D
   % 	       end
   % 	    else
   % 	       A = {GetTrueList Xs {List.length Xs}}
   % 	       B = {Int.'mod' {OS.rand}  {List.length A}} + 1
   % 	       Y = {List.nth A B}
   % 	       case Y
   % 	       of C#D then D
   % 	       end
   % 	    end
   % 	 end
   %    end	         
   % end
   fun {Nselect Xs}
      if {WaitForBound Xs} == true then
	 local X Y Z in
	    if {AllFalse Xs {List.length Xs}} == true then
	       Z = {List.nth Xs {List.length Xs}}
	       case Z of
		  C#D then D
	       end 
	    else
	       X = {GetTrueList Xs {List.length Xs}}
	       Y = {Int.'mod' {OS.rand}  {List.length X}} + 1
	       Z = {List.nth X Y}
	       case Z of
		  C#D then D
	       end	  
	    end
	 end
      else false
      end
   end

   local X Y Z A in
      A = [X#nil Y#nil Z#luck true#default]
      Z = X
      X = Y
      X = false
   %X =true
   %{Browse {AllFalse A {List.length A}}}
   %{Browse {GetTrueList A {List.length A}}}
   %{Browse A}
      {Browse {Nselect A}}
   end
end
	    
   
   