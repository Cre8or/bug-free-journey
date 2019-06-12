/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Partitions a region of an array using the Quicksort algorithm and returns the pivot for use in the next
		iteration.
		Called by fn_quickSort_internal.
	Arguments:
		0:	<ARRAY>		Array consisting of numbers that need to be sorted
		1:	<ARRAY>		Array consisting of any data type that should also be sorted (order will mirror
					that of the resulting first array)
		2:	<NUMBER>	The left index from where we should start sorting
		3:	<NUMBER>	The right index from where we should start sorting)
	Returns:
		0:	<NUMBER>	The pivot for the next Quicksort iteration
-------------------------------------------------------------------------------------------------------------------- */

// Fetch our params (no validation as the "public" function already handled it for us)
params [
	"_array",
	"_arrayOpt",
	"_indexL",
	"_indexR"
];

// Set up some variables
private _curL = _indexL;
private _curR = _indexR;
private _continue = true;
private _searching = true;

// Pick the middle element as the pivot
private _indexPivot = _indexL + floor ((_indexR - _indexL) / 2);
private _pivot = _array select _indexPivot;

// Move the pivot to the last positiom
[_array, _arrayOpt, _indexPivot, _indexR] call cre_fnc_util_quickSort_swap;
//systemChat format ["%1    -- Moved the pivot (%2)", _array, _pivot];


// Iterate through the assigned array region
while {_continue} do {

	// Reset our variables
	_searching = true;

	// Search for the next item from the left that is greater than the pivot
	while {_searching} do {
		if (_array select _curL > _pivot or {_curL >= _indexR}) then {
			_searching = false;
		} else {
			_curL = _curL + 1;
		};
	};

	_searching = true;

	// Search for the next item from the right that is less than the pivot
	while {_searching} do {
		if (_array select _curR < _pivot or {_curR <= _indexL}) then {
			_searching = false;
		} else {
			_curR = _curR - 1;
		};
	};

	// If we found a pair of numbers, swap them
	if (_curL < _curR) then {
		//systemChat format ["Swapped %1 and %2", _array select _curL, _array select _curR];
		[_array, _arrayOpt, _curL, _curR] call cre_fnc_util_quickSort_swap;

	// Otherwise, we exit
	} else {
		_continue = false;

		// Finally, we move the pivot to its final location
		if (_curL != _indexR) then {
			[_array, _arrayOpt, _curL, _indexR] call cre_fnc_util_quickSort_swap;
			//systemChat format ["Swapped pivot %1 and %2", _pivot, _array select _indexR];
		};
	};
};

// Return the left position as the new pivot
_curL;
