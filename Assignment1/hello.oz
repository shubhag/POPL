functor
import
    Browser(browse:Browse)
    System(showInfo:Print)

define
    local Take in
    	fun {Take Xs N}
    		if N < 1 then nil
    		else 
    			case Xs
    			of nil then nil
    			[] H|T then H|{Take T N-1}
    			end
    		end
    	end
%    	{Browse {Take [1 2 3] ~2}}
    end

    local Drop Length in
    	fun {Length Xs}
    		case Xs
    		of nil then 0
    		[] H|T then 1+ {Length T}
    		end
    	end

    	fun {Drop Xs N}
    		if N < 1 then Xs
    		elseif N > {Length Xs} then nil
    		elseif N == {Length Xs} then Xs
    		else {Drop Xs.2 N}
    		end
    	end
%    	{Browse {Drop [1 2 3] 0 }}
    end

    local Merge Length in
    	fun {Merge Xs Ys}
    		if Xs == nil then Ys
    		elseif Ys == nil then Xs
    		else
    			if Xs.1 < Ys.1 then Xs.1 | {Merge Xs.2 Ys}
    			else Ys.1 | {Merge Xs Ys.2}
    			end
    		end
    	end
%    	{Browse {Merge [4 8] [2 3 8 10 11]}}
    end

    local ZipWith BinOp in
    	fun {BinOp A B}
    		A * B
    	end

    	fun {ZipWith BinOp Xs Ys}
    		if Xs == nil then Ys
    		elseif Ys == nil then Xs
    		else
    			{BinOp Xs.1 Ys.1} | {ZipWith BinOp Xs.2 Ys.2}
    		end
    	end

%    	{Browse {ZipWith BinOp [1 2 3 4] [2 3 4 5 6 ]}}
    end

    local FoldR in
    	
    end
end