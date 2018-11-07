/* --------------------------------------------------------------------------------------------------------------------
        Author:         Cre8or
        Description:
                Returns the icon of a specific class.
        Arguments:
                0:      <STRING>        Classname of item to check
                1:      <NUMBER>        Category of the class (see fn_getClassCategory)
                2:      <STRING>        Default icon to be used if nothing was found
        Returns:
                0:      <STRING>        Icon path of the class
                                        (e.g. "a3\weapons_f\Items\data\UI\gear_FirstAidKit_CA.paa")
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

params [
        ["_class", "", [""]],
        ["_category", -1, [-1]],
        ["_default", "", [""]]
];

// If no class was provided, exit
if (_class == "" or {_category == -1}) exitWith {};





// Get our namespace
private _namespace = missionNamespace getVariable ["cre8ive_getClassIcon_namespace", locationNull];

// If the namespace doesn't exist yet, create it
if (isNull _namespace) then {
        _namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
        missionNamespace setVariable ["cre8ive_getClassIcon_namespace", _namespace, false];
};

// Fetch the icon path from the namespace
private _iconPath = _namespace getVariable [_class, " "];

// If the icon path doesn't exist yet, fetch it from the config
if (_iconPath == " ") then {

        switch (_category) do {
                case MACRO_ENUM_CATEGORY_ITEM;
                case MACRO_ENUM_CATEGORY_WEAPON: {
                        _iconPath = [configfile >> "CfgWeapons" >> _class, "picture", ""] call BIS_fnc_returnConfigEntry;

			#ifdef MACRO_DEBUG_GETCLASSICON
				systemChat format ["(getClassIcon) Item is a weapon - Icon: %1)", _iconPath];
			#endif
                };
                case MACRO_ENUM_CATEGORY_MAGAZINE: {
                        _iconPath = [configfile >> "CfgMagazines" >> _class, "picture", ""] call BIS_fnc_returnConfigEntry;

			#ifdef MACRO_DEBUG_GETCLASSICON
				systemChat format ["(getClassIcon) Item is a magazine - Icon: %1)", _iconPath];
			#endif
                };
                case MACRO_ENUM_CATEGORY_VEHICLE: {
                        _iconPath = [configfile >> "CfgVehicles" >> _class, "picture", ""] call BIS_fnc_returnConfigEntry;

			#ifdef MACRO_DEBUG_GETCLASSICON
				systemChat format ["(getClassIcon) Item is a vehicle - Icon: %1)", _iconPath];
			#endif
                };
                case MACRO_ENUM_CATEGORY_GLASSES: {
                        _iconPath = [configfile >> "CfgGlasses" >> _class, "picture", ""] call BIS_fnc_returnConfigEntry;

			#ifdef MACRO_DEBUG_GETCLASSICON
				systemChat format ["(getClassIcon) Item is a pair of glasses - Icon: %1)", _iconPath];
			#endif
                };
        };

        // If no icon was found in the config, use the default value instead
        if (_iconPath == "") then {
        	if (_default != "") then {
                        _iconPath = _default;
        	} else {
                        _iconPath = " ";
                        private _str = format ["ERROR [cre_fnc_getClassIcon]: Could not find icon for '%1', and no default path was provided!", _class];
        	        systemChat _str;
        	        hint _str;
        	};
        };

        // Save the class icon on the namespace
        _namespace setVariable [_class, _iconPath];
};

// Return the icon path
_iconPath;
