Class FHIRPROXYPKG.Message.PseudonymizationRequest Extends Ens.Request
{

/// Mode, usually "GetPseudonym" or "GetValue", but can be any value.
/// It is up to the target to act according to the specified Mode.
Property Mode As %String;

/// Which pseudonymization service to use.
/// It is up to the target to forward the request accordingly.
Property PSNService As %String(MAXLEN = "");

/// The actual pseudonymization requests, each with a domain and an input value
Property Requests As list Of FHIRPROXYPKG.Message.Sub.DomainAndInput;

Storage Default
{
<Data name="PseudonymizationRequestDefaultData">
<Subscript>"PseudonymizationRequest"</Subscript>
<Value name="1">
<Value>Mode</Value>
</Value>
<Value name="2">
<Value>PSNService</Value>
</Value>
<Value name="3">
<Value>Requests</Value>
</Value>
</Data>
<DefaultData>PseudonymizationRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

