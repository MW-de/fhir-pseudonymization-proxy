Class FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Generic.Generic Extends Ens.DataTransformDTL [ DependsOn = HS.FHIR.DTL.vR4.Model.Base.Resource ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Base.Resource' targetClass='HS.FHIR.DTL.vR4.Model.Base.Resource' create='copy' language='objectscript' >
<assign value='source.resourceType' property='resourceType' action='set' />
<group>
<annotation>Resource.id</annotation>
<assign value='aux("PSNInterface").GetIfNonEmpty(target.id, resourceType_".id")' property='target.id' action='set' />
</group>
<group expanded='false' >
<annotation>Resource.identifier</annotation>
<assign value='"identifier"' property='property' action='set' />
<if condition='##class(%Dictionary.CompiledProperty).%ExistsId(target.%ClassName(1)_"||"_property)' >
<true>
<foreach property='target.identifier()' key='k1' >
<assign value='aux("PSNInterface").GetPseudonymOrValue(target.identifier.(k1).value,resourceType_"." _ property)' property='target.identifier.(k1).value' action='set' />
</foreach>
</true>
</if>
</group>
<group expanded='false' >
<annotation>Resource.subject</annotation>
<assign value='"subject"' property='property' action='set' />
<if condition='##class(%Dictionary.CompiledProperty).%ExistsId(target.%ClassName(1)_"||"_property)' >
<true>
<assign value='aux("PSNInterface").GetPseudonymOrValue(target.subject.reference)' property='target.subject.reference' action='set' />
<assign value='""' property='target.subject.display' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>Resource.patient</annotation>
<assign value='"patient"' property='property' action='set' />
<if condition='##class(%Dictionary.CompiledProperty).%ExistsId(target.%ClassName(1)_"||"_property)' >
<true>
<assign value='aux("PSNInterface").GetPseudonymOrValue(target.subject.reference)' property='target.patient.reference' action='set' />
<assign value='""' property='target.patient.display' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>Resource.encounter</annotation>
<assign value='"encounter"' property='property' action='set' />
<if condition='##class(%Dictionary.CompiledProperty).%ExistsId(target.%ClassName(1)_"||"_property)' >
<true>
<assign value='aux("PSNInterface").GetPseudonymOrValue(target.encounter.reference)' property='target.encounter.reference' action='set' />
<assign value='""' property='target.encounter.display' action='set' />
</true>
</if>
</group>
</transform>
}

}

