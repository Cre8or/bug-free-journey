/* --------------------------------------------------------------------------------------------------------------------
	Author:		 Cre8or
	Description:
		Returns the mass of a certain class.
	Arguments:
		0:      <STRING>	Classname of the item/object to check
		1:      <NUMBER>	Category of the class (see fn_cfg_getClassCategory)
	Returns:
		0:      <NUMBER>	Mass of the class
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\common\macros.hpp"

// Fetch our params
params [
	["_class", "", [""]],
	["_category", MACRO_ENUM_CATEGORY_INVALID, [MACRO_ENUM_CATEGORY_INVALID]]
];

// If no class or no category was provided, exit and return no mass
if (_class == "" or {_category == MACRO_ENUM_CATEGORY_INVALID}) exitWith {0};






// Get our namespace
private _namespace = missionNamespace getVariable ["cre8ive_getClassMass_namespace", locationNull];

// Fetch the mass from the namespace
private _mass = _namespace getVariable _class;

// If the mass doesn't exist yet, we determine it
if (isNil "_mass") then {

	// If the namespace doesn't exist yet, create it
	if (isNull _namespace) then {
		_namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
		missionNamespace setVariable ["cre8ive_getClassMass_namespace", _namespace, false];
	};

	private _configPath = configFile;
	private _configPathAlt = _configPath;

	// Determine the config path based on the category
	switch (_category) do {
		case MACRO_ENUM_CATEGORY_ITEM;
		case MACRO_ENUM_CATEGORY_WEAPON;
		case MACRO_ENUM_CATEGORY_HEADGEAR;
		case MACRO_ENUM_CATEGORY_BINOCULARS;
		case MACRO_ENUM_CATEGORY_CONTAINER;
		case MACRO_ENUM_CATEGORY_UNIFORM;
		case MACRO_ENUM_CATEGORY_VEST: {
			_configPath = _configPath >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "mass";
			_configPathAlt = _configPathAlt >> "CfgWeapons" >> _class >> "ItemInfo" >> "mass";
		};
		case MACRO_ENUM_CATEGORY_BACKPACK: {
			_configPath = _configPath >> "CfgVehicles" >> _class >> "mass";
			_configPathAlt = _configPath;
		};
		case MACRO_ENUM_CATEGORY_MAGAZINE: {
			_configPath = _configPath >> "CfgMagazines" >> _class >> "mass";
			_configPathAlt = _configPath;
		};
		case MACRO_ENUM_CATEGORY_NVGS: {
			_configPath = _configPath >> "CfgWeapons" >> _class >> "ItemInfo" >> "mass";
			_configPathAlt = _configPath;
		};
		case MACRO_ENUM_CATEGORY_GOGGLES: {
			_configPath = _configPath >> "CfgGlasses" >> _class >> "mass";
			_configPathAlt = _configPathAlt >> "CfgWeapons" >> _class >> "ItemInfo" >> "mass";
		};
		default {
			private _str = format ["ERROR [cre_fnc_cfg_getClassMass]: No rule for category '%1' (%2)!", _category, _class];
			systemChat _str;
			hint _str;
		};
	};

	// Fetch the mass
	_mass = getNumber _configPath;
	if (_mass <= 0) then {
		_mass = getNumber _configPathAlt;
	};

	// Save the mass onto the namespace (and set it to 0 if no mass was found)
	_mass = _mass max 0;
	_namespace setVariable [_class, _mass];
};

// Return the mass
_mass;
