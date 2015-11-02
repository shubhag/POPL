local LazyAppend LazyQuicksort Partition Xs Ys in
   fun lazy {LazyAppend Xs Ys}
      if Xs == nil then Ys
      else Xs.1 | {Append Xs.2 Ys}
      end
   end
   local Xs Ys Zs in
      Xs = [2 3 4 8 5]
      Ys = [9 0 87 5]
      Zs = {LazyAppend Xs Ys}
      {Browse Zs.2.2.2.2.2.2.1}
   end

   proc {Partition Xs Pivot Left Right}
      case Xs
      of X|Xr then
	 if X < Pivot
	 then Ln in
	    Left = X | Ln
	    {Partition Xr Pivot Ln Right}
	 else Rn in
	    Right = X | Rn
	    {Partition Xr Pivot Left Rn}
	 end
      [] nil then
	 Left=nil
	 Right=nil
      end
   end
   
   fun lazy {LazyQuicksort Xs}
      case Xs of X|Xr then Left Right SortedLeft SortedRight in
	 {Partition Xr X Left Right}
	 {LazyAppend {LazyQuicksort Left} X|{LazyQuicksort Right}}
      [] nil then nil
      end
   end
   Xs = {LazyQuicksort [5 8 4 7 3 2 7 6 0 5 4 1 0 4]}
   {Browse Xs.2.2.2.2.2.1}
end


