/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Swaps two values inside an array to be sorted with the Quicksort algorithm. Also swaps the values in
		the optional array.
		Called by fn_quickSort_partition.
	Arguments:
		0:	<ARRAY>		Array consisting of numbers that need to be sorted
		1:	<ARRAY>		Array consisting of any data type that should also be sorted (order will mirror
					that of the resulting first array)
		2:	<NUMBER>	The left index from where we should start sorting
		3:	<NUMBER>	The right index from where we should start sorting)
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

// Fetch our params (no validation as the "public" Quicksort function already handled it for us)
params [
	"_array",
	"_arrayOpt",
	"_indexL",
	"_indexR"
];

// Set up our temporary variables
private _numTemp = _array select _indexL;
private _valTemp = _arrayOpt select _indexL;

// Move the entries from indexR to indexL
_array set [_indexL, _array select _indexR];
_arrayOpt set [_indexL, _arrayOpt select _indexR];

// Finally, move the entries from our temporary variables back into the arrays at IndexR
_array set [_indexR, _numTemp];
_arrayOpt set [_indexR, _valTemp];
