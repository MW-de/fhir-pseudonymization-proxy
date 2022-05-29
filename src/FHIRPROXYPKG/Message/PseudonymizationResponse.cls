Class FHIRPROXYPKG.Message.PseudonymizationResponse Extends Ens.Response
{

/// The pseudonymization reults, each with a domain, input and output value
Property Results As list Of FHIRPROXYPKG.Message.Sub.DomainInputOutput;

Storage Default
{
<Data name="PseudonymizationResponseDefaultData">
<Subscript>"PseudonymizationResponse"</Subscript>
<Value name="1">
<Value>Results</Value>
</Value>
</Data>
<DefaultData>PseudonymizationResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

