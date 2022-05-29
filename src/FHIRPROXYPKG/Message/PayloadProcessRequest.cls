Class FHIRPROXYPKG.Message.PayloadProcessRequest Extends Ens.Request
{

Property OriginalRequest As HS.FHIRServer.Interop.Request;

Property OriginalResponse As HS.FHIRServer.Interop.Response;

Storage Default
{
<Data name="PayloadProcessRequestDefaultData">
<Subscript>"PayloadProcessRequest"</Subscript>
<Value name="1">
<Value>OriginalRequest</Value>
</Value>
<Value name="2">
<Value>OriginalResponse</Value>
</Value>
</Data>
<DefaultData>PayloadProcessRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

