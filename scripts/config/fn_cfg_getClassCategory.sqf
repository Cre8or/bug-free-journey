/* --------------------------------------------------------------------------------------------------------------------
	Author:	 Cre8or
	Description:
		Returns the category of an item. Used to determine which config class to look it up in.
		For possible return values, see "macros.hpp".
	Arguments:
		0:      <STRING>	Classname the of item to check
		1:	<NUMBER>	The config type that this class is defined in (see macros.hpp)
	Returns:
		0:      <NUMBER>	Category of the class (see above)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\common\macros.hpp"

// Fetch our params
params [
	["_class", "", [""]],
	["_configType", MACRO_ENUM_CONFIGTYPE_INVALID, [MACRO_ENUM_CONFIGTYPE_INVALID]]
];

// If no class or no config type was provided, exit and return an invalid category
if (_class isEqualTo "" or {_configType == MACRO_ENUM_CONFIGTYPE_INVALID}) exitWith {MACRO_ENUM_CATEGORY_INVALID};





// Get our namespace
private _namespace = missionNamespace getVariable [format ["cre8ive_getClassCategory_%1_namespace", _configType], locationNull];

// Fetch the category from the namespace
private _category = _namespace getVariable _class;

// If the class doesn't have a category yet, determine it
if (isNil "_category") then {
	_category = MACRO_ENUM_CATEGORY_INVALID;

	// If the namespace doesn't exist yet, create it
	if (isNull _namespace) then {
		_namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
		missionNamespace setVariable [format ["cre8ive_getClassCategory_%1_namespace", _configType], _namespace, false];
	};

	scopeName "check";

	// Fetch the category
	switch (_configType) do {

		// CfgWeapons
		case MACRO_ENUM_CONFIGTYPE_CFGWEAPONS: {

			// If the class has a "type" entry in its ItemInfo subclass, it might be a piece of clothing
			private _configPath = configFile >> "CfgWeapons" >> _class;
			switch (getNumber (_configPath >> "ItemInfo" >> "type")) do {
				case 605: {
					// It's a helmet
					_category = MACRO_ENUM_CATEGORY_HEADGEAR;
					breakTo "check";
				};
				case 616: {
					// It's an NVG
					_category = MACRO_ENUM_CATEGORY_NVGS;
					breakTo "check";
				};
				case 701: {
					if (getNumber (_configPath >> "cre8ive_isContainer") > 0) then {
						// It's a container
						_category = MACRO_ENUM_CATEGORY_CONTAINER;
					} else {
						// It's a vest
						_category = MACRO_ENUM_CATEGORY_VEST;
					};
					breakTo "check";
				};
				case 801: {
					// It's a uniform
					_category = MACRO_ENUM_CATEGORY_UNIFORM;
					breakTo "check";
				};
			};

			// If the class has a WeaponSlotsInfo subclass, it might be a weapon
			if (isClass (_configPath >> "WeaponSlotsInfo")) then {

				// If the class is of type 4096, it's a binocular
				if (getNumber (_configPath >> "type") == 4096) then {
					_category = MACRO_ENUM_CATEGORY_BINOCULARS;
					breakTo "check";
				};

				// Otherwise, it's a weapon
				_category = MACRO_ENUM_CATEGORY_WEAPON;
				breakTo "check";
			};

			// Otherwise, it's an item
			_category = MACRO_ENUM_CATEGORY_ITEM;
		};

		// CfgVehicles
		case MACRO_ENUM_CONFIGTYPE_CFGVEHICLES: {

			// It's a backpack
			private _configPath = configFile >> "CfgVehicles" >> _class;
			if (getNumber (_configPath >> "isbackpack") > 0) then {
				_category = MACRO_ENUM_CATEGORY_BACKPACK;

			// Otherwise...
			} else {
				// It's either an object or a man
				_category = [
					MACRO_ENUM_CATEGORY_OBJECT,
					MACRO_ENUM_CATEGORY_MAN
				] select (getText (_configPath >> "simulation") == "soldier");
			};
		};

		// CfgMagazines
		case MACRO_ENUM_CONFIGTYPE_CFGMAGAZINES: {
			_category = MACRO_ENUM_CATEGORY_MAGAZINE;
		};

		// CfgGlasses
		case MACRO_ENUM_CONFIGTYPE_CFGGLASSES: {
			_category = MACRO_ENUM_CATEGORY_GOGGLES;
		};
	};

	// Save the category onto the namespace
	_namespace setVariable [_class, _category];
};

// Return the category
_category;
