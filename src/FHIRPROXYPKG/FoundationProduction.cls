Class FHIRPROXYPKG.FoundationProduction Extends Ens.Production [ Not ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="FHIRPROXYPKG.FoundationProduction" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="Ens.Activity.Operation.Local" Category="" ClassName="Ens.Activity.Operation.Local" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="InteropOperation" Category="" ClassName="HS.FHIRServer.Interop.DummyOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="InteropService" Category="" ClassName="HS.FHIRServer.Interop.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">RequestProcessor</Setting>
    <Setting Target="Host" Name="Timeout">300</Setting>
  </Item>
  <Item Name="Target FHIRServer" Category="" ClassName="HS.FHIRServer.Interop.HTTPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Host" Name="ServiceName">IRIS FHIRREPO</Setting>
  </Item>
  <Item Name="RequestProcessor" Category="" ClassName="FHIRPROXYPKG.RequestProcessor" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TargetFHIRServer">Target FHIRServer</Setting>
    <Setting Target="Host" Name="ResponsePayloadProcessor">ResponsePayloadProcessor</Setting>
    <Setting Target="Host" Name="RequestPreprocessor">RequestPreprocessor</Setting>
  </Item>
  <Item Name="ResponsePayloadProcessor" Category="" ClassName="FHIRPROXYPKG.ResponsePayloadProcessor" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="PSNOperation">PseudonymizationOperation</Setting>
    <Setting Target="Host" Name="PseudonymizationDTL">FHIRPROXYPKG.DTL.FHIR.vR4.vR4PSN.Resource.Resource</Setting>
  </Item>
  <Item Name="PseudonymizationOperation" Category="" ClassName="FHIRPROXYPKG.PseudonymizationOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="RequestPreprocessor" Category="" ClassName="FHIRPROXYPKG.RequestPreprocessor" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="PSNOperation">PseudonymizationOperation</Setting>
    <Setting Target="Host" Name="PreprocessingDTL">FHIRPROXYPKG.DTL.FHIR.Request.RequestPSN</Setting>
  </Item>
</Production>
}

}

