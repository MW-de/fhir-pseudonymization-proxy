/// 
Class FHIRPROXYPKG.RequestProcessor Extends Ens.BusinessProcessBPL
{

Parameter SETTINGS = "TargetFHIRServer:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},RequestPreprocessor:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},ResponsePayloadProcessor:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// The Business Process to send the FHIR bundle to.
Property TargetFHIRServer As Ens.DataType.ConfigName;

/// The Business Process that pre-processes the incoming request before it is dispatchd to the target FHIR server.
/// Can be used to perform a reverse lookup of pseudonymized IDs in the request.
Property RequestPreprocessor As Ens.DataType.ConfigName;

/// The Business Process that processes the response from the target FHIR server.
Property ResponsePayloadProcessor As Ens.DataType.ConfigName;

Storage Default
{
<Data name="RequestProcessorDefaultData">
<Subscript>"RequestProcessor"</Subscript>
<Value name="1">
<Value>TargetFHIRServer</Value>
</Value>
<Value name="2">
<Value>ResponsePayloadProcessor</Value>
</Value>
<Value name="3">
<Value>RequestPreprocessor</Value>
</Value>
</Data>
<DefaultData>RequestProcessorDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='HS.FHIRServer.Interop.Request' response='HS.FHIRServer.Interop.Response' height='2000' width='2000' >
<context>
<property name='PreprocessedRequest' type='HS.FHIRServer.Interop.Request' instantiate='0' />
<property name='OriginalResponse' type='HS.FHIRServer.Interop.Response' instantiate='0' />
</context>
<sequence xend='200' yend='1450' >
<switch name='RequestMethod' xpos='200' ypos='250' xend='200' yend='1350' >
<case condition='request.Request.RequestMethod = "GET"' name='GET' >
<empty name='Process incoming request' xpos='470' ypos='400' disabled="true"/>
<scope xpos='470' ypos='500' xend='470' yend='1250' >
<code name='Prepare request pre-processing' xpos='470' ypos='600' >
<annotation><![CDATA[- Clone original request
- save original SelfURL
- Retrieve target FHIR server base url]]></annotation>
<![CDATA[ set context.PreprocessedRequest = request.%ConstructClone(1)
 
 set context.PreprocessedRequest.Request.RequestFormatCode = context.PreprocessedRequest.Request.ResponseFormatCode
 set context.PreprocessedRequest.Request.RequestPath = "/" _ $zstrip(context.PreprocessedRequest.Request.RequestPath, "<", "/")
 
 
 set selfurl = context.PreprocessedRequest.Request.BaseURL _ context.PreprocessedRequest.Request.RequestPath _ "?" _ context.PreprocessedRequest.Request.QueryString
 
 // write SelfURL into AdditionalInfo
 do context.PreprocessedRequest.Request.AdditionalInfo.SetAt($zstrip(selfurl, ">", "?"), "SelfURL")
 
 
 // get the TargetBaseURL
 
 // retrieve ServiceName
 set targetservicename = ##class(Ens.Director).GetHostSettingValue(process.TargetFHIRServer, "ServiceName")
 set endpoint = ##class(HS.Registry.Service.HTTP).EndPointForNameType(targetservicename, "HTTP").EndPoint
 
 // write Endpoint into AdditionalInfo
 do context.PreprocessedRequest.Request.AdditionalInfo.SetAt(endpoint, "TargetBaseURL")
]]>
</code>
<call name='Pre-process request' target='@process.RequestPreprocessor' async='0' xpos='470' ypos='700' >
<request type='HS.FHIRServer.Interop.Request' >
<assign property="callrequest" value="context.PreprocessedRequest" action="set" />
</request>
<response type='HS.FHIRServer.Interop.Request' >
<assign property="context.PreprocessedRequest" value="callresponse" action="set" />
</response>
</call>
<call name='Target FHIRServer' target='@process.TargetFHIRServer' async='0' xpos='470' ypos='800' >
<request type='HS.FHIRServer.Interop.Request' >
<assign property="callrequest" value="context.PreprocessedRequest" action="set" />
</request>
<response type='HS.FHIRServer.Interop.Response' >
<assign property="context.OriginalResponse" value="callresponse" action="set" />
</response>
</call>
<call name='Process Response Payload' target='@process.ResponsePayloadProcessor' async='0' xpos='470' ypos='900' >
<request type='FHIRPROXYPKG.Message.PayloadProcessRequest' >
<assign property="callrequest.OriginalRequest" value="context.PreprocessedRequest" action="set" />
<assign property="callrequest.OriginalResponse" value="context.OriginalResponse" action="set" />
</request>
<response type='FHIRPROXYPKG.Message.PayloadProcessResponse' >
<assign property="response" value="callresponse.ProcessedResponse" action="set" />
</response>
</call>
<code name='Post-process request' xpos='470' ypos='1000' disabled="true">
<annotation><![CDATA[Placeholder]]></annotation>
</code>
<faulthandlers>
<catchall xpos='470' ypos='1100' xend='200' yend='350' >
<throw name='Rethrow' fault='$System.Status.GetOneStatusText(..%Context.%LastError,1)' xpos='200' ypos='250' />
</catchall>
</faulthandlers>
</scope>
</case>
<default name='default' >
<empty name='Not implemented' xpos='200' ypos='400' disabled="true">
<annotation><![CDATA[Methods other than GET are not supported atm]]></annotation>
</empty>
<code name='Prepare response' xpos='200' ypos='500' >
<![CDATA[ set response.Response.Status = 501]]>
</code>
</default>
</switch>
</sequence>
</process>
}

}

