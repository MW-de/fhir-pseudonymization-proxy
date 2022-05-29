/// 
Class FHIRPROXYPKG.RequestPreprocessor Extends Ens.BusinessProcessBPL
{

Parameter SETTINGS = "PSNOperation:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},PreprocessingDTL:Basic:dtlSelector,PSNService:Basic,PSNMode:Basic";

/// The Business Operation of the pseudonymization service to send pseudonymization requests to.
Property PSNOperation As Ens.DataType.ConfigName;

/// The DTL that shall perform pseudonymization of the FHIR Bundle.
Property PreprocessingDTL As %String(MAXLEN = 255);

Property PSNService As %String(MAXLEN = "");

Storage Default
{
<Data name="RequestPreprocessorDefaultData">
<Subscript>"RequestPreprocessor"</Subscript>
<Value name="1">
<Value>PSNOperation</Value>
</Value>
<Value name="2">
<Value>PreprocessingDTL</Value>
</Value>
<Value name="3">
<Value>PSNService</Value>
</Value>
</Data>
<DefaultData>RequestPreprocessorDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='HS.FHIRServer.Interop.Request' response='HS.FHIRServer.Interop.Request' height='2000' width='2000' >
<context>
<property name='PSNInterface' type='FHIRPROXYPKG.Util.PSNInterface' instantiate='0' />
</context>
<sequence xend='200' yend='900' >
<scope xpos='200' ypos='250' xend='200' yend='800' >
<code name='Setup PSNInterface' xpos='200' ypos='350' >
<![CDATA[ set context.PSNInterface = ##class(FHIRPROXYPKG.Util.PSNInterface).%New(process.PSNService, "GetValue", process, process.PSNOperation)]]>
</code>
<code name='Scan bundle for PSNs' xpos='200' ypos='450' >
<annotation><![CDATA[Invoke DTL: Bundle to BundlePSN
First pass: scan for pseudonyms
pass PSNInterface via aux("PSNInterface")]]></annotation>
<![CDATA[ set context.PSNInterface.Mode = "PassThrough"
 set aux("PSNInterface") = context.PSNInterface
 
 set tSC = $classmethod(process.PreprocessingDTL, "Transform", request, .reqout, .aux)
 
 $$$ThrowOnError(tSC)]]>
</code>
<code name='Transform Request via DTL' xpos='200' ypos='550' >
<![CDATA[ set context.PSNInterface.Mode = "GetValue"
 set aux("PSNInterface") = context.PSNInterface
 
 set tSC = $classmethod(process.PreprocessingDTL, "Transform", request, .reqout, .aux)
 $$$ThrowOnError(tSC)
 
 set response = reqout
 
]]>
</code>
<faulthandlers>
<catchall xpos='200' ypos='650' xend='200' yend='350' >
<throw name='Rethrow' fault='$System.Status.GetOneStatusText(..%Context.%LastError,1)' xpos='547' ypos='186' />
</catchall>
</faulthandlers>
</scope>
</sequence>
</process>
}

}

