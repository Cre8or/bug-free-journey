/* --------------------------------------------------------------------------------------------------------------------
	Author:	 Cre8or
	Description:
		Returns the sub-category of an item. Used to further distinguish between items, and to determine which
		slot(s) an item can go into (useful for special items such as maps, compasses, radios, etc.).
		For possible return values, see "macros.hpp".
	Arguments:
		0:      <STRING>	Classname the of item to check
	Returns:
		0:      <NUMBER>	Subcategory of the class (see above)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

// Fetch our params
params [
	["_class", "", [""]],
	["_category", MACRO_ENUM_CATEGORY_INVALID, [MACRO_ENUM_CATEGORY_INVALID]]
];

// If no class was provided, exit and return an invalid category
if (_class == "" or {_catgegory == MACRO_ENUM_CATEGORY_INVALID}) exitWith {MACRO_ENUM_SUBCATEGORY_INVALID};





// Get our namespace
private _namespace = missionNamespace getVariable ["cre8ive_getClassSubCategory_namespace", locationNull];

// Fetch the category from the namespace
private _subCategory = _namespace getVariable [_class, MACRO_ENUM_SUBCATEGORY_INVALID];

// If the class doesn't have a category yet, determine it
if (_subCategory == MACRO_ENUM_SUBCATEGORY_INVALID) then {

	// If the namespace doesn't exist yet, create it
	if (isNull _namespace) then {
		_namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
		missionNamespace setVariable ["cre8ive_getClassSubCategory_namespace", _namespace, false];
	};


	// Determine the sub-category based on the category
	switch (_category) do {

		// Item sub-categories
		case MACRO_ENUM_CATEGORY_ITEM: {

			// Fetch the simulation type of the item
			switch (toLower ([configFile >> "CfgWeapons" >> _class, "simulation", ""] call BIS_fnc_returnConfigEntry)) do {
				case "itemmap": {
					_subCategory = MACRO_ENUM_SUBCATEGORY_MAP;
				};
				case "itemgps": {
					_subCategory = MACRO_ENUM_SUBCATEGORY_GPS;
				};
				case "itemradio": {
					_subCategory = MACRO_ENUM_SUBCATEGORY_RADIO;
				};
				case "itemcompass": {
					_subCategory = MACRO_ENUM_SUBCATEGORY_COMPASS;
				};
				case "itemwatch": {
					_subCategory = MACRO_ENUM_SUBCATEGORY_WATCH;
				};
			};
		};

		// Weapon sub-categories
		case MACRO_ENUM_CATEGORY_WEAPON: {

			// Fetch the item's type value
			switch ([configFile >> "CfgWeapons" >> _class, "type", 0] call BIS_fnc_returnConfigEntry) do {
				case 1: {
					_subCategory = MACRO_ENUM_SUBCATEGORY_PRIMARYWEAPON;
				};
				case 2: {
					_subCategory = MACRO_ENUM_SUBCATEGORY_HANDGUNWEAPON;
				};
				case 4: {
					_subCategory = MACRO_ENUM_SUBCATEGORY_SECONDARYWEAPON;
				};
			};
		};

		case MACRO_ENUM_CATEGORY_UNIFORM;
		case MACRO_ENUM_CATEGORY_VEST;
		case MACRO_ENUM_CATEGORY_NVGS;
		case MACRO_ENUM_CATEGORY_HEADGEAR;
		case MACRO_ENUM_CATEGORY_BINOCULARS;
		case MACRO_ENUM_CATEGORY_GOGGLES;
		case MACRO_ENUM_CATEGORY_BACKPACK;
		case MACRO_ENUM_CATEGORY_CONTAINER;
		case MACRO_ENUM_CATEGORY_MAGAZINE: {};

		default {
			private _str = format ["ERROR [cre_fnc_cfg_getClassSubCategory]: No rule for category '%1' (%2)!", _category, _class];
			systemChat _str;
			hint _str;
		};
	};

	// Save the sub-category onto the namespace
	_namespace setVariable [_class, _subCategory];
};

// Return the sub-category
_subCategory;
