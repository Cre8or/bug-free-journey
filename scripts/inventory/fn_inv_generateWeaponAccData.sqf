/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Generates the item data for a weapon's attached items (accessories and loaded magazines).
	Arguments:
		0:      <LOCATION>	Item data of the weapon
		1:	<ARRAY>		Data array of the weapon (NOTE: This array is in the same format as the
					returned values from the "weaponsItems" command, or the
					cre_fnc_inv_generateWeaponAccArray function)
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\common\macros.hpp"

// Fetch our params
params [
	["_weaponData", locationNull, [locationNull]],
	["_args", [], [[]]]
];

// Fetch the data from the weapon array
_args params [
	["_class", "", [""]],
	["_accMuzzle", "", [""]],
	["_accSide", "", [""]],
	["_accOptic", "", [""]],
	["_magazine", [], ["", []]],
	["_magazineAlt", [], ["", []]],
	["_accBipod", "", [""]]
];

// Fetch the magazine data
_magazine params [
	["_magClass", ""],
	["_ammo", 0]
];

// Define some variables
private _magClassAlt = "";
private _ammoAlt = 0;





// If the magazine fits the weapon, it's a primary magazine
private _validMagazines = [_class] call cre_fnc_cfg_getWeaponMagazines;
if (_magClass != "") then {

	// If the magazine is is a primary magazine, or if there is also an alternate magazine...
	private _hasAltMagazine = _magazineAlt isEqualType [];
	if (_hasAltMagazine or {toLower _magClass in _validMagazines}) then {

		// Next, look at the alternate magazine
		if (_hasAltMagazine) then {
			_magClassAlt = _magazineAlt param [0, ""];
			_ammoAlt = _magazineAlt param [1, 0];
		} else {
			// Due to the command not adding empty arrays, we have to reassign the variables
			_accBipod = _magazineAlt;
		};

	// Otherwise, it's an alternate magazine
	} else {
		_accBipod = _magazineAlt;
		_magClassAlt = _magClass;
		_magClass = "";
	};
} else {
	if (_magazineAlt isEqualType []) then {
		_magClassAlt = _magazineAlt param [0, ""];
		_ammoAlt = _magazineAlt param [1, 0];
	} else {
		_accBipod = _magazineAlt;
		_magClassAlt = "";
	};
};

// Generate the item data for the attachments
{
	_x params ["_accItemClass", "_accVarName"];

	if (_accItemClass != "") then {

		// Create a new namespace for the item
		(call cre_fnc_inv_createNamespace) params ["_accItemData"];

		// Fill the attachment's item data
		_accItemData setVariable [MACRO_VARNAME_CLASS, _accItemClass];
		_accItemData setVariable [MACRO_VARNAME_PARENTDATA, _weaponData];

		// Update the weapon's item data to know about the attachment
		_weaponData setVariable [_accVarName, _accItemData];
	};
} forEach [
	[_accMuzzle,		MACRO_VARNAME_ACC_MUZZLE],
	[_accBipod,		MACRO_VARNAME_ACC_BIPOD],
	[_accSide,		MACRO_VARNAME_ACC_SIDE],
	[_accOptic,		MACRO_VARNAME_ACC_OPTIC]
];

// Generate the item data for the magazines
{
	_x params ["_magItemClass", "_magVarName"];

	if (_magItemClass != "") then {

		// Create a new namespace for the item
		(call cre_fnc_inv_createNamespace) params ["_magItemData", "_magUID"];

		// Fill the magazines's item data
		_magItemData setVariable [MACRO_VARNAME_CLASS, _magItemClass];
		_magItemData setVariable [MACRO_VARNAME_PARENTDATA, _weaponData];

		if (_forEachIndex == 0) then {
			_magItemData setVariable [MACRO_VARNAME_MAG_AMMO, _ammo];
		} else {
			_magItemData setVariable [MACRO_VARNAME_MAG_AMMO, _ammoAlt];
		};

		// Update the weapon's item data to know about the attachment
		_weaponData setVariable [_magVarName, _magItemData];
	};
} forEach [
	[_magClass,		MACRO_VARNAME_MAG],
	[_magClassAlt,		MACRO_VARNAME_MAGALT]
];
