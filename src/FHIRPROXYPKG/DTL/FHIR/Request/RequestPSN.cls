Class FHIRPROXYPKG.DTL.FHIR.Request.RequestPSN Extends Ens.DataTransformDTL [ DependsOn = HS.FHIRServer.Interop.Request ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIRServer.Interop.Request' targetClass='HS.FHIRServer.Interop.Request' create='copy' language='objectscript' >
<group expanded='false' >
<annotation>Determine requestResourceType</annotation>
<assign value='"/([A-Z][:alpha:]*)((/).*)?"' property='regex' action='set' />
<assign value='##class(%Regex.Matcher).%New(regex, target.Request.RequestPath)' property='matcher' action='set' />
<if condition='matcher.Locate()'  expanded='false' >
<true>
<assign value='matcher.GroupGet(1)' property='requestResourceType' action='set' />
</true>
</if>
</group>
<group>
<annotation>Process RequestPath for /Resource/[id]...</annotation>
<assign value='"/([:alpha:]+)/([-[:alnum:]]+)([/\?].*)?"' property='regex' action='set' />
<assign value='##class(%Regex.Matcher).%New(regex, target.Request.RequestPath)' property='matcher' action='set' />
<if condition='matcher.Locate()'  expanded='false' >
<true>
<assign value='matcher.GroupGet(1)' property='requestResourceType' action='set' />
<assign value='matcher.GroupGet(1) _ "/" _ matcher.GroupGet(2)' property='resourceRef' action='set' />
<assign value='aux("PSNInterface").GetPseudonymOrValue(resourceRef)' property='psn' action='set' />
<if condition='$piece(psn, "/", 2) = ""'  expanded='false' >
<annotation>if PSN not found</annotation>
<true>
<code>
<![CDATA[ return $$$ERROR($$$GeneralError, "Could not resolve pseudonym " _ resourceRef _ ". Query failed.")]]></code>
</true>
</if>
<assign value='$replace(target.Request.RequestPath, resourceRef, psn)' property='target.Request.RequestPath' action='set' />
</true>
</if>
</group>
<group>
<annotation>Process QueryString</annotation>
<assign value='##class(HS.FHIRServer.Utils).URLParamStringToArray(target.Request.QueryString, .urlparams)' property='tSC' action='set' />
<group expanded='false' >
<annotation>references: 

subject=[Patient]/[id]
patient=[Patient]/[id]
_id=[Patient]/[id]</annotation>
<assign value='##class(FHIRPROXYPKG.Util.ArrayUtils).ListFromString("_id,patient,subject")' property='parameters' action='set' />
<foreach property='parameters' key='k1'  expanded='false' >
<assign value='parameters.GetAt(k1)' property='param' action='set' />
<if condition='urlparams.GetAt(param) &apos;= ""'  expanded='false' >
<true>
<assign value='$zconvert($lg(urlparams.GetAt(param), 1), "I", "URL")' property='value' action='set' />
<assign value='"([:alpha:]+/)?([-[:alnum:]]+)"' property='regex' action='set' />
<assign value='##class(%Regex.Matcher).%New(regex, value)' property='matcher' action='set' />
<if condition='matcher.Locate()'  expanded='false' >
<true>
<group expanded='false' >
<annotation>Determine idType</annotation>
<assign value='$zstrip(matcher.GroupGet(1), "&gt;", "/")' property='prefix' action='set' />
<assign value='prefix' property='idType' action='set' />
<if condition='idType = ""'  expanded='false' >
<annotation>idType must be inferred. The following is a simplification and does not offer full FHIR search support.</annotation>
<true>
<if condition='(param = "subject") || (param = "patient")'  expanded='false' >
<true>
<assign value='"Patient"' property='idType' action='set' >
<annotation>Note: this is a simplification and does not offer full FHIR search support.</annotation>
</assign>
</true>
<false>
<assign value='requestResourceType' property='idType' action='set' >
<annotation>Note: this is a simplification and does not offer full FHIR search support.</annotation>
</assign>
</false>
</if>
</true>
</if>
</group>
<assign value='idType _ ".id"' property='idType' action='set' >
<annotation>defaults to defaultResourceType. Note: this is a simplification and does not offer full FHIR search support.</annotation>
</assign>
<assign value='matcher.GroupGet(2)' property='idValue' action='set' />
<assign value='aux("PSNInterface").GetPseudonymOrValue(idValue, idType)' property='psn' action='set' />
<if condition='psn = ""'  expanded='false' >
<true>
<code>
<![CDATA[ return $$$ERROR($$$GeneralError, "Could not resolve pseudonym " _ idType _ "/" _ idValue _ ". Query failed.")]]></code>
</true>
</if>
<if condition='prefix &apos;= ""'  expanded='false' >
<annotation>Prepend prefix if it was given in the request</annotation>
<true>
<assign value='prefix _ "/" _ psn' property='psn' action='set' />
</true>
</if>
<assign value='urlparams.SetAt($lb($zconvert(psn, "O", "URL")), param)' property='tSC' action='set' />
</true>
<false>
<code>
<![CDATA[ return $$$ERROR($$$GeneralError, "Invalid parameter: " _ value _ ". Query failed.")]]></code>
</false>
</if>
</true>
</if>
</foreach>
</group>
<group expanded='false' >
<annotation>identifier</annotation>
<assign value='"identifier"' property='param' action='set' />
<if condition='urlparams.GetAt(param) &apos;= ""'  expanded='false' >
<true>
<assign value='$zconvert($lg(urlparams.GetAt(param), 1), "I", "URL")' property='value' action='set' />
<assign value='$piece(value, "|", *)' property='idValue' action='set' >
<annotation>supporting the [system|]value syntax.</annotation>
</assign>
<assign value='requestResourceType _ "." _ param' property='idType' action='set' >
<annotation>[Resource].identifier</annotation>
</assign>
<assign value='aux("PSNInterface").GetPseudonymOrValue(idValue, idType)' property='psn' action='set' />
<if condition='psn = ""'  expanded='false' >
<true>
<code>
<![CDATA[ return $$$ERROR($$$GeneralError, "Could not resolve pseudonym " _ idType _ "/" _ idValue _ ". Query failed. value is:"_value_"!param is:"_urlparams.GetAt(param))]]></code>
</true>
</if>
<assign value='psn' property='$piece(value,"|",*)' action='set' >
<annotation>update value in-place, supporting the [system|]value syntax.</annotation>
</assign>
<assign value='urlparams.SetAt($lb($zconvert(value, "O", "URL")), param)' property='tSC' action='set' />
</true>
</if>
</group>
<assign value='##class(HS.FHIRServer.Utils).URLParameterArrayToString(urlparams)' property='target.Request.QueryString' action='set' />
</group>
</transform>
}

}

