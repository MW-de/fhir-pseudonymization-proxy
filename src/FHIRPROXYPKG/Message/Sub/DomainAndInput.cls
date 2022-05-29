Class FHIRPROXYPKG.Message.Sub.DomainAndInput Extends (%SerialObject, %XML.Adaptor)
{

/// The pseudonymization domain to use. Optional.
Property Domain As %String(MAXLEN = "");

/// The input value to (de-)pseudonymize.
Property Input As %String(MAXLEN = "") [ Required ];

Storage Default
{
<Data name="DomainAndInputState">
<Value name="1">
<Value>Domain</Value>
</Value>
<Value name="2">
<Value>Input</Value>
</Value>
</Data>
<State>DomainAndInputState</State>
<StreamLocation>^FHIRPROXYPK476C.DomainAndInputS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

