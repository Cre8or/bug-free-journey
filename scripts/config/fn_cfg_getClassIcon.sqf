/* --------------------------------------------------------------------------------------------------------------------
	Author:		 Cre8or
	Description:
		Returns the icon of a specific class.
	Arguments:
		0:      <STRING>	Classname of the item/object to check
		1:      <NUMBER>	Category of the class (see macros.hpp)
		2:      <STRING>	Default icon to be used if nothing was found
	Returns:
		0:      <STRING>	Icon path of the class
					(e.g. "a3\weapons_f\Items\data\UI\gear_FirstAidKit_CA.paa")
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\common\macros.hpp"

// Fetch our params
params [
	["_class", "", [""]],
	["_category", MACRO_ENUM_CATEGORY_INVALID, [MACRO_ENUM_CATEGORY_INVALID]],
	["_defaultIconPath", "", [""]]
];

// If no class was provided, exit and return an empty string
if (_class == "" or {_category == MACRO_ENUM_CATEGORY_INVALID}) exitWith {_defaultIconPath};





// Get our namespace
private _namespace = missionNamespace getVariable ["cre8ive_getClassIcon_namespace", locationNull];

// Fetch the icon path from the namespace
private _iconPath = _namespace getVariable _class;

// If the icon path doesn't exist yet, fetch it from the config
if (isNil "_iconPath") then {
	_iconPath = "";

	// If the namespace doesn't exist yet, create it
	if (isNull _namespace) then {
		_namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
		missionNamespace setVariable ["cre8ive_getClassIcon_namespace", _namespace, false];
	};

	// Fetch the icon from the proper config path, based on the category
	switch (_category) do {
		case MACRO_ENUM_CATEGORY_ITEM;
		case MACRO_ENUM_CATEGORY_WEAPON;
		case MACRO_ENUM_CATEGORY_NVGS;
		case MACRO_ENUM_CATEGORY_HEADGEAR;
		case MACRO_ENUM_CATEGORY_BINOCULARS;
		case MACRO_ENUM_CATEGORY_CONTAINER;
		case MACRO_ENUM_CATEGORY_UNIFORM;
		case MACRO_ENUM_CATEGORY_VEST: {
			_iconPath = [configfile >> "CfgWeapons" >> _class, "picture", ""] call BIS_fnc_returnConfigEntry;
		};
		case MACRO_ENUM_CATEGORY_MAGAZINE: {
			_iconPath = [configfile >> "CfgMagazines" >> _class, "picture", ""] call BIS_fnc_returnConfigEntry;
		};
		case MACRO_ENUM_CATEGORY_BACKPACK: {
			_iconPath = [configfile >> "CfgVehicles" >> _class, "picture", ""] call BIS_fnc_returnConfigEntry;
		};
		case MACRO_ENUM_CATEGORY_GOGGLES: {
			_iconPath = [configfile >> "CfgGlasses" >> _class, "picture", ""] call BIS_fnc_returnConfigEntry;
		};
		default {
			private _str = format ["ERROR [cre_fnc_cfg_getClassIcon]: No rule for category '%1' (%2)!", _category, _class];
			systemChat _str;
			hint _str;
		};
	};

	// If no icon was found in the config, use the default path instead
	if (_iconPath == "") then {
		if (_defaultIconPath != "") then {
			_iconPath = _defaultIconPath;
		} else {
			_iconPath = " ";
			private _str = format ["ERROR [cre_fnc_cfg_getClassIcon]: Could not find icon for '%1', and no default path was provided!", _class];
			systemChat _str;
			hint _str;
		};
	};

	// Save the class icon on the namespace
	_namespace setVariable [_class, _iconPath];
};

// Return the icon path
_iconPath;
