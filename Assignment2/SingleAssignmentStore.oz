declare
SAS = {Dictionary.new}

%Retrieve a value from the single assignment store. This will raise an exception if the key is missing from the SAS. For unbound keys, this will return equivalence(Key) -- this is guaranteed to be the same for two keys in the same equivalence set.
fun {RetrieveFromSAS Key}
   local Keyvalue = {Dictionary.get SAS Key} in
      case Keyvalue
      of unbound then equivalence(Keyvalue)
      [] equivalence(Y) then {RetrieveFromSAS Y}
      else Keyvalue
      end
   end
end

%If the key is unbound, then bind a reference to another key to a key in the SAS.
fun {BindRefToKeyInSAS Key RefKey}
   local Keyvalue = {Dictionary.get SAS Key} in
      case Keyvalue
      of unbound then {Dictionary.put SAS Key equivalence(RefKey)}
      [] equivalence(T) then {BindRefToKeyInSAS T RefKey}
      else raise error() end
	 
      end
   end
end

%If Key is unbound (value is part of an equivalence set) bind Val to a key in the SAS. Should raise an exception alreadyAssigned(Key Val CurrentValue) if the key is bound.
fun {BindValueToKeyInSAS Key Val}
   local Keyvalue = {Dictionary.get SAS Key} in
      case Keyvalue
      of unbound then {Dictionary.put SAS Key Val }
      [] equivalence(T) then {BindValueToKeyInSAS T Val}
      else raise alreadyAssigned(Key Val Keyvalue) end
      end
   end
end

      