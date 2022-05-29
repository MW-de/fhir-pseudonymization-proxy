Class FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Patient.Patient Extends Ens.DataTransformDTL [ DependsOn = HS.FHIR.DTL.vR4.Model.Resource.Patient ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Patient' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Patient' create='new' language='objectscript' >
<subtransform class='FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Generic.Generic' targetObj='target' sourceObj='source' aux='.aux' />
<group>
<annotation>Dates</annotation>
<if condition='source.birthDate &apos;= ""' >
<true>
<assign value='..SubString(source.birthDate,1,8)_15' property='target.birthDate' action='set' />
</true>
</if>
<if condition='source.deceasedDateTime &apos;= ""' >
<true>
<assign value='..SubString(source.deceasedDateTime,1,8)_15' property='target.deceasedDateTime' action='set' />
</true>
</if>
</group>
<group>
<annotation>Name</annotation>
<assign value='""' property='target.name' action='set' />
<assign value='"PSEUDONYMIZED"' property='target.name.(1).family' action='set' />
<assign value='""' property='target.name.(1).given' action='set' />
<assign value='""' property='target.name.(1).use' action='set' />
</group>
<group>
<annotation>Address</annotation>
<assign value='""' property='target.address' action='set' />
<assign value='""' property='target.address.(1).line.(1)' action='set' />
<assign value='..SubString(source.address.(1).postalCode,1,3)' property='target.address.(1).postalCode' action='set' />
<assign value='""' property='target.address.(1).city' action='set' />
<assign value='"temp"' property='target.address.(1).use' action='set' />
</group>
<group>
<annotation>Other Properties</annotation>
<assign value='' property='target.telecom' action='clear' />
<assign value='' property='target.contact' action='clear' />
<assign value='' property='target.photo' action='clear' />
<assign value='' property='target.generalPractitioner' action='clear' />
</group>
</transform>
}

}

