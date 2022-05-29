Class FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Bundle.Bundle Extends Ens.DataTransformDTL [ DependsOn = HS.FHIR.DTL.vR4.Model.Resource.Bundle ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Bundle' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Bundle' create='new' language='objectscript' >
<comment>
<annotation>ProxyBaseURL, TargetBaseURL and SelfURL must be provided by the caller via aux to adjust the links in Bundle.link</annotation>
</comment>
<assign value='$get(aux("ProxyBaseURL"), "&lt;PROXYBASEURL MISSING&gt;")' property='proxyBaseUrl' action='set' />
<assign value='$get(aux("TargetBaseURL"), "&lt;TARGETBASEURL MISSING&gt;")' property='targetBaseUrl' action='set' />
<assign value='$get(aux("SelfURL"), "&lt;SELFURL MISSING&gt;")' property='selfUrl' action='set' />
<group expanded='false' >
<annotation>Properties to copy</annotation>
<assign value='source.id' property='target.id' action='set' />
<assign value='source.meta' property='target.meta' action='set' />
<assign value='source.implicitRules' property='target.implicitRules' action='set' />
<assign value='source.language' property='target.language' action='set' />
<assign value='source.identifier' property='target.identifier' action='set' />
<assign value='source.type' property='target.type' action='set' />
<assign value='source.timestamp' property='target.timestamp' action='set' />
<assign value='source.signature' property='target.signature' action='set' />
</group>
<group>
<annotation>Bundle.link</annotation>
<foreach property='source.link()' key='k1' >
<assign value='source.link.(k1).relation' property='target.link.(k1).relation' action='set' />
<if condition='source.link.(k1).relation = "self"' >
<true>
<assign value='selfUrl' property='target.link.(k1).url' action='set' />
</true>
<false>
<assign value='$replace(source.link.(k1).url, targetBaseUrl, proxyBaseUrl)' property='target.link.(k1).url' action='set' />
</false>
</if>
</foreach>
</group>
<assign value='source.total' property='target.total' action='set' />
<foreach property='source.entry()' key='k1' >
<assign value='k1' property='k2' action='set' />
<comment>
<annotation>Pseudonymize resource via subtransform</annotation>
</comment>
<subtransform class='FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Resource.Resource' targetObj='target.entry.(k2).resource' sourceObj='source.entry.(k1).resource' aux='.aux' />
<group>
<annotation>Construct new fullUrl to avoid leakage of the original id</annotation>
<assign value='""' property='target.entry.(k2).id' action='set' >
<annotation>entry.id should be empty anyway... ?</annotation>
</assign>
<assign value='""' property='newurl' action='set' />
<if condition='target.entry.(k2).resource.id &apos;= ""' >
<annotation>if the resource has an id set, generate a fullUrl from it</annotation>
<true>
<assign value='target.entry.(k2).resource.resourceType _ "/" _ target.entry.(k2).resource.id' property='newurl' action='set' />
<assign value='newurl' property='target.entry.(k2).fullUrl' action='set' />
</true>
</if>
</group>
<group>
<annotation>Copy Bundle.request, Bundle.search and Bundle.response</annotation>
<if condition='source.entry.(k1).request &apos;= ""' >
<true>
<assign value='source.entry.(k1).request' property='target.entry.(k2).request' action='set' />
<assign value='newurl' property='target.entry.(k2).request.url' action='set' />
</true>
<false>
<assign value='source.entry.(k1).search' property='target.entry.(k2).search' action='set' />
<assign value='source.entry.(k1).response' property='target.entry.(k2).response' action='set' />
</false>
</if>
</group>
</foreach>
</transform>
}

}

