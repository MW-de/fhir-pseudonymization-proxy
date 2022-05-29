Class FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Procedure.Procedure Extends Ens.DataTransformDTL [ DependsOn = HS.FHIR.DTL.vR4.Model.Resource.Procedure ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Procedure' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Procedure' create='new' language='objectscript' >
<subtransform class='FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Generic.Generic' targetObj='target' sourceObj='source' aux='.aux' />
<foreach property='target.reasonReference()' key='k1' >
<assign value='aux("PSNInterface").GetIfNonEmpty(target.reasonReference.(k1).reference)' property='target.reasonReference.(k1).reference' action='set' />
</foreach>
</transform>
}

}

