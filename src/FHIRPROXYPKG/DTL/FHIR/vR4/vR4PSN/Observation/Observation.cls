Class FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Observation.Observation Extends Ens.DataTransformDTL [ DependsOn = HS.FHIR.DTL.vR4.Model.Resource.Observation ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Observation' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Observation' create='new' language='objectscript' >
<subtransform class='FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Generic.Generic' targetObj='target' sourceObj='source' aux='.aux' />
</transform>
}

}

