/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Compares the category of every item in the container to the one(s) specified, and returns a list of all
		classes that match, along with a count of how often each class occurs (see output formats below).
	Arguments:
		0:	<LOCATION>	Item data of the container to be inspected
		1:	<ARRAY>		Array of allowed categories (item classes that don't match are ignored)
					NOTE: Leave empty to include ALL categories
		2:	<NUMBER>	Output format to use
					Valid options are 0 and 1 (see output formats below)
		3:	<BOOL>		Whether the allowed categories array is to be considered as a blacklist (true)
					or as a whitelist (false, default)
	Returns:
		0:	<ARRAY>		Nested array of results. Can come in one of the following formats:
					Format 0:	[[Class1,Class2,...,ClassN], [Count1,Count2,...,CountN]]
					Format 1:	[[Class1,Count1], [Class2,Count2], ..., [ClassN,CountN]]
					with:
					 	Class1...ClassN:	<STRING>
						Count1...CountN:	<NUMBER>
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\..\res\config\dialogs\macros.hpp"

// Fetch the params
params [
	["_containerData", locationNull, [locationNull]],
	["_validCategories", [], [[]]],
	["_outputFormat", 0, [0]],
	["_isBlacklist", false, [false]]
];

// If the container (or its data) doesn't exist, exit and return an empty array
if (isNull (_containerData getVariable [MACRO_VARNAME_CONTAINER, objNull])) exitWith {
	systemChat format ["ERROR [cre_fnc_inv_getClassCountsByCategory]: Provided container data is empty, or container doesn't exist! (%1 - %2)", _containerData getVariable [MACRO_VARNAME_UID, "n/a"], _containerData getVariable [MACRO_VARNAME_CLASS, "n/a"]];
	[ [], [[],[]] ] select (_outputFormat == 0)
};





// Define some variables
private _res = [];
private _checkCategory = {};

// If the valid categories array is empty, use the empty category enum ( = wildcard)
if (_validCategories isEqualTo []) then {
	_validCategories = [MACRO_ENUM_CATEGORY_EMPTY];
};

// If the empty category enum is passed, include ALL items
if (_validCategories isEqualTo [MACRO_ENUM_CATEGORY_EMPTY]) then {
	if (!_isBlacklist) then {
		_checkCategory = {
			private _count = _namespace getVariable [_class, 0];
			_namespace setVariable [_class, _count + 1];
		};
	};

// Otherwise, compare to the valid categories list
} else {

	// If the categories array should be a blacklist, exclude items that match
	if (_isBlacklist) then {
		_checkCategory = {
			if !(_category in _validCategories) then {
				private _count = _namespace getVariable [_class, 0];
				_namespace setVariable [_class, _count + 1];
			};
		};

	// Otherwise, include them
	} else {
		_checkCategory = {
			if (_category in _validCategories) then {
				private _count = _namespace getVariable [_class, 0];
				_namespace setVariable [_class, _count + 1];
			};
		};
	};
};






// Output format 1
if (_outputFormat == 0) then {
	_res = [[],[]];

	// Create the dummy namespace
	private _namespace = createLocation ["NameVillage", [0,0,0], 0, 0];

	{
		// Fetch the item category
		private _class = _x getVariable [MACRO_VARNAME_CLASS, ""];
		private _category = [_class] call cre_fnc_cfg_getClassCategory;

		// If the category is valid, add it to our results
		call _checkCategory;

	} forEach (_containerData getVariable [MACRO_VARNAME_ITEMS, []]);

	// Compile the results
	private _classes = [];
	private _counts = [];
	{
		_classes pushBack _x;
		_counts pushBack (_namespace getVariable [_x, 0]);
	} forEach allVariables _namespace;
	_res = [_classes, _counts];

	// Delete the namespace
	deleteLocation _namespace;

// Output format 1
} else {

	// Create the dummy namespace
	private _namespace = createLocation ["NameVillage", [0,0,0], 0, 0];

	{
		// Fetch the item category
		private _class = _x getVariable [MACRO_VARNAME_CLASS, ""];
		private _category = [_class] call cre_fnc_cfg_getClassCategory;

		// If the category is valid, add it to our results
		[_category] call _checkCategory;
	} forEach (_containerData getVariable [MACRO_VARNAME_ITEMS, []]);

	// Compile the results
	{
		_res pushBack [_x, _namespace getVariable [_x, 0]];
	} forEach allVariables _namespace;

	// Delete the namespace
	deleteLocation _namespace;
};

// Return the results
_res;
