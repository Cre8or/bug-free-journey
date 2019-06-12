/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Sorts a region of an array using the quicksort algorithm.
		Called by fn_quickSort, and recursively in this function.
	Arguments:
		0:	<ARRAY>		Array consisting of numbers that need to be sorted
		1:	<ARRAY>		Array consisting of any data type that should also be sorted (order will mirror
					that of the resulting first array)
		2:	<NUMBER>	The left index from where we should start sorting
		3:	<NUMBER>	The right index from where we should start sorting)
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

// Fetch our params (no validation as the "public" function already handled it for us)
params [
	"_array",
	"_arrayOpt",
	"_indexL",
	"_indexR"
];

// Only continue if we have at least two values
if (_indexL < _indexR) then {

	// Partition the array and fetch the next pivot
	private _pivot = [_array, _arrayOpt, _indexL, _indexR] call cre_fnc_util_quickSort_partition;

	// Recursively call this function on the two chunks of the array
	if (_indexL < _pivot - 1) then {
		[_array, _arrayOpt, _indexL, _pivot - 1] call cre_fnc_util_quickSort_internal;
	};
	if (_pivot + 1 < _indexR) then {
		[_array, _arrayOpt, _pivot + 1, _indexR] call cre_fnc_util_quickSort_internal;
	};

};
