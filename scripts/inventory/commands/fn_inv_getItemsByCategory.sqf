/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Compares the category of every item in the container to the one(s) specified, and returns a list of all
		items that match.
	Arguments:
		0:	<LOCATION>	Item data of the container to be inspected
		1:	<ARRAY>		Array of allowed categories (item classes that don't match are ignored)
		2:	<BOOL>		Whether the allowed categories array is to be considered as a blacklist (true)
					or as a whitelist (false, default)
	Returns:
		0:	<ARRAY>		Array of item datas (<LOCATION>) that match the specified category/categories
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\..\res\common\macros.hpp"

// Fetch the params
params [
	["_containerData", locationNull, [locationNull]],
	["_validCategories", [], [[]]],
	["_isBlacklist", false, [false]]
];

// If the container (or its data) doesn't exist, exit and return an empty array
if (isNull (_containerData getVariable [MACRO_VARNAME_CONTAINER, objNull])) exitWith {
	systemChat format ["ERROR [cre_fnc_inv_getItemsByCategory]: Provided container data is empty, or container doesn't exist! (%1 - %2)", _containerData getVariable [MACRO_VARNAME_UID, "n/a"], _containerData getVariable [MACRO_VARNAME_CLASS, "n/a"]];
	[]
};





// Define some variables
private _res = [];
private _checkCategory = {};

// If the categories array should be a blacklist, exclude items that match
if (_isBlacklist) then {
	_checkCategory = {
		if !(_category in _validCategories) then {
			_res pushBack _x;
		};
	};

// Otherwise, include them
} else {
	_checkCategory = {
		if (_category in _validCategories) then {
			_res pushBack _x;
		};
	};
};





// Iterate through all items
if !(_validCategories isEqualTo []) then {
	{
		// Fetch the item category
		private _class = _x getVariable [MACRO_VARNAME_CLASS, ""];
		private _category = [_class] call cre_fnc_cfg_getClassCategory;

		// If the category is valid, add it to our results
		call _checkCategory;
	} forEach (_containerData getVariable [MACRO_VARNAME_ITEMS, []]);
};

// Return the results
_res;
