Class FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Encounter.Encounter Extends Ens.DataTransformDTL [ DependsOn = HS.FHIR.DTL.vR4.Model.Resource.Encounter ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Encounter' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Encounter' create='copy' language='objectscript' >
<subtransform class='FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Generic.Generic' targetObj='target' sourceObj='source' aux='.aux' />
<if condition='target.partOf &apos;= ""' >
<true>
<assign value='aux("PSNInterface").GetIfNonEmpty(source.partOf.reference)' property='target.partOf.reference' action='set' />
<assign value='""' property='target.partOf.display' action='set' />
</true>
</if>
<foreach property='target.diagnosis()' key='k1' >
<assign value='aux("PSNInterface").GetIfNonEmpty(target.diagnosis.(k1).condition.reference)' property='target.diagnosis.(k1).condition.reference' action='set' />
</foreach>
<if condition='target.serviceProvider &apos;= ""' >
<true>
<assign value='aux("PSNInterface").GetIfNonEmpty(target.serviceProvider.reference)' property='target.serviceProvider.reference' action='set' />
</true>
</if>
<assign value='' property='target.participant' action='clear' />
<assign value='' property='target.episodeOfCare' action='clear' />
<assign value='' property='target.basedOn' action='clear' />
<assign value='' property='target.appointment' action='clear' />
<assign value='' property='target.reasonReference' action='clear' />
<assign value='' property='target.account' action='clear' />
</transform>
}

}

