declare
FList = [[literal(baz) literal(42)]
	 [literal(quux) literal(314)]
	 [literal(dash) literal(fuck)]
	]
PFList = [[literal(baz) literal(42)]
	  [literal(quux) literal(31)]
	  [literal(dash) literal(fuck)]
	 ]
Env = environment()
fun {Test Env FList PFList N}
    case FList of nil then
      case PFList of nil then Env end
   [] HFList|TFList then case PFList of HPFList|TPFList then
			    if HFList.1 == HPFList.1 then
			       local EnvTemp in
				  {Browse HFList.2.1#HPFList.2.1}
				  EnvTemp = {Adjoin Env environment(HPFList.2.1:N)}
				  {Browse EnvTemp}
				  {Test EnvTemp TFList TPFList N+1}
			       end
			    else
			       raise patternFeature(FList PFList) end
			    end
			 end
   end
end
{Browse {Test Env FList PFList 1}}



