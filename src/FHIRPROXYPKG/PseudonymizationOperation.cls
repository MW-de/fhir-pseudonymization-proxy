/// BusinessOperation which receives a PseudonymizationRequest and returns pseudonyms.
/// 
/// This is an example which implements its own (simple) pseudonymization method via hashing
/// and persistence of hashed pseudonyms in a global (^PseudonymD) for reverse lookup.
/// 
/// Real applications will implement a more sophisticated pseudonymization stragegy
/// or pass the request to an external pseudonymization service.
Class FHIRPROXYPKG.PseudonymizationOperation Extends Ens.BusinessOperation
{

Method PseudonymizationRequest(pInput As FHIRPROXYPKG.Message.PseudonymizationRequest, Output pOutput As FHIRPROXYPKG.Message.PseudonymizationResponse) As %Status
{
	set mode = $select((pInput.Mode = "GetPseudonym"): 1, (pInput.Mode = "GetValue"): 2, 1: 0)
	
	if (mode = 0) return $$$ERROR($$$GeneralError, "Unsupported Mode: " _ pInput.Mode)

	set pOutput = ##class(FHIRPROXYPKG.Message.PseudonymizationResponse).%New()

	#dim req As FHIRPROXYPKG.Message.Sub.DomainAndInput
	#dim ret As FHIRPROXYPKG.Message.Sub.DomainInputOutput

	for i=1:1:pInput.Requests.Count() {
		set req = pInput.Requests.GetAt(i)
		
		// in this example, the PSNService is used as a hash secret (salt)
		if (mode = 1) set output = ..CreateAndStorePseudonym(req.Domain, req.Input, pInput.PSNService)
		if (mode = 2) set output = ..GetOriginalValue(req.Domain, req.Input)
		
		
		set ret = ##class(FHIRPROXYPKG.Message.Sub.DomainInputOutput).%New()
		set ret.Domain = req.Domain
		set ret.Input  = req.Input
		set ret.Output = output
		
		do pOutput.Results.Insert(ret)
	}
	
	return $$$OK
}

ClassMethod CreateAndStorePseudonym(pDomain As %String, pInput As %String, pSecret As %String) As %String
{
	// create pseudonym. in this example, the domain is preprended to the input
	set psn = ..CalculateHash(pDomain _ "/" _ pInput, pSecret)
	
	// store in reverse lookup table
	set ^PseudonymD(pDomain, psn) = pInput
	
	return psn
}

ClassMethod GetOriginalValue(pDomain As %String, pInput As %String) As %String
{
	return $get(^PseudonymD(pDomain, pInput))
}

ClassMethod CalculateHash(pInput As %String, pHashSecret As %String, psnLength As %Numeric = 12, psnPrefix As %String = "PSN-") As %String
{
	return psnPrefix _ $extract(..HMACHashString(pInput, pHashSecret), 1, psnLength)
}

/// Calculate the HMAC-SHA from pInput and pSecret and outputs the hex representation of its bytes.
ClassMethod HMACHashString(pInput As %String(MAXLEN=""), pSecret As %String(MAXLEN="")) As %String
{
	return $zconvert(..StringToHex($SYSTEM.Encryption.HMACSHA(160, pInput, pSecret)), "L")
}

/// Converts a string to the hex representation of its bytes
/// from: https://community.intersystems.com/post/sha-512-seems-be-wrong
ClassMethod StringToHex(pInput As %String(MAXLEN="")) As %String
{
	set hashHex=""
	for i=1:1:$l(pInput) set hashHex = hashHex _ $translate($justify($zhex($a(pInput,i)),2)," ","0")
	return hashHex
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="FHIRPROXYPKG.Message.PseudonymizationRequest">
        <Method>PseudonymizationRequest</Method>
    </MapItem>
</MapItems>
}

}

