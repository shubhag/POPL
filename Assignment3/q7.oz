local Barrier BarrierListLoop in
   proc {Barrier Procedures}
      fun {BarrierListLoop Procedures X}
	 if Procedures == nil then X
	 else
	    local M in
	       thread {Procedures.1} M= X end
	       {BarrierListLoop Procedures.2 M}
	    end
	 end
      end
      local A in
	 A = {BarrierListLoop Procedures unit}
	 {Wait A}
      end
   end
   local X Y Z in
      {Barrier [proc {$} X = 1 end
		proc {$} Y = X + 2 end
		proc {$} Z = X + Y end
		proc {$} {Browse Z} end
	       ]}
   end
   
end
