Class FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.OperationOutcome.OperationOutcome Extends Ens.DataTransformDTL [ DependsOn = HS.FHIR.DTL.vR4.Model.Resource.OperationOutcome ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.OperationOutcome' targetClass='HS.FHIR.DTL.vR4.Model.Resource.OperationOutcome' create='copy' language='objectscript' >
<annotation>Passes-through the OperationOutcome. WARNING: This may leak psn &lt;&gt; value pairs. Filtering may be implemented here.</annotation>
</transform>
}

}

