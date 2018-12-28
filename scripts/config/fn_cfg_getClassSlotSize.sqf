/* --------------------------------------------------------------------------------------------------------------------
	Author:	 	Cre8or
	Description:
		Returns the slot size of a certain class in the form [x,y].
	Arguments:
		0:      <STRING>	Classname of the item to check
		1:      <NUMBER>	Category of the class (see fn_cfg_getClassCategory)
	Returns:
		0:      <ARRAY>	 	Slot size of the class in format [<NUMBER> x, <NUMBER> y]
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

params [
	["_class", "", [""]],
	["_category", MACRO_ENUM_CATEGORY_INVALID, [MACRO_ENUM_CATEGORY_INVALID]]
];

// If no class or no category was provided, exit and return an empty array
if (_class == "" or {_category == MACRO_ENUM_CATEGORY_INVALID}) exitWith {[1,1]};





// Get our namespace
private _namespace = missionNamespace getVariable ["cre8ive_getClassSlotSize_namespace", locationNull];

// Fetch the slot size from the namespace
private _slotSize = _namespace getVariable [_class, []];

// If the slot size doesn't exist yet, try to determine it
if (_slotSize isEqualTo []) then {

	// If the namespace doesn't exist yet, create it
	if (isNull _namespace) then {
		_namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
		missionNamespace setVariable ["cre8ive_getClassSlotSize_namespace", _namespace, false];
	};

	// Determine the config path based on the category
	private _configPath = "";
	switch (_category) do {
		case MACRO_ENUM_CATEGORY_ITEM;
		case MACRO_ENUM_CATEGORY_WEAPON;
		case MACRO_ENUM_CATEGORY_UNIFORM;
		case MACRO_ENUM_CATEGORY_VEST;
		case MACRO_ENUM_CATEGORY_HEADGEAR: {
			_configPath = "CfgWeapons"
		};
		case MACRO_ENUM_CATEGORY_BACKPACK;
		case MACRO_ENUM_CATEGORY_VEHICLE: {
			_configPath = "CfgVehicles"
		};
		case MACRO_ENUM_CATEGORY_MAGAZINE: {
			_configPath = "CfgMagazines"
		};
		case MACRO_ENUM_CATEGORY_GOGGLES: {
			_configPath = "CfgGlasses"
		};
		default {
			private _str = format ["ERROR [cre_fnc_cfg_getClassSlotSize]: No rule for category '%1' (%2)!", _category, _class];
			systemChat _str;
			hint _str;
		};
	};

	// Look up the slot size in the config (in case it's specifically defined for this class)
	_slotSize = [configfile >> _configPath >> _class, "slotSize", []] call BIS_fnc_returnConfigEntry;

	// If we didn't find a specific slot size, we have to determine it
	if (_slotSize isEqualTo []) then {

		// To do so, we use the mass of the item
		private _mass = [_class, _category] call cre_fnc_cfg_getClassMass;

		switch (_category) do {
			case MACRO_ENUM_CATEGORY_WEAPON: {
				private _x = round (1.0 * _mass ^ (1/3));     // Cubic root
				private _y = round (1 + 0.4 * _mass ^ (1/3));
				_slotSize = [_x, _y];
			};
			case MACRO_ENUM_CATEGORY_MAGAZINE: {
				private _x = floor (1.0 * _mass ^ (1/3));     // Cubic root
				private _y = round (1.0 * _mass ^ (1/3));
				_slotSize = [_x, _y];
			};
			case MACRO_ENUM_CATEGORY_ITEM;
			case MACRO_ENUM_CATEGORY_UNIFORM;
			case MACRO_ENUM_CATEGORY_VEST;
			case MACRO_ENUM_CATEGORY_BACKPACK;
			case MACRO_ENUM_CATEGORY_GOGGLES;
			case MACRO_ENUM_CATEGORY_HEADGEAR;
			case MACRO_ENUM_CATEGORY_VEHICLE: {
				private _x = round (1.0 * _mass ^ (1/3));     // Cubic root
				private _y = floor (1.0 * _mass ^ (1/3));
				_slotSize = [_x, _y];
			};
			default {
				_slotSize = [1,1];
				private _str = format ["ERROR [cre_fnc_cfg_getClassSlotSize]: Could not determine slot size for '%1'!", _class];
				systemChat _str;
				hint _str;
			};
		};
	};

	// Save the slot size onto the namespace
	_namespace setVariable [_class, _slotSize];
};

// Return the slot size
_slotSize;
