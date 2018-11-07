/* --------------------------------------------------------------------------------------------------------------------
        Author:         Cre8or
        Description:
                Returns the category of an item. Used to determine which config class to look it up in.
                Possible return values:
                        MACRO_ENUM_CATEGORY_ITEM                ( -> CfgWeapons)
                        MACRO_ENUM_CATEGORY_WEAPON              ( -> CfgWeapons)
                        MACRO_ENUM_CATEGORY_MAGAZINE            ( -> CfgMagazines)
                        MACRO_ENUM_CATEGORY_VEHICLE             ( -> CfgVehicles)
                        MACRO_ENUM_CATEGORY_GLASSES             ( -> CfgGlasses)
        Arguments:
                0:      <STRING>        Classname of item to check
        Returns:
                0:      <NUMBER>        Category of the class (see above)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

params [
        ["_class", "", [""]]
];

// If no class was provided, exit
if (_class == "") exitWith {};





// Get our namespace
private _namespace = missionNamespace getVariable ["cre8ive_getClassCategory_namespace", locationNull];

// If the namespace doesn't exist yet, create it
if (isNull _namespace) then {
        _namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
        missionNamespace setVariable ["cre8ive_getClassCategory_namespace", _namespace, false];
};

// Fetch the category from the namespace
private _category = _namespace getVariable [_class, -1];

// Iterate through the usual config paths and look for the class
{
        // If the class exists, inspect it
        if (isClass (configFile >> _x >> _class)) then {

                // Unless we're inside CfgWeapons, we can already stop here because we know what it is
                if (_forEachIndex > 0) then {

                        // Pick the matching category
                        switch (_forEachIndex) do {
                                case 1: {_category = MACRO_ENUM_CATEGORY_MAGAZINE};
                                case 2: {_category = MACRO_ENUM_CATEGORY_VEHICLE};
                                case 3: {_category = MACRO_ENUM_CATEGORY_GLASSES};
                        };

                // Otherwise, we need to further distinguish between weapons and items
                } else {

                        // If the class has a WeaponSlotsInfo subclass, it's a weapon
                        if (isClass (configFile >> _x >> _class >> "WeaponSlotsInfo")) then {
                                _category = MACRO_ENUM_CATEGORY_WEAPON;

                        // Otherwise, it's an item
                        } else {
                                _category = MACRO_ENUM_CATEGORY_ITEM;
                        };
                };
        };

        // If we determined the category, save it onto the namespace
        if (_category != -1) exitWith {
                _namespace setVariable [_class, _category];
        };
} forEach ["CfgWeapons", "CfgMagazines", "CfgVehicles", "CfgGlasses"];

// Return the category
_category;
