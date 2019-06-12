/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Sorts two arrays using the Quicksort algorithm.
		The first array is used to determine the order during sorting, while the second array will simply mirror
		all transformations that were applied on the first one. This allows the sorting of any arbitrary data.
	Arguments:
		0:	<ARRAY>		Array consisting of numbers that need to be sorted
		1:	<ARRAY>		Array consisting of any data type that should also be sorted (order will
					mirror that of the resulting first array)
					NOTE: Must have the same length as the first array!
		2:	<NUMBER>	The left index from where we should start sorting (default: 0)
		3:	<NUMBER>	The right index from where we should start sorting (default: 0)
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

// Fetch our params
params [
	["_array", [], [[]]],
	["_arrayOpt", [], [[]]],
	["_indexL", 0, [0]],
	["_indexR", 0, [0]]
];





private _countArray = count _array;
private _countArrayOpt = count _arrayOpt;

// If the second array doesn't have the same count as the first one, exit
if (_countArray != _countArrayOpt) exitWith {
	private _str = format ["ERROR [cre_fnc_util_quickSort]: Second array has an incorrect elements count! (got %1, expected %2)", _countArrayOpt, _countArray];
	systemChat _str;
	hint _str;
};

// Translate default values
private _indexLast = _countArray - 1;
if (_indexR == 0) then {
	_indexR = _indexLast;
};

// Validate our inputs
_indexL = (_indexL min _indexLast) max 0;
_indexR = (_indexR min _indexLast) max 0;

if (_indexL > _indexR) then {
	_indexL = _indexR;
};

// If the array holds zero or only one element, do nothing
if (_countArray <= 1 or {_indexR == _indexL}) exitWith {};





// All validation tests passed, now we call the internal Quicksort function and return the results
[_array, _arrayOpt, _indexL, _indexR] call cre_fnc_util_quickSort_internal;

//systemChat "Done!";
