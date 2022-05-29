Class FHIRPROXYPKG.Util.ArrayUtils Extends Ens.Rule.FunctionSet
{

/// Replaces the values in Array with the values at Array2(value1)
ClassMethod ArrayReplaceValues(Array1 As %ArrayOfDataTypes, Array2 As %ArrayOfDataTypes) As %ArrayOfDataTypes
{
	Do ..ArrayReplaceValuesInPlace(.Array1, .Array2)
	return Array1
}

/// Replaces the values in Array with the values at Array2(value1)
ClassMethod ArrayReplaceValuesInPlace(ByRef Array1 As %ArrayOfDataTypes, ByRef Array2 As %ArrayOfDataTypes) As %Status
{
	set key = ""
	While (Array1.Next(key) '= "") {
		Set key = Array1.Next(key)
		Set value1 = Array1.GetAt(key)
		
		if (Array2.IsDefined(value1)) Do Array1.SetAt(Array2.GetAt(value1), key)
	}
	
	return $$$OK
}

/// Alias for CopyToCollection for compatibility
ClassMethod CopyToList(pInput As %Collection.AbstractIterator, ByRef pTarget As %Collection.AbstractList) As %Status
{
	return ..CopyToCollection(pInput, .pTarget)
}

/// Copies the contents of List or Array <pInput> to List or Array <pTarget>
/// pInput can be anything that implements %Collection.AbstractIterator
/// pTarget must either extend %Collection.AbstractArray and implement SetAt(),
/// or support Insert().
ClassMethod CopyToCollection(pInput As %Collection.AbstractIterator, ByRef pTarget As %Collection.AbstractIterator) As %Status
{
	set targetIsArray = pTarget.%Extends("%Collection.AbstractArray")
	
	set key = ""
	while (pInput.Next(key) '= "") {
		set key = pInput.Next(key)
		set value = pInput.GetAt(key)
		
		if (targetIsArray) { do pTarget.SetAt(value, key) }
		else { do pTarget.Insert(value) }
	}
	
	return $$$OK
}

/// Splits a string into a %ListOfDataTypes
/// Strips whitespaces at the beginning and at the end of each item by default, as specified by <var>pStripParams</var>
/// Skips empty items by default, as specified by <var>pSkipEmpty</var>
ClassMethod ListFromString(pInput As %String(MAXLEN=""), pDelimiter As %String = ",", pStripParams As %String = "<>W", pSkipEmpty As %Boolean = 1) As %ListOfDataTypes
{
	set tResult = ##class(%ListOfDataTypes).%New()
	
	set lb = $listfromstring(pInput, pDelimiter)
	set ptr = 0
 
	while ($listnext(lb, ptr, value)) {
		set current = $zstrip(value, pStripParams)
		if (current '= "") || (pSkipEmpty = 0) {
			do tResult.Insert(current)
		}
	}
	
	return tResult
}

/// Joins a %Collection.AbstractIterator (including %ListOfDataTypes, %ArrayOfDataTypes) into a string
/// 
/// Keys (indices for lists, keys for arrays) will be included if pKeyValueDelimiter is not ""
ClassMethod ListToString(pInput As %Collection.AbstractIterator, pDelimiter As %String = ",", pStripParams As %String = "", pSkipEmpty As %Boolean = 0, pKeyValueDelimiter As %String = "") As %String(MAXLEN="")
{
	set tResult = ""
	
	set key = ""
	while (pInput.Next(key) '= "") {
		set key = pInput.Next(key)
		set value = $zstrip(pInput.GetAt(key), pStripParams)
		
		// skip empty values unless pSkipEmpty is false
		if (value '= "") || (pSkipEmpty = 0) {
			if (pKeyValueDelimiter '= "") set value = key _ pKeyValueDelimiter _ value
			
			set tResult = tResult _ pDelimiter _ value
		}
	}
	
	return $extract(tResult, $length(pDelimiter) + 1, *)
}

/// Joins a Multidimensional array into a string
/// 
/// Keys (indices for lists, keys for arrays) will be included if pKeyValueDelimiter is not ""
ClassMethod MultidimensionalToString(ByRef pInput, pDelimiter As %String = ",", pStripParams As %String = "", pSkipEmpty As %Boolean = 0, pKeyValueDelimiter As %String = "") As %String(MAXLEN="")
{
	set tResult = ""
	
	set key = ""
	while ($order(pInput(key)) '= "") {
		set key = $order(pInput(key))
		set value = $zstrip(pInput(key), pStripParams)
		
		// skip empty values unless pSkipEmpty is false
		if (value '= "") || (pSkipEmpty = 0) {
			if (pKeyValueDelimiter '= "") set value = key _ pKeyValueDelimiter _ value
			
			set tResult = tResult _ pDelimiter _ value
		}
	}
	
	return $extract(tResult, $length(pDelimiter) + 1, *)
}

/// Inserts pCount copies of pElement into pTarget
ClassMethod FillList(ByRef pTarget As %Collection.AbstractList, pCount As %Numeric, pElement As %RawString = "") As %Status
{
	for i=1:1:pCount {
		do pTarget.Insert(pElement)
	}
	
	return $$$OK
}

}

