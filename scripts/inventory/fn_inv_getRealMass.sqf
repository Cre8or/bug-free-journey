/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Returns the total mass of all items that are inside a container.
		Unlike cre_fnc_inv_getInvMass, this function completely ignores the container's data, and instead relies
		entirely on the container's actual content.
		NOTE: Does not include the container's own mass.
	Arguments:
		0:      <OBJECT>	Container object
		1:	<BOOL>		Whether or not exceptional items (magazines and weapon attachments) should
					be considered (default: true)
		2:	<BOOL>		Whether or not non-exceptional items (everything else) should be considered
					(default: true)
	Returns:
		0:      <NUMBER>	Total mass of all objects inside the container object
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\common\macros.hpp"

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
private _contents = [ [[],[]], [[],[]] ];

// If we should include non-exceptions, add them to the list
if (_includeNonExceptions) then {
	_contents = [getItemCargo _container, getBackpackCargo _container];
};


// If we should include exceptions, use a more complex loop
if (_includeExceptions) then {

	// Include magazines
	_contents pushBack getMagazineCargo _container;

	// Iterate through the weapons inside the container
	{
		_x params [
			"",
			"_accMuzzle",
			"_accSide",
			"_accOptic",
			"_magazine",
			"_magazineAlt",
			"_accBipod"
		];

		// Iterate through the weapon's items
		{
			if (_x != "") then {
				private _configType = [MACRO_ENUM_CONFIGTYPE_CFGWEAPONS, MACRO_ENUM_CONFIGTYPE_CFGMAGAZINES] select (_forEachIndex >= 4);
				private _category = [_x, _configType] call cre_fnc_cfg_getClassCategory;
				private _mass = [_x, _category] call cre_fnc_cfg_getClassMass;
				//diag_log format ["    Added attachment: %1 (%2)", _x, _mass];

				// Add the mass to the total
				_totalMass = _totalMass + _mass;
			};
		} forEach [
			_accMuzzle,
			_accBipod,
			_accSide,
			_accOptic,
			_magazine param [0, ""],
			_magazineAlt param [0, ""]
		];
	} forEach weaponsItemsCargo _container;
};

//diag_log format ["Total mass (1): %1", _totalMass];

// If we should include non-exceptions, include the weapons
if (_includeNonExceptions) then {

	// Fetch the weapon classes and counts
	(getWeaponCargo _container) params ["_classes", "_counts"];

	// Iterate through the weapon classes
	{
		// Look up the mass of one item and multiply it by the count
		private _category = [_x, MACRO_ENUM_CONFIGTYPE_CFGWEAPONS] call cre_fnc_cfg_getClassCategory;
		private _mass = [_x, _category] call cre_fnc_cfg_getClassMass;
		//diag_log format ["    Added weapon: %1 (%2)", _x, _mass];

		_totalMass = _totalMass + _mass * (_counts select _forEachIndex);
	} forEach _classes;
};

//diag_log format ["Total mass (2): %1", _totalMass];
//diag_log format ["Checking contents: %1", _contents];

// Iterate through the remaining contents of the container
{
	_x params ["_classes", "_counts"];
	private _formatType = _forEachIndex;

	// Iterate through the classes
	{
		// Determine the config type
		private _configType = switch (_formatType) do {
			case 0: {						// getItemCargo
				[
					MACRO_ENUM_CONFIGTYPE_CFGWEAPONS,
					MACRO_ENUM_CONFIGTYPE_CFGGLASSES
				] select isClass (configFile >> "CfgGlasses" >> _x)		// NOTE: Possible classname conflict - if there are 2 identical entries in CfgWeapons and CfgGlasses, we always assume it's CfgGlasses. Need a new scripting command to differentiate
			};
			case 1: {						// getBackpackCargo
				MACRO_ENUM_CONFIGTYPE_CFGVEHICLES
			};
			case 2: {						// getMagazineCargo
				MACRO_ENUM_CONFIGTYPE_CFGMAGAZINES
			};
			default {MACRO_ENUM_CONFIGTYPE_INVALID};		// fallback value
		};

		private _category = [_x, _configType] call cre_fnc_cfg_getClassCategory;
		private _mass = [_x, _category] call cre_fnc_cfg_getClassMass;
		private _count = _counts param [_forEachIndex, 1];
		//diag_log format ["    Added item: %1 (%2) (configType: %3 - category: %4)", _x, _mass, _configType, _category];

		_totalMass = _totalMass + _mass * _count;
	} forEach _classes;
} forEach _contents;

//diag_log format ["(%1) Final REAL mass: %2", diag_frameNo, _totalMass];

// Return the total mass
_totalMass;
