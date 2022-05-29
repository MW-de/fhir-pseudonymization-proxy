/// 
Class FHIRPROXYPKG.ResponsePayloadProcessor Extends Ens.BusinessProcessBPL
{

Parameter SETTINGS = "PSNOperation:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},PseudonymizationDTL:Basic:dtlSelector,PSNService:Basic,PSNMode:Basic";

/// The Business Operation of the pseudonymization service to send pseudonymization requests to.
Property PSNOperation As Ens.DataType.ConfigName;

/// The DTL that shall perform pseudonymization of the FHIR Bundle.
Property PseudonymizationDTL As %String(MAXLEN = 255);

Property PSNService As %String(MAXLEN = "");

Storage Default
{
<Data name="ResponsePayloadProcessorDefaultData">
<Subscript>"ResponsePayloadProcessor"</Subscript>
<Value name="1">
<Value>PSNOperation</Value>
</Value>
<Value name="2">
<Value>PseudonymizationDTL</Value>
</Value>
<Value name="3">
<Value>PSNService</Value>
</Value>
</Data>
<DefaultData>ResponsePayloadProcessorDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='FHIRPROXYPKG.Message.PayloadProcessRequest' response='FHIRPROXYPKG.Message.PayloadProcessResponse' height='2000' width='2000' >
<context>
<property name='PSNInterface' type='FHIRPROXYPKG.Util.PSNInterface' instantiate='0' />
<property name='FHIRObj' type='HS.FHIR.DTL.vR4.Model.Base.Resource' instantiate='0' />
</context>
<sequence xend='200' yend='1100' >
<assign name="Init response" property="response.ProcessedResponse" value="request.OriginalResponse.%ConstructClone(1)" action="set" xpos='200' ypos='250' />
<if name='Payload' condition='request.OriginalResponse.QuickStreamId &apos;= ""' xpos='200' ypos='350' xend='200' yend='1000' >
<true>
<code name='Setup PSNInterface' xpos='470' ypos='500' >
<![CDATA[ set context.PSNInterface = ##class(FHIRPROXYPKG.Util.PSNInterface).%New(process.PSNService, "GetPseudonym", process, process.PSNOperation)
 
 ]]>
</code>
<code name='Import FHIR Resource from Stream' xpos='470' ypos='600' >
<![CDATA[ set qs = ##class(HS.SDA3.QuickStream).%OpenId(request.OriginalResponse.QuickStreamId)
 
 set context.FHIRObj = ##class(HS.FHIR.DTL.vR4.Model.Base.Resource).FromJSON(qs,"vR4")]]>
</code>
<code name='Scan bundle for PSNs' xpos='470' ypos='700' >
<annotation><![CDATA[Invoke DTL: Bundle to BundlePSN
First pass: scan for pseudonyms
pass PSNInterface via aux("PSNInterface")]]></annotation>
<![CDATA[ set context.PSNInterface.Mode = "PassThrough"
 set aux("PSNInterface") = context.PSNInterface
 
 // Invoke DTL
 
 set tSC = $classmethod(process.PseudonymizationDTL, "Transform", context.FHIRObj, .bundleout, .aux)
 
 $$$ThrowOnError(tSC)]]>
</code>
<code name='Transform Bundle via DTL' xpos='470' ypos='800' >
<annotation><![CDATA[Invoke DTL: Bundle to BundlePSN
Second pass: perform pseudonymization]]></annotation>
<![CDATA[ set context.PSNInterface.Mode = "GetPseudonym"
 set aux("PSNInterface") = context.PSNInterface
 

 set aux("ProxyBaseURL")  = request.OriginalRequest.Request.BaseURL
 set aux("SelfURL")       = request.OriginalRequest.Request.AdditionalInfo.GetAt("SelfURL") 
 set aux("TargetBaseURL") = request.OriginalRequest.Request.AdditionalInfo.GetAt("TargetBaseURL")
 
 // invoke DTL
 
 set tSC = $classmethod(process.PseudonymizationDTL, "Transform", context.FHIRObj, .bundleout, .aux)
 $$$ThrowOnError(tSC)
 
 set context.FHIRObj = bundleout
 
]]>
</code>
<code name='Prepare response' xpos='470' ypos='900' >
<![CDATA[ set qs = ##class(HS.SDA3.QuickStream).%New()
 do qs.CopyFrom(context.FHIRObj.ToJSON())
 
 set response.ProcessedResponse.QuickStreamId = qs.%Id()]]>
</code>
</true>
<false>
<empty name='Do nothing' xpos='200' ypos='500' />
</false>
</if>
</sequence>
</process>
}

}

