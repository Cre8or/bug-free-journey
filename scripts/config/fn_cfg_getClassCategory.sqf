/* --------------------------------------------------------------------------------------------------------------------
	Author:	 Cre8or
	Description:
		Returns the category of an item. Used to determine which config class to look it up in.
		For possible return values, see "macros.hpp".
	Arguments:
		0:      <STRING>	Classname the of item to check
	Returns:
		0:      <NUMBER>	Category of the class (see above)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

// Fetch our params
params [
	["_class", "", [""]]
];

// If no class was provided, exit and return an invalid category
if (_class == "") exitWith {MACRO_ENUM_CATEGORY_INVALID};





// Get our namespace
private _namespace = missionNamespace getVariable ["cre8ive_getClassCategory_namespace", locationNull];

// Fetch the category from the namespace
private _category = _namespace getVariable [_class, MACRO_ENUM_CATEGORY_INVALID];

// If the class doesn't have a category yet, determine it
if (_category == MACRO_ENUM_CATEGORY_INVALID) then {

	// If the namespace doesn't exist yet, create it
	if (isNull _namespace) then {
		_namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
		missionNamespace setVariable ["cre8ive_getClassCategory_namespace", _namespace, false];
	};

	// Iterate through the usual config paths and look for the class
	{
		scopeName "loop";

		// If the class exists, inspect it
		if (isClass (configFile >> _x >> _class)) then {

			// Pick the matching category
			switch (_forEachIndex) do {

				// CfgWeapons
				case 0: {

					// If the class has a "type" entry in its ItemInfo subclass, it might be a piece of clothing
					private _type = [configfile >> "CfgWeapons" >> _class >> "ItemInfo", "type", 0] call BIS_fnc_returnConfigEntry;
					switch (_type) do {
						case 605: {
							// It's a helmet
							_category = MACRO_ENUM_CATEGORY_HEADGEAR;
							breakTo "loop";
						};
						case 616: {
							// It's an NVG
							_category = MACRO_ENUM_CATEGORY_NVGS;
							breakTo "loop";
						};
						case 701: {
							// It's a vest
							_category = MACRO_ENUM_CATEGORY_VEST;
							breakTo "loop";
						};
						case 801: {
							// It's a uniform
							_category = MACRO_ENUM_CATEGORY_UNIFORM;
							breakTo "loop";
						};
					};

					// If the class has a WeaponSlotsInfo subclass, it might be a weapon
					if (isClass (configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo")) then {

						// If the class is of type 4096, it's a binocular
						if (getNumber (configFile >> "CfgWeapons" >> _class >> "type") == 4096) then {
							_category = MACRO_ENUM_CATEGORY_BINOCULARS;
							breakTo "loop";
						};

						// Otherwise, it's a weapon
						_category = MACRO_ENUM_CATEGORY_WEAPON;
						breakTo "loop";
					};

					// Otherwise, it's an item
					_category = MACRO_ENUM_CATEGORY_ITEM;
				};

				// CfgVehicles
				case 1: {

					// If the class inherits from "Bag_Base", it's a backpack
					if (_class isKindOf "Bag_Base") then {
						_category = MACRO_ENUM_CATEGORY_BACKPACK;
						breakTo "loop";
					};

					// Otherwise, it's a vehicle
					_category = MACRO_ENUM_CATEGORY_VEHICLE;
				};


				// CfgMagazines
				case 2: {
					_category = MACRO_ENUM_CATEGORY_MAGAZINE;
				};

				// CfgGlasses
				case 3: {
					_category = MACRO_ENUM_CATEGORY_GOGGLES;
				};
			};
		};

		// If we determined the category, save it onto the namespace
		if (_category != MACRO_ENUM_CATEGORY_INVALID) exitWith {
			_namespace setVariable [_class, _category];
		};
	} forEach ["CfgWeapons", "CfgVehicles", "CfgMagazines", "CfgGlasses"];
};

// Return the category
_category;
