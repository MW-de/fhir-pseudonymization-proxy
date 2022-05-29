/// Extends the FHIRInteropAdapter (a %CSP.REST class) by inserting custom headers into the response
Class FHIRPROXYPKG.HS.FHIRServer.HC.FHIRInteropAdapter Extends HS.FHIRServer.HC.FHIRInteropAdapter
{

ClassMethod marshallResponseHeaders(pResponse As HS.FHIRServer.API.Data.Response) [ Internal ]
{
	do ##super(.pResponse)
	
	#dim %response As %CSP.Response
	Do %response.SetHeader("Via", "FHIR Proxy on " _ $system.Version.Format(4))
	
	Quit
}

}

