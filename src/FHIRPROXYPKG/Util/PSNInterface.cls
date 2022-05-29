/// Interface class to call a pseudonymization service (e.g. from a DTL).
///  
/// One instance should be created per pseudonymization process.
/// 
/// PSNInterface can be used in two passes for caching and bulk requests:
/// - First pass: Set Mode to "PassThrough" and call GetPseudonymOrValue to request all PSNs that will be needed
/// - Second pass: Set Mode to "GetPseudonym" or "GetValue" and call GetPseudonymOrValue again for each PSN.
///   The first call of GetPseudonymOrValue with a mode other than "PassThrough" will invoke bulk queries
///   of all cached requests. Subsequent requests will be served from cache.
/// 
/// PSNInterface accepts absolute references as input (e. g. http://fhir.server:port/url/fhir/Patient/1234)
/// but ALWAYS ouputs relative references (Patient/1234), even in PassThrough mode.
/// 
/// Throws exceptions on error.
Class FHIRPROXYPKG.Util.PSNInterface Extends %RegisteredObject
{

/// The pseudonymization service the PSNOperation should use.
/// Canonical URLs are the proposed format for this.
/// 
/// PSNService supports [:<domain>] placeholders, which will be replaced with the first matching input in <domain>.
/// Example: https://psn-service.org/providers/somerandomizer?context=[:Patient.id]
/// 
/// Retrieve substituted string via property PSNServiceString
Property PSNService As %String(MAXLEN = "");

/// The PSNService property with [:<domain>] replaced by the first <input> in domain found in the Cache
/// Used when calling the PSNOperation.
Property PSNServiceString As %String(MAXLEN = "") [ Calculated, Transient ];

/// One of: GetPseudonym, GetValue, PassThrough
/// PassThrough will return the requested <ID> unchanged, as in
/// - GetPseudonymOrValue("SomeDomain/<ID>")
/// - GetPseudonymOrValue("<ID>", "SomeDomain")
/// and write the requested ID to the cache.
/// To retrieve the PSNs/Values for the cached IDs in bulk,
/// change Mode to GetPseudonym or GetValue after caching
/// and call GetPseudonymOrValue again.
Property Mode As %String(VALUELIST = ",GetPseudonym,GetValue,PassThrough");

/// Reference to the Business Process to send messages
/// This is "process" in BPLs
Property BPRef As Ens.BusinessProcess;

/// The Business Operation of the pseudonymization service
Property PSNOperation As Ens.DataType.ConfigName;

/// The cache that holds previously queried pseudonyms or values
/// in form ..Cache(domain, input) = output
Property Cache [ MultiDimensional, Private ];

Method %OnNew(PSNService As %String(MAXLEN=""), Mode As %String(VALUELIST=",GetPseudonym,GetValue,PassThrough"), BPRef As Ens.BusinessProcess, PSNOperation As Ens.DataType.ConfigName) As %Status
{
	set ..PSNService = PSNService
	Set ..Mode = Mode
	Set ..BPRef = BPRef
	Set ..PSNOperation = PSNOperation
	
	return $$$OK
}

/// Calls GetPseudonymOrValue if input is non-empty to retrieve a PSN or a value.
/// Leading and trailing '"' will be removed
Method GetIfNonEmpty(input As %String, explicitIDType As %String = "") As %String
{
	set input = $zstrip(input, "<>", """")
 
	return:(input = "") ""
	
	return ..GetPseudonymOrValue(input, explicitIDType)
}

/// GetPseudonymOrValue is called to retrieve a PSN or a value.
/// 
/// ID Type may be given explicitly via explicitIDType, or implicitly by prefixing the input with <IDType>/
/// In the latter case, <IDType>.id is assumed as the explicitIDType.
/// 
/// Both will generate the same pseudonyms, but return values retain the prefix:
/// - GetPseudonymOrValue("Patient/123") => "Patient/<PSN>"
/// - GetPseudonymOrValue("123", "Patient.id") => "<PSN>"
/// 
/// Another typical usage:
/// - GetPseudonymOrValue("123", "Patient.MRN") => "<PSN for MRN>"
Method GetPseudonymOrValue(input As %String, explicitIDType As %String = "") As %String
{
	#dim fullDomain, IDType, inputID, outPrefix As %String
	
	set inputID = $piece(input, "/", *)	// ID is the last part of "[IDType/]ID"
	if (inputID = "") $$$ThrowStatus($$$ERROR($$$GeneralError, "PSNInterface: <input> was empty."))
		
	set outPrefix = ""

	if explicitIDType '= "" { // ID type was explicitly given
		set IDType =  explicitIDType
	}
	else {
		// implicit ID type expected, but there is none.
		if ($find(input,"/") < 3) { // Note: $find returns 3 if / is at position 2 (as in "P/1234")
			$$$ThrowStatus($$$ERROR($$$GeneralError, "PSNInterface: No IDType found for input " _ input))
		}
		
		// use the last-before piece of the input for IDType to support http://absolute.url/path/Patient/123 
		set IDType = $piece(input, "/", *-1) _ ".id" // per convention, append .id if PSN has been requested in <IDType>/123 format
		
		set outPrefix = $piece(input, "/", *-1) _ "/" // and prepend the original IDType to the output
	}
		

	set domain = IDType

		
	// Cache lookup. $get returns "" in case of missing entry.
	if ($get(..Cache(domain, inputID)) '= "") {
		// Cache hit: return cached output
		if (..Mode '= "PassThrough") return outPrefix _ ..Cache(domain, inputID)
	}
	else {
		// Create Cache entry with empty value for subsequent bulk requests
		Set ..Cache(domain, inputID) = ""
	}
	
	// if PassThrough, return the input unchanged
	if (..Mode = "PassThrough") return outPrefix _ inputID
	
	// otherwise, execute query and return the output value
	
	Do ..QueryAllInCache()
	
	if (..Cache(domain, inputID) = "<FAILED>") {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "PSNInterface: " _ ..Mode _ " for inputID " _ inputID _ " in domain " _ domain _ " has failed."))
	}
	
	// return the retreived output value
	return outPrefix _ ..Cache(domain, inputID)
}

Method QueryAllInCache() [ Private ]
{
	#dim tRequest As FHIRPROXYPKG.Message.PseudonymizationRequest = ..PseudonymizationRequestFromCache()
	
	if (tRequest.Requests.Count() = 0) return
	
	#dim tResponse As FHIRPROXYPKG.Message.PseudonymizationResponse
		
	// TODO: Check InProc invocation
	//if (..BPRef.#INVOCATION = "InProc") {
		// if (..Mode = "GetPseudonym") set tResponse = ..PSNTarget.xxxx(tRequest)
		// if (..Mode = "GetValue") set tResponse = ..PSNTarget.xxxx(tRequest)
	//}

	// Send request to pseudonymization service Business Operation in the name of ..BPRef
	Set tSC = ..BPRef.SendRequestSync(..PSNOperation, tRequest, .tResponse)
	
	$$$ThrowOnError(tSC)
	
	for i=1:1:tResponse.Results.Count() {
		Set domain = tResponse.Results.GetAt(i).Domain
		Set input  = tResponse.Results.GetAt(i).Input
		Set output = tResponse.Results.GetAt(i).Output
		
		// Save responses to Cache
		if (input '= "") Set ..Cache(domain, input) = output
	}
}

Method PseudonymizationRequestFromCache() As FHIRPROXYPKG.Message.PseudonymizationRequest [ Private ]
{
	// prepare request to PSNOperation
	#dim tRequest As FHIRPROXYPKG.Message.PseudonymizationRequest = ##class(FHIRPROXYPKG.Message.PseudonymizationRequest).%New() 
	set tRequest.Mode = ..Mode
	set tRequest.PSNService = ..PSNServiceString
	
	// return empty request if cache is empty
	if ($data(..Cache) = 0) return tRequest
	
	#dim tRequestEntry As FHIRPROXYPKG.Message.Sub.DomainAndInput
	
	// Iterate through ..Cache
	// $q and $qs is iterator magic of Multidimenional variables in ObjectScript
	// k1 and k2 are the first- and second-level iterators
	Set k1 = $qs($q(..Cache), 1)
	Set k2 = $qs($q(..Cache(k1)), 2)

	for {
		// Entries with value "" will be queried
		if (..Cache(k1, k2) = "") {
			set tRequestEntry = ##class(FHIRPROXYPKG.Message.Sub.DomainAndInput).%New()
			set tRequestEntry.Domain = k1
			set tRequestEntry.Input  = k2
		
			do tRequest.Requests.Insert(tRequestEntry)
		
			// set FAILED in case there is no response
			Set ..Cache(k1, k2) = "<FAILED>"
		}
		
		Set next = $q(..Cache(k1, k2))

		// exit for if end of Cache reached
		quit:(next = "")
		
		// move iterators forward
		Set k1 = $qs(next, 1)
		Set k2 = $qs(next, 2)
	}
	
	
	return tRequest
}

/// Implements calculated property PSNServiceString
/// See PSNService for details
Method PSNServiceStringGet() As %String
{
	set psnservice = ..PSNService
	set matcher = ##class(%Regex.Matcher).%New("\[:([-.\w]+)\]", psnservice)
	
	while matcher.Locate() {
		set domain = matcher.GroupGet(1)
		
		// $order returns first item, or "" if non-existent
		set replacement = $order(..Cache(domain, ""))
	
		set psnservice = $replace(psnservice, matcher.Group, replacement)
	}
	
	return psnservice
}

}

