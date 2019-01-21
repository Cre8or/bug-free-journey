/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Returns the total mass of all items that are inside a container.
		Unlike cre_fnc_inv_getInvMass, this function completely ignores the container's data, and instead relies
		entirely on the container's actual content.
		NOTE: Does not include the container's own mass.
	Arguments:
		0:      <OBJECT>	Container object
		1:	<BOOL>		Whether or not exceptional items (magazines and weapon items) should
					be considered (default: true)
		2:	<BOOL>		Whether or not non-exceptional items should be considered
					(default: true)
	Returns:
		0:      <NUMBER>	Total mass of all objects inside the container object
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

// Fetch our params
params [
	["_container", objNull, [objNull]],
	["_includeExceptions", true, [true]],
	["_includeNonExceptions", true, [true]]
];

// If the passed container doesn't exist, exit and return 0
if (!alive _container) exitWith {0};





// Set up some variables
private _totalMass = 0;
private _contents = [[],[]];

// If we should include non-exceptions, add them to the list
if (_includeNonExceptions) then {
	_contents = [getItemCargo _container, getBackpackCargo _container];
};


// If we should include exceptions, use a more complex loop
if (_includeExceptions) then {

	// Include magazines
	_contents pushBack (getMagazineCargo _container);

	// Iterate through the weapons inside the container
	{
		_x params [
			"",
			["_accMuzzle", ""],
			["_accSide", ""],
			["_accOptic", ""],
			["_magazine", []],
			["_magazineAlt", []],
			["_accBipod", ""]
		];

		// Fetch the magazine classes
		_magazine = _magazine param [0, ""];
		if (_magazineAlt isEqualType []) then {
			_magazineAlt = _magazineAlt param [0, ""];
		} else {
			_accBipod = _magazineAlt;
			_magazineAlt = "";
		};

		// Iterate through the weapon's items
		{
			private _category = [_x] call cre_fnc_cfg_getClassCategory;
			private _mass = [_x, _category] call cre_fnc_cfg_getClassMass;

			// Add the mass to the total
			_totalMass = _totalMass + _mass;
		} forEach [
			_accMuzzle,
			_accBipod,
			_accSide,
			_accOptic,
			_magazine,
			_magazineAlt
		];
	} forEach (weaponsItemsCargo _container);
};

// If we should include non-exceptions, include the weapons
if (_includeNonExceptions) then {

	// Fetch the weapon classes and counts
	(getWeaponCargo _container) params ["_classes", "_counts"];

	// Iterate through the weapon classes
	{
		// Look up the mass of one item and multiply it by the count
		private _mass = [_x, MACRO_ENUM_CATEGORY_WEAPON] call cre_fnc_cfg_getClassMass;
		_totalMass = _totalMass + _mass * (_counts select _forEachIndex);
	} forEach _classes;
};

// Iterate through the remaining contents of the container
{
	_x params [
		["_classes", []],
 		["_counts", []]
	];

	// Iterate through the classes
	{
		private _category = [_x] call cre_fnc_cfg_getClassCategory;
		private _mass = [_x, _category] call cre_fnc_cfg_getClassMass;
		private _count = _counts param [_forEachIndex, 1];
		_totalMass = _totalMass + _mass * _count;
	} forEach _classes;
} forEach _contents;

// Return the total mass
_totalMass;
