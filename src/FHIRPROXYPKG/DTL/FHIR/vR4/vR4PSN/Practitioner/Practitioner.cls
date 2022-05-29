Class FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Practitioner.Practitioner Extends Ens.DataTransformDTL [ DependsOn = HS.FHIR.DTL.vR4.Model.Resource.Practitioner ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Practitioner' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Practitioner' create='new' language='objectscript' >
<subtransform class='FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Generic.Generic' targetObj='target' sourceObj='source' aux='.aux' />
<assign value='' property='target.name' action='clear' />
<assign value='"PSEUDONYMIZED"' property='target.name.(1).family' action='set' />
<assign value='' property='target.address' action='clear' />
<assign value='' property='target.telecom' action='clear' />
<assign value='""' property='target.birthDate' action='set' />
<assign value='' property='target.photo' action='clear' />
</transform>
}

}

