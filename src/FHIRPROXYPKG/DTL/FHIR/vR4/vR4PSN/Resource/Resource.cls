Class FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Resource.Resource Extends Ens.DataTransformDTL [ DependsOn = HS.FHIR.DTL.vR4.Model.Base.Resource ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Base.Resource' targetClass='HS.FHIR.DTL.vR4.Model.Base.Resource' create='new' language='objectscript' >
<assign value='source.resourceType' property='resourceType' action='set' />
<assign value='$piece($classname($this), ".", 1, *-2) _ "." _ resourceType _ "." _ resourceType' property='DTL' action='set' >
<annotation>using $piece($classname($this), &quot;.&quot;, 1, *-2) to retrieve package name</annotation>
</assign>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId(DTL)' >
<true>
<comment>
<annotation>Delegate to the resource-specific DTL</annotation>
</comment>
<assign value='$classmethod(DTL, "Transform", source, .target, .aux)' property='tSC' action='set' />
</true>
<false>
<comment>
<annotation>If no specific DTL is defined, call the Generic DTL and issue a warning.</annotation>
</comment>
<assign value='$piece($classname($this), ".", 1, *-2) _ ".Generic.Generic"' property='DTL' action='set' >
<annotation>using $piece($classname($this), &quot;.&quot;, 1, *-2) to retrieve package name</annotation>
</assign>
<assign value='$classmethod(DTL, "Transform", source, .target, .aux)' property='tSC' action='set' />
<code>
<![CDATA[ do ##class(Ens.Util.Log).LogWarning($classname($this), "Transform", "No pseudonymization DTL is defined for resource " _ resourceType _ ". Using the Generic DTL. Sensitive data may be revealed.")]]></code>
</false>
</if>
</transform>
}

}

