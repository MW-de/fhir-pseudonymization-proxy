Class FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Consent.Consent Extends Ens.DataTransformDTL [ DependsOn = HS.FHIR.DTL.vR4.Model.Resource.Consent ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Consent' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Consent' create='new' language='objectscript' >
<subtransform class='FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Generic.Generic' targetObj='target' sourceObj='source' aux='.aux' />
</transform>
}

}

