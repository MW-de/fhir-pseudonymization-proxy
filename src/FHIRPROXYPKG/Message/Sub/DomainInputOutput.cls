Class FHIRPROXYPKG.Message.Sub.DomainInputOutput Extends FHIRPROXYPKG.Message.Sub.DomainAndInput
{

Property Output As %String(MAXLEN = "");

Storage Default
{
<Data name="DomainAndInputState">
<Value name="1">
<Value>Domain</Value>
</Value>
<Value name="2">
<Value>Input</Value>
</Value>
<Value name="3">
<Value>Output</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}

